// this file is written in Haxe
// and is part of the MSDFGen library.
// It is used to generate multi-channel signed distance fields from fonts and shapes.
package msdfgen;

import haxe.zip.Compress;
import haxe.crypto.Base64;
import binpacking.NaiveShelfPacker;
import binpacking.MaxRectsPacker;
import binpacking.GuillotinePacker;
import binpacking.ShelfPacker;
import binpacking.SimplifiedMaxRectsPacker;
import binpacking.SkylinePacker;
import haxe.io.Bytes;
import haxe.xml.Access;
import msdfgen.SDF;
import msdfgen.MSDFGen;
import msdfgen.Charset;
import msdfgen.PackingAlgorithm;
import msdfgen.FontAtlasInfo;

typedef GenConfig = AtlasConfig & {
	var input:String; // path to ttf
	var inputs:Array<String>;
	var svgInput:Null<Dynamic>;
	var charset:Array<Dynamic>; // Charset info
	var fontSize:Null<Int>;
	var padding:{
		top:Null<Int>,
		bottom:Null<Int>,
		left:Null<Int>,
		right:Null<Int>
	};
	// TODO: Margin
	var dfSize:Null<Int>;
	var template:String;
};



class GeneratorFont {
	public function new(fontPtr:FontPtr) {
		this.fontPtr = fontPtr;
	}

	public var fontPtr:FontPtr;

	public function getGlyphInfo(char:Int, paddingLeft:Int, paddingTop:Int, extendWidth:Int, extendHeight:Int, dfRange:Int):GlyphInfo {
		if (char == -1) {
			return null;
		}

		static var m = GlyphMetrics.make();

		if (fontPtr.getGlyphMetrics(char, m)) {
			var g = new GlyphInfo();

			g.char = char;
			g.width = m.width + extendWidth;
			g.height = m.height + extendHeight;
			g.xOffset = -m.offsetX + paddingLeft + Math.ceil(dfRange / 2);
			g.yOffset = m.offsetY + paddingTop + Math.ceil(dfRange / 2);
			g.advance = m.advanceX;
			g.descent = m.descent;
			g.isCCW = m.ccw;

			return g;
		}

		return null;
	}
}

class GenerationResult {
	public function new(width:Int, height:Int, imageData:Bytes) {
		this.atlas = imageData;
		this.width = width;
		this.height = height;
	}

	public var atlas:Bytes = null;
	public var width:Int = 0;
	public var height:Int = 0;

	public function dispose() {
		atlas = null;
	}
}

class Generator {
	var shapeLibrary:ShapeLibraryPtr = null;
	var fontLibrary:FontLibraryPtr = null;
	var _fontMap = new Map<String, GeneratorFont>();

	public function new() {
		fontLibrary = FontLibraryPtr.alloc();
	}

	public function loadFont(path:String, size:Int) {
		if (_fontMap.exists(path)) {
			return _fontMap.get(path);
		}

		var fontPtr = fontLibrary.load(path, size);
		if (fontPtr == null) {
			throw "Failed to load font from path: " + path;
		}
		var generatorFont = new GeneratorFont(fontPtr);
		_fontMap.set(path, generatorFont);
		return generatorFont;
	}

	//			static function writeFntFile(pngPath, config, glyphs:Array<GlyphInfo>, renderer:Render) {

	public function generateAtlasFromFont(font:GeneratorFont, charset:Charset, config:FontAtlasConfig):FontAtlasInfo {
		// calculate parameters
		var dfRange = (config.mode == Raster) ? 0 : config.dfSize;

		var paddingLeft = config.padding.left;
		var paddingTop = config.padding.top;
		var paddingBottom = config.padding.bottom;
		var extendWidth = config.padding.left + config.padding.right + dfRange;
		var extendHeight = config.padding.top + config.padding.bottom + dfRange;

		var printableChars = [for (c in charset) c].filter(c -> !Charset.NONPRINTING.contains(c));
		// generate glyphs
		var glyphs = [
			for (char in printableChars) {
				font.getGlyphInfo(char, paddingLeft, paddingTop, extendWidth, extendHeight, dfRange);
			}
		];
		glyphs.sort(config.sort);

		function getPackingFn():(w:Int, h:Int) -> binpacking.Rect {
			return switch (config.algorithm) {
				case PackingAlgorithm.PGuillotine:
					var p = new GuillotinePacker(config.width, config.height);
					p.insert.bind(_, _, false, BestLongSideFit, MaximizeArea);
				case PackingAlgorithm.PNaiveShelf:
					var p = new NaiveShelfPacker(config.width, config.height);
					p.insert;
				case PackingAlgorithm.PShelf(heuristic):
					var p = new ShelfPacker(config.width, config.height, config.useWasteMap);
					p.insert.bind(_, _, heuristic);
				case PackingAlgorithm.PSimplifiedMaxRects:
					var p = new SimplifiedMaxRectsPacker(config.width, config.height);
					p.insert;
				case PackingAlgorithm.PSkyline(heuristic):
					var p = new SkylinePacker(config.width, config.height, true); // Does not expect usage without waste map.
					p.insert.bind(_, _, heuristic);
				case PackingAlgorithm.PMaxRects(heuristic):
					var p = new MaxRectsPacker(config.width, config.height, false);
					p.insert.bind(_, _, heuristic);
				default:
					throw "Unknown packing algorithm: " + config.algorithm;
			}
		}

		var insert = getPackingFn();
		// pack glyphs
		var xMax = 0;
		var yMax = 0;
		for (g in glyphs) {
			var rect = g.rect = insert(g.width + config.spacing.x, g.height + config.spacing.y);
			if (rect == null) {
				throw "Failed to pack glyph: "
					+ g.char
					+ ", size: "
					+ g.width
					+ "x"
					+ g.height
					+ ", extend: "
					+ config.spacing.x
					+ "x"
					+ config.spacing.y;
			}
			var tmp = Std.int(rect.x + rect.width);
			if (tmp > xMax)
				xMax = tmp;
			tmp = Std.int(rect.y + rect.height);
			if (tmp > yMax)
				yMax = tmp;
		}

		var atlasWidth = xMax;
		var atlasHeight = yMax;

		// adjust atlas size
		if (config.exact) {
			atlasWidth = config.width;
			atlasHeight = config.height;
		} else if (config.pot) {
			inline function toPOT(v:Int):Int {
				// https://graphics.stanford.edu/~seander/bithacks.html#RoundUpPowerOf2
				v--;
				v |= v >> 1;
				v |= v >> 2;
				v |= v >> 4;
				v |= v >> 8;
				v |= v >> 16;
				return v + 1;
			}

			atlasWidth = toPOT(xMax);
			atlasHeight = toPOT(yMax);
		}

		// do the render

		var rasterMode = config.mode == Raster;
		var bgColor = (rasterMode && !config.rasterR8) ? 0x00ffffff : 0xff000000;

		var atlas = AtlasPtr.alloc();

		atlas.begin(atlasWidth, atlasHeight, bgColor, config.rasterR8);

		var halfDF = (dfRange * .5);
		inline function glyphWidth(g:GlyphInfo)
			return g.width;
		inline function glyphHeight(g:GlyphInfo)
			return g.height;
		inline function canvasX(g:GlyphInfo)
			return Std.int(g.rect.x);
		inline function canvasY(g:GlyphInfo)
			return Std.int(g.rect.y);
		inline function translateX(g:GlyphInfo)
			return g.xOffset - 0.5;
		inline function translateY(g:GlyphInfo)
			return Math.floor(halfDF) + 0.5 - g.descent + paddingBottom;

		var genFn = switch (config.mode) {
			case MSDF: (char:Int,
					g:GlyphInfo) -> return atlas.generateMSDFGlyph(font.fontPtr, char, glyphWidth(g), glyphHeight(g), canvasX(g), canvasY(g), translateX(g),
						translateY(g), g.isCCW, dfRange);
			case SDF: (char:Int,
					g:GlyphInfo) -> return atlas.generateSDFGlyph(font.fontPtr, char, glyphWidth(g), glyphHeight(g), canvasX(g), canvasY(g), translateX(g),
						translateY(g), g.isCCW, dfRange);
			case PSDF: (char:Int,
					g:GlyphInfo) -> return atlas.generatePSDFGlyph(font.fontPtr, char, glyphWidth(g), glyphHeight(g), canvasX(g), canvasY(g), translateX(g),
						translateY(g), g.isCCW, dfRange);
			case Raster:
				(char:Int,
						g:GlyphInfo) -> return atlas.rasterizeGlyph(font.fontPtr, char, g.width, g.height, canvasX(g) + paddingLeft,
						canvasY(g) + paddingTop); // todo is +padding required here, g.rect already contains it.
		}

		for (g in glyphs) {
			if (g != null && g.width != 0 && g.height != 0) {
				genFn(g.char, g);
			}
		}

		atlas.end();
		var bytes = atlas.imageByteCount();
		if (bytes == 0) {
			throw "Failed to generate atlas, no bytes returned.";
		}

		var imageData = haxe.io.Bytes.alloc(bytes);
		atlas.copyImage(idl.NativeBytes.fromIO(imageData));

		atlas.free();

		var info = FontAtlasInfo.make(config, glyphs, font.fontPtr);
		info.width = atlasWidth;
		info.height = atlasHeight;
		var compressedData = Compress.run(imageData, 9 );
		info.textureZip64 = Base64.encode(compressedData);
		return info;
	}

	public function dispose() {
		if (shapeLibrary != null) {
			shapeLibrary.free();
			shapeLibrary = null;
		}
		if (fontLibrary != null) {
			fontLibrary.free();
			fontLibrary = null;
		}
		_fontMap = null;
	}
}

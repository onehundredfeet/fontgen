package msdfgen;

import haxe.io.Bytes;
import msdfgen.MSDFGen;
import msdfgen.Render;
import msdfgen.SDF;
import msdfgen.Generator;

class GlyphRenderTTF implements  Render {
	
	static var METRICS:FontMetrics = FontMetrics.make();
	static var GLYPH:GlyphMetrics = GlyphMetrics.make();
	
	/** Internal slot index **/
	public var slot:FontPtr;
	
	public var fontName:String;
	public var unitsPerEm:Int;
	public var bold:Bool;
	public var italic:Bool;
	public var lineHeight:Int;
	public var baseLine:Int;
	public var fontHeight:Int;
	public var ascent:Int;
	public var descent:Int;
	var mode:SdfMode;
	var dfRange:Int;
	var extendWidth:Int;
	var extendHeight:Int;
	var config:GenConfig;
	var glyphMap:Map<Int, GlyphInfo>;
	public var renderGlyphs:Array<GlyphInfo>;
	
	public function new(font : FontPtr,  config:GenConfig)
	{		
		var m = METRICS;
		slot = font;
		this.ascent = m.ascent;
		this.descent = m.descent;
		this.baseLine = m.baseLine;
		this.unitsPerEm = m.unitsPerEm;
		this.lineHeight = m.lineHeight;
		this.fontHeight = m.lineHeight;
		this.bold = (m.flags & 1) != 0;
		this.italic = (m.flags & 2) != 0;
		this.config = config;
		this.mode = config.mode;
		this.dfRange = (mode==Raster)? 0 : config.dfSize;
		this.extendWidth = config.padding.left + config.padding.right + dfRange;
		this.extendHeight = config.padding.top + config.padding.bottom + dfRange;
		fontName = slot.getName();
		
		glyphMap = [];
		renderGlyphs = [];
	}
	
	public function get(char:Int) {
		var g = glyphMap.get(char);
		if (g == null) {
			var paddingLeft = config.padding.left;
			var paddingTop = config.padding.top;
			g = new GlyphInfo();
			g.renderer = this;
			glyphMap.set(char, g);
			var m = GLYPH;
			if (slot.getGlyphMetrics(char, m)) {
				g.char = char;
				g.width = m.width + extendWidth;
				g.height = m.height+ extendHeight;
				g.xOffset = -m.offsetX + paddingLeft + Math.ceil(dfRange/2);
				g.yOffset = m.offsetY + paddingTop + Math.ceil(dfRange/2);
				g.advance = m.advanceX;
				g.descent = m.descent;
				g.isCCW = m.ccw;
			}
		}
		return g.char == -1 ? null : g;
	}

	public function renderToAtlas(atlas:AtlasPtr){
		var paddingLeft = config.padding.left;
		var paddingTop = config.padding.top;
		var paddingBottom = config.padding.bottom;
		var halfDF = (dfRange * .5);
		inline function glyphWidth(g:GlyphInfo) return g.width;
		inline function glyphHeight(g:GlyphInfo) return g.height;
		inline function canvasX(g:GlyphInfo) return Std.int(g.rect.x);
		inline function canvasY(g:GlyphInfo) return Std.int(g.rect.y);
		inline function translateX(g:GlyphInfo) return   g.xOffset - 0.5 ;
		inline function translateY(g:GlyphInfo) return Math.floor(halfDF) + 0.5 - g.descent + paddingBottom;

		switch (config.mode) {
			case MSDF:
				for (g in renderGlyphs) {
					if (g.width != 0 && g.height != 0)
						atlas.generateMSDFGlyph(g.renderer.slot, g.char, glyphWidth(g), glyphHeight(g), canvasX(g), canvasY(g), translateX(g), translateY(g), g.isCCW, dfRange);
				}
			case SDF:
				for (g in renderGlyphs) {
					if (g.width != 0 && g.height != 0)
						atlas.generateSDFGlyph(g.renderer.slot, g.char, glyphWidth(g), glyphHeight(g), canvasX(g), canvasY(g), translateX(g), translateY(g), g.isCCW, dfRange);
				}
			case PSDF:
				for (g in renderGlyphs) {
					if (g.width != 0 && g.height != 0)
						atlas.generatePSDFGlyph(g.renderer.slot, g.char, glyphWidth(g), glyphHeight(g), canvasX(g), canvasY(g), translateX(g), translateY(g), g.isCCW, dfRange);
				}
			case Raster:
				for (g in renderGlyphs) {
					if (g.width != 0 && g.height != 0)
						atlas.rasterizeGlyph(g.renderer.slot, g.char, g.width, g.height, canvasX(g) + paddingLeft, canvasY(g) + paddingTop); // todo is +padding required here, g.rect already contains it.
				}
		}
	}
	
}


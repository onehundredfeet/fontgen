package msdfgen;


import msdfgen.Render;
import msdfgen.MSDFGen;
import sys.io.File;

import msdfgen.Generator;
import msdfgen.SVGLoader;

typedef SvgDescr = {
	filename:String,
	?pathName:String,
	bounds:Bounds,
	slot:ShapePtr
}


class GlyphRenderSVG implements Render {
	public var file:String;
	public var renderGlyphs:Array<GlyphInfo> = [];
	public var shapeLibrary:ShapeLibraryPtr;
	var dfRange = 5.;
	var glyphMap:Map<Int, GlyphInfo> = new Map();
	var svgDescrs:Map<Int, SvgDescr> = new Map();
	var config:GenConfig;

	public function new(config) {
		this.config = config;

		shapeLibrary = ShapeLibraryPtr.alloc(); 
	}

	public function destroy() {
		if (shapeLibrary != null) {
			shapeLibrary.free();
			shapeLibrary = null;
		}
	}

	public function reg(char:Int, svgfile:String, path = "") {
		var gi = new GlyphInfo();
		gi.char = char;
		renderGlyphs.push(gi);
		glyphMap.set(char, gi);
		var pathDef = SVGLoader.load(svgfile, path);
		var snapRange = SVGLoader.calcEndpointSnapRange(svgfile);
		var slotIndex = shapeLibrary.loadSvgShape(pathDef, config.fontSize, 1, snapRange);
		var bounds = slotIndex.getBounds();

		gi.width = Math.ceil(bounds.r - bounds.l + dfRange);
		gi.height = Math.ceil(bounds.t - bounds.b + dfRange);

		gi.xOffset = 0; // - Math.floor(bounds.l - dfRange/2);
		gi.yOffset = -Math.ceil(bounds.b - bounds.t - dfRange / 2);
		gi.advance = Math.ceil(bounds.r - bounds.l);

		var descr = {
			filename: svgfile,
			pathName: path,
			slot: slotIndex,
			bounds: bounds
		};
		svgDescrs.set(char, descr);
		return gi;
	}


	

	public function get(char:Int):GlyphInfo {
		return glyphMap.get(char);
	}

	public function renderToAtlas(atlas:AtlasPtr):Void {
        inline function glyphWidth(g:GlyphInfo) return g.width;
		inline function glyphHeight(g:GlyphInfo) return g.height;
		inline function canvasX(g:GlyphInfo) return Std.int(g.rect.x) ;
		inline function canvasY(g:GlyphInfo) return Std.int(g.rect.y);
		inline function translateX(g:GlyphInfo, d:SvgDescr) return  dfRange/2 - d.bounds.l - 0.5 ;
		inline function translateY(g:GlyphInfo, d:SvgDescr) return dfRange/2 - d.bounds.b + 0.5;

		switch (config.mode) {
			case MSDF:
				for (g in renderGlyphs) {
					var descr = svgDescrs.get(g.char);
					if (g.width != 0 && g.height != 0)
						atlas.generateMSDFPath(descr.slot, glyphWidth(g), glyphHeight(g), canvasX(g), canvasY(g), translateX(g, descr), translateY(g, descr),
							dfRange, 1);
				}
			case SDF:
				for (g in renderGlyphs) {
					var descr = svgDescrs.get(g.char);
					if (g.width != 0 && g.height != 0)
						atlas.generateSDFPath(descr.slot, glyphWidth(g), glyphHeight(g), canvasX(g), canvasY(g), translateX(g, descr), translateY(g, descr),
							dfRange, 1);
				}
			case PSDF:
				for (g in renderGlyphs) {
					var descr = svgDescrs.get(g.char);
					if (g.width != 0 && g.height != 0)
						atlas.generatePSDFPath(descr.slot, glyphWidth(g), glyphHeight(g), canvasX(g), canvasY(g), translateX(g, descr), translateY(g, descr),
							dfRange, 1);
				}
			case Raster:
				throw "SVG rasterizing is not implemened.";
		}
	}
}


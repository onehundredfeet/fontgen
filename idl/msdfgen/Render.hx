package msdfgen;


import msdfgen.MSDFGen;
interface Render {
//	public var file:String;
	public var renderGlyphs:Array<GlyphInfo>;
	public function get(char:Int):GlyphInfo;
    
	public function renderToAtlas(atlas:AtlasPtr):Void;
	
}


package msdfgen;
#if hl

abstract Bounds(idl.Types.Ref) from idl.Types.Ref to idl.Types.Ref {
	public var l(get, set) : Float;
	@:hlNative("MSDFGen", "Bounds_get_l")
	function get_l():Float return 0.;
	@:hlNative("MSDFGen", "Bounds_set_l")
	function set_l(_v:Float):Float return 0.;
	public var b(get, set) : Float;
	@:hlNative("MSDFGen", "Bounds_get_b")
	function get_b():Float return 0.;
	@:hlNative("MSDFGen", "Bounds_set_b")
	function set_b(_v:Float):Float return 0.;
	public var r(get, set) : Float;
	@:hlNative("MSDFGen", "Bounds_get_r")
	function get_r():Float return 0.;
	@:hlNative("MSDFGen", "Bounds_set_r")
	function set_r(_v:Float):Float return 0.;
	public var t(get, set) : Float;
	@:hlNative("MSDFGen", "Bounds_get_t")
	function get_t():Float return 0.;
	@:hlNative("MSDFGen", "Bounds_set_t")
	function set_t(_v:Float):Float return 0.;
}
abstract FontMetrics(idl.Types.Ref) from idl.Types.Ref to idl.Types.Ref {
	@:hlNative("MSDFGen", "FontMetrics_new0")
	static function new0():msdfgen.FontMetrics return cast(0, FontMetrics);
	public inline function new():msdfgen.FontMetrics return new0();
	public var size(get, set) : Int;
	@:hlNative("MSDFGen", "FontMetrics_get_size")
	function get_size():Int return 0;
	@:hlNative("MSDFGen", "FontMetrics_set_size")
	function set_size(_v:Int):Int return 0;
	public var ascent(get, set) : Int;
	@:hlNative("MSDFGen", "FontMetrics_get_ascent")
	function get_ascent():Int return 0;
	@:hlNative("MSDFGen", "FontMetrics_set_ascent")
	function set_ascent(_v:Int):Int return 0;
	public var descent(get, set) : Int;
	@:hlNative("MSDFGen", "FontMetrics_get_descent")
	function get_descent():Int return 0;
	@:hlNative("MSDFGen", "FontMetrics_set_descent")
	function set_descent(_v:Int):Int return 0;
	public var unitsPerEm(get, set) : Int;
	@:hlNative("MSDFGen", "FontMetrics_get_unitsPerEm")
	function get_unitsPerEm():Int return 0;
	@:hlNative("MSDFGen", "FontMetrics_set_unitsPerEm")
	function set_unitsPerEm(_v:Int):Int return 0;
	public var baseLine(get, set) : Int;
	@:hlNative("MSDFGen", "FontMetrics_get_baseLine")
	function get_baseLine():Int return 0;
	@:hlNative("MSDFGen", "FontMetrics_set_baseLine")
	function set_baseLine(_v:Int):Int return 0;
	public var lineHeight(get, set) : Int;
	@:hlNative("MSDFGen", "FontMetrics_get_lineHeight")
	function get_lineHeight():Int return 0;
	@:hlNative("MSDFGen", "FontMetrics_set_lineHeight")
	function set_lineHeight(_v:Int):Int return 0;
	public var flags(get, set) : Int;
	@:hlNative("MSDFGen", "FontMetrics_get_flags")
	function get_flags():Int return 0;
	@:hlNative("MSDFGen", "FontMetrics_set_flags")
	function set_flags(_v:Int):Int return 0;
}
abstract GlyphMetrics(idl.Types.Ref) from idl.Types.Ref to idl.Types.Ref {
	@:hlNative("MSDFGen", "GlyphMetrics_new0")
	static function new0():msdfgen.GlyphMetrics return cast(0, GlyphMetrics);
	public inline function new():msdfgen.GlyphMetrics return new0();
	public var width(get, set) : Int;
	@:hlNative("MSDFGen", "GlyphMetrics_get_width")
	function get_width():Int return 0;
	@:hlNative("MSDFGen", "GlyphMetrics_set_width")
	function set_width(_v:Int):Int return 0;
	public var height(get, set) : Int;
	@:hlNative("MSDFGen", "GlyphMetrics_get_height")
	function get_height():Int return 0;
	@:hlNative("MSDFGen", "GlyphMetrics_set_height")
	function set_height(_v:Int):Int return 0;
	public var offsetX(get, set) : Int;
	@:hlNative("MSDFGen", "GlyphMetrics_get_offsetX")
	function get_offsetX():Int return 0;
	@:hlNative("MSDFGen", "GlyphMetrics_set_offsetX")
	function set_offsetX(_v:Int):Int return 0;
	public var offsetY(get, set) : Int;
	@:hlNative("MSDFGen", "GlyphMetrics_get_offsetY")
	function get_offsetY():Int return 0;
	@:hlNative("MSDFGen", "GlyphMetrics_set_offsetY")
	function set_offsetY(_v:Int):Int return 0;
	public var advanceX(get, set) : Int;
	@:hlNative("MSDFGen", "GlyphMetrics_get_advanceX")
	function get_advanceX():Int return 0;
	@:hlNative("MSDFGen", "GlyphMetrics_set_advanceX")
	function set_advanceX(_v:Int):Int return 0;
	public var descent(get, set) : Int;
	@:hlNative("MSDFGen", "GlyphMetrics_get_descent")
	function get_descent():Int return 0;
	@:hlNative("MSDFGen", "GlyphMetrics_set_descent")
	function set_descent(_v:Int):Int return 0;
	public var ccw(get, set) : Bool;
	@:hlNative("MSDFGen", "GlyphMetrics_get_ccw")
	function get_ccw():Bool return false;
	@:hlNative("MSDFGen", "GlyphMetrics_set_ccw")
	function set_ccw(_v:Bool):Bool return false;
}
abstract Font(idl.Types.Ref) from idl.Types.Ref to idl.Types.Ref {
	@:hlNative("MSDFGen", "Font_getGlyphMetrics2")
	public function getGlyphMetrics(charcode:Int, metrics:GlyphMetrics):Bool return false;
	@:hlNative("MSDFGen", "Font_getKerning2")
	public function getKerning(left:Int, right:Int):Int return 0;
	@:hlNative("MSDFGen", "Font_getName0")
	public function getName():String return null;
	@:hlNative("MSDFGen", "Font_getMetrics0")
	public function getMetrics():FontMetrics return null;
}
abstract FontLibrary(idl.Types.Ref) from idl.Types.Ref to idl.Types.Ref {
	@:hlNative("MSDFGen", "FontLibrary_new0")
	static function new0():msdfgen.FontLibrary return cast(0, FontLibrary);
	public inline function new():msdfgen.FontLibrary return new0();
	@:hlNative("MSDFGen", "FontLibrary_load2")
	public function load(filename:String, fontSize:Int):Font return null;
	@:hlNative("MSDFGen", "FontLibrary_unloadAll0")
	public function unloadAll():Void { }
}
abstract Atlas(idl.Types.Ref) from idl.Types.Ref to idl.Types.Ref {
	@:hlNative("MSDFGen", "Atlas_new0")
	static function new0():msdfgen.Atlas return cast(0, Atlas);
	public inline function new():msdfgen.Atlas return new0();
	@:hlNative("MSDFGen", "Atlas_begin4")
	public function begin(atlasWidth:Int, atlasHeight:Int, defaultColor:Int, enforceR8:Bool):Void { }
	@:hlNative("MSDFGen", "Atlas_end0")
	public function end():Void { }
	@:hlNative("MSDFGen", "Atlas_generateSDFGlyph10")
	public function generateSDFGlyph(font:Font, charcode:Int, width:Int, height:Int, ox:Int, oy:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool return false;
	@:hlNative("MSDFGen", "Atlas_generatePSDFGlyph10")
	public function generatePSDFGlyph(font:Font, charcode:Int, width:Int, height:Int, ox:Int, oy:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool return false;
	@:hlNative("MSDFGen", "Atlas_generateMSDFGlyph10")
	public function generateMSDFGlyph(font:Font, charcode:Int, width:Int, height:Int, ox:Int, oy:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool return false;
	@:hlNative("MSDFGen", "Atlas_rasterizeGlyph6")
	public function rasterizeGlyph(font:Font, charcode:Int, width:Int, height:Int, ox:Int, oy:Int):Bool return false;
	@:hlNative("MSDFGen", "Atlas_generateSDFPath9")
	public function generateSDFPath(shape:Shape, width:Float, height:Float, ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool return false;
	@:hlNative("MSDFGen", "Atlas_generateMSDFPath9")
	public function generateMSDFPath(shape:Shape, width:Float, height:Float, ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool return false;
	@:hlNative("MSDFGen", "Atlas_generatePSDFPath9")
	public function generatePSDFPath(shape:Shape, width:Float, height:Float, ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool return false;
	@:hlNative("MSDFGen", "Atlas_imageByteCount0")
	public function imageByteCount():Int return 0;
	@:hlNative("MSDFGen", "Atlas_copyImage1")
	public function copyImage(data:hl.Bytes):Void { }
}
abstract Shape(idl.Types.Ref) from idl.Types.Ref to idl.Types.Ref {
	@:hlNative("MSDFGen", "Shape_getBounds0")
	public function getBounds():msdfgen.Bounds return cast(0, Bounds);
}
abstract ShapeLibrary(idl.Types.Ref) from idl.Types.Ref to idl.Types.Ref {
	@:hlNative("MSDFGen", "ShapeLibrary_new0")
	static function new0():msdfgen.ShapeLibrary return cast(0, ShapeLibrary);
	public inline function new():msdfgen.ShapeLibrary return new0();
	@:hlNative("MSDFGen", "ShapeLibrary_loadSvgShape4")
	public function loadSvgShape(path:String, fontSize:Int, scale:Float, endpointSnapRange:Float):Shape return null;
}

#end
#if cpp

@:native("Bounds") @:structAccess @:unreflective @:nativeArrayAccess @:build(idl.macros.MacroTools.buildHXCPPIDLType("${MSDFGEN_IDL_DIR}/msdfgen.idl")) extern class Bounds {
	public var l : Float;
	public var b : Float;
	public var r : Float;
	public var t : Float;
	public inline function asPtr():msdfgen.BoundsPtr return cpp.Pointer.addressOf(this);
}
@:forward @:forwardStatics @:unreflective extern abstract BoundsPtr(cpp.Pointer<msdfgen.Bounds>) from cpp.Pointer<msdfgen.Bounds> to cpp.Pointer<msdfgen.Bounds> {
	public inline function asPtr():msdfgen.BoundsPtr return this;
	@:from
	public static inline function fromCast(self:cpp.Reference<msdfgen.Bounds>):msdfgen.BoundsPtr return cpp.Pointer.addressOf(self);
}
@:native("MSDFFontMetrics") @:structAccess @:unreflective @:nativeArrayAccess @:build(idl.macros.MacroTools.buildHXCPPIDLType("${MSDFGEN_IDL_DIR}/msdfgen.idl")) extern class FontMetrics {
	public var size : Int;
	public var ascent : Int;
	public var descent : Int;
	public var unitsPerEm : Int;
	public var baseLine : Int;
	public var lineHeight : Int;
	public var flags : Int;
	public inline function asPtr():msdfgen.FontMetricsPtr return cpp.Pointer.addressOf(this);
	@:native("MSDFFontMetrics")
	public static function make():msdfgen.FontMetrics;
}
@:forward @:forwardStatics @:unreflective extern abstract FontMetricsPtr(cpp.Pointer<msdfgen.FontMetrics>) from cpp.Pointer<msdfgen.FontMetrics> to cpp.Pointer<msdfgen.FontMetrics> {
	@:native("new MSDFFontMetrics")
	public static extern function alloc():msdfgen.FontMetricsPtr;
	@:native("delete ")
	public extern function free():Void;
	public inline function asPtr():msdfgen.FontMetricsPtr return this;
	@:from
	public static inline function fromCast(self:cpp.Reference<msdfgen.FontMetrics>):msdfgen.FontMetricsPtr return cpp.Pointer.addressOf(self);
}
@:native("GlyphMetrics") @:structAccess @:unreflective @:nativeArrayAccess @:build(idl.macros.MacroTools.buildHXCPPIDLType("${MSDFGEN_IDL_DIR}/msdfgen.idl")) extern class GlyphMetrics {
	public var width : Int;
	public var height : Int;
	public var offsetX : Int;
	public var offsetY : Int;
	public var advanceX : Int;
	public var descent : Int;
	public var ccw : Bool;
	public inline function asPtr():msdfgen.GlyphMetricsPtr return cpp.Pointer.addressOf(this);
	@:native("GlyphMetrics")
	public static function make():msdfgen.GlyphMetrics;
}
@:forward @:forwardStatics @:unreflective extern abstract GlyphMetricsPtr(cpp.Pointer<msdfgen.GlyphMetrics>) from cpp.Pointer<msdfgen.GlyphMetrics> to cpp.Pointer<msdfgen.GlyphMetrics> {
	@:native("new GlyphMetrics")
	public static extern function alloc():msdfgen.GlyphMetricsPtr;
	@:native("delete ")
	public extern function free():Void;
	public inline function asPtr():msdfgen.GlyphMetricsPtr return this;
	@:from
	public static inline function fromCast(self:cpp.Reference<msdfgen.GlyphMetrics>):msdfgen.GlyphMetricsPtr return cpp.Pointer.addressOf(self);
}
@:native("MSDFFont") @:structAccess @:unreflective @:nativeArrayAccess @:build(idl.macros.MacroTools.buildHXCPPIDLType("${MSDFGEN_IDL_DIR}/msdfgen.idl")) extern class Font {
	public extern function getGlyphMetrics(charcode:Int, metrics:GlyphMetricsPtr):Bool;
	public extern function getKerning(left:Int, right:Int):Int;
	public extern function getName():String;
	public extern function getMetrics():FontMetricsPtr;
	public inline function asPtr():msdfgen.FontPtr return cpp.Pointer.addressOf(this);
}
@:forward @:forwardStatics @:unreflective extern abstract FontPtr(cpp.Pointer<msdfgen.Font>) from cpp.Pointer<msdfgen.Font> to cpp.Pointer<msdfgen.Font> {
	public inline function getGlyphMetrics(charcode:Int, metrics:GlyphMetricsPtr):Bool return this.ref.getGlyphMetrics(charcode, metrics);
	public inline function getKerning(left:Int, right:Int):Int return this.ref.getKerning(left, right);
	public inline function getName():String return this.ref.getName();
	public inline function getMetrics():FontMetricsPtr return this.ref.getMetrics();
	public inline function asPtr():msdfgen.FontPtr return this;
	@:from
	public static inline function fromCast(self:cpp.Reference<msdfgen.Font>):msdfgen.FontPtr return cpp.Pointer.addressOf(self);
}
@:native("FontLibrary") @:structAccess @:unreflective @:nativeArrayAccess @:build(idl.macros.MacroTools.buildHXCPPIDLType("${MSDFGEN_IDL_DIR}/msdfgen.idl")) extern class FontLibrary {
	public extern function load(filename:String, fontSize:Int):FontPtr;
	public extern function unloadAll():Void;
	public inline function asPtr():msdfgen.FontLibraryPtr return cpp.Pointer.addressOf(this);
	@:native("FontLibrary")
	public static function make():msdfgen.FontLibrary;
}
@:forward @:forwardStatics @:unreflective extern abstract FontLibraryPtr(cpp.Pointer<msdfgen.FontLibrary>) from cpp.Pointer<msdfgen.FontLibrary> to cpp.Pointer<msdfgen.FontLibrary> {
	@:native("new FontLibrary")
	public static extern function alloc():msdfgen.FontLibraryPtr;
	@:native("delete ")
	public extern function free():Void;
	public inline function load(filename:String, fontSize:Int):FontPtr return this.ref.load(filename, fontSize);
	public inline function unloadAll():Void this.ref.unloadAll();
	public inline function asPtr():msdfgen.FontLibraryPtr return this;
	@:from
	public static inline function fromCast(self:cpp.Reference<msdfgen.FontLibrary>):msdfgen.FontLibraryPtr return cpp.Pointer.addressOf(self);
}
@:native("Atlas") @:structAccess @:unreflective @:nativeArrayAccess @:build(idl.macros.MacroTools.buildHXCPPIDLType("${MSDFGEN_IDL_DIR}/msdfgen.idl")) extern class Atlas {
	public extern function begin(atlasWidth:Int, atlasHeight:Int, defaultColor:Int, enforceR8:Bool):Void;
	public extern function end():Void;
	public extern function generateSDFGlyph(font:FontPtr, charcode:Int, width:Int, height:Int, ox:Int, oy:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool;
	public extern function generatePSDFGlyph(font:FontPtr, charcode:Int, width:Int, height:Int, ox:Int, oy:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool;
	public extern function generateMSDFGlyph(font:FontPtr, charcode:Int, width:Int, height:Int, ox:Int, oy:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool;
	public extern function rasterizeGlyph(font:FontPtr, charcode:Int, width:Int, height:Int, ox:Int, oy:Int):Bool;
	public extern function generateSDFPath(shape:ShapePtr, width:Float, height:Float, ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool;
	public extern function generateMSDFPath(shape:ShapePtr, width:Float, height:Float, ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool;
	public extern function generatePSDFPath(shape:ShapePtr, width:Float, height:Float, ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool;
	public extern function imageByteCount():Int;
	public extern function copyImage(data:cpp.Pointer<cpp.UInt8>):Void;
	public inline function asPtr():msdfgen.AtlasPtr return cpp.Pointer.addressOf(this);
	@:native("Atlas")
	public static function make():msdfgen.Atlas;
}
@:forward @:forwardStatics @:unreflective extern abstract AtlasPtr(cpp.Pointer<msdfgen.Atlas>) from cpp.Pointer<msdfgen.Atlas> to cpp.Pointer<msdfgen.Atlas> {
	@:native("new Atlas")
	public static extern function alloc():msdfgen.AtlasPtr;
	@:native("delete ")
	public extern function free():Void;
	public inline function begin(atlasWidth:Int, atlasHeight:Int, defaultColor:Int, enforceR8:Bool):Void this.ref.begin(atlasWidth, atlasHeight, defaultColor, enforceR8);
	public inline function end():Void this.ref.end();
	public inline function generateSDFGlyph(font:FontPtr, charcode:Int, width:Int, height:Int, ox:Int, oy:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool return this.ref.generateSDFGlyph(font, charcode, width, height, ox, oy, tx, ty, ccw, range);
	public inline function generatePSDFGlyph(font:FontPtr, charcode:Int, width:Int, height:Int, ox:Int, oy:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool return this.ref.generatePSDFGlyph(font, charcode, width, height, ox, oy, tx, ty, ccw, range);
	public inline function generateMSDFGlyph(font:FontPtr, charcode:Int, width:Int, height:Int, ox:Int, oy:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool return this.ref.generateMSDFGlyph(font, charcode, width, height, ox, oy, tx, ty, ccw, range);
	public inline function rasterizeGlyph(font:FontPtr, charcode:Int, width:Int, height:Int, ox:Int, oy:Int):Bool return this.ref.rasterizeGlyph(font, charcode, width, height, ox, oy);
	public inline function generateSDFPath(shape:ShapePtr, width:Float, height:Float, ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool return this.ref.generateSDFPath(shape, width, height, ox, oy, tx, ty, range, scale);
	public inline function generateMSDFPath(shape:ShapePtr, width:Float, height:Float, ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool return this.ref.generateMSDFPath(shape, width, height, ox, oy, tx, ty, range, scale);
	public inline function generatePSDFPath(shape:ShapePtr, width:Float, height:Float, ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool return this.ref.generatePSDFPath(shape, width, height, ox, oy, tx, ty, range, scale);
	public inline function imageByteCount():Int return this.ref.imageByteCount();
	public inline function copyImage(data:cpp.Pointer<cpp.UInt8>):Void this.ref.copyImage(data);
	public inline function asPtr():msdfgen.AtlasPtr return this;
	@:from
	public static inline function fromCast(self:cpp.Reference<msdfgen.Atlas>):msdfgen.AtlasPtr return cpp.Pointer.addressOf(self);
}
@:native("MSDFShape") @:structAccess @:unreflective @:nativeArrayAccess @:build(idl.macros.MacroTools.buildHXCPPIDLType("${MSDFGEN_IDL_DIR}/msdfgen.idl")) extern class Shape {
	public extern function getBounds():Bounds;
	public inline function asPtr():msdfgen.ShapePtr return cpp.Pointer.addressOf(this);
}
@:forward @:forwardStatics @:unreflective extern abstract ShapePtr(cpp.Pointer<msdfgen.Shape>) from cpp.Pointer<msdfgen.Shape> to cpp.Pointer<msdfgen.Shape> {
	public inline function getBounds():Bounds return this.ref.getBounds();
	public inline function asPtr():msdfgen.ShapePtr return this;
	@:from
	public static inline function fromCast(self:cpp.Reference<msdfgen.Shape>):msdfgen.ShapePtr return cpp.Pointer.addressOf(self);
}
@:native("ShapeLibrary") @:structAccess @:unreflective @:nativeArrayAccess @:build(idl.macros.MacroTools.buildHXCPPIDLType("${MSDFGEN_IDL_DIR}/msdfgen.idl")) extern class ShapeLibrary {
	public extern function loadSvgShape(path:String, fontSize:Int, scale:Float, endpointSnapRange:Float):ShapePtr;
	public inline function asPtr():msdfgen.ShapeLibraryPtr return cpp.Pointer.addressOf(this);
	@:native("ShapeLibrary")
	public static function make():msdfgen.ShapeLibrary;
}
@:forward @:forwardStatics @:unreflective extern abstract ShapeLibraryPtr(cpp.Pointer<msdfgen.ShapeLibrary>) from cpp.Pointer<msdfgen.ShapeLibrary> to cpp.Pointer<msdfgen.ShapeLibrary> {
	@:native("new ShapeLibrary")
	public static extern function alloc():msdfgen.ShapeLibraryPtr;
	@:native("delete ")
	public extern function free():Void;
	public inline function loadSvgShape(path:String, fontSize:Int, scale:Float, endpointSnapRange:Float):ShapePtr return this.ref.loadSvgShape(path, fontSize, scale, endpointSnapRange);
	public inline function asPtr():msdfgen.ShapeLibraryPtr return this;
	@:from
	public static inline function fromCast(self:cpp.Reference<msdfgen.ShapeLibrary>):msdfgen.ShapeLibraryPtr return cpp.Pointer.addressOf(self);
}

#end

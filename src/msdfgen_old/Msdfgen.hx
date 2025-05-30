package msdfgen;
#if false
// import ammer.def.Library;

// import haxe.io.Bytes as HB;
// import ammer.ffi.Bytes as AB;

// import ammer.ffi.*;

// class Msdfgen extends Library<"msdfgen_lib"> {
	
// 	@:ammer.native("wrap_initializeFreetype")
// 	public static function initializeFreetype():Bool;
	
// 	@:ammer.native("wrap_deinitializeFreetype")
// 	public static function deinitializeFreetype():Void;
	
// 	public static function initFont(filename:String, metrics:Bytes, fontSize:Int):Int;
// 	public static function unloadFonts():Void;
// 	public static function getGlyphMetrics(font:Int, charcode:Int, output:HB):Bool;
// 	public static function getKerning(font:Int, left:Int, right:Int):Int;
// 	public static function getFontName(font:Int, len:SizeOfReturn):HB;

// 	public static function beginAtlas(width:Int, height:Int, defaultColor:Int, enforceR8:Bool):Void;
// 	public static function endAtlas(output:String):Void;
	
// 	public static function generateSDFGlyph(slot:Int, charcode:Int, width:Int, height:Int, x:Int, y:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool;
// 	public static function generatePSDFGlyph(slot:Int, charcode:Int, width:Int, height:Int, x:Int, y:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool;
// 	public static function generateMSDFGlyph(slot:Int, charcode:Int, width:Int, height:Int, x:Int, y:Int, tx:Float, ty:Float, ccw:Bool, range:Float):Bool;
// 	public static function rasterizeGlyph(slot:Int, charcode:Int, width:Int, height:Int, x:Int, y:Int):Bool;

// 	public static function initSvgShape(pathDef:String, fontSize:Int, scale:Float, endpointSnapRange:Float):Int;
// 	public static function getBounds(slot:Int):String; 
// 	public static function generateSDFPath(slot:Int, width:Float, height:Float,  ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool;
// 	public static function generateMSDFPath(slot:Int, width:Float, height:Float,  ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool;
// 	public static function generatePSDFPath(slot:Int, width:Float, height:Float,  ox:Int, oy:Int, tx:Float, ty:Float, range:Float, scale:Float):Bool;
// }

// class MsdfgenUtils {
// 	public static inline function getBounds(slot:Int):Bounds{
// 		return haxe.Json.parse(Msdfgen.getBounds(slot));
// 	}
// }
typedef Bounds = {
	public var l:Float;
	public var b:Float;
	public var r:Float;
	public var t:Float;
}

#end
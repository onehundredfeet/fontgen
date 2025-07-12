package msdfgen;

import binpacking.Rect;
import msdfgen.GlyphRenderTTF;
class GlyphInfo {
	
	public var char:Int;
	public var width:Int;
	public var height:Int;
	public var xOffset:Int;
	public var yOffset:Int;
	public var descent:Float;
	public var advance:Int;
	public var isCCW:Bool;
	
	public var rect:Rect;
	public var renderer:GlyphRenderTTF;
	public var plane:Int;
	
	public function new() {
		char = -1;
	}
	
	public function toString() {
		return '{ $char : size: [$width x $height] off: [$xOffset, $yOffset] adv: $advance }';
	}
	
	public static function widthSort(a:GlyphInfo, b:GlyphInfo):Int {
		return Math.round(a.width - b.width);
	}

	public static function heightSort(a:GlyphInfo, b:GlyphInfo):Int {
		return Math.round(a.height - b.height);
	}
	public static function reverseHeightSort(a:GlyphInfo, b:GlyphInfo):Int {
		return Math.round(b.height - a.height);
	}

	public static function areaSort(a:GlyphInfo, b:GlyphInfo):Int {
		return Math.round((a.width * a.height) - (b.width * b.height));
	}

	public static function perimeterSort(a:GlyphInfo, b:GlyphInfo):Int {
		return Math.round((a.width + a.height) - (b.width + b.height));
	}

	public static function idSort(a:GlyphInfo, b:GlyphInfo):Int {
		return a.char - b.char;
	}
}
package msdfgen;

import haxe.io.Bytes;
import msdfgen.Generator;
import msdfgen.MSDFGen;
import msdfgen.SDF;

import msdfgen.FontAtlasConfig;

// 		lines.push('char id=${char.id} x=${char.x} y=${char.y} width=${char.w} height=${char.h} xoffset=${char.xo} yoffset=${char.yo} xadvance=${char.xa} page=0 chnl=15');

typedef FontAtlasChar = {id:Int, x:Int, y:Int, w:Int, h:Int, xo:Int, yo:Int, xa:Int};
typedef FontAtlasKerning = {first:Int, second:Int, amount:Int};

typedef FontAtlasInfoData = {
	var face:String;
	var size:Int;
	var bold:Bool;
	var italic:Bool;
	var padding:{
		up:Int,
		down:Int,
		left:Int,
		right:Int
	};
	var spacing:{x:Int, y:Int};
	var outline:Int;
	var dfSize:Int;
	var dfMode:SdfMode;

	var lineHeight:Int;
	var base:Int;
	var bytes:Bytes;
	var textureZip64:String;
	var width:Int;
	var height:Int;

	var chars:Array<FontAtlasChar>;

	var kernings:Array<FontAtlasKerning>;
}

@:forward
abstract FontAtlasInfo(FontAtlasInfoData) {
	public function new(data:FontAtlasInfoData) {
		this = data;
	}

	public static function make(config:FontAtlasConfig, glyphs:Array<GlyphInfo>, font:FontPtr):FontAtlasInfo {
		var metrics:FontMetricsPtr = font.getMetrics();
		var baseLine = metrics.ref.baseLine;
		var flags = metrics.ref.flags;

		var kernings = new Array<FontAtlasKerning>();
		final len = glyphs.length;
		for (i in 0...len) {
			var left = glyphs[i];
			for (j in (i + 1)...len) {
				var right = glyphs[j];
				var kern = font.getKerning(left.char, right.char);
				if (kern != 0) {
					kernings.push({first: left.char, second: right.char, amount: kern});
				}
				kern = font.getKerning(right.char, left.char);
				if (kern != 0) {
					kernings.push({first: right.char, second: left.char, amount: kern});
				}
			}
		}
		var chars = [];

		for (g in glyphs) {
			chars.push({
				id: g.char,
				x: Std.int(g.rect.x),
				y: Std.int(g.rect.y),
				w: g.width,
				h: g.height,
				xa: g.advance,
				xo: -g.xOffset,
				yo: (baseLine - g.yOffset),
			});
		}

		return new FontAtlasInfo({
			face: font.getName(),
			size: metrics.ref.size,
			bold: (flags & 1) != 0,
			italic: (flags & 2) != 0,
			padding: {
				up: config.padding.top,
				down: config.padding.bottom,
				left: config.padding.left,
				right: config.padding.right
			},
			spacing: {
				x: config.spacing.x,
				y: config.spacing.y
			},
			outline: 0,
			dfSize: config.dfSize,
			dfMode: config.mode,
			lineHeight: metrics.ref.lineHeight,
			base: baseLine,
			width: config.width,
			height: config.height,

			chars: chars,

			kernings: kernings,
			bytes: null,
			textureZip64: null
		});
	}

	public static function fromJSON(json:String):FontAtlasInfo {
		var data:FontAtlasInfoData = haxe.Json.parse(json);
		return new FontAtlasInfo(data);
	}

	public function toString(?space):String {
		return haxe.Json.stringify(this, space);
	}
}


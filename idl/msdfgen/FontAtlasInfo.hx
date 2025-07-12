package msdfgen;

import haxe.io.Bytes;
import msdfgen.Generator;
import msdfgen.MSDFGen;
import msdfgen.SDF;
import msdfgen.FontAtlasConfig;

// 		lines.push('char id=${char.id} x=${char.x} y=${char.y} width=${char.w} height=${char.h} xoffset=${char.xo} yoffset=${char.yo} xadvance=${char.xa} page=0 chnl=15');

typedef FontAtlasChar = {id:Int, x:Int, y:Int, w:Int, h:Int, xo:Int, yo:Int, xa:Int};
typedef FontAtlasKerning = {first:Int, second:Int, amount:Int};

typedef FontAtlasPlaneInfo = {
	var dfSize:Int;
	var padding:{
		up:Int,
		down:Int,
		left:Int,
		right:Int
	};
	var font:FontPtr;
	var size:Int;
	var bold:Bool;
	var italic:Bool;
	var chars:Array<FontAtlasChar>;
	var kernings:Array<FontAtlasKerning>;
	var lineHeight:Int;
	var base:Int;
}

typedef FontAtlasInfoData = {
	var face:String;
	var spacing:{x:Int, y:Int};
	var outline:Int;
	var dfMode:SdfMode;
	var bytes:Bytes;
	var textureZip64:String;
	var width:Int;
	var height:Int;
	var planes:Array<FontAtlasPlaneInfo>;
}

@:forward
abstract FontAtlasInfo(FontAtlasInfoData) from FontAtlasInfoData to FontAtlasInfoData {
	public function new() {
		this = {
			face: "",
			spacing: {x: 0, y: 0},
			outline: 0,
			dfMode: SdfMode.Raster,
			bytes: null,
			textureZip64: null,
			width: 0,
			height: 0,
			planes: []
		};
	}

	public static function make(allConfig:FontAtlasConfig, planes:Array<{glyphs:Array<GlyphInfo>, font:FontPtr}>):FontAtlasInfo {
		var result = new FontAtlasInfo();

		for (i in 0...planes.length) {
			var plane = planes[i];
			var metrics:FontMetricsPtr = plane.font.getMetrics();
			var baseLine = metrics.ref.baseLine;
			var flags = metrics.ref.flags;
			var config = allConfig.planes[i];

			var resultPlane:FontAtlasPlaneInfo = {
				dfSize:config.dfSize,
				padding:{
					up:config.padding.top,
					down:config.padding.bottom,
					left:config.padding.left,
					right:config.padding.right
				},
				font:plane.font,
				size:metrics.ref.size,
				bold:(flags & 1) != 0,
				italic:(flags & 2) != 0,
				chars:null,
				kernings:null,
				lineHeight : metrics.ref.lineHeight,
				base : baseLine
			};

			var kernings = resultPlane.kernings = new Array<FontAtlasKerning>();
			final len = plane.glyphs.length;
			for (i in 0...len) {
				var left = plane.glyphs[i];
				for (j in (i + 1)...len) {
					var right = plane.glyphs[j];
					var kern = plane.font.getKerning(left.char, right.char);
					if (kern != 0) {
						kernings.push({first: left.char, second: right.char, amount: kern});
					}
					kern = plane.font.getKerning(right.char, left.char);
					if (kern != 0) {
						kernings.push({first: right.char, second: left.char, amount: kern});
					}
				}
			}
			var chars = resultPlane.chars = [];

			for (g in plane.glyphs) {
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
			result.planes.push(resultPlane);
		}

		result.spacing = {
			x: allConfig.spacing.x,
			y: allConfig.spacing.y
		};
		result.outline = 0; // TODO: support outline
		result.dfMode = allConfig.mode;
		result.width = allConfig.width;
		result.height = allConfig.height;
		result.face = "unknown"; // TODO: support face name
		result.textureZip64 = null; // TODO: support texture zip64

		return result;
	}

	// public static function fromJSON(json:String):FontAtlasInfo {
	// 	var data:FontAtlasInfoData = haxe.Json.parse(json);
	// 	return new FontAtlasInfo(data);
	// }
	// public function toString(?space):String {
	// 	return haxe.Json.stringify(this, space);
	// }
}

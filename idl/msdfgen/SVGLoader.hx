package msdfgen;

import haxe.xml.Access;
import haxe.xml.Parser;
import sys.io.File;

class SVGLoader {
    inline static var ENDPOINT_SNAP_RANGE_PROPORTION = 1/16384.;

	public static function load(file, pathName) {
		function findPath(xml:Xml, name) {
			var access = new Access(xml);
			for (node in access.elements) {
				if (node.name == "path") {
					if (pathName == "" || (node.has.id && node.att.id == pathName))
						return node.x;
				} else if (node.name == "g")
					return findPath(node.x, name);
			}
			return null;
		}

		var svg:Xml = Parser.parse(File.getContent(file));
		var root = svg.elementsNamed("svg").next();
		var path:Xml = findPath(root, pathName);
		if (path == null || !path.exists("d")) {
			trace('cant find path with name $pathName in file $file');
			return null;
		}
		return path.get("d").toString();
	}

	public static function calcEndpointSnapRange(file) {
		var svg:Xml = Parser.parse(File.getContent(file));
		var root = svg.elementsNamed("svg").next();
		var w = Std.parseFloat(root.get('width'));
		var h = Std.parseFloat(root.get('height'));
		return Math.sqrt(w * w + h * h) * ENDPOINT_SNAP_RANGE_PROPORTION;
	}
}

package msdfgen;
import msdfgen.SDF;
import binpacking.MaxRectsPacker;

class FontPlaneConfig {
	public function new() {}
	public var padding = {
		top: 0,
		bottom: 0,
		left: 0,
		right: 0
	};

	public var dfSize = 4;
	public var size = 32;
	public var file = "";
}

class FontAtlasConfig {
	public function new() {}

	public var width = 2048;
	public var height = 2048;
    
	public var mode = SdfMode.Raster; // Generator mode
	public var pot = false;
	public var exact = false;
	public var sort = GlyphInfo.reverseHeightSort;
	public var algorithm = PackingAlgorithm.PMaxRects(FreeRectChoiceHeuristic.BestLongSideFit);
	public var useWasteMap = true;
	public var spacing = {x: 2, y: 2};

	public var planes :Array<FontPlaneConfig> = [];
	
	public var rasterR8:Bool = false;
}
package msdfgen;
import binpacking.ShelfPacker;
import binpacking.SkylinePacker;
import binpacking.MaxRectsPacker;

enum PackingAlgorithm {
	PUnknown;
	PGuillotine;
	PNaiveShelf;
	PShelf(heuristic:ShelfChoiceHeuristic);
	PSimplifiedMaxRects;
	PSkyline(heuristic:LevelChoiceHeuristic);
	PMaxRects(heuristic:FreeRectChoiceHeuristic);
}


typedef PackerConfig = {
	var size:Null<Int>;
	var width:Null<Int>;
	var height:Null<Int>;
	var pot:Bool;
	var exact:Bool;
	var sort:String;
	var algorithm:String;
	var heuristic:String;
	var useWasteMap:Null<Bool>;
}

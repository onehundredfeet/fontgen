package msdfgen;
import msdfgen.SDF;
import msdfgen.PackingAlgorithm;

typedef AtlasConfig = {
	var mode:SdfMode; // Generator mode
	var packer:PackerConfig;
	var spacing: { x:Null<Int>, y:Null<Int> };
	var output:String; // path to output .fnt
	var options:Array<String>;
}

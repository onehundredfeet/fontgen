package msdfgen;

enum abstract SdfMode(String) from String to String {
	
	var SDF = "sdf";
	var PSDF = "psdf";
	var MSDF = "msdf";
	var Raster = "raster";
	
	public inline function validate() {
		if (this != SDF && this != PSDF && this != MSDF && this != Raster)
			throw "Invalid render mode, allowed values are 'msdf', 'sdf', 'psdf' or 'raster'";
	}
	
}
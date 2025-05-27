package;

import idl.Options;


class MSDFGenCustomCode extends idl.CustomCode {
    public override function getHLInclude() {
		return "
        #ifdef _WIN32
#pragma warning(disable:4305)
#pragma warning(disable:4244)
#pragma warning(disable:4316)
#endif
        ";
	}

	public override function getJVMInclude() {
		return "";
	}

	public override function getEmscriptenInclude() {
		return "";
	}

	public override function getJSInclude() {
		return "";
	}

	public override function getHXCPPInclude() {
		return "
		";
	}

}
class Generator {
	// Put any necessary includes in this string and they will be added to the generated files
	
	public static function main() {
        trace('Building...');
        var sampleCode : idl.CustomCode = new MSDFGenCustomCode();
        var options = {
            idlFile: "idl/msdfgen.idl",
            target: null,
            packageName: "msdfgen",
            nativeLib: "MSDFGen",
            glueDir: "idl/msdfgen/hxcpp",
            autoGC: true,
            defaultConfig: "Release",
            architecture: ArchAll,
			hxDir:"idl",
            customCode: sampleCode,
			includes: [], 
			libs:[]
        };

		new idl.Cmd(options).run();
	}
}

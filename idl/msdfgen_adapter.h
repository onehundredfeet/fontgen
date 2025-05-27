#pragma once
#include <stdint.h>

// Haxe struct for font metrics.
struct FontMetrics {
	int ascent;
	int descent;
	int unitsPerEm;
	int baseLine;
	int lineHeight;
	int flags;
};

// Haxe struct for glyph metrics.
struct GlyphMetrics {
	int width;
	int height;
	int offsetX;
	int offsetY;
	int advanceX;
	int descent;
	int ccw;
};

class AtlasInternal;

class Atlas {
	public:
	Atlas();
	~Atlas();

	void begin(int width, int height, int defaultColor, bool _enforceR8);
	
	bool generateSDFGlyph( int charcode, int width, int height, int ox, int oy, double tx, double ty, bool ccw, double range);
	bool generatePSDFGlyph( int charcode, int width, int height, int ox, int oy, double tx, double ty, bool ccw, double range);
	bool generateMSDFGlyph( int charcode, int width, int height, int ox, int oy, double tx, double ty, bool ccw, double range);
	bool rasterizeGlyph( int charcode, int width, int height, int ox, int oy);

	void end();

private:
	AtlasInternal *atlasInternal;

};

struct FontSlot;

class Font {
	friend class FontLibrary;

public:
	Font();
	~Font();
	
	bool getGlyphMetrics( int charcode, GlyphMetrics *metrics);
	int getKerning( int left, int right);
	const char* getFontName();




private:
	double scale;
	FontSlot *fontSlot;
};


class FontLibraryInternal;
class FontLibrary {
public:
	FontLibrary();
	~FontLibrary();

	Font *load(const char* filename, FontMetrics* metrics, int fontSize) ;
	void unloadAll();

	private:
	FontLibraryInternal *fontLibraryInternal;

};


class ShapeInternal;
class Shape {
	Shape();
	~Shape();
	private:
	ShapeInternal *shapeInternal;
};


class ShapeLibraryInternal;
class ShapeLibrary {
public:
	ShapeLibrary();
	~ShapeLibrary();

	Shape *loadSvgShape(const char *path, int fontSize, double scale, double endpointSnapRange);
	
	private:
	ShapeLibraryInternal *shapeLibraryInternal;
};
/*




LIB_EXPORT int initSvgShape(const char *path, int fontSize, double scale, double endpointSnapRange);
LIB_EXPORT char* getBounds(int slot);
LIB_EXPORT bool generateSDFPath(int slot, double width, double height,  int ox, int oy, double tx, double ty, double range, double scale);
LIB_EXPORT bool generateMSDFPath(int slot, double width, double height,  int ox, int oy, double tx, double ty, double range, double scale);
LIB_EXPORT bool generatePSDFPath(int slot, double width, double height,  int ox, int oy, double tx, double ty, double range, double scale);

*/
#pragma once
#include <stdint.h>
#include <string>
#include <vector>

struct Bounds {
    double l, b, r, t;
};
// Haxe struct for font metrics.
struct MSDFFontMetrics {
    int size;
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

struct FontSlot;
class AtlasUtils;
class FontLibrary;

class MSDFFont {
    friend class FontLibrary;
    friend class AtlasUtils;
    friend class Atlas;
    
   public:
    MSDFFont(FontLibrary *);
    ~MSDFFont();

    bool getGlyphMetrics(int charcode, GlyphMetrics *metrics);
    int getKerning(int left, int right);
    const char *getName();
    MSDFFontMetrics *getMetrics() { return &_metrics; }

   private:
    double scale;
    FontSlot *fontSlot;
	std::string name;
    FontLibrary *_library;
    MSDFFontMetrics _metrics;
};

class FontLibraryInternal;
class FontLibrary {
   public:
    FontLibrary();
    ~FontLibrary();

    MSDFFont *load(const char *filename,  int fontSize);
    void unloadAll();

   private:
   friend class AtlasUtils;
   friend class Atlas;
    FontLibraryInternal *_internal;
};

class MSDFShapeInternal;
class ShapeLibrary;
class MSDFShape {
   public:
    MSDFShape();
    ~MSDFShape();
    Bounds getBounds();

   private:
    MSDFShapeInternal *_internal;
	friend class Atlas;
    friend class ShapeLibrary;
};

class ShapeLibrary {
   public:
    ShapeLibrary();
    ~ShapeLibrary();

    MSDFShape *loadSvgShape(const char *path, int fontSize, double scale,
                            double endpointSnapRange);

   private:
    std::vector<MSDFShape *> shapes;
};

class AtlasInternal;


class Atlas {
   public:
    Atlas();
    ~Atlas();

    void begin(int width, int height, int defaultColor, bool _enforceR8);

    bool generateSDFGlyph(MSDFFont *, int charcode, int width, int height,
                          int ox, int oy, double tx, double ty, bool ccw,
                          double range);
    bool generatePSDFGlyph(MSDFFont *, int charcode, int width, int height,
                           int ox, int oy, double tx, double ty, bool ccw,
                           double range);
    bool generateMSDFGlyph(MSDFFont *, int charcode, int width, int height,
                           int ox, int oy, double tx, double ty, bool ccw,
                           double range);
    bool rasterizeGlyph(MSDFFont *, int charcode, int width, int height, int ox,
                        int oy);

    bool generateSDFPath(MSDFShape *slot, double width, double height, int ox,
                         int oy, double tx, double ty, double range,
                         double scale);
    bool generateMSDFPath(MSDFShape *slot, double width, double height, int ox,
                          int oy, double tx, double ty, double range,
                          double scale);
    bool generatePSDFPath(MSDFShape *slot, double width, double height, int ox,
                          int oy, double tx, double ty, double range,
                          double scale);

    void end();

    int imageByteCount();
	void copyImage( unsigned char *bytes );
    int bytesPerChannel();
    int numChannels();
   private:
    AtlasInternal *_internal;

    friend class AtlasUtils;
};

/*




LIB_EXPORT int initSvgShape(const char *path, int fontSize, double scale, double
endpointSnapRange);


*/
#include "msdfgen_adapter.h"

#include <ft2build.h>
#include <lodepng.h>
#include <stdio.h>

#include <cstdlib>
#include <iostream>
#include <sstream>

#include "msdfgen/ext/import-svg.h"
#include "msdfgen/msdfgen-ext.h"
#include "msdfgen/msdfgen.h"
#include FT_FREETYPE_H
#include FT_OUTLINE_H
#include FT_TRUETYPE_TABLES_H
#include FT_SFNT_NAMES_H
#include FT_BITMAP_H

using namespace msdfgen;

// Since we can't send structs/pointers to Haxe, store it locally and use slots
// for referencing.
struct FontSlot {
    friend class FontLibrary;
    friend class Font;

    FontSlot() {
        font = NULL;
        ft = NULL;
    }

    FontHandle* font;
    FT_Face ft;
};

MSDFFont::MSDFFont(FontLibrary* library) {
    fontSlot = new FontSlot();
    scale = 1.0;
    _library = library;
}

MSDFFont::~MSDFFont() {
    if (fontSlot != NULL) {
        if (fontSlot->font != NULL) {
            destroyFont(fontSlot->font);
        }
        if (fontSlot->ft != NULL) {
            FT_Done_Face(fontSlot->ft);
        }
        delete fontSlot;
        fontSlot = NULL;
    }
}

template <typename T, int N>
inline int sizeOfBitmap(const Bitmap<T, N>& bitmap) {
    return sizeof(T) * N * bitmap.width() * bitmap.height();
}

class AtlasInternal {
   public:
    bool enforceR8 = false;
    bool normalizeShapes = false;
    Bitmap<byte, 4> atlasPixels;

    int numBytes() { return sizeOfBitmap(atlasPixels); }

    int bytesPerChannel() { return 1; }

    int numChannels() { return 4; }

    void copyImage(void* bytes) {
        const unsigned char* src = atlasPixels(0,0);
        unsigned char* dst = (unsigned char*)bytes;
        int size = numBytes();
        for (int i = 0; i < size; i++) {
            *dst++ = *src++;
        }
    }
};

Atlas::Atlas() { _internal = new AtlasInternal(); }

Atlas::~Atlas() {
    if (_internal != NULL) {
        delete _internal;
        _internal = NULL;
    }
}

int Atlas::bytesPerChannel() { return _internal->bytesPerChannel(); }
int Atlas::numChannels() { return _internal->numChannels(); }
int Atlas::imageByteCount() { return _internal->numBytes(); }
void Atlas::copyImage(unsigned char* bytes){this -> _internal->copyImage(bytes);}

class FontLibraryInternal {
   public:
    FontLibraryInternal() {
        ft = initializeFreetype();
        FT_Init_FreeType(&ft_lib);
        if (ft == NULL) {
            std::cerr << "[Error] Failed to initialize FreeType.\n";
        }
    }

    ~FontLibraryInternal() {
        if (ft != NULL) {
            FT_Done_FreeType(ft_lib);
            deinitializeFreetype(ft);
        }
    }

    FreetypeHandle* ft = NULL;
    FT_Library ft_lib;
    std::vector<MSDFFont*> fonts;
};

FontLibrary::FontLibrary() { _internal = new FontLibraryInternal(); }
FontLibrary::~FontLibrary() {
    if (_internal != NULL) {
        delete _internal;
        _internal = NULL;
    }
}

class MSDFShapeInternal {
   public:
    MSDFShapeInternal() {
        shape = nullptr;
        scale = 1.0;
    }
    msdfgen::Shape* shape;
    double scale;
};

MSDFShape::MSDFShape() { _internal = new MSDFShapeInternal(); }
MSDFShape::~MSDFShape() {
    if (_internal != NULL) {
        delete _internal;
        _internal = NULL;
    }
}

Bounds MSDFShape::getBounds() {
    auto b = _internal->shape->getBounds();
    return {b.l, b.b, b.r, b.t};
}

ShapeLibrary::ShapeLibrary() {}

ShapeLibrary::~ShapeLibrary() {
    for (std::vector<MSDFShape*>::iterator it = shapes.begin();
         it != shapes.end(); ++it) {
        delete *it;
    }
}

MSDFFont* FontLibrary::load(const char* filename, int fontSize) {
    FontHandle* msdfHandle = loadFont(_internal->ft, filename);
    if (msdfHandle != NULL) {
        MSDFFont* font = new MSDFFont(this);
        FontSlot* slot = font->fontSlot;

        slot->font = msdfHandle;

        FT_New_Face(_internal->ft_lib, filename, 0, &slot->ft);
        font->scale = (double)fontSize / (double)slot->ft->units_per_EM * 64.;
        FT_Set_Pixel_Sizes(slot->ft, 0, fontSize);

        auto metrics = font->getMetrics();

        metrics->ascent = slot->ft->ascender;
        metrics->descent = slot->ft->descender;
        metrics->unitsPerEm = slot->ft->units_per_EM;
        metrics->baseLine = (slot->ft->size->metrics.ascender + 32) >> 6;
        metrics->lineHeight = (slot->ft->size->metrics.height + 32) >> 6;
        TT_Header* header =
            (TT_Header*)FT_Get_Sfnt_Table(slot->ft, FT_SFNT_HEAD);
        metrics->flags = (int)header->Mac_Style | header->Flags << 16;

        _internal->fonts.push_back(font);
        return font;
    }
    return nullptr;
}

// No single font unload, because there's no point.
void FontLibrary::unloadAll() {
    std::vector<MSDFFont*>::iterator it = _internal->fonts.begin();
    int size = _internal->fonts.size();
    while (size-- > 0) {
        MSDFFont* handle = *it++;
        delete handle;
    }
    _internal->fonts.clear();
}

const char* MSDFFont::getName() {
    if (name.length() == 0) {
        FT_Face face = fontSlot->ft;
        FT_SfntName name;
        int count = FT_Get_Sfnt_Name_Count(face);
        for (int i = 0; i < count; i++) {
            FT_Get_Sfnt_Name(face, i, &name);
            if (name.name_id == 4 &&
                (name.platform_id == 3 || name.platform_id == 0) &&
                name.language_id == 0x409) {
                unsigned char* data =
                    (unsigned char*)malloc(name.string_len + 1);
                memcpy(data, name.string, name.string_len);
                data[name.string_len] = '\0';  // Null-terminate the string
                this->name = std::string((char*)data);
                free(data);
            }
        }
    }

    return name.c_str();
}

bool MSDFFont::getGlyphMetrics(int charcode, GlyphMetrics* metrics) {
    FT_Face face = fontSlot->ft;
    FT_UInt index = FT_Get_Char_Index(face, charcode);
    // In case we actually try to draw charcode 0.
    if (index == 0 && charcode != 0) return false;
    FT_Error err = FT_Load_Glyph(face, index, FT_LOAD_DEFAULT);
    if (err) return false;
    FT_GlyphSlot slot = face->glyph;

    metrics->width = slot->bitmap.width;
    metrics->height = slot->bitmap.rows;
    metrics->offsetX = slot->bitmap_left;
    metrics->offsetY = slot->bitmap_top;
    metrics->advanceX = (slot->advance.x + 32) >> 6;
    metrics->descent = (slot->metrics.horiBearingY - slot->metrics.height) >> 6;
    metrics->ccw = FT_Outline_Get_Orientation(&slot->outline);
    // Slower alternative:
    // FT_BBox bbox;
    // FT_Outline_Get_CBox(&slot->outline, &bbox);
    // metrics->descent = bbox.yMin >> 6;
    return true;
}

int MSDFFont::getKerning(int left, int right) {
    FT_Vector vec;
    FT_Face face = fontSlot->ft;
    FT_Error err = FT_Get_Kerning(face, FT_Get_Char_Index(face, left),
                                  FT_Get_Char_Index(face, right),
                                  FT_KERNING_DEFAULT, &vec);
    if (err) return err;
    return (vec.x + 32) >> 6;
}

void Atlas::begin(int atlasWidth, int atlasHeight, int defaultColor,
                  bool _enforceR8) {
    _internal->atlasPixels = Bitmap<byte, 4>(atlasWidth, atlasHeight);
    _internal->enforceR8 = _enforceR8;
    const int max = atlasWidth * atlasHeight;
    unsigned int* pixels =
        (unsigned int*)(unsigned char*)_internal->atlasPixels;
    // Ensure empty memory
    memset(pixels, 0, max * sizeof(int));
    if (defaultColor != 0) {
        for (int i = 0; i < max; i++) {
            pixels[i] = defaultColor;
        }
    }
}

void Atlas::end() {
    // const unsigned char* pixels = (const unsigned char*)atlasPixels;
    // lodepng::encode(output, pixels, atlasPixels.width(),
    // atlasPixels.height(), LCT_RGBA);
    // TODO: Optimization: Save in appropriate format - grayscale (SDF/PSDF),
    // RGB (MSDF) and RGBA for raster.
}

class AtlasUtils {
   public:
    static void copyGrayBitmapToAtlas(Atlas& atlas, Bitmap<float, 1>& sdf,
                                      int width, int height, int ox, int oy,
                                      bool ccw) {
        auto atlasPixels = atlas._internal->atlasPixels;

        oy += height;
        if (ccw) {
            for (int y = height - 1; y >= 0; y--) {
                byte* it = atlasPixels(ox, oy - y);
                for (int x = 0; x < width; x++) {
                    byte px = pixelFloatToByte(1.f - *sdf(x, y));
                    *it++ = px;
                    *it++ = px;
                    *it++ = px;
                    *it++ = 0xff;
                }
            }
        } else {
            for (int y = height - 1; y >= 0; y--) {
                byte* it = atlasPixels(ox, oy - y);
                for (int x = 0; x < width; x++) {
                    byte px = pixelFloatToByte(*sdf(x, y));
                    *it++ = px;
                    *it++ = px;
                    *it++ = px;
                    *it++ = 0xff;
                }
            }
        }
    }

    static void copyColorBitmapToAtlas(Atlas& atlas, Bitmap<float, 3>& msdf,
                                       int width, int height, int ox, int oy,
                                       bool ccw) {
        auto atlasPixels = atlas._internal->atlasPixels;
        oy += height;
        if (ccw) {
            for (int y = height - 1; y >= 0; y--) {
                byte* it = atlasPixels(ox, oy - y);
                for (int x = 0; x < width; x++) {
                    *it++ = pixelFloatToByte(1.f - msdf(x, y)[0]);
                    *it++ = pixelFloatToByte(1.f - msdf(x, y)[1]);
                    *it++ = pixelFloatToByte(1.f - msdf(x, y)[2]);
                    *it++ = 0xff;
                }
            }
        } else {
            for (int y = height - 1; y >= 0; y--) {
                byte* it = atlasPixels(ox, oy - y);
                for (int x = 0; x < width; x++) {
                    *it++ = pixelFloatToByte(msdf(x, y)[0]);
                    *it++ = pixelFloatToByte(msdf(x, y)[1]);
                    *it++ = pixelFloatToByte(msdf(x, y)[2]);
                    *it++ = 0xff;
                }
            }
        }
    }

    static void normalizeShape(Atlas& atlas, Shape& shape) {
        if (atlas._internal->normalizeShapes) {
            shape.normalize();
        } else {
            for (std::vector<msdfgen::Contour>::iterator contour =
                     shape.contours.begin();
                 contour != shape.contours.end(); ++contour) {
                if (contour->edges.size() == 1) {
                    contour->edges.clear();
                }
            }
        }
    }
};

bool Atlas::rasterizeGlyph(MSDFFont* font, int charcode, int width, int height,
                           int ox, int oy) {
    if (width == 0 || height == 0) return true;

    auto atlasPixels = _internal->atlasPixels;
    auto ft_lib = font->_library->_internal->ft_lib;

    FT_Error err = FT_Load_Char(font->fontSlot->ft, charcode, FT_LOAD_RENDER);
    if (err) return false;
    FT_Bitmap* bitmap = &font->fontSlot->ft->glyph->bitmap;
    int multiplier = 1;
    switch (bitmap->pixel_mode) {
        case FT_PIXEL_MODE_MONO:
            FT_Bitmap grayBtm;
            FT_Bitmap_Init(&grayBtm);
            FT_Bitmap_Convert(ft_lib, bitmap, &grayBtm, 1);
            bitmap = &grayBtm;
            multiplier = 0xff;
            // fall trough
        case FT_PIXEL_MODE_GRAY:
            if (_internal->enforceR8) {
                for (int y = 0; y < height; y++) {
                    byte* it = atlasPixels(ox, oy + y);
                    for (int x = 0; x < width; x++) {
                        unsigned char px =
                            bitmap->buffer[(y)*bitmap->width + x] * multiplier;
                        *it++ = px;
                        *it++ = px;
                        *it++ = px;
                        *it++ = 0xff;
                    }
                }
            } else {
                for (int y = 0; y < height; y++) {
                    byte* it = atlasPixels(ox, oy + y);
                    for (int x = 0; x < width; x++) {
                        unsigned char px =
                            bitmap->buffer[(y)*bitmap->width + x] * multiplier;
                        *it++ = 0xff;
                        *it++ = 0xff;
                        *it++ = 0xff;
                        *it++ = px;
                    }
                }
            }

            if (bitmap->pixel_mode == FT_PIXEL_MODE_MONO) {
                FT_Bitmap_Done(ft_lib, &grayBtm);
            }
            return true;
            break;
        default:
            std::cout << "[Error] Unsupported pixel mode: "
                      << (int)bitmap->pixel_mode << "\n";
            // TODO: Other pixel modes
            return false;
    }
}

bool Atlas::generateSDFGlyph(MSDFFont* font, int charcode, int width,
                             int height, int ox, int oy, double tx, double ty,
                             bool ccw, double range) {
    if (width == 0 || height == 0) return true;

    Shape glyph;
    if (loadGlyph(glyph, font->fontSlot->font, charcode)) {
        AtlasUtils::normalizeShape(*this, glyph);
        Bitmap<float, 1> sdf(width, height);
        double scale = font->scale;
        generateSDF(sdf, glyph, range / scale, scale,
                    Vector2(tx / scale, ty / scale));
        AtlasUtils::copyGrayBitmapToAtlas(*this, sdf, width, height, ox, oy,
                                          ccw);
        return true;
    }
    return false;
}

bool Atlas::generatePSDFGlyph(MSDFFont* font, int charcode, int width,
                              int height, int ox, int oy, double tx, double ty,
                              bool ccw, double range) {
    if (width == 0 || height == 0) return true;

    Shape glyph;
    if (loadGlyph(glyph, font->fontSlot->font, charcode)) {
        AtlasUtils::normalizeShape(*this, glyph);
        Bitmap<float, 1> sdf(width, height);
        double scale = font->scale;
        generatePseudoSDF(sdf, glyph, range / scale, scale,
                          Vector2(tx / scale, ty / scale));
        AtlasUtils::copyGrayBitmapToAtlas(*this, sdf, width, height, ox, oy,
                                          ccw);
        return true;
    }
    return false;
}

bool Atlas::generateMSDFGlyph(MSDFFont* font, int charcode, int width,
                              int height, int ox, int oy, double tx, double ty,
                              bool ccw, double range) {
    if (width == 0 || height == 0) return true;
    Shape glyph;
    if (loadGlyph(glyph, font->fontSlot->font, charcode)) {
        AtlasUtils::normalizeShape(*this, glyph);
        edgeColoringSimple(glyph, 3, 0);
        Bitmap<float, 3> msdf(width, height);
        double scale = font->scale;
        generateMSDF(msdf, glyph, range / scale, scale,
                     Vector2(tx / scale, ty / scale));
        AtlasUtils::copyColorBitmapToAtlas(*this, msdf, width, height, ox, oy,
                                           ccw);
        return true;
    }
    return false;
}

bool Atlas::generateSDFPath(MSDFShape* msdfShape, double width, double height,
                            int ox, int oy, double tx, double ty, double range,
                            double _scale) {
    auto* slot = msdfShape->_internal;
    Bitmap<float, 1> sdf(width, height);
    Shape* shape = slot->shape;
    generateSDF(sdf, *shape, range, Vector2(slot->scale, slot->scale),
                Vector2(tx, ty));
    AtlasUtils::copyGrayBitmapToAtlas(*this, sdf, width, height, ox, oy, false);
    return true;
}

bool Atlas::generateMSDFPath(MSDFShape* msdfShape, double width, double height,
                             int ox, int oy, double tx, double ty, double range,
                             double _scale) {
    auto* slot = msdfShape->_internal;
    Bitmap<float, 3> sdf(width, height);
    Shape* shape = slot->shape;
    edgeColoringSimple(*shape, 3, 0);
    generateMSDF(sdf, *shape, range, Vector2(slot->scale, slot->scale),
                 Vector2(tx, ty));
    AtlasUtils::copyColorBitmapToAtlas(*this, sdf, width, height, ox, oy,
                                       false);
    return true;
}

bool Atlas::generatePSDFPath(MSDFShape* msdfShape, double width, double height,
                             int ox, int oy, double tx, double ty, double range,
                             double _scale) {
    auto* slot = msdfShape->_internal;
    Bitmap<float, 1> sdf(width, height);
    Shape* shape = slot->shape;
    generatePseudoSDF(sdf, *shape, range, Vector2(slot->scale, slot->scale),
                      Vector2(tx, ty));
    AtlasUtils::copyGrayBitmapToAtlas(*this, sdf, width, height, ox, oy, false);
    return true;
}



MSDFShape* ShapeLibrary::loadSvgShape(const char* path, int fontSize,
                                      double scale, double endpointSnapRange) {
    Shape* shape = new Shape();
    // buildShapeFromSvgPath(*shape, path, fontSize*1.4);
    buildShapeFromSvgPath(*shape, path, endpointSnapRange);
    bool autoFrame = true;
    Vector2 translate;
    bool scaleSpecified = false;
    Shape::Bounds bounds = {};
    shape->normalize();
    shape->inverseYAxis = true;

    bounds = shape->getBounds();
    int index = shapes.size();
    MSDFShape* msdfShape = new MSDFShape();
    msdfShape->_internal->shape = shape;
    msdfShape->_internal->scale = scale;

    this->shapes.push_back(msdfShape);
    return msdfShape;
}

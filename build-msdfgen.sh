cmake -GNinja -B build_msdf_debug -DMSDFGEN_USE_VCPKG=OFF -DMSDFGEN_USE_SKIA=OFF -DCMAKE_BUILD_TYPE=Debug native/msdfgen/
cmake --build build_msdf_debug
cmake -GNinja -B build_msdf_release -DMSDFGEN_USE_VCPKG=OFF -DMSDFGEN_USE_SKIA=OFF -DCMAKE_BUILD_TYPE=Release native/msdfgen/
cmake --build build_msdf_release

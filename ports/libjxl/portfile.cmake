vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO 4creators/libjxl
    REF 839e59a7805ffc38174ba0d5270b4cdf420aee30
    SHA512 4e256a76888a4a52dd882ab4836ceba923d29350cb1d8078b32a64296710f99e82a45e1476ab303c9e535eb505a74ff8699acf22a9f56aa1a2a3cf6f4d321e63
    HEAD_REF SupportBgra
    PATCHES
        # fix-dependencies.patch
        # avoid-exe-linker-flags.patch # https://github.com/libjxl/libjxl/pull/4229
        # msvc-remove-libm.patch
        # disambiguate-pow-calls.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools JPEGXL_ENABLE_TOOLS
    INVERTED_FEATURES
        tools CMAKE_DISABLE_FIND_PACKAGE_GIF
        tools CMAKE_DISABLE_FIND_PACKAGE_JPEG
        tools CMAKE_DISABLE_FIND_PACKAGE_PNG
        tools CMAKE_DISABLE_FIND_PACKAGE_ZLIB
)

if(VCPKG_TARGET_IS_UWP)
    string(APPEND VCPKG_C_FLAGS " /wd4146")
    string(APPEND VCPKG_CXX_FLAGS " /wd4146")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DJPEGXL_VERSION=${JPEGXL_VERSION}"
        -DJPEGXL_FORCE_SYSTEM_HWY=ON
        -DJPEGXL_FORCE_SYSTEM_BROTLI=ON
        -DJPEGXL_FORCE_SYSTEM_HWY=ON
        -DJPEGXL_FORCE_SYSTEM_LCMS2=ON
        ${FEATURE_OPTIONS}
        -DJPEGXL_ENABLE_BENCHMARK=OFF
        -DJPEGXL_ENABLE_DOXYGEN=OFF
        -DJPEGXL_ENABLE_EXAMPLES=OFF
        -DJPEGXL_ENABLE_FUZZERS=OFF
        -DJPEGXL_ENABLE_JNI=OFF
        -DJPEGXL_ENABLE_MANPAGES=OFF
        -DJPEGXL_ENABLE_OPENEXR=OFF
        -DJPEGXL_ENABLE_PLUGINS=OFF
        -DJPEGXL_ENABLE_SJPEG=OFF
        -DJPEGXL_ENABLE_SKCMS=OFF
        -DJPEGXL_ENABLE_TCMALLOC=OFF
        -DBUILD_TESTING=OFF
        -DCMAKE_FIND_PACKAGE_TARGETS_GLOBAL=ON
        -DJPEGXL_BUNDLE_LIBPNG=OFF
    MAYBE_UNUSED_VARIABLES
        CMAKE_DISABLE_FIND_PACKAGE_GIF
        CMAKE_DISABLE_FIND_PACKAGE_JPEG
        CMAKE_DISABLE_FIND_PACKAGE_PNG
        CMAKE_DISABLE_FIND_PACKAGE_ZLIB
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

if(JPEGXL_ENABLE_TOOLS)
    vcpkg_copy_tools(TOOL_NAMES cjxl djxl jxlinfo AUTO_CLEAN)
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/jxl/jxl_export.h" "ifdef JXL_STATIC_DEFINE" "if 1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

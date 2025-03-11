if(NOT TARGET hermes-engine::libhermes)
add_library(hermes-engine::libhermes SHARED IMPORTED)
set_target_properties(hermes-engine::libhermes PROPERTIES
    IMPORTED_LOCATION "/Users/monangchampaneri/.gradle/caches/8.10.2/transforms/d4a5a98d73f1004cb0065b606bfea594/transformed/hermes-android-0.78.0-release/prefab/modules/libhermes/libs/android.armeabi-v7a/libhermes.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/monangchampaneri/.gradle/caches/8.10.2/transforms/d4a5a98d73f1004cb0065b606bfea594/transformed/hermes-android-0.78.0-release/prefab/modules/libhermes/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()


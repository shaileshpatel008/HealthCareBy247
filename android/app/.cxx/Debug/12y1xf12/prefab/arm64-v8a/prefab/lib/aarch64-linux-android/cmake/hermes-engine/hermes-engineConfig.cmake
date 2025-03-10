if(NOT TARGET hermes-engine::libhermes)
add_library(hermes-engine::libhermes SHARED IMPORTED)
set_target_properties(hermes-engine::libhermes PROPERTIES
    IMPORTED_LOCATION "/Users/monangchampaneri/.gradle/caches/8.10.2/transforms/036baa93aa40cd2773c52577e2f2a480/transformed/hermes-android-0.78.0-debug/prefab/modules/libhermes/libs/android.arm64-v8a/libhermes.so"
    INTERFACE_INCLUDE_DIRECTORIES "/Users/monangchampaneri/.gradle/caches/8.10.2/transforms/036baa93aa40cd2773c52577e2f2a480/transformed/hermes-android-0.78.0-debug/prefab/modules/libhermes/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()


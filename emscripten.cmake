if(DEFINED ENV{EMSDK})
  add_library(emscripten_system_include INTERFACE)
  target_include_directories(emscripten_system_include
    INTERFACE $<BUILD_INTERFACE:$ENV{EMSDK}/upstream/emscripten/system/include>)
endif()

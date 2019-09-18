include_guard(GLOBAL)

add_library(std_thread INTERFACE)
if(UNIX AND NOT APPLE)
  target_compile_options(std_thread INTERFACE -pthread)
  target_link_libraries(std_thread INTERFACE "-Wl,-lpthread")
endif()

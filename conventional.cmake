add_library(std_thread INTERFACE)
if(UNIX AND NOT APPLE)
  target_compile_options(std_thread INTERFACE -pthread)
  target_link_libraries(std_thread INTERFACE "-Wl,-lpthread")
endif()

option(COVERAGE "Enable coverage reporting (only on GCC / Clang)" OFF)

function(target_conventional_config name)
  if(COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(${name} INTERFACE -g --coverage)
    target_link_options(${name} INTERFACE --coverage)
  endif()
endfunction()

function(add_conventional_library name)
  file(GLOB_RECURSE library_files "library/*.hpp" "library/*.cpp")
  file(GLOB_RECURSE include_files "include/${name}/*.hpp")
  source_group("library" REGULAR_EXPRESSION "library/.*")
  source_group("include\\${name}" REGULAR_EXPRESSION "include/${name}/.*")
  if ("${library_files}" STREQUAL "")
    add_library(${name} INTERFACE)
    target_sources(${name} INTERFACE ${include_files})
    target_include_directories(${name}
      INTERFACE
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
  else()
    add_library(${name} ${library_files} ${include_files})
    target_include_directories(${name}
      PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
      PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/library")
  endif()
  target_conventional_config(${name})
endfunction()

function(add_conventional_executable name)
  file(GLOB_RECURSE program_files "program/*.cpp" "program/*.hpp")
  source_group("program" REGULAR_EXPRESSION "program/.*")
  add_executable(${name} ${program_files})
  target_include_directories(${name}
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/program")
  target_conventional_config(${name})
endfunction()

function(add_conventional_executable_test name)
  file(GLOB_RECURSE testing_files "testing/*.cpp" "testing/*.hpp")
  source_group("testing" REGULAR_EXPRESSION "testing/.*")
  add_executable(${name} ${testing_files})
  target_include_directories(${name}
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/testing")
  target_conventional_config(${name})
  add_test(NAME ${name} COMMAND ${name})
endfunction()

function(add_conventional_targets_under directory)
  if(EXISTS "${directory}/CMakeLists.txt")
    add_subdirectory("${directory}")
  else()
    file(GLOB files "${directory}/*")
    foreach(file ${files})
      if(IS_DIRECTORY "${file}")
        add_conventional_targets_under("${file}")
      endif()
    endforeach()
  endif()
endfunction()

function(add_conventional_targets_provided_under directory)
  if(EXISTS "${directory}/provides")
    add_conventional_targets_under("${directory}/provides")
  else()
    file(GLOB files "${directory}/*")
    foreach(file ${files})
      if(IS_DIRECTORY "${file}")
        add_conventional_targets_provided_under("${file}")
      endif()
    endforeach()
  endif()
endfunction()

function(add_conventional_targets)
  add_conventional_targets_provided_under("${CMAKE_CURRENT_SOURCE_DIR}/requires")
  add_conventional_targets_under("${CMAKE_CURRENT_SOURCE_DIR}/provides")
  add_conventional_targets_provided_under("${CMAKE_CURRENT_SOURCE_DIR}/equipment")
  add_conventional_targets_under("${CMAKE_CURRENT_SOURCE_DIR}/internals")
endfunction()

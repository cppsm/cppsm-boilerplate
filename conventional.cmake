set_property(GLOBAL PROPERTY USE_FOLDERS ON)

add_library(std_thread INTERFACE)
if(UNIX AND NOT APPLE)
  target_compile_options(std_thread INTERFACE -pthread)
  target_link_libraries(std_thread INTERFACE "-Wl,-lpthread")
endif()

option(COVERAGE "Enable coverage reporting (only on GCC / Clang)" OFF)

function(target_conventional_folder name)
  file(RELATIVE_PATH folder ${PROJECT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
  set_target_properties(${name} PROPERTIES FOLDER ${folder})
endfunction()

function(target_conventional_config name)
  if(COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(${name} INTERFACE -g --coverage)
    target_link_options(${name} INTERFACE --coverage)
  endif()
endfunction()

function(add_conventional_library name)
  file(GLOB_RECURSE library_files "library/*.hpp" "library/*.cpp")
  file(GLOB_RECURSE include_files "include/${name}/*.hpp")
  if("${library_files}" STREQUAL "")
    add_library(${name} INTERFACE)
    target_include_directories(${name}
      INTERFACE
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)

	set(interface_name "${name}.interface")
	source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/include" PREFIX "include" FILES ${include_files})
	add_custom_target(${interface_name} SOURCES ${include_files})
	target_conventional_folder(${interface_name})

	add_dependencies(${name} ${interface_name})
  else()
    source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/library" PREFIX "library" FILES ${library_files})
    source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/include" PREFIX "include" FILES ${include_files})
    add_library(${name} ${library_files} ${include_files})
    target_include_directories(${name}
      PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
      PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/library")
    target_conventional_folder(${name})
  endif()
  target_conventional_config(${name})
endfunction()

function(add_conventional_executable name)
  file(GLOB_RECURSE program_files "program/*.cpp" "program/*.hpp")
  source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/program" PREFIX "program" FILES ${program_files})
  add_executable(${name} ${program_files})
  target_include_directories(${name}
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/program")
  target_conventional_folder(${name})
  target_conventional_config(${name})
endfunction()

function(add_conventional_executable_test name)
  file(GLOB_RECURSE testing_files "testing/*.cpp" "testing/*.hpp")
  source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/testing" PREFIX "testing" FILES ${testing_files})
  add_executable(${name} ${testing_files})
  target_include_directories(${name}
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/testing")
  target_conventional_folder(${name})
  target_conventional_config(${name})
  add_test(NAME ${name} COMMAND ${name})
endfunction()

function(add_conventional_executable_tests)
  file(GLOB_RECURSE test_sources "testing/*.cpp")
  source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/testing" PREFIX "testing" FILES ${test_sources})
  foreach(test_source ${test_sources})
    get_filename_component(test ${test_source} NAME_WE)
    add_executable(${test} ${test_source})
    target_link_libraries(${test} ${ARGV})
    target_conventional_folder(${test})
    target_conventional_config(${test})
    add_test(NAME ${test} COMMAND ${test})
  endforeach()
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

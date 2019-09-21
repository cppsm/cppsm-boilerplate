include_guard(GLOBAL)

# Private ----------------------------------------------------------------------

function(target_conventional_folder name)
  file(RELATIVE_PATH folder ${PROJECT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
  set_target_properties(${name} PROPERTIES FOLDER ${folder})
endfunction()

function(conventional_source_group prefix files)
  source_group(
    TREE "${CMAKE_CURRENT_SOURCE_DIR}/${prefix}"
    PREFIX "${prefix}"
    FILES ${files})
endfunction()

# Public -----------------------------------------------------------------------

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
    conventional_source_group("include" "${include_files}")
    add_custom_target(${interface_name} SOURCES ${include_files})
    target_conventional_folder(${interface_name})

    add_dependencies(${name} ${interface_name})
  else()
    conventional_source_group("library" "${library_files}")
    conventional_source_group("include" "${include_files}")
    add_library(${name} ${library_files} ${include_files})
    target_include_directories(${name}
      PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
      PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/library")
    target_conventional_folder(${name})
  endif()
endfunction()

function(add_conventional_executable name)
  file(GLOB_RECURSE program_files "program/*.cpp" "program/*.hpp")
  conventional_source_group("program" "${program_files}")
  add_executable(${name} ${program_files})
  target_include_directories(${name}
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/program")
  target_conventional_folder(${name})
endfunction()

function(add_conventional_executable_test name)
  file(GLOB_RECURSE testing_files "testing/*.cpp" "testing/*.hpp")
  conventional_source_group("testing" "${testing_files}")
  add_executable(${name} ${testing_files})
  target_include_directories(${name}
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/testing")
  target_conventional_folder(${name})
  add_test(NAME ${name} COMMAND ${name})
endfunction()

function(add_conventional_executable_tests)
  file(GLOB_RECURSE test_sources "testing/*.cpp")
  conventional_source_group("testing" "${test_sources}")
  foreach(test_source ${test_sources})
    get_filename_component(test ${test_source} NAME_WE)
    add_executable(${test} ${test_source})
    target_link_libraries(${test} ${ARGV})
    target_conventional_folder(${test})
    add_test(NAME ${test} COMMAND ${test})
  endforeach()
endfunction()

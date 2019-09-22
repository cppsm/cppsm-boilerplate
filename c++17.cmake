if("${CMAKE_SOURCE_DIR}" STREQUAL "${PROJECT_SOURCE_DIR}")
  enable_testing()

  set_property(GLOBAL PROPERTY USE_FOLDERS ON)

  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
  set(CMAKE_CXX_EXTENSIONS FALSE)

  option(CPPSM_COVERAGE "Enable coverage reporting (only on GCC / Clang)" OFF)
  option(CPPSM_EXCEPTIONS "Enable C++ exceptions" ON)
  option(CPPSM_RTTI "Enable generation of RTTI information" ON)

  if(MSVC)
    set(CMAKE_CXX_FLAGS "/W4 /WX /Oy")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHsc")
    if(NOT CPPSM_RTTI)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /GR-")
    endif()
  else()
    set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic -Werror -fomit-frame-pointer")
    if(CPPSM_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g --coverage")
      set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
    endif()
    if(NOT CPPSM_EXCEPTIONS)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
    endif()
    if(NOT CPPSM_RTTI)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
    endif()
  endif()

  include(.cppsm/std_thread.cmake)
endif()

include(.cppsm/conventional.cmake)

add_conventional_targets()

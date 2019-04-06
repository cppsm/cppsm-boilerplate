enable_testing()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_EXTENSIONS FALSE)

if (MSVC)
  set(CMAKE_CXX_FLAGS "/W4 /WX /EHsc /GR-")
else()
  set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic -Werror -fno-exceptions -fno-rtti -fomit-frame-pointer")
endif()

include(.cppsm/conventional.cmake)

add_conventional_targets()

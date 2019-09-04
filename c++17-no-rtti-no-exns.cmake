if(NOT DEFINED CPPSM_EXCEPTIONS)
  set(CPPSM_EXCEPTIONS OFF CACHE BOOL "Disable C++ exceptions")
endif()

if(NOT DEFINED CPPSM_RTTI)
  set(CPPSM_RTTI OFF CACHE BOOL "Disable generation of RTTI information")
endif()

include(.cppsm/c++17.cmake)

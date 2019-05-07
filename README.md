# [≡](#contents) [C++ submodule manager boilerplate](#)

Per project boilerplate files for C++ submodule manager. See also the
[C++ submodule manager command-line interface](https://github.com/cppsm/cppsm-cli)
project.

## <a id="contents"></a> [≡](#contents) [Contents](#contents)

- [CMake functions](#cmake-functions)
  - [`add_conventional_executable(name)`](#add_conventional_executable)
  - [`add_conventional_executable_test(name)`](#add_conventional_executable_test)
  - [`add_conventional_executable_tests(...)`](#add_conventional_executable_tests)
  - [`add_conventional_library(name)`](#add_conventional_library)
- [Travis](#travis)

## <a id="cmake-functions"></a> [≡](#contents) [CMake functions](#cmake-functions)

CMake functions are provided for simple libraries, tests, and executables.

### <a id="add_conventional_executable"></a> [≡](#contents) [`add_conventional_executable(name)`](#add_conventional_executable)

Adds an executable target. Assumes that the target directory has the following
structure:

    CMakeLists.txt
    program/
      *.(cpp|hpp)

Add dependencies using `target_link_libraries` separately.

### <a id="add_conventional_executable_test"></a> [≡](#contents) [`add_conventional_executable_test(name)`](#add_conventional_executable_test)

Adds an executable test target. Assumes that the target directory has the
following structure:

    CMakeLists.txt
    testing/
      *.(cpp|hpp)

Add dependencies using `target_link_libraries` separately.

### <a id="add_conventional_executable_tests"></a> [≡](#contents) [`add_conventional_executable_tests(...)`](#add_conventional_executable_tests)

Adds an executable test target per `.cpp` file. Assumes that the target
directory has the following structure:

    CMakeLists.txt
    testing/
      *.cpp

The arguments given to `add_conventional_executable_tests` are passed to
`target_link_libraries` for each added test target.

### <a id="add_conventional_library"></a> [≡](#contents) [`add_conventional_library(name)`](#add_conventional_library)

Adds a library target. Assumes that the target directory has the following
structure:

    CMakeLists.txt
    include/
      ${name}/
        *.hpp
    library/
      *.(cpp|hpp)

Note that inside `include` there is a directory with the target `${name}` (which
should also include the major version) to differentiate between the header files
of different targets (and their major versions).

Add dependencies using `target_link_libraries` separately.

## <a id="travis"></a> [≡](#contents) [Travis](#travis)

A [Travis CI](https://travis-ci.org/) configuration file is provided to build
and test both `Debug` and `Release` builds on various OS and compiler
configurations:

- Linux
  - GCC (8)
  - Clang (7)
- OS X
  - GCC (8)
  - Apple Clang (10)
- Windows
  - Visual Studio (2017)
  - MinGW GCC (8)

Just add your project to Travis CI.

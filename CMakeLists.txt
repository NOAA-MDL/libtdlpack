# This is the main CMake file for libtdlpack.
#
# Eric Engle
cmake_minimum_required(VERSION 3.18)

# Get the version from the VERSION file.
file(STRINGS "VERSION" pVersion)

# Set up the cmake project.
project(tdlpack VERSION ${pVersion} LANGUAGES C Fortran)

# Load GNU standard install paths.
include(GNUInstallDirs)

# Handle user options.
#option(ENABLE_DOCS "Enable generation of Doxygen-based documentation" OFF)
#option(OPENMP "Use OpenMP threading" OFF)
option(BUILD_SHARED_LIBS "Build shared libraries" ON)
option(BUILD_STATIC_LIBS "Build static libraries" ON)
option(BUILD_4 "Build the 4-byte integer & real version of the library, libtdlpack_4.{a,so}" ON)
#option(BUILD_8 "Build the 8-byte integer & real version of the library, libtdlpack_8.{a,so}" OFF)
option(BUILD_TESTING "Build tests" ON)
option(CMAKE_POSITION_INDEPENDENT_CODE "Enable PIC" ON)

# Figure whether user wants a _4 and/or _8.
if(BUILD_4)
  set(kinds "4")
endif()
#if(BUILD_8)
#  set(kinds ${kinds} "8")
#endif()
#if(NOT BUILD_4 AND NOT BUILD_8)
#  message(FATAL_ERROR "At least one of BUILD_4 and BUILD_8 must be turned on")
#endif()
message(STATUS "Library kinds that will be build: ${kinds}")

# Set the build type.
if(NOT CMAKE_BUILD_TYPE MATCHES "^(Debug|Release|RelWithDebInfo|MinSizeRel)$")
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# Handle OpenMP if desired.
#if(OPENMP)
#  find_package(OpenMP REQUIRED COMPONENTS Fortran)
#endif()

# Set compiler flags.
if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel|IntelLLVM)$")
  set(CMAKE_Fortran_FLAGS "-g -traceback -assume byterecl -fp-model strict -fpp -auto ${CMAKE_Fortran_FLAGS}")
  #set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -check all -warn all")
  #if(CMAKE_Fortran_COMPILER_ID MATCHES "^(IntelLLVM)$")
  #  # Avoid Intel OneAPI 2023.2.1 bug
  #  set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -check nouninit ")
  #endif()
#  set(fortran_8_flags "-i8 -r8")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^(GNU)$")
  set(CMAKE_Fortran_FLAGS "-O3 -g -fbacktrace -fautomatic -finit-integer=zero -finit-real=zero -finit-logical=false ${CMAKE_Fortran_FLAGS}")
  set(F77_FLAGS "-fd-lines-as-comments -ffixed-form")
  set(F90_FLAGS "")
  #set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -ggdb -Wall -Wno-unused-dummy-argument -Wsurprising -Wextra -fcheck=all")
#  set(fortran_8_flags "-fdefault-integer-8 -fdefault-real-8")
endif()

# This is the source code directiroy.
add_subdirectory(src)

# Build tests.
include(CTest)
if(BUILD_TESTING)
  add_subdirectory(tests)
endif()

# If doxygen documentation we enabled, build it.
#if(ENABLE_DOCS)
#  find_package(Doxygen REQUIRED)
#  set(abs_top_srcdir "${CMAKE_SOURCE_DIR}")
#  add_subdirectory(docs)  
#endif()

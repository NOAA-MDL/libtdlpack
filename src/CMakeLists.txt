# This is the CMake file for the src directory of libtdlpack.
#
# Eric Engle

# These are the source code filees.
file(GLOB F77_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/*.f)
file(GLOB F90_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/*.f90)

# Set compiler flags.
#if(CMAKE_BUILD_TYPE MATCHES "Debug")
#  # Bounds checking is turned on for all files for the "Debug" build in the
#  # main CMakeLists.txt.
#  if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel|IntelLLVM)$")
#    set_source_files_properties(sp_mod.F PROPERTIES COMPILE_FLAGS -check=nobounds)
#  elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^(GNU)$")
#    if(${CMAKE_Fortran_COMPILER_VERSION} VERSION_GREATER_EQUAL 6)
#      set_source_files_properties(sp_mod.F PROPERTIES COMPILE_FLAGS -fcheck=no-bounds)
#    else()
#      set_source_files_properties(sp_mod.F PROPERTIES COMPILE_FLAGS -fno-bounds-check)
#    endif()
#  endif()
#endif()

# Build _4 and/or _8 depending on options provided to CMake
foreach(kind ${kinds})
  #set(lib_name ${PROJECT_NAME}_${kind})
  #set(module_dir "${CMAKE_CURRENT_BINARY_DIR}/include_${kind}")
  set(lib_name ${PROJECT_NAME})
  set(module_dir "${CMAKE_CURRENT_BINARY_DIR}/include")

  # Create the C header files for this kind.
  #configure_file(tdlpack_${kind}.h ${CMAKE_CURRENT_BINARY_DIR}/include_${kind}/tdlpack.h COPYONLY)
  configure_file(tdlpack.h ${CMAKE_CURRENT_BINARY_DIR}/include/tdlpack.h COPYONLY)

  # Apply flags to fixed-form sources (.f)
  set_source_files_properties(${F77_SRCS} PROPERTIES 
      COMPILE_FLAGS "${CMAKE_Fortran_FLAGS} ${F77_FLAGS}")

  # Apply flags to free-form sources (.f90)
  set_source_files_properties(${F90_SRCS} PROPERTIES 
      COMPILE_FLAGS "${CMAKE_Fortran_FLAGS} ${F90_FLAGS}")

  # Build the object library. The object library will be used to
  # static and shared libraries.
  add_library(${lib_name}_objlib OBJECT ${F77_SRCS} ${F90_SRCS})
  target_include_directories(${lib_name}_objlib PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
  add_library(${PROJECT_NAME}::${lib_name} ALIAS ${lib_name}_objlib)

  # Build the static library.
  if(BUILD_STATIC_LIBS)
    add_library(${lib_name}_static STATIC $<TARGET_OBJECTS:${lib_name}_objlib>)
    set_target_properties(${lib_name}_static PROPERTIES OUTPUT_NAME ${lib_name})
    set_target_properties(${lib_name}_static PROPERTIES EXPORT_NAME ${lib_name})
    set_target_properties(${lib_name}_static PROPERTIES EXPORT_NAME ${lib_name}_static)
    list(APPEND LIB_TARGETS ${lib_name}_static)
  endif()
  
  # For shared, set SOVERSION; increment it if API changes (other than
  # adding new functions).
  if(BUILD_SHARED_LIBS)
    add_library(${lib_name}_shared SHARED $<TARGET_OBJECTS:${lib_name}_objlib>)
    set_target_properties(${lib_name}_shared PROPERTIES OUTPUT_NAME ${lib_name})
    set_target_properties(${lib_name}_shared PROPERTIES EXPORT_NAME ${lib_name})
    set_target_properties(${lib_name}_shared PROPERTIES SOVERSION 0)
    list(APPEND LIB_TARGETS ${lib_name}_shared)
  endif()

  # Handle OpenMP.
  #if(OpenMP_Fortran_FOUND)
  #  target_link_libraries(${lib_name} PUBLIC OpenMP::OpenMP_Fortran)
  #endif()

  #set_target_properties(${lib_name} PROPERTIES COMPILE_FLAGS "${fortran_${kind}_flags}")
  set_target_properties(${lib_name}_objlib PROPERTIES COMPILE_FLAGS "${fortran_flags}")
  set_target_properties(${lib_name}_objlib PROPERTIES Fortran_MODULE_DIRECTORY "${module_dir}")
  #target_include_directories(${lib_name}
  #  PUBLIC $<BUILD_INTERFACE:${module_dir}> $<INSTALL_INTERFACE:include_${kind}>)
  target_include_directories(${lib_name}_objlib
    PUBLIC $<BUILD_INTERFACE:${module_dir}> $<INSTALL_INTERFACE:include>)

  if(BUILD_STATIC_LIBS)
    set_target_properties(${lib_name}_static PROPERTIES COMPILE_FLAGS "${fortran_flags}")
    set_target_properties(${lib_name}_static PROPERTIES Fortran_MODULE_DIRECTORY "${module_dir}")
    target_include_directories(${lib_name}_static
      PUBLIC $<BUILD_INTERFACE:${module_dir}> $<INSTALL_INTERFACE:include>)
  endif()

  if(BUILD_SHARED_LIBS)
    set_target_properties(${lib_name}_shared PROPERTIES COMPILE_FLAGS "${fortran_flags}")
    set_target_properties(${lib_name}_shared PROPERTIES Fortran_MODULE_DIRECTORY "${module_dir}")
    target_include_directories(${lib_name}_shared
      PUBLIC $<BUILD_INTERFACE:${module_dir}> $<INSTALL_INTERFACE:include>)
  endif()

#  list(APPEND LIB_TARGETS ${lib_name})
  
  install(DIRECTORY ${module_dir} DESTINATION ${CMAKE_INSTALL_PREFIX})
  #install(FILES tdlpack_${kind}.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include_${kind} RENAME tdlpack.h)
  install(FILES tdlpack.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include RENAME tdlpack.h)
endforeach()

# Install the library or libraries.
install(
  TARGETS ${LIB_TARGETS}
  EXPORT ${PROJECT_NAME}Exports
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

### Package config
include(CMakePackageConfigHelpers)
set(CONFIG_INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

export(EXPORT ${PROJECT_NAME}Exports
  NAMESPACE ${PROJECT_NAME}::
  FILE ${PROJECT_NAME}-targets.cmake)

configure_package_config_file(
  ${CMAKE_SOURCE_DIR}/cmake/PackageConfig.cmake.in ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config.cmake
  INSTALL_DESTINATION ${CONFIG_INSTALL_DESTINATION})
install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config.cmake
  DESTINATION ${CONFIG_INSTALL_DESTINATION})

write_basic_package_version_file(
  ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion)
install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
  DESTINATION ${CONFIG_INSTALL_DESTINATION})

install(EXPORT ${PROJECT_NAME}Exports
  NAMESPACE ${PROJECT_NAME}::
  FILE ${PROJECT_NAME}-targets.cmake
  DESTINATION ${CONFIG_INSTALL_DESTINATION})

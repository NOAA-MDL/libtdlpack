# This is the CMake file for the tests/ directory of tdlpack.
# It define dozens of CTest unit tests. All new and modified code
# should have one or more unit tests to verify correct operation,
# including validation of outputs against known cases.
#
# Eric Engle

#if(FTP_TEST_FILES)
#  set(TEST_TARBALL_FILE "ip-test-data-20241230.tgz")
#  set(TEST_TARBALL_URL "https://ftp.emc.ncep.noaa.gov/static_files/public/tdlpack/${TEST_TARBALL_FILE}")
#  if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/${TEST_TARBALL_FILE})
#    message(STATUS "Using existing cached test file ${CMAKE_CURRENT_BINARY_DIR}/${TEST_TARBALL_FILE} ...")
#  elseif(TEST_FILES_CACHE)
#    if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/${TEST_TARBALL_FILE})
#      message(STATUS "Using existing cached test file ${CMAKE_CURRENT_BINARY_DIR}/${TEST_TARBALL_FILE} ...")
#    else()
##      message(STATUS "Copying in cached test file ${TEST_FILES_CACHE} ...")
#      file(COPY_FILE
#        ${TEST_FILES_CACHE}
#        ${CMAKE_CURRENT_BINARY_DIR}/${TEST_TARBALL_FILE}
#      )
#    endif()
#  else()
#    file(DOWNLOAD
#      ${TEST_TARBALL_URL}
#      ${CMAKE_CURRENT_BINARY_DIR}/${TEST_TARBALL_FILE}
#      SHOW_PROGRESS
#      STATUS DOWNLOAD_RESULT
#      INACTIVITY_TIMEOUT 30
#      )
#    if(NOT DOWNLOAD_RESULT EQUAL 0)
#      message(FATAL_ERROR "Failed to download ${TAR_FILE}")
#    endif()
#  endif()
#  find_program(TAR tar)
#  execute_process(
#    COMMAND ${TAR} -xzf "${CMAKE_CURRENT_BINARY_DIR}/${TEST_TARBALL_FILE}" -C "${CMAKE_CURRENT_BINARY_DIR}"
#    RESULT_VARIABLE TAR_RESULT
#  )
#  if(NOT TAR_RESULT EQUAL 0)
#    message(FATAL_ERROR "Failed to extract ${TAR_FILE}")
#  endif()
#endif()

#function(create_sp_test name kind timeout)
#  add_executable(${name}_${kind} ${name}.F90)
#
#  # Include openMP if desired.
#  if(OpenMP_Fortran_FOUND)
#    target_link_libraries(${name}_${kind} PRIVATE OpenMP::OpenMP_Fortran)
#  endif()
#  target_link_libraries(${name}_${kind} PRIVATE ip::ip_${kind})
#  if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel|IntelLLVM)$")
#    set_target_properties(${name}_${kind} PROPERTIES COMPILE_FLAGS "-convert big_endian ${fortran_${kind}_flags}")
#  elseif(${CMAKE_Fortran_COMPILER_ID} MATCHES "^(GNU)$")
#    set_target_properties(${name}_${kind} PROPERTIES COMPILE_FLAGS "-fconvert=big-endian ${fortran_${kind}_flags}")
#  endif()
#  add_test(NAME ${name}_${kind} COMMAND ${name}_${kind})
#  target_compile_definitions(${name}_${kind} PRIVATE "LSIZE=${kind}")
#  if(TEST_TIME_LIMIT)
#    set_tests_properties(${name}_${kind} PROPERTIES TIMEOUT ${timeout})
#  endif()
#endfunction()

# Set compiler flags.
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${CMAKE_Fortran_FLAGS_DEBUG}")
if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel|IntelLLVM)$")
  set(CMAKE_Fortran_FLAGS " -heap-arrays ${CMAKE_Fortran_FLAGS}")
  set(CMAKE_C_FLAGS "-std=c99")
endif()

foreach(kind ${kinds})
  string(TOUPPER ${kind} kind_definition)

  # Test open_log_file
  add_executable(test_open_log_file test_open_log_file.c)
  target_link_libraries(test_open_log_file PUBLIC tdlpack::tdlpack)
  #target_compile_definitions(test_open_log_file PRIVATE "LSIZE=${kind_definition}")
  #set_target_properties(test_open_log_file PROPERTIES COMPILE_FLAGS "${fortran_${kind}_flags}")
  add_test(test_open_log_file test_open_log_file)

  # Test open_tdlpack_file
  add_executable(test_open_tdlpack_file test_open_tdlpack_file.c)
  target_link_libraries(test_open_tdlpack_file PUBLIC tdlpack::tdlpack)
  #target_compile_definitions(test_open_tdlpack_file PRIVATE "LSIZE=${kind_definition}")
  #set_target_properties(test_open_tdlpack_file PROPERTIES COMPILE_FLAGS "${fortran_${kind}_flags}")
  add_test(test_open_tdlpack_file test_open_tdlpack_file)

  # Test write_ra
  add_executable(test_write_ra test_write_ra.c)
  target_link_libraries(test_write_ra PUBLIC tdlpack::tdlpack)
  #target_compile_definitions(test_write_ra PRIVATE "LSIZE=${kind_definition}")
  #set_target_properties(test_write_ra PROPERTIES COMPILE_FLAGS "${fortran_${kind}_flags}")
  add_test(test_write_ra test_write_ra)

  # Test write_sq
  add_executable(test_write_sq test_write_sq.c)
  target_link_libraries(test_write_sq PUBLIC tdlpack::tdlpack)
  #target_compile_definitions(test_write_sq PRIVATE "LSIZE=${kind_definition}")
  #set_target_properties(test_write_sq PROPERTIES COMPILE_FLAGS "${fortran_${kind}_flags}")
  add_test(test_write_sq test_write_sq)

endforeach() # foreach(kind ${kinds})

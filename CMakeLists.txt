# ############################################################################
# Copyright (C) 2023 Pedro Oliveira. All Rights Reserved.
# ############################################################################

# ############################################################################
# Configuring
# ############################################################################

# ============================================================================
# CMake General Settings
# ============================================================================

cmake_minimum_required(VERSION 3.21)

set(COMPANY_NAME "MyCompany")
project(
  MyProject
  VERSION 1.0.0.0
  LANGUAGES CXX
)

# ----------------------------------------------------------------------------
# CMake Include Modules
# ----------------------------------------------------------------------------

include(tools/BuildTools/cmake/Modules/BuildToolsMain.cmake)

# ----------------------------------------------------------------------------
# CMake Cache Variables & Options
# ----------------------------------------------------------------------------

cmake_host_system_information(RESULT OS_NAME_RESULT QUERY OS_NAME)

# short alias for top-level root folder
set(ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})

# VRVIU is not using the latest standard
set(CMAKE_CXX_STANDARD 20)

# prevent std=gnu++20 or similar
set(CMAKE_CXX_EXTENSIONS OFF)

# Surpress CTest Targets (Continuous, Experimental, Nightly)
set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED 1)

# Surpresses MSVC Target ZERO_CHECK
set(CMAKE_SUPPRESS_REGENERATION ON)

set(CMAKE_VERBOSE_MAKEFILE OFF)

set(CMAKE_DEBUG_POSTFIX d)

# Check to see if this project is the root/top-level project
if(CMAKE_VERSION VERSION_LESS 3.21)
  # This variable is set by project() in CMake 3.21+
  string(
    COMPARE EQUAL
            "${CMAKE_SOURCE_DIR}"
            "${PROJECT_SOURCE_DIR}"
            PROJECT_IS_TOP_LEVEL
  )
endif()

# ############################################################################
# Building
# ############################################################################

# ============================================================================
# CMake Configured Headers
# ============================================================================

# configure project metadata header file based on CMake configuration options
include(tools/BuildTools/cmake/Templates/IncludeMeta.cmake)
configure_meta_header_file()

# ============================================================================
# global settings that propagates settings to linking targets
# ============================================================================

add_library(myproject_global_settings INTERFACE)
set_project_warnings(myproject_global_settings)

# Include What You Use (from Windows)
if(OS_NAME_RESULT STREQUAL "Windows")

  target_compile_definitions(
    myproject_global_settings #
    INTERFACE WIN32_LEAN_AND_MEAN _WIN32_WINNT=0x0601 NOMINMAX
  )

  # target_link_libraries(myproject_global_settings INTERFACE ws2_32)
endif()

# ============================================================================
# myproject: My Project main library
# ============================================================================

add_library(myprojectlib)
add_dependencies(myprojectlib myproject_global_settings)
file(GLOB_RECURSE myprojectlib_SOURCE_FILES "src/ProjectLib/*.cpp")
file(GLOB_RECURSE myprojectlib_HEADER_FILES "src/ProjectLib/*.hpp")
file(GLOB_RECURSE myprojectlib_PUBLIC_HEADER_FILES "include/*.hpp")

target_sources(myprojectlib PRIVATE ${myprojectlib_SOURCE_FILES} ${myprojectlib_HEADER_FILES} ${myprojectlib_PUBLIC_HEADER_FILES})

target_include_directories(
  myprojectlib
  PRIVATE ${ROOT_DIR}/lib
  PUBLIC ${ROOT_DIR}/include
)

find_package(spdlog CONFIG REQUIRED)
target_link_libraries(myprojectlib PUBLIC myproject_global_settings spdlog::spdlog)

set_target_precompiled_headers(myprojectlib PRIVATE)

# ============================================================================
# myprojectapp: My Project main application
# ============================================================================

add_executable(myprojectapp)
add_dependencies(myprojectapp myprojectlib)

file(GLOB_RECURSE myprojectapp_SOURCE_FILES "src/ProjectApp/*.cpp")
file(GLOB_RECURSE myprojectapp_HEADER_FILES "src/ProjectApp/*.hpp")

target_sources(myprojectapp PRIVATE ${myprojectapp_SOURCE_FILES} ${myprojectapp_HEADER_FILES})

target_link_libraries(myprojectapp PRIVATE myprojectlib)

set_target_precompiled_headers(myprojectapp PRIVATE)

# ############################################################################
# Testing
# ############################################################################

enable_testing()
include(CTest)

# ============================================================================
# Main Tests
# ============================================================================

option(MYPROJECT_BUILD_MAIN_TESTS "Build main test targets" ${PROJECT_IS_TOP_LEVEL})
if(MYPROJECT_BUILD_MAIN_TESTS)

  # --------------------------------------------------------------------------
  # Dependencies
  # --------------------------------------------------------------------------

  find_package(Catch2 CONFIG REQUIRED)
  include(Catch)

  # --------------------------------------------------------------------------
  # TARGET: myproject_main_tests
  # --------------------------------------------------------------------------

  add_executable(myproject_main_tests)
  add_dependencies(myproject_main_tests myprojectlib)

  file(GLOB_RECURSE myproject_main_tests_SOURCE_FILES "tests/MainTests/*.cpp")

  target_sources(myproject_main_tests PRIVATE ${myproject_main_tests_SOURCE_FILES})

  target_link_libraries(myproject_main_tests PRIVATE myprojectlib Catch2::Catch2WithMain)

  set_target_precompiled_headers(myproject_main_tests PRIVATE)

  # --------------------------------------------------------------------------
  # Utilities
  # --------------------------------------------------------------------------

  catch_discover_tests(myproject_main_tests TEST_PREFIX "myproject_main_test_")

endif(MYPROJECT_BUILD_MAIN_TESTS)

# ============================================================================
# Unit Tests
# ============================================================================

option(MYPROJECT_BUILD_UNIT_TESTS "Build unit test targets" ${PROJECT_IS_TOP_LEVEL})
if(MYPROJECT_BUILD_UNIT_TESTS)
  # --------------------------------------------------------------------------
  # Dependencies
  # --------------------------------------------------------------------------
  set(gtest_EXTERNAL_DIR ${CMAKE_CURRENT_LIST_DIR}/external/googletest)
  find_package(GTest CONFIG REQUIRED)
  include(GoogleTest)
  # --------------------------------------------------------------------------
  # TARGET: myproject_unit_tests
  # --------------------------------------------------------------------------
  add_executable(myproject_unit_tests)
  add_dependencies(myproject_unit_tests myprojectlib)

  file(GLOB_RECURSE myproject_unit_tests_SOURCE_FILES "tests/UnitTests/*.cpp")

  target_sources(myproject_unit_tests PRIVATE ${myproject_unit_tests_SOURCE_FILES})

  target_link_libraries(myproject_unit_tests PRIVATE myprojectlib GTest::gtest GTest::gmock)

  set_target_precompiled_headers(myproject_unit_tests PRIVATE)

  # --------------------------------------------------------------------------
  # Utilities
  # --------------------------------------------------------------------------
  gtest_discover_tests(myproject_unit_tests TEST_PREFIX "myproject_unit_test_")

endif(MYPROJECT_BUILD_UNIT_TESTS)

# ============================================================================
# Performance Tests
# ============================================================================

option(MYPROJECT_BUILD_PERF_TESTS "Build performance test target" ${PROJECT_IS_TOP_LEVEL})
if(MYPROJECT_BUILD_PERF_TESTS AND ${CMAKE_BUILD_TYPE} STREQUAL "Release")
  # --------------------------------------------------------------------------
  # Dependencies
  # --------------------------------------------------------------------------
  find_package(benchmark CONFIG REQUIRED)
  # --------------------------------------------------------------------------
  # TARGET: myproject_perf_tests
  # --------------------------------------------------------------------------
  add_executable(myproject_perf_tests)
  add_dependencies(myproject_perf_tests myprojectlib)

  file(GLOB_RECURSE myproject_perf_tests_SOURCE_FILES "tests/PerfTests/*.cpp")
  target_sources(myproject_perf_tests PRIVATE ${myproject_perf_tests_SOURCE_FILES})
  target_link_libraries(myproject_perf_tests PRIVATE myprojectlib benchmark::benchmark)

  set_target_precompiled_headers(myproject_perf_tests PRIVATE)

  # --------------------------------------------------------------------------
  # Utilities
  # --------------------------------------------------------------------------
  # Allow short runs during automated testing to see if something new breaks
  # set(PERF_RUNTIME 2 CACHE STRING "Number of seconds to run fuzz tests during
  # ctest run" ) # Default of 2 seconds add_test(NAME perf_tester_run COMMAND
  # myproject_perf_tests -max_total_time=${PERF_RUNTIME} )
endif()

# ============================================================================
# Fuzzing Tests
# ============================================================================

option(MYPROJECT_BUILD_FUZZ_TESTS "Build fuzz test target" ${PROJECT_IS_TOP_LEVEL})
if(MYPROJECT_BUILD_FUZZ_TESTS)
  if(NOT
     CMAKE_CXX_COMPILER_ID
     STREQUAL
     "Clang"
     OR MSVC
  )
    log_warn("Fuzz tests require Clang")
    add_custom_target(myproject_fuzz_tests COMMAND echo -e "Fuzz tests require Clang")
  else()
    # ------------------------------------------------------------------------
    # Dependencies
    # ------------------------------------------------------------------------
    set(fmt_EXTERNAL_DIR ${CMAKE_CURRENT_LIST_DIR}/external/fmt)
    find_package(fmt CONFIG REQUIRED)
    # ------------------------------------------------------------------------
    # TARGET: myproject_fuzz_tests
    # ------------------------------------------------------------------------
    add_executable(myproject_fuzz_tests)
    add_dependencies(myproject_fuzz_tests myprojectlib)

    file(GLOB_RECURSE myproject_fuzz_tests_SOURCE_FILES "tests/FuzzTests/*.cpp")
    target_sources(myproject_fuzz_tests PRIVATE ${myproject_fuzz_tests_SOURCE_FILES})
    target_link_libraries(
      myproject_fuzz_tests
      PRIVATE myproject_global_settings
              fmt::fmt
              -coverage
              -fsanitize=fuzzer,undefined,address
    )
    target_compile_options(myproject_fuzz_tests PRIVATE -fsanitize=fuzzer,undefined,address)
    target_compile_features(myproject_fuzz_tests PRIVATE cxx_std_20)

    set_target_precompiled_headers(myproject_fuzz_tests PRIVATE)

    # ------------------------------------------------------------------------
    # Utilities
    # ------------------------------------------------------------------------
    # Allow short runs during automated testing to see if something new breaks
    # set(FUZZ_RUNTIME 2 CACHE STRING "Number of seconds to run fuzz tests
    # during ctest run" ) # Default of 2 seconds

    # add_test(NAME fuzz_tester_run COMMAND myproject_fuzz_tests
    # -max_total_time=${FUZZ_RUNTIME} )
  endif()
endif()

# ============================================================================
# Coverage Tests
# ============================================================================

option(MYPROJECT_BUILD_GCOV_TESTS "Build coverage test target" ${PROJECT_IS_TOP_LEVEL} # Problems with LLVM:
       # undefined reference to llvm_* functions
)
if(MYPROJECT_BUILD_GCOV_TESTS
   AND NOT MSVC
   AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU"
)
  # --------------------------------------------------------------------------
  # TARGET: myproject_covr_tests
  # --------------------------------------------------------------------------
  add_executable(myproject_covr_tests)
  add_dependencies(myproject_covr_tests myprojectlib)
  file(GLOB_RECURSE myproject_covr_tests_SOURCE_FILES "tests/UnitTests/*.cpp")
  target_sources(
    myproject_covr_tests
    PRIVATE ${myproject_SOURCE_FILES}
            ${myproject_HEADER_FILES}
            ${myproject_PUBLIC_HEADER_FILES}
            ${myproject_covr_tests_SOURCE_FILES}
  )
  target_link_libraries(
    myproject_covr_tests
    PRIVATE myprojectlib
            GTest::gtest
            GTest::gmock
            gcov
  )
  target_include_directories(myproject_covr_tests PRIVATE ${ROOT_DIR}/lib)

  set_target_precompiled_headers(myproject_covr_tests PRIVATE)

  # --------------------------------------------------------------------------
  # Utilities from CodeCoverage.cmake (in kksk_cmake_modules)
  # --------------------------------------------------------------------------
  # 1. Append necessary compiler flags for all supported source files
  append_coverage_compiler_flags_to_target(myproject_covr_tests)
  # 1. create a custom make target which runs your test executable and produces a
  #   code coverage report
  setup_target_for_coverage_lcov(
    NAME
    myproject_covr_tests_coverage
    EXECUTABLE
    myproject_covr_tests
    DEPENDENCIES
    myproject_covr_tests
    BASE_DIRECTORY
    "${ROOT_DIR}/tests/CovrTests"
    NO_DEMANGLE
  )
  add_custom_command(
    TARGET myproject_covr_tests_coverage
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${ROOT_DIR}/logs/myproject_covr_tests_coverage
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/myproject_covr_tests_coverage ${ROOT_DIR}/logs/myproject_covr_tests_coverage
    COMMENT "Copying report to ${ROOT_DIR}/logs/myproject_covr_tests_coverage"
  )
endif()

# ============================================================================
# Custom Targets
# ============================================================================

add_custom_target(BUILD_ALL_TESTS EXCLUDE_FROM_ALL)
add_dependencies(BUILD_ALL_TESTS myproject_unit_tests myproject_main_tests)

add_custom_target(
  RUN_ALL_TARGETS
  COMMAND myprojectapp
  COMMAND ${CMAKE_COMMAND} -E echo "Running Unit Tests"
  COMMAND ${CMAKE_COMMAND} -E echo ""
  COMMAND myproject_unit_tests
  COMMAND ${CMAKE_COMMAND} -E echo ""
  COMMAND ${CMAKE_COMMAND} -E echo "Running Main Tests"
  COMMAND ${CMAKE_COMMAND} -E echo ""
  COMMAND myproject_main_tests
  COMMAND ${CMAKE_COMMAND} -E echo ""
  COMMAND ${CMAKE_COMMAND} -E echo "Running Perf Tests"
  COMMAND ${CMAKE_COMMAND} -E echo ""
  COMMAND $<$<CONFIG:Release>:myproject_perf_tests>
  COMMAND ${CMAKE_COMMAND} -E echo ""
  COMMAND ${CMAKE_COMMAND} -E echo "Finished executing RUN_ALL_TARGETS"
)

# ############################################################################
# Installing
# ############################################################################

# ############################################################################
# Packaging
# ############################################################################

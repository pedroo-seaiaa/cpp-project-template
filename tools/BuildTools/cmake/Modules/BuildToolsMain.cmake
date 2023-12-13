include_guard(GLOBAL)

set(THIS_DIR ${CMAKE_CURRENT_LIST_DIR})
list(APPEND CMAKE_MODULE_PATH ${THIS_DIR})

# Check to see if this project is the root/top-level project
if(CMAKE_VERSION VERSION_LESS 3.21)
  # This variable is set by project() in CMake 3.21+
  string(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${PROJECT_SOURCE_DIR}" PROJECT_IS_TOP_LEVEL)
endif()

if(NOT PROJECT_IS_TOP_LEVEL)
  set(CMAKE_MODULE_PATH
      ${CMAKE_MODULE_PATH}
      PARENT_SCOPE
  )
endif()

include(Logger)

log_trace("Including Filesystem...")
include(Filesystem)
log_trace("Including Filesystem -- DONE")

log_trace("Including HostSystemInformation...")
include(HostSystemInformation)
log_trace("Including HostSystemInformation -- DONE")

log_trace("Including StandardProjectSettings...")
include(StandardProjectSettings)
log_trace("Including StandardProjectSettings -- DONE")

log_trace("Including PreventInSourceBuilds...")
include(PreventInSourceBuilds)
log_trace("Including PreventInSourceBuilds -- DONE")

log_trace("Including CCache...")
include(CCache)
log_trace("Including CCache -- DONE")

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  log_trace("Including CodeCoverage...")
  include(CodeCoverage)
  log_trace("Including CodeCoverage -- DONE")
endif()

log_trace("Including StaticAnalyzers...")
include(StaticAnalyzers)
log_trace("Including StaticAnalyzers -- DONE")

log_trace("Including CompilerWarnings...")
include(CompilerWarnings)
log_trace("Including CompilerWarnings -- DONE")

log_trace("Including Sanitizers...")
include(Sanitizers)
log_trace("Including Sanitizers -- DONE")

log_trace("Including Doxygen...")
include(Doxygen)
log_trace("Including Doxygen -- DONE")

log_trace("Including CPM...")
set(CMAKE_MESSAGE_LOG_LEVEL ERROR)
include(CPM)
set(CMAKE_MESSAGE_LOG_LEVEL STATUS)
log_trace("Including CPM -- DONE")

log_trace("Including FetchAndInstall...")
include(FetchAndInstall)
log_trace("Including FetchAndInstall -- DONE")

log_trace("Including FetchGTest...")
include(FetchGTest)
log_trace("Including FetchGTest -- DONE")

log_trace("Including FetchCatch...")
include(FetchCatch)
log_trace("Including FetchCatch -- DONE")

log_trace("Including FetchGSL...")
include(FetchGSL)
log_trace("Including FetchGSL -- DONE")

log_trace("Setting CMAKE_PROJECT_INCLUDE...")
set(CMAKE_PROJECT_INCLUDE ${THIS_DIR}/CMakeProjectInclude.cmake)
log_trace("Setting CMAKE_PROJECT_INCLUDE -- DONE")

log_trace("Setting CMAKE_PROJECT_INCLUDE_BEFORE...")
set(CMAKE_PROJECT_INCLUDE_BEFORE ${THIS_DIR}/CMakeProjectIncludeBefore.cmake)
log_trace("Setting CMAKE_PROJECT_INCLUDE_BEFORE -- DONE")

log_trace("Setting CMAKE_PROJECT_INCLUDE_BEFORE...")
include(PreCompiledHeaders)
log_trace("Setting CMAKE_PROJECT_INCLUDE_BEFORE -- DONE")

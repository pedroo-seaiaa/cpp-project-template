include_guard(GLOBAL)

function(include_gsl)
  log_info("Configuring GSL")
  find_package(Microsoft.GSL CONFIG QUIET)
  if(NOT Microsoft.GSL_FOUND)
    if(NOT EXISTS ${CMAKE_BINARY_DIR}/_deps/GSL-src)
      log_warn("Configuring GSL -- NOT FOUND")
      log_info("Downloading into ${CMAKE_BINARY_DIR}/_deps")
      FetchContent_Declare(
        GSL
        GIT_REPOSITORY "https://github.com/microsoft/GSL"
        GIT_TAG "v4.0.0"
        GIT_SHALLOW ON
      )
      FetchContent_MakeAvailable(GSL)
    else()
      log_warn("Configuring GSL -- FOUND in ${CMAKE_BINARY_DIR}/_deps")
      add_subdirectory(${CMAKE_BINARY_DIR}/_deps/GSL-src)
    endif()
    log_info("You might want to try installing on your system")
    add_library(KKSK::GSL ALIAS GSL)
  else()
    add_library(KKSK::GSL ALIAS GSL)
  endif()
  log_info("Configuring GSL -- done")
endfunction()

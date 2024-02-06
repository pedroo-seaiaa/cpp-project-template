include_guard(GLOBAL)

function(include_catch)
  log_info("Configuring Catch")
  find_package(Catch2 3 QUIET)
  if(NOT Catch2_FOUND)
    if(NOT EXISTS ${CMAKE_BINARY_DIR}/_deps/Catch2-src)
      log_warn("Configuring Catch2 -- NOT FOUND")
      log_info("Downloading into ${CMAKE_BINARY_DIR}/_deps")
      FetchContent_Declare(
        Catch2
        GIT_REPOSITORY https://github.com/catchorg/Catch2.git
        GIT_TAG ab6c7375be9a8e71ee84c6f8537113f9f47daf99 # v3.2.1
      )
      FetchContent_MakeAvailable(Catch2)
    else()
      log_warn("Configuring Catch -- FOUND in ${CMAKE_BINARY_DIR}/_deps")
      add_subdirectory(${CMAKE_BINARY_DIR}/_deps/catch2-src)
    endif()
    log_warn("Appending Catch2 modules to CMAKE_MODULE_PATH")
    # Only necessary if using FetchContent
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR}/_deps/catch2-src/extras)
    set(CMAKE_MODULE_PATH
        ${CMAKE_MODULE_PATH}
        PARENT_SCOPE
    )
    log_info("You might want to try installing on your system")
    add_library(KKSK::Catch2 ALIAS Catch2)
    add_library(KKSK::Catch2WithMain ALIAS Catch2WithMain)
  else()
    add_library(KKSK::Catch2 ALIAS Catch2)
    add_library(KKSK::Catch2WithMain ALIAS Catch2WithMain)
  endif(NOT Catch2_FOUND)
  log_info("Configuring Catch -- done")
endfunction()

include_guard(GLOBAL)

include(FetchContent)
function(fetch_and_install)

  set(options SYSTEM_INSTALL_)
  set(oneValueArgs NAME_ REPO_ TAG_ INSTALL_FOLDER_)
  set(multiValueArgs OPTIONS_)

  cmake_parse_arguments(FETCH_AND_INSTALL "${options}" "${oneValueArgs}" "${multiValueArgs}" "${ARGN}")

  if(NOT FETCH_AND_INSTALL_NAME_)
    log_fatal("Missing dependency name")
  endif()
  if(NOT FETCH_AND_INSTALL_REPO_)
    log_fatal("Missing dependency repository")
  endif()
  if(NOT FETCH_AND_INSTALL_TAG_)
    log_fatal("Missing dependency tag")
  endif()
  if(NOT FETCH_AND_INSTALL_INSTALL_FOLDER_)
    log_fatal("Missing dependency installation folder")
  endif()

  log_info("Declaring ${FETCH_AND_INSTALL_NAME_} ...")
  FetchContent_Declare(
    ${FETCH_AND_INSTALL_NAME_}
    GIT_REPOSITORY ${FETCH_AND_INSTALL_REPO_}
    GIT_TAG ${FETCH_AND_INSTALL_TAG_}
  )
  log_info("Declaring ${FETCH_AND_INSTALL_NAME_} -- DONE")

  log_info("Populating ${FETCH_AND_INSTALL_NAME_} ...")
  FetchContent_Populate(${FETCH_AND_INSTALL_NAME_})
  set(OLD_PROJECT_SOURCE_DIR ${PROJECT_SOURCE_DIR})
  set(PROJECT_SOURCE_DIR ${PROJECT_BINARY_DIR}/_deps/${FETCH_AND_INSTALL_NAME_}-src)
  log_info("Populating ${FETCH_AND_INSTALL_NAME_} -- DONE")

  if(MSVC)
    log_info("Configuring ${FETCH_AND_INSTALL_NAME_} ...")
    execute_process(
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} COMMAND ${CMAKE_COMMAND} -S . -B ${PROJECT_SOURCE_DIR}/build/Windows -A
                                                      x64 -DBUILD_SHARED_LIBS:BOOL=ON ${FETCH_AND_INSTALL_OPTIONS_}
    )
    log_info("Configuring ${FETCH_AND_INSTALL_NAME_} -- DONE")
    log_info("Building ${FETCH_AND_INSTALL_NAME_} [DEBUG] ...")
    execute_process(
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} COMMAND ${CMAKE_COMMAND} --build ${PROJECT_SOURCE_DIR}/build/Windows
                                                      --config Debug
    )
    log_info("Building ${FETCH_AND_INSTALL_NAME_} [DEBUG] -- DONE")
    log_info("Installing ${FETCH_AND_INSTALL_NAME_} [DEBUG] ...")
    execute_process(
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMAND ${CMAKE_COMMAND} --install ${PROJECT_SOURCE_DIR}/build/Windows --config Debug --prefix
              ${FETCH_AND_INSTALL_INSTALL_FOLDER_}/Debug
    )
    log_info("Installing ${FETCH_AND_INSTALL_NAME_} [DEBUG] -- DONE")
    log_info("Building ${FETCH_AND_INSTALL_NAME_} [RELEASE] ...")
    execute_process(
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} COMMAND ${CMAKE_COMMAND} --build ${PROJECT_SOURCE_DIR}/build/Windows
                                                      --config Release
    )
    log_info("Building ${FETCH_AND_INSTALL_NAME_} [RELEASE] -- DONE")
    log_info("Installing ${FETCH_AND_INSTALL_NAME_} [RELEASE] ...")
    execute_process(
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMAND ${CMAKE_COMMAND} --install ${PROJECT_SOURCE_DIR}/build/Windows --config Release --prefix
              ${FETCH_AND_INSTALL_INSTALL_FOLDER_}/Release
    )
    log_info("Installing ${FETCH_AND_INSTALL_NAME_} [RELEASE] -- DONE")
  else()
    log_info("Configuring ${FETCH_AND_INSTALL_NAME_} [DEBUG] ...")
    execute_process(
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMAND
        ${CMAKE_COMMAND} -S . -B ${PROJECT_SOURCE_DIR}/build/Linux/Debug -A x64 -DCMAKE_BUILD_TYPE:STRING=Debug
        -DBUILD_SHARED_LIBS:BOOL=ON -DCMAKE_INSTALL_PREFIX:STRING=${FETCH_AND_INSTALL_INSTALL_FOLDER_}/Debug
        ${FETCH_AND_INSTALL_OPTIONS_}
    )
    execute_process(
      log_info ("Configuring ${FETCH_AND_INSTALL_NAME_} [DEBUG] -- DONE") log_info
      ("Configuring ${FETCH_AND_INSTALL_NAME_} [RELEASE] ...")
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMAND
        ${CMAKE_COMMAND} -S . -B ${PROJECT_SOURCE_DIR}/build/Linux/Release -A x64 -DCMAKE_BUILD_TYPE:STRING=Release
        -DBUILD_SHARED_LIBS:BOOL=ON -DCMAKE_INSTALL_PREFIX:STRING=${FETCH_AND_INSTALL_INSTALL_FOLDER_}/Release
        ${FETCH_AND_INSTALL_OPTIONS_}
    )
    log_info("Configuring ${FETCH_AND_INSTALL_NAME_} [RELEASE] -- DONE")
    log_info("Installing ${FETCH_AND_INSTALL_NAME_} ...")
    execute_process(
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} COMMAND ${CMAKE_COMMAND} --build ${PROJECT_SOURCE_DIR}/build/Linux/Debug
                                                      --target install --config Debug
    )
    execute_process(
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMAND ${CMAKE_COMMAND} --build ${PROJECT_SOURCE_DIR}/build/Linux/Release --target install --config Release
    )
  endif()
  log_info("Installing ${FETCH_AND_INSTALL_NAME_} -- DONE")
  set(PROJECT_SOURCE_DIR ${OLD_PROJECT_SOURCE_DIR})
endfunction()

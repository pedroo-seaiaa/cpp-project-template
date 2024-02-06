include_guard()

# C Standard Library pre-compiled headers
set(c_standard_library_pch
    <cassert>
    <cmath>
    <climits>
    <cstdint>
    <cstdio>
    <cstdlib>
    <cstring>
)

# C++ Standard Library pre-compiled headers
set(cpp_standard_library_pch
    <algorithm>
    <array>
    <iostream>
    <filesystem>
    <memory>
    <span>
    <string_view>
    <string>
    <sstream>
    <thread>
    <vector>
)
# Win32 API pre-compiled headers
set(windows_api_library_pch #
    # <Windows.h> <WinSock2.h> <Ws2tcpip.h> <iphlpapi.h>
)

# POSIX API pre-compiled headers
set(linux_api_library_pch
    # <arpa/inet.h>
    # <errno.h>
    # <fcntl.h>
    # <ifaddrs.h>
    # <netdb.h>
    # <netinet/in.h>
    # <sys/socket.h>
    # <sys/types.h>
    # <unistd.h>
)

function(set_target_precompiled_headers target VISIBILITY)
  cmake_host_system_information(RESULT OS_NAME_RESULT QUERY OS_NAME)
  if(OS_NAME_RESULT STREQUAL "Windows")
    target_precompile_headers(
      ${target}
      ${VISIBILITY}
      # C Standard Library pre-compiled headers
      ${c_standard_library_pch}
      # C++ Standard Library pre-compiled headers
      ${cpp_standard_library_pch}
      # Win32 API pre-compiled headers
      ${windows_api_library_pch}
    )
  elseif(OS_NAME_RESULT STREQUAL "Linux")
    target_precompile_headers(
      ${target}
      ${VISIBILITY}
      # C Standard Library pre-compiled headers
      ${c_standard_library_pch}
      # C++ Standard Library pre-compiled headers
      ${cpp_standard_library_pch}
      # POSIX API pre-compiled headers
      ${linux_api_library_pch}
    )
  elseif(OS_NAME_RESULT STREQUAL "macOS")
    target_precompile_headers(
      ${target}
      ${VISIBILITY}
      # C Standard Library pre-compiled headers
      ${c_standard_library_pch}
      # C++ Standard Library pre-compiled headers
      ${cpp_standard_library_pch}
      # POSIX API pre-compiled headers
      ${linux_api_library_pch}
    )
  else()
    message(FATAL_ERROR "[BUG] OS_NAME_RESULT: ${OS_NAME_RESULT}")
  endif()
endfunction()
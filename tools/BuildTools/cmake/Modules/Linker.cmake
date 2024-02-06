# cmake-format: off
# =============================================================================
# Copyright (C) lefticus
#
# See Also: https://github.com/lefticus
# See Also: https://github.com/cpp-best-practices/cpp_starter_project
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <https://unlicense.org>
# =============================================================================
# cmake-format: on
include_guard(GLOBAL)

option(ENABLE_USER_LINKER "Enable a specific linker if available" OFF)

include(CheckCXXCompilerFlag)

set(USER_LINKER_OPTION
    "lld"
    CACHE STRING "Linker to be used"
)
set(USER_LINKER_OPTION_VALUES "lld" "gold" "bfd")
set_property(CACHE USER_LINKER_OPTION PROPERTY STRINGS ${USER_LINKER_OPTION_VALUES})
list(FIND USER_LINKER_OPTION_VALUES ${USER_LINKER_OPTION} USER_LINKER_OPTION_INDEX)

if(${USER_LINKER_OPTION_INDEX} EQUAL -1)
  log_info(
    "Using custom linker: '${USER_LINKER_OPTION}', explicitly supported entries are ${USER_LINKER_OPTION_VALUES}"
  )
endif()

function(configure_linker project_name)
  if(NOT ENABLE_USER_LINKER)
    return()
  endif()

  set(LINKER_FLAG "-fuse-ld=${USER_LINKER_OPTION}")

  check_cxx_compiler_flag(${LINKER_FLAG} CXX_SUPPORTS_USER_LINKER)
  if(CXX_SUPPORTS_USER_LINKER)
    target_compile_options(${project_name} INTERFACE ${LINKER_FLAG})
  endif()
endfunction()

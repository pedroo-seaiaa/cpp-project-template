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

#
option(ENABLE_CACHE "Enable cache if available" ON)
if(NOT ENABLE_CACHE)
  return()
endif()

set(CACHE_OPTION
    "ccache"
    CACHE STRING "Compiler cache to be used"
)
set(CACHE_OPTION_VALUES "ccache" "sccache")
set_property(CACHE CACHE_OPTION PROPERTY STRINGS ${CACHE_OPTION_VALUES})
list(FIND CACHE_OPTION_VALUES ${CACHE_OPTION} CACHE_OPTION_INDEX)

if(${CACHE_OPTION_INDEX} EQUAL -1)
  log_info(
    "Using custom compiler cache system: '${CACHE_OPTION}', explicitly supported entries are ${CACHE_OPTION_VALUES}"
  )
endif()

find_program(CACHE_BINARY ${CACHE_OPTION})
if(CACHE_BINARY)
  log_info("${CACHE_OPTION} found and enabled")
  set(CMAKE_CXX_COMPILER_LAUNCHER ${CACHE_BINARY})
else()
  log_warn("${CACHE_OPTION} is enabled but was not found. Not using it")
endif()

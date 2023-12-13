include_guard(GLOBAL)

set(THIS_DIR ${CMAKE_CURRENT_LIST_DIR})
function(configure_meta_header_file)
  string(TOLOWER COMPANY_NAME COMPANY_NAME_LOWER_CASE)
  string(TOLOWER PROJECT_NAME PROJECT_NAME_LOWER_CASE)
  configure_file(
    "${THIS_DIR}/Meta.h.in" "${CMAKE_BINARY_DIR}/${COMPANY_NAME}/${PROJECT_NAME}/Meta.hpp"
    ESCAPE_QUOTES
  )
endfunction()

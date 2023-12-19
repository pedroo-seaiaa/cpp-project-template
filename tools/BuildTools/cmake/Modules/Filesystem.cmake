include_guard(GLOBAL)

function(get_all_objects_in directory return_value)
  log_trace("get_all_objects_in")
  if(IS_DIRECTORY ${directory})
    log_trace("${directory} is a directory")
    file(GLOB objects ${directory}/*)
    log_debug("objects: ${objects}")
    set(${return_value}
        ${objects}
        PARENT_SCOPE
    )
  else()
    log_error("${directory} is not a directory")
  endif()
endfunction()

function(get_all_subdirectories_in directory return_value)
  log_trace("get_all_subdirectories_in")
  get_all_objects_in(${directory} objects)
  log_debug("objects: ${objects}")
  set(subdirs "")
  foreach(object ${objects})
    if(IS_DIRECTORY ${object})
      list(APPEND subdirs ${object})
    endif()
  endforeach()
  log_debug("subdirs: ${subdirs}")
  set(${return_value}
      ${subdirs}
      PARENT_SCOPE
  )
endfunction()

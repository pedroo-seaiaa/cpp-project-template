include_guard(GLOBAL)

# if($ENV{CLION_IDE}) # TODO: Do the same for CLion

# else()
#   if(NOT WIN32)
#     string(ASCII 27 Esc)
#     set(ColourReset "${Esc}[m")
#     set(ColourBold "${Esc}[1m")
#     set(Red "${Esc}[31m")
#     set(Green "${Esc}[32m")
#     set(Yellow "${Esc}[33m")
#     set(Blue "${Esc}[34m")
#     set(Magenta "${Esc}[35m")
#     set(Cyan "${Esc}[36m")
#     set(White "${Esc}[37m")
#     set(BoldRed "${Esc}[1;31m")
#     set(BoldGreen "${Esc}[1;32m")
#     set(BoldYellow "${Esc}[1;33m")
#     set(BoldBlue "${Esc}[1;34m")
#     set(BoldMagenta "${Esc}[1;35m")
#     set(BoldCyan "${Esc}[1;36m")
#     set(BoldWhite "${Esc}[1;37m")
#   endif()
# endif()

set(CMAKE_LOG_LEVEL_TRACE 2)
set(CMAKE_LOG_LEVEL_DEBUG 3)
set(CMAKE_LOG_LEVEL_INFO 4)
set(CMAKE_LOG_LEVEL_WARNING 5)
set(CMAKE_LOG_LEVEL_ERROR 6)
set(CMAKE_LOG_LEVEL_FATAL 7)

if(NOT PROJECT_IS_TOP_LEVEL)
  set(CMAKE_LOG_LEVEL_TRACE
      2
      PARENT_SCOPE
  )
  set(CMAKE_LOG_LEVEL_DEBUG
      3
      PARENT_SCOPE
  )
  set(CMAKE_LOG_LEVEL_INFO
      4
      PARENT_SCOPE
  )
  set(CMAKE_LOG_LEVEL_WARNING
      5
      PARENT_SCOPE
  )
  set(CMAKE_LOG_LEVEL_ERROR
      6
      PARENT_SCOPE
  )
  set(CMAKE_LOG_LEVEL_FATAL
      7
      PARENT_SCOPE
  )
endif()

# Sets the CMAKE_CURRENT_LOG_LEVEL to the default or command line option
option(CMAKE_CURRENT_LOG_LEVEL "Set CMake current log level" ${CMAKE_LOG_LEVEL_INFO})

if(CMAKE_CURRENT_LOG_LEVEL STREQUAL "OFF")
  message("[CORE][WARNING] CMAKE_CURRENT_LOG_LEVEL not set")
  message("[CORE][INFO] Defaulting to CMAKE_LOG_LEVEL_INFO")
  set(CMAKE_CURRENT_LOG_LEVEL ${CMAKE_LOG_LEVEL_INFO})
  if(NOT PROJECT_IS_TOP_LEVEL)
    set(CMAKE_CURRENT_LOG_LEVEL
        ${CMAKE_LOG_LEVEL_INFO}
        PARENT_SCOPE
    )
  endif()
endif()

function(log_message msg log_level)
  if(NOT ${log_level} LESS CMAKE_CURRENT_LOG_LEVEL)
    message(${msg})
  endif()
endfunction()

function(log_trace msg)
  log_message("${ColourBold}[TRACE]${ColourReset} ${msg}" ${CMAKE_LOG_LEVEL_TRACE})
endfunction(log_trace)

function(log_debug msg)
  log_message("${Cyan}[DEBUG]${ColourReset} ${msg}" ${CMAKE_LOG_LEVEL_DEBUG})
endfunction(log_debug)

function(log_info msg)
  log_message("${Green}[INFO]${ColourReset} ${msg}" ${CMAKE_LOG_LEVEL_INFO})
endfunction(log_info)

function(log_warn msg)
  log_message("${BoldYellow}[WARNING]${ColourReset} ${msg}" ${CMAKE_LOG_LEVEL_WARNING})
endfunction(log_warn)

function(log_error msg)
  message(SEND_ERROR "${BoldRed}[ERROR]${ColourReset} ${msg}")
endfunction(log_error)

function(log_fatal msg)
  message(FATAL_ERROR "${BoldRed}[FATAL]${ColourReset} ${msg} ")
endfunction(log_fatal)

log_info("Logger -- Initialized successfull")
log_info("CMake Version: ${CMAKE_VERSION}")

@echo off

call:main

echo.&pause&goto:eof

:: ###########################################################################
:: Main Entry Point
:: ###########################################################################

:main
call:log " === Windows Configuration Batch File (version 0.1.0) ==="
call:setup-git-hooks
call:run-python-setup
goto:eof


:: ###########################################################################
:: "Functions"
:: ###########################################################################

:setup-git-hooks
call:log "Configuring Git Hooks..."
IF EXIST ./tools/scripts/git/hooks (
    call:log "Installing hooks..."
    git config core.hooksPath ./tools/scripts/git/hooks
    call:log "Installing hooks -- SUCCESS"
    call:log "Configuring Git Hooks -- SUCCESS"
) else (
    call:log "Installing hooks -- FAILED"
    call:log "Configuring Git Hooks -- FAILED"
)
goto:eof

:run-python-setup
call:log "Testing if python is installed or in PATH..."
where python >nul 2>nul
if %errorlevel% neq 0 (
    call:log "Testing if python is installed or in PATH -- FAILED"
) else (
    call:log "Testing if python is installed or in PATH -- SUCCESS"
    call:log "Checking python for version 3.12.0 ..."
    python --version > temp.txt 2>&1
    findstr /C:"3.12.0" temp.txt >nul 2>nul
    if %errorlevel% neq 0 (
        call:log "Checking python for version 3.12.0 -- FAILED"
        call:log "This project was tested with Python 3.12.0. Other versions may not work as expected."
    ) else (
        call:log "Checking python for version 3.12.0 -- SUCCESS"
    )
    
    del temp.txt

    call:log "Detecting setup.py ..."
    IF EXIST ./tools/scripts/setup.py (
        call:log "Detecting setup.py -- SUCCESS"
        call:log "Running setup.py"
    ) else (
        call:log "Detecting setup.py -- FAILED"
        call:log "Aborting..."
    )
)
goto:eof

:: ===========================================================================
:: Utility Functions
:: ===========================================================================

:log
:: if verbose is passed
::echo [configure.bat]%~1
echo %~1
goto:eof

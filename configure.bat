@echo off

:: Testing if python is installed (or in the PATH)
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [configure.bat] Python is not installed or not in your PATH.
) else (
    echo [configure.bat] Python is installed.

    :: Testing the python version
    python --version > temp.txt 2>&1
    findstr /C:"3.12.0" temp.txt >nul 2>nul
    if %errorlevel% neq 0 (
        echo [configure.bat] Python 3.12.0 is not installed.
        echo [configure.bat] This project was tested with Python 3.12.0. Other versions may not work as expected.
    ) else (
        echo [configure.bat] Python 3.12.0 is installed.

        :: Testing for the exist
        IF EXIST ./tools/scripts/setup.py (
            echo [configure.bat] Running setup.py
        ) else (
            echo [configure.bat] setup.py not found! Aborting!
        )
    )
    del temp.txt
)
pause

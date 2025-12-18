@echo off
REM Quick Start Script for DevSecOps Lab
echo ========================================
echo DevSecOps Lab - Quick Start Guide
echo ========================================
echo.

echo IMPORTANT: Read DEVSECOPS_LAB_GUIDE.md for detailed instructions!
echo.

echo Current Status:
echo ---------------
echo [x] Project structure created
echo [x] Git initialized  
echo [x] Initial commit completed
echo [x] Branch renamed to 'main'
echo.

echo What do you want to do?
echo.
echo 1. Check Prerequisites (Java, Docker, Maven, Git)
echo 2. Connect to GitHub (create and link repository)
echo 3. Build the Application
echo 4. View Complete Lab Guide
echo 5. Exit
echo.

set /p CHOICE="Enter your choice (1-5): "

if "%CHOICE%"=="1" goto :prerequisites
if "%CHOICE%"=="2" goto :github
if "%CHOICE%"=="3" goto :build
if "%CHOICE%"=="4" goto :guide
if "%CHOICE%"=="5" goto :end

echo Invalid choice!
pause
goto :end

:prerequisites
echo.
call check-prerequisites.bat
goto :end

:github
echo.
echo Opening browser to create GitHub repository...
start https://github.com/new
echo.
call connect-github.bat
goto :end

:build
echo.
call build.bat
goto :end

:guide
echo.
echo Opening lab guide in your default text editor...
start DEVSECOPS_LAB_GUIDE.md
pause
goto :end

:end
echo.
echo Run START-HERE.bat again anytime for this menu!

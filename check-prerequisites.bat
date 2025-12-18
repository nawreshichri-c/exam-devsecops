@echo off
REM DevSecOps Lab - Quick Setup Script
echo ========================================
echo DevSecOps Lab - Project Setup
echo ========================================
echo.

REM Check Java
echo [1/4] Checking Java...
java -version
if errorlevel 1 (
    echo ERROR: Java not found! Please install Java 21.
    pause
    exit /b 1
)
echo.

REM Check Docker
echo [2/4] Checking Docker...
docker --version
if errorlevel 1 (
    echo ERROR: Docker not found! Please install Docker Desktop.
    pause
    exit /b 1
)
echo.

REM Check Maven
echo [3/4] Checking Maven...
mvn -version
if errorlevel 1 (
    echo WARNING: Maven not found!
    echo.
    echo Please install Maven:
    echo   Option 1: choco install maven
    echo   Option 2: Download from https://maven.apache.org/download.cgi
    echo.
    echo Or continue without Maven (you'll use Docker instead)
    pause
)
echo.

REM Check Git
echo [4/4] Checking Git...
git --version
if errorlevel 1 (
    echo ERROR: Git not found! Please install Git.
    pause
    exit /b 1
)
echo.

echo ========================================
echo All prerequisites checked!
echo See DEVSECOPS_LAB_GUIDE.md for next steps
echo ========================================
pause

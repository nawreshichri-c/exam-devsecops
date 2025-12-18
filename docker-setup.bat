@echo off
REM Complete Setup Script for Docker Hub Configuration
echo ========================================
echo Docker Hub Setup - Part 3 of Lab
echo ========================================
echo.

set /p DOCKERHUB_USERNAME="Enter your Docker Hub username: "

if "%DOCKERHUB_USERNAME%"=="" (
    echo ERROR: Docker Hub username is required!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Step 1: Building Docker Image
echo ========================================
echo.

REM First, make sure the JAR file exists
if not exist "target\democyber-0.0.1-SNAPSHOT.jar" (
    echo JAR file not found! Building application first...
    call build.bat
    if errorlevel 1 (
        echo ERROR: Build failed!
        pause
        exit /b 1
    )
)

echo Building Docker image as: %DOCKERHUB_USERNAME%/democyber:latest
docker build -t %DOCKERHUB_USERNAME%/democyber:latest .

if errorlevel 1 (
    echo ERROR: Docker build failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Step 2: Testing Docker Image Locally
echo ========================================
echo.
echo Starting container on port 8080...
echo.
echo Opening browser to http://localhost:8080
start http://localhost:8080
echo.
echo Press Ctrl+C to stop the container when done testing...
docker run -p 8080:8080 %DOCKERHUB_USERNAME%/democyber:latest

echo.
pause

echo.
echo ========================================
echo Step 3: Login to Docker Hub
echo ========================================
echo.
docker login

if errorlevel 1 (
    echo ERROR: Docker login failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Step 4: Push to Docker Hub
echo ========================================
echo.
docker push %DOCKERHUB_USERNAME%/democyber:latest

if errorlevel 1 (
    echo ERROR: Docker push failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Docker image published!
echo ========================================
echo.
echo Image: %DOCKERHUB_USERNAME%/democyber:latest
echo.
echo Visit Docker Hub: https://hub.docker.com/r/%DOCKERHUB_USERNAME%/democyber
echo.
echo Next: Configure GitHub Actions secrets
echo 1. Go to: https://github.com/Haroun-Gaida/exam-devsecops/settings/secrets/actions
echo 2. Add DOCKERHUB_USERNAME = %DOCKERHUB_USERNAME%
echo 3. Add DOCKERHUB_TOKEN = (get from Docker Hub)
echo.
echo See DEVSECOPS_LAB_GUIDE.md Section 4 for details.
echo.
pause

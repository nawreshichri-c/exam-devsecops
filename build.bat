@echo off
REM Build script that works with or without Maven installed
echo ========================================
echo Building DevSecOps Lab Application
echo ========================================
echo.

REM Try Maven first
echo Attempting build with Maven...
mvn -version >nul 2>&1
if not errorlevel 1 (
    echo [Using Maven]
    mvn clean package
    if errorlevel 1 (
        echo ERROR: Maven build failed!
        pause
        exit /b 1
    )
    goto :success
)

echo.
echo Maven not found. Building with Docker instead...
echo This will create the target folder using a Docker container.
echo.

REM Build with Docker (multi-stage build)
docker build -t democyber-build:latest -f Dockerfile.build .
if errorlevel 1 (
    echo ERROR: Docker build failed!
    pause
    exit /b 1
)

:success
echo.
echo ========================================
echo BUILD SUCCESS!
echo ========================================
echo.
echo Output: target\democyber-0.0.1-SNAPSHOT.jar
echo.
echo Next steps:
echo 1. Test locally:   java -jar target\democyber-0.0.1-SNAPSHOT.jar
echo 2. Build Docker:   docker build -t your-username/democyber:latest .
echo 3. Run Docker:     docker run -p 8080:8080 your-username/democyber:latest
echo.
pause

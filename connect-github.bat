@echo off
REM Helper script to connect to GitHub
echo ========================================
echo GitHub Repository Setup
echo ========================================
echo.

echo Step 1: Create GitHub Repository
echo ---------------------------------
echo 1. Go to: https://github.com/new
echo 2. Repository name: tp-devsecops
echo 3. DO NOT check "Initialize with README"
echo 4. Click "Create repository"
echo.
pause

echo.
echo Step 2: Get your GitHub repository URL
echo ---------------------------------
set /p GITHUB_URL="Enter your GitHub repository URL (e.g., https://github.com/YOUR_USERNAME/tp-devsecops.git): "

echo.
echo Step 3: Linking local repository to GitHub...
git remote add origin %GITHUB_URL%
if errorlevel 1 (
    echo.
    echo Note: If you see "remote origin already exists", run this first:
    echo   git remote remove origin
    echo Then run this script again.
    pause
    exit /b 1
)

echo.
echo Step 4: Verifying remote connection...
git remote -v

echo.
echo Step 5: Pushing to GitHub...
git push -u origin main

if errorlevel 1 (
    echo.
    echo ERROR: Push failed! Common issues:
    echo 1. Authentication required - you may need to enter credentials
    echo 2. Repository doesn't exist on GitHub
    echo 3. Network connection issue
    echo.
    echo For authentication, visit: https://github.com/settings/tokens
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Your code is now on GitHub!
echo Visit: %GITHUB_URL:.git=%
echo ========================================
pause

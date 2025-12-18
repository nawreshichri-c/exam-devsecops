@echo off
REM Interactive Setup Script for DevSecOps Pipeline
echo ========================================
echo DevSecOps Pipeline - Interactive Setup
echo ========================================
echo.

echo This script will guide you through configuring all required secrets.
echo.
pause

echo.
echo ========================================
echo STEP 1: Docker Hub Secrets
echo ========================================
echo.

echo First, you need to create a Docker Hub access token.
echo.
echo 1. Open: https://hub.docker.com/settings/security
echo 2. Click "New Access Token"
echo 3. Name: github-actions-democyber
echo 4. Permissions: Read and Write
echo 5. Click "Generate"
echo 6. COPY THE TOKEN (shown only once!)
echo.
pause

echo.
echo Now add the secrets to GitHub:
echo 1. Open: https://github.com/Haroun-Gaida/exam-devsecops/settings/secrets/actions
echo.
echo Add these 2 secrets:
echo   - DOCKERHUB_USERNAME: Your Docker Hub username
echo   - DOCKERHUB_TOKEN: The token you just copied
echo.
start https://github.com/Haroun-Gaida/exam-devsecops/settings/secrets/actions
echo.
echo Browser opened to GitHub secrets page...
echo.
pause

echo.
echo ========================================
echo STEP 2: SonarCloud Secrets  
echo ========================================
echo.

echo First, sign in to SonarCloud:
echo 1. Open: https://sonarcloud.io
echo 2. Log in with GitHub
echo 3. Create organization (key: haroun-gaida-devsecops)
echo 4. Create project for exam-devsecops repository
echo 5. Generate token: My Account -\u003e Security -\u003e Generate Token
echo.
start https://sonarcloud.io
echo.
echo Browser opened to SonarCloud...
echo.
pause

echo.
echo Now add these 3 secrets to GitHub:
echo   - SONAR_TOKEN: The token you generated
echo   - SONAR_ORGANIZATION: haroun-gaida-devsecops
echo   - SONAR_PROJECT_KEY: Haroun-Gaida_exam-devsecops
echo.
echo (GitHub secrets page should still be open)
echo.
pause

echo.
echo ========================================
echo STEP 3: Test Clean Pipeline
echo ========================================
echo.

echo Now that all secrets are configured, let's test the pipeline!
echo.
set /p TEST_PIPELINE="Trigger test pipeline now? (y/n): "

if /i "%TEST_PIPELINE%"=="y" (
    echo.
    echo Triggering pipeline...
    git commit --allow-empty -m "test: trigger pipeline with all secrets configured"
    git push origin main
    echo.
    echo Pipeline triggered! Check: https://github.com/Haroun-Gaida/exam-devsecops/actions
    start https://github.com/Haroun-Gaida/exam-devsecops/actions
)

echo.
echo ========================================
echo STEP 4: Test Gitleaks Detection
echo ========================================
echo.

echo Next, we'll test Gitleaks by injecting a fake secret.
echo This should make the pipeline FAIL (intentionally).
echo.
set /p TEST_GITLEAKS="Continue with Gitleaks test? (y/n): "

if /i "%TEST_GITLEAKS%"=="y" (
    echo.
    echo Opening DemocyberApplication.java for editing...
    echo.
    echo ACTION REQUIRED:
    echo   Add this line after line 12:
    echo   private static final String GITHUB_TOKEN = "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    echo.
    start notepad "src\main\java\com\example\democyber\DemocyberApplication.java"
    echo.
    pause
    
    echo.
    echo Committing fake secret...
    git add src/main/java/com/example/democyber/DemocyberApplication.java
    git commit -m "test: inject fake secret to demonstrate Gitleaks detection"
    git push origin main
    echo.
    echo Pipeline should FAIL on Gitleaks step!
    echo Check: https://github.com/Haroun-Gaida/exam-devsecops/actions
    start https://github.com/Haroun-Gaida/exam-devsecops/actions
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Wait for pipeline to fail (Gitleaks detection)
echo 2. Take screenshots of the failure
echo 3. Comment out the secret in DemocyberApplication.java
echo 4. Push fix and watch pipeline pass
echo.
echo See TESTING_GUIDE.md for detailed instructions!
echo.
pause

# 🚀 Complete DevSecOps Pipeline - Step-by-Step Testing Guide

## 📋 Current Status

Based on the GitHub repository check:
- ❌ **No secrets configured** - We need to add 5 secrets
- ✅ **Pipeline code ready** - All security scanning configured
- ✅ **Application ready** - Spring Boot app with monitoring

---

## 🎯 Step-by-Step Configuration & Testing

### STEP 1: Configure Docker Hub Secrets (Required)

These secrets are needed for Docker build and deployment.

#### 1.1 Create Docker Hub Access Token

**Action:**
1. Open: https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Name: `github-actions-democyber`
4. Permissions: **Read & Write**
5. Click "Generate"
6. **⚠️ COPY THE TOKEN IMMEDIATELY** (shown only once!)

Example token: `dckr_pat_XXXXXX...`

#### 1.2 Add DOCKERHUB_USERNAME Secret

**Action:**
1. Page already open: https://github.com/Haroun-Gaida/exam-devsecops/settings/secrets/actions
2. Click "New repository secret"
3. Name: `DOCKERHUB_USERNAME`
4. Value: Your Docker Hub username (check at https://hub.docker.com)
5. Click "Add secret"

#### 1.3 Add DOCKERHUB_TOKEN Secret

**Action:**
1. Click "New repository secret"
2. Name: `DOCKERHUB_TOKEN`
3. Value: Paste the token from step 1.1
4. Click "Add secret"

**✅ Verification:** You should now see 2 secrets listed

---

### STEP 2: Configure SonarCloud Secrets (Required)

These secrets are needed for code quality analysis.

#### 2.1 Sign in to SonarCloud

**Action:**
1. Open: https://sonarcloud.io
2. Click "Log in"
3. Choose "GitHub"
4. Authorize SonarCloud

#### 2.2 Create Organization

**Action:**
1. After sign in, click "+" → "Create an organization"
2. Choose "Create an organization manually"
3. Organization Key: `haroun-gaida-devsecops` (must be unique, lowercase, no spaces)
4. Organization Name: `Haroun Gaida DevSecOps`
5. Choose plan: **Free** (for public repos)
6. Click "Create Organization"

**💾 Save this:** Organization key = `haroun-gaida-devsecops`

#### 2.3 Create Project

**Action:**
1. Click "Analyze new project"
2. Select repository: `exam-devsecops`
3. Click "Set Up"
4. Choose: "With GitHub Actions"
5. Note the **Project Key** shown (usually: `Haroun-Gaida_exam-devsecops`)

**💾 Save this:** Project key = `Haroun-Gaida_exam-devsecops`

#### 2.4 Generate SonarCloud Token

**Action:**
1. Click your avatar (top right)
2. Go to "My Account"
3. Click "Security" tab
4. Click "Generate Token"
5. Name: `github-actions-token`
6. Type: **User Token**
7. Expiration: 90 days
8. Click "Generate"
9. **⚠️ COPY THE TOKEN IMMEDIATELY**

Example token: `sqp_abc123...`

#### 2.5 Add SonarCloud Secrets to GitHub

**Action:**
1. Go back to: https://github.com/Haroun-Gaida/exam-devsecops/settings/secrets/actions

2. **Add SONAR_TOKEN:**
   - Click "New repository secret"
   - Name: `SONAR_TOKEN`
   - Value: Paste token from step 2.4
   - Click "Add secret"

3. **Add SONAR_ORGANIZATION:**
   - Click "New repository secret"
   - Name: `SONAR_ORGANIZATION`
   - Value: `haroun-gaida-devsecops` (from step 2.2)
   - Click "Add secret"

4. **Add SONAR_PROJECT_KEY:**
   - Click "New repository secret"
   - Name: `SONAR_PROJECT_KEY`
   - Value: `Haroun-Gaida_exam-devsecops` (from step 2.3)
   - Click "Add secret"

**✅ Verification:** You should now see 5 secrets total:
- DOCKERHUB_USERNAME
- DOCKERHUB_TOKEN
- SONAR_TOKEN
- SONAR_ORGANIZATION
- SONAR_PROJECT_KEY

---

### STEP 3: Test Clean Pipeline Run

Now all secrets are configured, let's test the complete pipeline!

#### 3.1 Trigger Pipeline

**Option A: Push a commit**
```bash
cd c:\CTF\secure_app

# Make a small change
echo "# Pipeline test" >> TEST.md

# Commit and push
git add TEST.md
git commit -m "test: trigger complete security pipeline"
git push origin main
```

**Option B: Empty commit**
```bash
git commit --allow-empty -m "test: trigger pipeline with all secrets configured"
git push origin main
```

#### 3.2 Watch Pipeline Execute

**Action:**
1. Go to: https://github.com/Haroun-Gaida/exam-devsecops/actions
2. Click on the latest workflow run
3. Watch steps execute in real-time

**Expected Flow:**
```
1. ✅ Checkout repository
2. ✅ Run Gitleaks scan (no secrets = PASS)
3. ✅ Upload Gitleaks report
4. ✅ Set up JDK 21
5. ✅ Compile Java
6. ✅ Build Java project with Maven
7. ✅ SonarCloud Scan
8. ✅ Login to Docker Hub
9. ✅ Build Docker image
10. ✅ Test Docker image locally
11. ✅ Scan with Trivy (table format)
12. ✅ Scan with Trivy (SARIF format)
13. ✅ Upload Trivy report
14. ✅ Push Docker image
15. ✅ Pipeline Summary
```

**⏱️ Expected Duration:** 3-5 minutes

#### 3.3 Verify Success

**Check these:**
- ✅ All steps have green checkmarks
- ✅ No failed steps
- ✅ Artifacts available (gitleaks-report, trivy-report)

---

### STEP 4: Test Gitleaks Secret Detection (Demo Failure)

Now let's intentionally break the pipeline to see Gitleaks in action!

#### 4.1 Inject Fake Secret

**Action:**

Edit: `c:\CTF\secure_app\src\main\java\com\example\democyber\DemocyberApplication.java`

Add this line after line 12 (after `private static final String SECRET_TEST = "1234567890";`):

```java
private static final String GITHUB_TOKEN = "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
```

**Complete code should look like:**
```java
@SpringBootApplication
@RestController
public class DemocyberApplication {

    private static final String SECRET_TEST = "1234567890";
    private static final String GITHUB_TOKEN = "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";  // ← ADD THIS

    public static void main(String[] args) {
        SpringApplication.run(DemocyberApplication.class, args);
    }
    // ...
}
```

#### 4.2 Commit and Push

```bash
cd c:\CTF\secure_app

git add src/main/java/com/example/democyber/DemocyberApplication.java
git commit -m "test: inject fake secret to demonstrate Gitleaks detection"
git push origin main
```

#### 4.3 Watch Pipeline Fail

**Action:**
1. Go to: https://github.com/Haroun-Gaida/exam-devsecops/actions
2. Click on the latest run
3. Watch it FAIL at "Run Gitleaks scan" step

**Expected:**
```
❌ Run Gitleaks scan
   │
   ├─ Finding: github-pat
   ├─ Secret: ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   ├─ File: src/main/java/com/example/democyber/DemocyberApplication.java
   ├─ Line: 13
   └─ ❌ Gitleaks encountered problems
```

#### 4.4 Take Screenshots (LAB REQUIREMENT)

**📸 Screenshot 1:** Failed workflow overview
**📸 Screenshot 2:** Gitleaks error message (click on failed step)
**📸 Screenshot 3:** Gitleaks report artifact

#### 4.5 Fix the Issue

**Action:**

Edit: `c:\CTF\secure_app\src\main\java\com\example\democyber\DemocyberApplication.java`

Comment out the secret:
```java
@SpringBootApplication
@RestController
public class DemocyberApplication {

    private static final String SECRET_TEST = "1234567890";
    // private static final String GITHUB_TOKEN = "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";  // ← COMMENT OUT

    public static void main(String[] args) {
        SpringApplication.run(DemocyberApplication.class, args);
    }
    // ...
}
```

#### 4.6 Commit Fix

```bash
git add src/main/java/com/example/democyber/DemocyberApplication.java
git commit -m "fix: remove exposed secret from source code"
git push origin main
```

#### 4.7 Verify Pipeline Passes Again

**Expected:** ✅ All steps pass (pipeline goes back to green)

---

### STEP 5: Verify SonarCloud Analysis

#### 5.1 Check SonarCloud Dashboard

**Action:**
1. Go to: https://sonarcloud.io/project/overview?id=Haroun-Gaida_exam-devsecops
2. Wait for analysis to complete (automatically triggered by pipeline)

**You should see:**
- Quality Gate: ✅ Passed or ❌ Failed
- Security Rating: A / B / C / D / E
- Reliability Rating: A / B / C / D / E
- Maintainability Rating: A / B / C / D / E
- Code Coverage: X%
- Bugs: X
- Vulnerabilities: X
- Code Smells: X

#### 5.2 Take Screenshots (LAB REQUIREMENT)

**📸 Screenshot 1:** SonarCloud dashboard overview
**📸 Screenshot 2:** Security rating details
**📸 Screenshot 3:** Reliability rating details
**📸 Screenshot 4:** Maintainability rating details

---

### STEP 6: Verify Docker Hub Deployment

#### 6.1 Check Docker Hub

**Action:**
1. Go to: https://hub.docker.com/repositories
2. Find `democyber` repository
3. Click on it
4. Verify `latest` tag exists with recent timestamp

**📸 Screenshot:** Docker Hub repository with latest tag

#### 6.2 Test Locally

**Action:**
```bash
# Pull from Docker Hub
docker pull YOUR_USERNAME/democyber:latest

# Run container
docker run -d -p 8080:8080 --name democyber-test YOUR_USERNAME/democyber:latest

# Test endpoint
curl http://localhost:8080

# Expected: "Hello from Democyber 123!"

# Cleanup
docker stop democyber-test
docker rm democyber-test
```

**📸 Screenshot:** Terminal showing docker pull and run commands with successful output

---

### STEP 7: Download Security Reports

#### 7.1 Download Gitleaks Report

**Action:**
1. Go to successful workflow run: https://github.com/Haroun-Gaida/exam-devsecops/actions
2. Scroll to "Artifacts" section
3. Download `gitleaks-report`
4. Extract and open `results.sarif` in text editor

**📸 Screenshot:** Artifacts section showing gitleaks-report

#### 7.2 Download Trivy Report

**Action:**
1. Same workflow run, Artifacts section
2. Download `trivy-report`
3. Extract and open `trivy-results.sarif`

**📸 Screenshot:** Artifacts section showing trivy-report

---

## ✅ SUCCESS CHECKLIST

### Configuration
- [ ] DOCKERHUB_USERNAME secret added
- [ ] DOCKERHUB_TOKEN secret added
- [ ] SONAR_TOKEN secret added
- [ ] SONAR_ORGANIZATION secret added
- [ ] SONAR_PROJECT_KEY secret added

### Testing
- [ ] Clean pipeline run (all steps pass)
- [ ] Gitleaks detected fake secret (pipeline failed)
- [ ] Fixed secret (pipeline passed again)
- [ ] SonarCloud analysis completed
- [ ] Docker image pushed to Docker Hub
- [ ] Docker image pulled and tested locally
- [ ] Downloaded Gitleaks report
- [ ] Downloaded Trivy report

### Screenshots Taken
- [ ] Clean pipeline success
- [ ] Gitleaks failure overview
- [ ] Gitleaks error message
- [ ] Gitleaks artifact
- [ ] SonarCloud dashboard
- [ ] SonarCloud ratings
- [ ] Docker Hub repository
- [ ] Local docker pull/run
- [ ] Security report artifacts

---

## 🎯 Quick Command Reference

```bash
# Navigate to project
cd c:\CTF\secure_app

# Build locally
mvn clean package
java -jar target/democyber-0.0.1-SNAPSHOT.jar

# Test endpoints
curl http://localhost:8080
curl http://localhost:8080/actuator/prometheus

# Git workflow
git status
git add .
git commit -m "your message"
git push origin main

# Docker testing
docker pull YOUR_USERNAME/democyber:latest
docker run -p 8080:8080 YOUR_USERNAME/democyber:latest

# Monitoring stack
cd monitoring
docker compose up -d
docker compose down
```

---

## 📊 Expected Results Summary

| Component | Status | Evidence |
|-----------|--------|----------|
| Gitleaks | ✅ Working | Failed on fake secret, passed after fix |
| SonarCloud | ✅ Analyzing | Dashboard shows ratings |
| Trivy | ✅ Scanning | SARIF report generated |
| Docker Build | ✅ Success | Image on Docker Hub |
| CI/CD Pipeline | ✅ Passing | Green checkmarks |

---

**🎉 Complete this guide and you'll have a fully tested, production-ready DevSecOps pipeline!**

**Start with STEP 1 and work through each step sequentially.**

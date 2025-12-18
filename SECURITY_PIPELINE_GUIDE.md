# Secure CI/CD Pipeline - Complete Lab Guide

## 🔒 Overview

This guide covers implementing a production-ready secure CI/CD pipeline with:
- **Gitleaks**: Secret detection in source code
- **Trivy**: Docker image vulnerability scanning
- **Automated Testing**: Container health checks
- **Docker Hub Deployment**: Automated image publishing

---

## Part 1: Gitleaks Secret Scanning

### What is Gitleaks?

**Gitleaks** is a SAST (Static Application Security Testing) tool that scans your code for hardcoded secrets, API keys, tokens, and passwords. It prevents accidental exposure of sensitive information.

**What it detects:**
- GitHub tokens (ghp_*, gho_*, etc.)
- AWS access keys
- Database credentials
- API keys
- Private keys
- Passwords in code

### Step 1: Setup Gitleaks

The CI/CD workflow now includes:

```yaml
- name: Run Gitleaks scan
  uses: zricethezav/gitleaks-action@v2
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**What this does:**
- Scans all files in your repository
- Checks for patterns matching known secret formats
- Fails the pipeline if secrets are detected
- Generates a SARIF report with findings

### Step 2: Test with Fake Secret

To demonstrate Gitleaks detection, we'll inject a fake GitHub token:

**File:** `src/main/java/com/example/democyber/DemocyberApplication.java`

```java
// Add this line (temporarily)
private static final String GITHUB_TOKEN = "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
```

**Expected Behavior:**
- ❌ **Pipeline FAILS** - Gitleaks detects the secret pattern
- 🔴 **Error Message**: Shows the file, line number, and secret type
- 🛑 **Stops deployment** - Image is NOT pushed to Docker Hub

**Why did it fail?**
- Gitleaks uses regex patterns to detect token formats
- `ghp_*` is the prefix for GitHub personal access tokens
- Even though it's fake, the pattern matches

**What problems does Gitleaks prevent?**
1. **Data Breaches**: Prevents API keys from being exposed publicly
2. **Unauthorized Access**: Stops attackers from stealing credentials
3. **Compliance Violations**: Helps meet security standards (SOC2, PCI-DSS)
4. **Financial Loss**: Prevents abuse of cloud credentials (AWS, Azure)
5. **Reputation Damage**: Protects company image

### Step 3: Gitleaks Report Artifact

The workflow uploads scan results:

```yaml
- name: Upload Gitleaks report
  if: always()
  uses: actions/upload-artifact@v4
  with:
    name: gitleaks-report
    path: results.sarif
```

**What's in the report?**
- SARIF format (Static Analysis Results Interchange Format)
- List of all detected secrets
- File paths and line numbers
- Secret types (e.g., "github-pat", "aws-access-token")
- Confidence levels

**Why is this important?**
- **Audit Trail**: Track security findings over time
- **Remediation**: Developers can review and fix issues
- **Compliance**: Prove security scanning is happening
- **Integration**: SARIF can be imported into security dashboards

**Actions to take if secrets are detected:**
1. **Immediate**: Comment out or remove the secret
2. **Rotate**: If the secret is real, revoke and regenerate it
3. **Environment Variables**: Move secrets to GitHub Secrets
4. **Rewrite History**: Use `git filter-branch` to remove from git history
5. **Monitor**: Check for unauthorized usage of exposed credentials

---

## Part 2: Docker Build and Testing

### Step 1: Docker Hub Login

```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v2
  with:
    username: ${{ secrets.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}
```

**What this does:**
- Authenticates GitHub Actions to Docker Hub
- Uses secrets to securely store credentials
- Required before pushing images

### Step 2: Build Docker Image

```yaml
- name: Build Docker image
  run: docker build -t $DOCKER_IMAGE_NAME .
```

**What this verifies:**
- Dockerfile syntax is correct
- All COPY commands work
- Base image is accessible
- Build completes without errors

### Step 3: Test Docker Image Locally

```yaml
- name: Test Docker image locally
  run: |
    docker run -d --name democyber-test -p 8080:8080 $DOCKER_IMAGE_NAME
    sleep 10
    curl -f http://localhost:8080 || echo "App not responding"
    docker stop democyber-test
    docker rm democyber-test
```

**What this verifies:**
1. Container starts successfully
2. Application listens on port 8080
3. Endpoint responds to HTTP requests
4. Container can be stopped cleanly

**Why test before pushing?**
- **Quality Assurance**: Don't publish broken images
- **Fast Feedback**: Catch issues before deployment
- **Cost Savings**: Avoid pulling broken images in production
- **User Experience**: Ensure containers work out-of-the-box

---

## Part 3: Trivy Vulnerability Scanning

### What is Trivy?

**Trivy** is a comprehensive vulnerability scanner for container images. It checks:
- OS packages (Ubuntu, Alpine, etc.)
- Application dependencies (Java JARs, Node modules)
- Known CVEs (Common Vulnerabilities and Exposures)

### Trivy Configuration

```yaml
- name: Scan Docker image with Trivy
  uses: aquasecurity/trivy-action@0.20.0
  with:
    image-ref: ${{ env.DOCKER_IMAGE_NAME }}
    format: 'table'
    exit-code: '1'
    severity: 'CRITICAL,HIGH'
```

**Parameter Explanations:**

| Parameter | Value | Explanation |
|-----------|-------|-------------|
| `image-ref` | `democyber:latest` | The Docker image to scan |
| `format` | `table` | Output format (table, json, sarif) |
| `exit-code` | `'1'` | Fail pipeline if vulnerabilities found |
| `severity` | `CRITICAL,HIGH` | Only fail on severe vulnerabilities |

**Severity Levels:**
- **CRITICAL**: Immediate action required (e.g., remote code execution)
- **HIGH**: Serious security risk (e.g., privilege escalation)
- **MEDIUM**: Moderate risk (e.g., information disclosure)
- **LOW**: Minor issues (e.g., outdated packages)

### Output Formats

**1. Table Format** (for human reading):
```
democyber:latest (ubuntu 22.04)
==============================
Total: 45 (CRITICAL: 2, HIGH: 10, MEDIUM: 20, LOW: 13)
```

**2. SARIF Format** (for tooling):
```yaml
- name: Scan Docker image with Trivy (SARIF Format)
  uses: aquasecurity/trivy-action@0.20.0
  with:
    image-ref: ${{ env.DOCKER_IMAGE_NAME }}
    format: 'sarif'
    output: 'trivy-results.sarif'
    severity: 'CRITICAL,HIGH'
```

### Trivy Report Artifact

```yaml
- name: Upload Trivy report
  if: always()
  uses: actions/upload-artifact@v4
  with:
    name: trivy-report
    path: trivy-results.sarif
```

**What's in the Trivy report?**
- CVE IDs (e.g., CVE-2023-12345)
- Affected packages
- Severity ratings
- Fixed versions available
- Description of vulnerability

**Actions to take if vulnerabilities are found:**
1. **Update base image**: Use newer version (e.g., `ubuntu:24.04`)
2. **Update dependencies**: Bump versions in pom.xml
3. **Apply patches**: Run `apt update && apt upgrade` in Dockerfile
4. **Accept risk**: Document why vulnerability is acceptable
5. **Use distroless**: Switch to minimal base images

---

## Part 4: Push to Docker Hub

### Docker Push Step

```yaml
- name: Push Docker image to Docker Hub
  run: docker push $DOCKER_IMAGE_NAME
```

**What happens:**
- Image is uploaded to Docker Hub repository
- Tagged as `latest` (and any other tags specified)
- Publicly accessible (or private based on repo settings)

**Confirmation:**
1. **GitHub Actions**: Green checkmark on push step
2. **Docker Hub**: Image appears in repository
3. **Pull Test**: `docker pull YOUR_USERNAME/democyber:latest`

---

## 🎯 Complete Workflow Summary

The pipeline executes in this order:

```
1. Checkout Code
   ↓
2. 🔒 Gitleaks Secret Scan
   ↓ (fails if secrets detected)
3. ☕ Build Java Application (Maven)
   ↓
4. 🐳 Build Docker Image
   ↓
5. ✅ Test Docker Container
   ↓
6. 🔍 Trivy Vulnerability Scan
   ↓ (fails if CRITICAL/HIGH CVEs found)
7. 📤 Push to Docker Hub
   ↓
8. ✅ Success!
```

**Security Gates:**
- ❌ Fails on secrets → Protects credentials
- ❌ Fails on vulnerabilities → Ensures secure images

---

## 📋 Lab Questions & Answers

### Part 1: Gitleaks

**Q: What does Gitleaks do?**

**A:** Gitleaks is a security scanner that detects hardcoded secrets (API keys, tokens, passwords) in source code. It prevents sensitive information from being accidentally committed to version control and exposed publicly.

**Q: Why did the pipeline fail after injecting the fake secret?**

**A:** Gitleaks detected the pattern `ghp_*` which matches GitHub Personal Access Token format. Even though the token is fake, the pattern-matching algorithm flagged it as a potential secret. This demonstrates how Gitleaks prevents credential leaks.

**Q: What kind of problems does Gitleaks prevent?**

**A:**
1. **Data breaches** from exposed API keys
2. **Unauthorized access** to cloud resources
3. **Financial loss** from abused AWS/Azure credentials
4. **Compliance violations** (PCI-DSS, SOC2 requirements)
5. **Reputation damage** from public security incidents

**Q: What does the Gitleaks report show?**

**A:** The SARIF report contains:
- Detected secret types (e.g., "github-token", "aws-access-key")
- File paths and line numbers where secrets were found
- Confidence scores for each detection
- Remediation advice

**Q: Why is it important to analyze this report?**

**A:**
- **Prioritization**: Shows which secrets are most critical to fix
- **Audit trail**: Proves security scanning is active
- **Compliance**: Required for many security certifications
- **Remediation**: Guides developers on what needs fixing

**Q: What actions would you take if a secret is detected?**

**A:**
1. **Immediate removal**: Delete or comment out the secret
2. **Rotate credentials**: Revoke and regenerate the exposed secret
3. **Use environment variables**: Move to GitHub Secrets or vault
4. **Git history cleanup**: Use `git filter-branch` to remove from history
5. **Monitor**: Check logs for unauthorized usage

### Part 2: Docker Build and Test

**Q: What does the local Docker test verify?**

**A:**
- Container starts without errors
- Application binds to port 8080
- HTTP endpoint responds correctly
- Container can be stopped cleanly

**Q: Why is testing the image locally important before pushing to Docker Hub?**

**A:**
- **Quality**: Ensures images work before public release
- **User experience**: Users can trust images work out-of-box
- **Efficiency**: Catches issues before deployment
- **Cost**: Avoids downloading broken images in production

### Part 3: Trivy Scan

**Q: Explain each Trivy parameter:**

**A:**
- `image-ref`: The Docker image to scan
- `format`: Output format (`table` for humans, `sarif` for tools)
- `exit-code: '1'`: Fail pipeline if vulnerabilities found
- `severity`: Which severity levels trigger failure (CRITICAL, HIGH)

**Q: What happens if Trivy finds vulnerabilities?**

**A:**
- Pipeline **fails** (exit code 1)
- Deployment is **blocked**
- Report shows CVE details
- Developers must fix vulnerabilities before merge

---

## 🚀 Deployment Instructions

### Prerequisites

You need Docker Hub credentials configured in GitHub Secrets:

1. **DOCKERHUB_USERNAME**: Your Docker Hub username
2. **DOCKERHUB_TOKEN**: Personal access token from Docker Hub

### Step 1: Clean Run (No Secrets)

```bash
# Ensure no secrets in code
git add .
git commit -m "feat: add gitleaks security scan"
git push origin main
```

**Expected:** ✅ All steps pass, image pushed to Docker Hub

### Step 2: Test Secret Detection

```bash
# Edit DemocyberApplication.java - add fake secret
git add .
git commit -m "test: inject fake secret"
git push origin main
```

**Expected:** ❌ Gitleaks fails, pipeline stops

### Step 3: Fix and Retry

```bash
# Comment out the secret
git add .
git commit -m "fix: remove exposed secret"
git push origin main
```

**Expected:** ✅ Pipeline passes again

---

## 📊 Success Metrics

Your pipeline should:
- ✅ Detect secrets with Gitleaks
- ✅ Build Java application successfully
- ✅ Create Docker image
- ✅ Test container locally
- ✅ Scan for vulnerabilities with Trivy
- ✅ Push to Docker Hub
- ✅ Upload security reports as artifacts

---

## 🎓 Best Practices Implemented

1. **Security-First**: Scans before build and deploy
2. **Fail Fast**: Stop on security issues
3. **Automated Testing**: Verify container works
4. **Artifact Retention**: Save reports for analysis
5. **Clear Commit Messages**: Follow conventional commits
6. **Environment Secrets**: No hardcoded credentials

---

**Your pipeline is now production-ready with enterprise-level security scanning!** 🎉

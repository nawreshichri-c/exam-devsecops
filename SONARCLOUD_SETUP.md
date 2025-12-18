# SonarCloud Setup Guide

## 🎯 Overview

**SonarCloud** is a cloud-based code quality and security analysis platform that provides:
- Static code analysis (SAST)
- Security vulnerability detection
- Code quality metrics
- Technical debt assessment
- Code coverage analysis

---

## Step 1: Connect SonarCloud to GitHub

### 1.1 Create SonarCloud Account

1. **Go to:** https://sonarcloud.io
2. **Click:** "Start Free"
3. **Choose:** "Sign in with GitHub"
4. **Authorize:** Allow SonarCloud to access your GitHub account

### 1.2 Create Organization

After signing in:

1. **Click:** "+" (top right) → "Create an organization"
2. **Choose:** "Create an organization manually"
3. **Organization Key:** Enter a unique key (e.g., `haroun-gaida-devsecops`)
4. **Organization Name:** Same as key or descriptive name
5. **Choose plan:** Free (for public repositories)
6. **Click:** "Create Organization"

**Save this:** Your organization key will be used in the pipeline!

### 1.3 Create New Project

1. **Click:** "Analyze new project" (or "+" → "Analyze new project")
2. **Select:** Your GitHub repository `exam-devsecops`
3. **Click:** "Set Up"
4. **Choose:** "With GitHub Actions" (CI-based analysis)

SonarCloud will provide:
- **Organization:** `your-org-key`
- **Project Key:** `Haroun-Gaida_exam-devsecops` (auto-generated)

**Save these values!** You'll need them for GitHub secrets.

---

## Step 2: Generate SonarCloud Token

### 2.1 Navigate to Security Settings

1. **Click:** Your avatar (top right)
2. **Select:** "My Account"
3. **Click:** "Security" tab

### 2.2 Generate Token

1. **Click:** "Generate Token"
2. **Name:** `sonar-token`
3. **Type:** User Token
4. **Expiration:** 90 days (or custom)
5. **Click:** "Generate"

### 2.3 Copy Token

⚠️ **IMPORTANT:** Copy the token immediately - it's shown only once!

Example token format: `sqp_1234567890abcdef1234567890abcdef12345678`

**Store it securely** - you'll add it to GitHub secrets next.

---

## Step 3: Add Secrets to GitHub

### 3.1 Navigate to Repository Secrets

**Go to:** https://github.com/Haroun-Gaida/exam-devsecops/settings/secrets/actions

### 3.2 Add SONAR_TOKEN

1. **Click:** "New repository secret"
2. **Name:** `SONAR_TOKEN`
3. **Value:** Paste the token from SonarCloud
4. **Click:** "Add secret"

### 3.3 Add SONAR_ORGANIZATION

1. **Click:** "New repository secret"
2. **Name:** `SONAR_ORGANIZATION`
3. **Value:** Your organization key (from Step 1.2)
4. **Click:** "Add secret"

### 3.4 Add SONAR_PROJECT_KEY

1. **Click:** "New repository secret"
2. **Name:** `SONAR_PROJECT_KEY`
3. **Value:** Your project key (usually `USERNAME_REPOSITORY`)
   - Example: `Haroun-Gaida_exam-devsecops`
4. **Click:** "Add secret"

### 3.5 Verify Secrets

You should now have **5 secrets** configured:
- ✅ DOCKERHUB_USERNAME
- ✅ DOCKERHUB_TOKEN
- ✅ SONAR_TOKEN
- ✅ SONAR_ORGANIZATION
- ✅ SONAR_PROJECT_KEY

---

## Step 4: Create sonar-project.properties

This file configures SonarCloud analysis for your project.

**Create:** `sonar-project.properties` in project root

```properties
# SonarCloud Project Configuration
sonar.projectKey=Haroun-Gaida_exam-devsecops
sonar.organization=haroun-gaida-devsecops

# Project metadata
sonar.projectName=exam-devsecops
sonar.projectVersion=1.0

# Source code location
sonar.sources=src/main/java
sonar.java.source=21

# Test code location (if you have tests)
# sonar.tests=src/test/java

# Binary files for bytecode analysis
sonar.java.binaries=target/classes

# Exclude build artifacts
sonar.exclusions=**/target/**,**/*.class

# Code coverage (if using JaCoCo)
# sonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml

# Encoding
sonar.sourceEncoding=UTF-8
```

**Important:** Replace the values with your actual organization and project key!

---

## Step 5: Update CI/CD Pipeline

The pipeline has already been updated with SonarCloud integration!

**File:** `.github/workflows/ci.yml`

```yaml
- name: SonarCloud Scan
  uses: SonarSource/sonarcloud-github-action@master
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
  with:
    projectBaseDir: .
    args: >
      -Dsonar.organization=${{ secrets.SONAR_ORGANIZATION }}
      -Dsonar.projectKey=${{ secrets.SONAR_PROJECT_KEY }}
```

---

## Step 6: Trigger Analysis

```bash
# Commit the sonar-project.properties
git add sonar-project.properties
git commit -m "feat: add SonarCloud configuration"
git push origin main
```

The pipeline will automatically run SonarCloud analysis!

---

## Step 7: View Results

### 7.1 Check GitHub Actions

**Go to:** https://github.com/Haroun-Gaida/exam-devsecops/actions

Watch the workflow run - SonarCloud step should complete successfully.

### 7.2 View SonarCloud Dashboard

**Go to:** https://sonarcloud.io/project/overview?id=Haroun-Gaida_exam-devsecops

**You'll see:**
- Overall quality gate status (Passed/Failed)
- Security rating (A-E)
- Reliability rating (A-E)
- Maintainability rating (A-E)
- Code coverage percentage
- Bugs, Vulnerabilities, Code Smells
- Technical debt

---

## 🎓 Understanding SonarCloud Results

### Quality Gate

**Passed ✅** or **Failed ❌**

Default conditions:
- No new bugs
- No new vulnerabilities
- Security hotspots reviewed
- Coverage on new code ≥ 80%
- Duplicated lines ≤ 3%
- Maintainability rating ≥ A

### Security Rating

**Grades: A (best) → E (worst)**

Based on:
- Security vulnerabilities count
- Severity (Critical, High, Medium, Low)

**A:** 0 vulnerabilities
**B:** At least 1 minor vulnerability
**C:** At least 1 major vulnerability
**D:** At least 1 critical vulnerability
**E:** At least 1 blocker vulnerability

### Reliability Rating

**Grades: A → E**

Based on:
- Bugs count and severity

**A:** 0 bugs
**B:** At least 1 minor bug
**C:** At least 1 major bug
**D:** At least 1 critical bug
**E:** At least 1 blocker bug

### Maintainability Rating

**Grades: A → E**

Based on:
- Technical debt ratio
- Code smells

**A:** Technical debt ratio ≤ 5%
**B:** 6-10%
**C:** 11-20%
**D:** 21-50%
**E:** > 50%

---

## 🆘 Troubleshooting

### Error: "Could not find a default branch"

**Solution:** Ensure your repository has at least one commit on the main branch.

### Error: "Organization key is invalid"

**Solution:** 
- Verify organization key matches exactly
- Check secret name is `SONAR_ORGANIZATION` (case-sensitive)

### Error: "Project key not found"

**Solution:**
- Verify project key in SonarCloud dashboard
- Update `SONAR_PROJECT_KEY` secret if needed

### Error: "Not authorized"

**Solution:**
- Regenerate SonarCloud token
- Ensure token has correct permissions
- Update `SONAR_TOKEN` secret

### No analysis results showing

**Solution:**
- Check `sonar-project.properties` paths are correct
- Ensure `target/classes` exists (Maven build completed)
- Check GitHub Actions logs for errors

---

## 📋 Checklist

- [ ] Created SonarCloud account
- [ ] Created organization
- [ ] Created project for exam-devsecops
- [ ] Generated SonarCloud token
- [ ] Added SONAR_TOKEN to GitHub secrets
- [ ] Added SONAR_ORGANIZATION to GitHub secrets
- [ ] Added SONAR_PROJECT_KEY to GitHub secrets
- [ ] Created sonar-project.properties file
- [ ] Updated CI/CD pipeline (already done)
- [ ] Pushed changes to trigger analysis
- [ ] Viewed results on SonarCloud dashboard
- [ ] Documented grades and findings

---

## 🔗 Quick Links

- **SonarCloud:** https://sonarcloud.io
- **Your Project:** https://sonarcloud.io/project/overview?id=Haroun-Gaida_exam-devsecops
- **GitHub Secrets:** https://github.com/Haroun-Gaida/exam-devsecops/settings/secrets/actions
- **Documentation:** https://docs.sonarcloud.io

---

**After completing these steps, your pipeline will include comprehensive code quality and security analysis!** 🎉

# 🔑 SonarCloud Secrets - Ready to Add!

**⚠️ Note:** Your actual SonarCloud token should **NOT** be committed to the repository.  
The token has been configured in GitHub Secrets.

## Add These 3 Secrets to GitHub

**Page:** https://github.com/Haroun-Gaida/exam-devsecops/settings/secrets/actions

Click "New repository secret" for each one:

### SECRET 1: SONAR_TOKEN
```
Name:  SONAR_TOKEN
Value: [Your SonarCloud token from https://sonarcloud.io/account/security]
```

### SECRET 2: SONAR_ORGANIZATION
```
Name:  SONAR_ORGANIZATION
Value: haroun-gaida
```

### SECRET 3: SONAR_PROJECT_KEY
```
Name:  SONAR_PROJECT_KEY
Value: Haroun-Gaida_exam-devsecops
```

## ✅ After Adding

You should see **5 total secrets**:
- DOCKERHUB_USERNAME ✅
- DOCKERHUB_TOKEN ✅
- SONAR_TOKEN ← Configured
- SONAR_ORGANIZATION ← Configured
- SONAR_PROJECT_KEY ← Configured

**✅ All secrets are now configured in GitHub!** 🚀

# Configure GitHub Secrets for CI/CD Pipeline

## 🔐 Required Secrets

Your CI/CD pipeline needs these secrets to work:

1. **DOCKERHUB_USERNAME** - Your Docker Hub username
2. **DOCKERHUB_TOKEN** - Personal access token from Docker Hub

---

## Step 1: Create Docker Hub Access Token

### 1.1 Login to Docker Hub

Go to: https://hub.docker.com

### 1.2 Create Personal Access Token

1. Click your **profile icon** (top right)
2. Go to **Account Settings**
3. Click **Security** tab
4. Click **New Access Token**
5. Token description: `github-actions`
6. Access permissions: **Read & Write**
7. Click **Generate**
8. **⚠️ IMPORTANT**: Copy the token immediately (you can't see it again!)

Example token format: `dckr_pat_XXXXXXXXXXXX...`

---

## Step 2: Add Secrets to GitHub

### 2.1 Navigate to Repository Settings

Go to: https://github.com/Haroun-Gaida/exam-devsecops/settings/secrets/actions

### 2.2 Add DOCKERHUB_USERNAME

1. Click **New repository secret**
2. Name: `DOCKERHUB_USERNAME`
3. Value: Your Docker Hub username (e.g., `haroun-gaida`)
4. Click **Add secret**

### 2.3 Add DOCKERHUB_TOKEN

1. Click **New repository secret**
2. Name: `DOCKERHUB_TOKEN`
3. Value: Paste the token you copied from Docker Hub
4. Click **Add secret**

---

## Step 3: Verify Secrets

You should now see two secrets listed:
- ✅ DOCKERHUB_USERNAME
- ✅ DOCKERHUB_TOKEN

**Note**: Values are hidden for security.

---

## Step 4: Trigger Pipeline

After adding secrets, push any change to trigger the pipeline:

```bash
# Make a small change
echo "# Secrets configured" >> README.md

# Commit and push
git add README.md
git commit -m "docs: update README"
git push origin main
```

Go to Actions tab to watch it run: https://github.com/Haroun-Gaida/exam-devsecops/actions

---

## 🎯 What Each Secret Does

| Secret | Purpose | Used By |
|--------|---------|---------|
| DOCKERHUB_USERNAME | Authenticates to Docker Hub | `docker/login-action@v2` |
| DOCKERHUB_TOKEN | Password for Docker Hub login | `docker/login-action@v2` |

Both are used in this step of the workflow:

```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v2
  with:
    username: ${{ secrets.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}
```

---

## 🆘 Troubleshooting

### Error: "Username and password required"

**Cause**: Secrets not configured or incorrectly named

**Solution**: 
- Verify secret names are exactly `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`
- Check for typos
- Ensure secrets are in **Repository** secrets, not Environment secrets

### Error: "incorrect username or password"

**Cause**: Invalid Docker Hub token or username

**Solution**:
- Regenerate Docker Hub token
- Update the `DOCKERHUB_TOKEN` secret on GitHub
- Verify your Docker Hub username is correct

### Error: "denied: requested access to the resource is denied"

**Cause**: Token doesn't have write permissions

**Solution**:
- Create new token with **Read & Write** permissions
- Update `DOCKERHUB_TOKEN` secret

---

## 🎓 Security Best Practices

✅ **DO:**
- Use Personal Access Tokens (not passwords)
- Set token expiration (e.g., 90 days)
- Use separate tokens for different purposes
- Rotate tokens regularly
- Delete unused tokens

❌ **DON'T:**
- Hardcode credentials in code
- Share tokens via email or chat
- Use the same token for multiple projects
- Give tokens unnecessary permissions
- Commit .env files with secrets

---

## 📋 Checklist

- [ ] Created Docker Hub personal access token
- [ ] Added DOCKERHUB_USERNAME to GitHub secrets
- [ ] Added DOCKERHUB_TOKEN to GitHub secrets
- [ ] Verified both secrets appear in GitHub settings
- [ ] Triggered pipeline to test
- [ ] Pipeline completes successfully

---

**After completing these steps, your pipeline will be able to push images to Docker Hub!** 🚀

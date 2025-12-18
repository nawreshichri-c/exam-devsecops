# 📝 Complete Git Commands Reference

## ✅ What Just Happened

All files have been committed and pushed to GitHub successfully!

**Commit:** `5f655e2` - "chore: add progress update and documentation for Docker Hub integration"

**Files pushed:**
- PROGRESS_UPDATE.md
- WHAT_YOU_MUST_DO.md
- (All previous work already on GitHub)

---

## 🔄 Complete Git Workflow Commands

### Basic Workflow (What We Just Did)

```bash
# 1. Check current status
cd c:\CTF\secure_app
git status

# 2. Stage all changes
git add .

# 3. Commit with message
git commit -m "your commit message here"

# 4. Push to GitHub
git push origin main
```

---

## 📚 All Git Commands You'll Need

### Check Status
```bash
# See what files have changed
git status

# See commit history
git log --oneline

# See what's on GitHub vs local
git fetch
git status
```

### Stage Files
```bash
# Stage all files
git add .

# Stage specific file
git add filename.txt

# Stage specific folder
git add folder/

# Unstage files (undo git add)
git restore --staged filename.txt
```

### Commit Changes
```bash
# Commit with message
git commit -m "your message"

# Commit with multi-line message
git commit -m "Title" -m "Description"

# Best practice commit messages:
git commit -m "feat: add new feature"
git commit -m "fix: resolve bug"
git commit -m "docs: update documentation"
git commit -m "chore: update dependencies"
git commit -m "test: add tests"
```

### Push to GitHub
```bash
# Push to main branch
git push origin main

# Push and set upstream (first time)
git push -u origin main

# Force push (CAREFUL!)
git push origin main --force
```

### Pull from GitHub
```bash
# Pull latest changes
git pull origin main

# Pull and rebase
git pull origin main --rebase
```

### Branch Operations
```bash
# Create new branch
git checkout -b feature-name

# Switch branches
git checkout main
git checkout feature-name

# List branches
git branch

# Delete branch
git branch -d feature-name
```

### Undo Changes
```bash
# Discard local changes
git restore filename.txt

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Amend last commit message
git commit --amend -m "new message"
```

---

## 🚀 Quick Commands for This Project

### Test Pipeline
```bash
# Trigger pipeline with empty commit
git commit --allow-empty -m "test: trigger pipeline"
git push origin main
```

### Add New Files
```bash
# After creating new files
git add .
git commit -m "feat: add new feature"
git push origin main
```

### Update Documentation
```bash
# After editing docs
git add *.md
git commit -m "docs: update documentation"
git push origin main
```

### Fix Issues
```bash
# After fixing bugs
git add .
git commit -m "fix: resolve issue with X"
git push origin main
```

---

## 🔍 View Repository Status

### Check Local vs Remote
```bash
# Fetch latest from GitHub (doesn't change local files)
git fetch

# See differences
git status

# See what commits are on GitHub
git log origin/main

# See what commits are local only
git log main ^origin/main
```

### View File Changes
```bash
# See what changed in files
git diff

# See what changed in staged files
git diff --staged

# See changes in specific file
git diff filename.txt
```

---

## 📦 Complete Workflow Example

```bash
# Navigate to project
cd c:\CTF\secure_app

# 1. Check current status
git status

# 2. Make your changes (edit files, create new files, etc.)
# ... edit code ...

# 3. See what changed
git status
git diff

# 4. Stage changes
git add .

# 5. Commit
git commit -m "feat: add new feature"

# 6. Push to GitHub
git push origin main

# 7. Verify on GitHub
# Go to: https://github.com/Haroun-Gaida/exam-devsecops
```

---

## 🎯 Common Scenarios

### Scenario 1: Quick Update
```bash
git add .
git commit -m "docs: update README"
git push origin main
```

### Scenario 2: New Feature
```bash
# Create feature branch
git checkout -b feature-monitoring

# Make changes
# ... edit files ...

# Commit
git add .
git commit -m "feat: add Prometheus monitoring"

# Push to GitHub
git push origin feature-monitoring

# Later, merge to main
git checkout main
git merge feature-monitoring
git push origin main
```

### Scenario 3: Fix Mistake
```bash
# Oops, wrong commit message!
git commit --amend -m "correct message"

# Oops, forgot a file!
git add forgotten-file.txt
git commit --amend --no-edit

# Push (need force because we changed history)
git push origin main --force
```

---

## 🔗 Repository Links

- **Repository:** https://github.com/Haroun-Gaida/exam-devsecops
- **Actions:** https://github.com/Haroun-Gaida/exam-devsecops/actions
- **Commits:** https://github.com/Haroun-Gaida/exam-devsecops/commits/main
- **Files:** https://github.com/Haroun-Gaida/exam-devsecops/tree/main

---

## ✅ Current Repository Status

**Branch:** main
**Latest commit:** 5f655e2 - "chore: add progress update and documentation for Docker Hub integration"
**Remote:** https://github.com/Haroun-Gaida/exam-devsecops.git
**Status:** ✅ All changes pushed

---

## 🎓 Commit Message Best Practices

**Format:** `<type>: <description>`

**Types:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code formatting (no logic change)
- `refactor:` Code restructuring
- `test:` Adding tests
- `chore:` Maintenance tasks

**Examples:**
```bash
git commit -m "feat: add Docker monitoring support"
git commit -m "fix: resolve Gitleaks false positive"
git commit -m "docs: update SonarCloud setup guide"
git commit -m "test: add unit tests for API endpoints"
git commit -m "chore: update dependencies to latest versions"
```

---

**Need to run any of these commands? Just copy and paste!** 🚀

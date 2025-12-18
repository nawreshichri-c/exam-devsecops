# exam-devsecops - DevSecOps Lab Project

A Spring Boot application demonstrating DevSecOps practices with Git, Docker, and GitHub Actions CI/CD.

## 🚀 Quick Start

### Prerequisites
- Java 21
- Maven 3.6+ (or use build.bat script)
- Docker Desktop
- Git

### Build & Run Locally

```bash
# Build with Maven
mvn clean package

# Or use the build script
.\build.bat

# Run the application
java -jar target/democyber-0.0.1-SNAPSHOT.jar

# Visit: http://localhost:8080
# Expected: "Hello from Democyber 123!"
```

### Build & Run with Docker

```bash
# Build Docker image (replace YOUR_USERNAME)
docker build -t YOUR_USERNAME/democyber:latest .

# Run container
docker run -p 8080:8080 YOUR_USERNAME/democyber:latest

# Visit: http://localhost:8080
```

## 📚 Documentation

**Complete Lab Guide:** [DEVSECOPS_LAB_GUIDE.md](DEVSECOPS_LAB_GUIDE.md)
- Part 1: Git & GitHub Setup
- Part 2: Java/Maven Application
- Part 3: Docker Build & Push
- Part 4: CI/CD with GitHub Actions
- Answers to all lab questions

**Quick Start:** Run `START-HERE.bat` for interactive menu

## 🏗️ Project Structure

```
exam-devsecops/
├── .github/workflows/        # GitHub Actions CI/CD pipeline
│   └── ci.yml
├── src/
│   └── main/
│       ├── java/            # Java source code
│       │   └── com/example/democyber/
│       │       └── DemocyberApplication.java
│       └── resources/        # Application configuration
│           └── application.properties
├── Dockerfile               # Docker configuration
├── pom.xml                  # Maven configuration (Java 21)
├── START-HERE.bat           # Interactive quick start menu
├── build.bat                # Smart build script
├── connect-github.bat       # GitHub connection helper
├── check-prerequisites.bat  # Prerequisites checker
├── README.md                # This file
└── DEVSECOPS_LAB_GUIDE.md   # Complete step-by-step guide
```

## 🔐 DevSecOps Practices

This project demonstrates:
- ✅ **Version Control:** Git with GitHub
- ✅ **Build Automation:** Maven with proper dependency management
- ✅ **Containerization:** Docker for consistent deployments
- ✅ **CI/CD Pipeline:** GitHub Actions for automated builds
- ✅ **Security:** Secrets management, dependency scanning
- ✅ **Documentation:** Comprehensive guides and inline comments

## 🎯 Lab Objectives

1. **Git:** Initialize repository, commit, and push to GitHub
2. **Maven:** Build Java Spring Boot application
3. **Docker:** Containerize application and push to Docker Hub
4. **CI/CD:** Set up automated pipeline with GitHub Actions
5. **Security:** Configure secrets and follow best practices

## 📋 Quick Commands

```bash
# Check prerequisites
.\check-prerequisites.bat

# Build application
.\build.bat
# OR
mvn clean package

# Run locally
java -jar target\democyber-0.0.1-SNAPSHOT.jar

# Docker build
docker build -t username/democyber:latest .

# Docker run
docker run -p 8080:8080 username/democyber:latest

# Push to Docker Hub
docker login
docker push username/democyber:latest

# Git commands
git add .
git commit -m "message"
git push origin main
```

## 🆘 Help & Troubleshooting

- **Maven not found?** Use `build.bat` or install: `choco install maven`
- **Port 8080 in use?** Stop other apps or use different port
- **Docker build fails?** Make sure target/democyber-0.0.1-SNAPSHOT.jar exists
- **Need detailed help?** See [DEVSECOPS_LAB_GUIDE.md](DEVSECOPS_LAB_GUIDE.md)

## 📝 Lab Report Questions

All answers with detailed explanations are in `DEVSECOPS_LAB_GUIDE.md`:
1. Screenshot of successful pipeline run
2. What happens if a workflow step fails?
3. Why specify branch (main) as trigger?

## 👨‍💻 Author

Haroun Gaida - DevSecOps Lab Exercise

## 📄 License

Educational project for DevSecOps lab exercises.

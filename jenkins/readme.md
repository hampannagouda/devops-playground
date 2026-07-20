# Jenkins

> An open-source automation server for building, testing, and deploying software — reliably, repeatedly, and without the human error that creeps into manual releases.

![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939?logo=jenkins&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Status](https://img.shields.io/badge/status-active-brightgreen)

---

## Overview

Jenkins is the backbone of countless engineering pipelines. It watches your repository, notices when something changes, and takes over from there — compiling code, running tests, packaging artifacts, and shipping them wherever they need to go. What started as a fork of a Sun Microsystems project called Hudson has grown into the most widely deployed automation server in the industry, largely because it refuses to be opinionated. Jenkins doesn't care what language you write in, what cloud you deploy to, or how unusual your workflow is. If you can script it, Jenkins can automate it.

This repository documents how Jenkins is configured and used in this project.

## Why Jenkins

- **Extensible by design.** With well over a thousand community plugins, Jenkins integrates with almost every tool in the modern DevOps toolchain — Git, Docker, Kubernetes, Slack, Terraform, and more.
- **Pipeline as code.** Build logic lives in a `Jenkinsfile`, versioned alongside your source, reviewed like any other code change.
- **Distributed builds.** A single controller can delegate work across many agent nodes, scaling horizontally as your build load grows.
- **Vendor-neutral.** Self-hosted or cloud-hosted, on-premises or in a container — Jenkins runs wherever you need it to.
- **Battle-tested.** Over a decade of production use across organizations of every size.

## Prerequisites

- Java 11 or 17 (JDK)
- 256 MB RAM minimum (4 GB+ recommended for real workloads)
- 10 GB disk space
- Docker (optional, but recommended for isolated builds)

## Installation

### Docker (recommended)

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

### Debian/Ubuntu

```bash
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install jenkins
```

Once installed, Jenkins is available at `http://localhost:8080`. The initial admin password is printed to the console log or found at:

```bash
/var/jenkins_home/secrets/initialAdminPassword
```

## Project Structure

```
.
├── Jenkinsfile              # Pipeline definition (build, test, deploy stages)
├── jenkins/
│   ├── plugins.txt          # Pinned plugin versions
│   ├── casc.yaml            # Configuration as Code definitions
│   └── scripts/             # Shared groovy helper scripts
└── README.md
```

## Pipeline

The `Jenkinsfile` defines a declarative pipeline with four stages:

| Stage      | Purpose                                      |
|------------|-----------------------------------------------|
| Checkout   | Pull the latest source from version control    |
| Build      | Compile and package the application            |
| Test       | Run unit and integration test suites            |
| Deploy     | Ship artifacts to staging or production          |

Example skeleton:

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Build') {
            steps { sh './gradlew build' }
        }
        stage('Test') {
            steps { sh './gradlew test' }
        }
        stage('Deploy') {
            when { branch 'main' }
            steps { sh './deploy.sh' }
        }
    }

    post {
        failure {
            slackSend channel: '#builds', message: "Build failed: ${env.BUILD_URL}"
        }
    }
}
```

## Configuration as Code

Rather than click through the UI to configure Jenkins, this project uses the [Configuration as Code (JCasC)](https://www.jenkins.io/projects/jcasc/) plugin. All controller settings live in `jenkins/casc.yaml`, so a fresh Jenkins instance can be stood up identically every time, with no manual setup.

## Recommended Plugins

- **Pipeline** — core pipeline-as-code support
- **Git** — source control integration
- **Credentials Binding** — secrets management
- **Blue Ocean** — a modern, visual pipeline UI
- **Slack Notification** — build status alerts

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-change`)
3. Commit your changes with clear, descriptive messages
4. Open a pull request against `main`

All pull requests trigger the pipeline automatically; a passing build is required before merge.

## Resources

- [Official Jenkins Documentation](https://www.jenkins.io/doc/)
- [Pipeline Syntax Reference](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Plugin Index](https://plugins.jenkins.io/)
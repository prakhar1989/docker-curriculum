---
title: Container Security Best Practices
---

When running containers in production environments, security should be top of mind. By default, processes running inside a Docker container execute as the **`root`** user unless configured otherwise.

If an attacker manages to exploit a vulnerability in your application running as `root`, they could potentially break out of the container boundary or access underlying host system resources.

Let's look at three essential security practices for hardening your Docker containers.

---

### 1. Run Containers as Non-Root Users

The easiest and most effective way to secure a container is to instruct Docker to run processes under a non-privileged user account.

#### In Dockerfile:

```dockerfile
FROM python:3.12-slim

# Create a dedicated non-root user and group
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /usr/src/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Change ownership of working directory to non-root user
RUN chown -R appuser:appuser /usr/src/app

# Switch to non-root user
USER appuser

EXPOSE 5000
CMD ["python", "./app.py"]
```

#### In Docker Compose:

You can also enforce non-root user execution in `docker-compose.yml`:

```yaml
services:
  web:
    image: yourusername/catnip
    user: "10001:10001"
```

---

### 2. Exclude Unnecessary Files with `.dockerignore`

Just like `.gitignore` prevents secret keys, build artifacts, and logs from being committed to Git, a **`.dockerignore`** file prevents sensitive or unnecessary files from being copied into your Docker image.

Create a `.dockerignore` file in the root of your project:

```text
# .dockerignore
.git
.gitignore
__pycache__/
*.pyc
*.pyo
.env
.env.local
node_modules/
Dockerfile
docker-compose*.yml
README.md
```

Benefits of `.dockerignore`:
* Prevents accidental leaks of secret environment variables (`.env`).
* Keeps Docker build context small, speeding up `docker build`.
* Avoids overwriting in-container package installations with local host `node_modules` or `__pycache__`.

---

### 3. Vulnerability Scanning with `docker scout`

Even if your code is clean, third-party libraries or OS base images can contain known security vulnerabilities (CVEs). Modern Docker CLI includes **Docker Scout** for scanning images directly from your terminal.

#### Quick Vulnerability Overview

Scan your built image for vulnerabilities:

```bash
$ docker scout quickview yourusername/catnip:latest
```

Output:

```text
 Target             │ yourusername/catnip:latest  │ 0 critical, 0 high, 2 medium, 4 low
 Base image         │ python:3.12-slim            │ 0 critical, 0 high
 Updated base image │ python:3.12-slim            │ No update needed
```

#### Inspecting Specific Vulnerabilities

To get detailed recommendations on upgrading vulnerable packages or base images:

```bash
$ docker scout cves yourusername/catnip:latest
```

Docker Scout will list affected packages and suggest patch versions to secure your image.

---

### Summary Checklist for Production Containers

* [x] **Use minimal base images** (`python:3.12-slim`, `alpine`).
* [x] **Copy requirements first** to optimize layer caching.
* [x] **Run as a non-root user** (`USER appuser`).
* [x] **Use `.dockerignore`** to exclude secrets and build clutter.
* [x] **Scan images** regularly with `docker scout`.

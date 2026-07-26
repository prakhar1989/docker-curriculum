---
title: BuildKit & Multi-Platform Builds
---

Docker Desktop and modern Docker Engine use **[BuildKit](https://docs.docker.com/build/buildkit/)** as the default build engine. BuildKit is a complete overhaul of the Docker build system, designed to be faster, more efficient, and feature-rich.

### Why BuildKit?

Compared to legacy Docker builds, BuildKit introduces powerful features out of the box:

* **Parallel Execution**: Independent build stages execute concurrently.
* **Smart Layer Caching**: Unused build steps are skipped automatically.
* **Advanced Mount Types**: Mount cache directories (`--mount=type=cache`) or secret keys (`--mount=type=secret`) without burning them into image layers.

### Fast Package Caching with `--mount=type=cache`

When building Docker images for Python, Node.js, or Rust, `pip install` or `npm install` often re-downloads packages if dependencies change. With BuildKit cache mounts, you can persist package caches across builds:

```dockerfile
# Syntax directive enabling BuildKit features
# syntax=docker/dockerfile:1

FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt .

# Mount the pip cache directory across container builds
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

COPY . .
```

Even if `requirements.txt` changes slightly, `pip` won't need to re-download unchanged packages from PyPI because the cache directory persists across builds on your machine!

---

### The Problem: Mac (ARM64) vs Cloud Servers (AMD64)

If you write code on an Apple Silicon Mac (M1/M2/M3/M4), your computer runs on the **ARM64** CPU architecture. However, standard cloud servers (like standard AWS EC2 instances, DigitalOcean Droplets, or GCP Compute Engine VMs) run on **AMD64 / x86_64** CPUs.

If you build an image locally on an Apple Silicon Mac and push it directly to Docker Hub without specifying a target architecture, a standard Linux x86 EC2 server pulling your image will crash with a cryptic CPU architecture mismatch error:

```text
exec /usr/local/bin/python: exec format error
```

This happens because the Linux OS on the EC2 server cannot execute binary instructions compiled for ARM processors.

---

### Solution 1: Cross-Building for Mac to AWS EC2

For individual developers or quick staging tests, **`docker buildx`** solves this problem by enabling multi-platform builds right from your Mac.

#### Step 1: Create a Multi-Platform Builder

`buildx` comes built into Docker Desktop. Create a builder instance that supports cross-compilation via QEMU:

```bash
$ docker buildx create --name mybuilder --use
$ docker buildx inspect --bootstrap
```

#### Step 2: Build for the Target Cloud Architecture (`linux/amd64`)

When building an image on your Mac to deploy to a standard AWS EC2 instance, tell `buildx` to target `linux/amd64` and push it to a **Container Registry** (like Docker Hub or AWS Elastic Container Registry):

```bash
$ docker buildx build --platform linux/amd64 -t yourusername/catnip:v1 --push .
```

#### Step 3: Pull and Run on EC2

Now, SSH into your AWS EC2 instance and pull the image:

```bash
$ docker run -d -p 80:5000 yourusername/catnip:v1
```

Because you explicitly targeted `linux/amd64`, the container runs smoothly on your EC2 instance!

---

### Multi-Platform Manifest Lists

What if you want a single image tag (like `yourusername/catnip:v2`) to run on **both** Apple Silicon Macs and Linux x86 EC2 servers without separate tags?

You can build for multiple architectures simultaneously:

```bash
$ docker buildx build --platform linux/amd64,linux/arm64 -t yourusername/catnip:v2 --push .
```

When you push a multi-platform image to a Container Registry, Docker uploads a **manifest list**. When a machine pulls `yourusername/catnip:v2`, Docker automatically inspects the machine's CPU architecture and downloads the matching binary slice:

```text
               ┌──> linux/amd64 (Cloud EC2 / Intel)
yourusername/catnip:v2 (Manifest List)
               └──> linux/arm64 (Apple Silicon)
```

---

### How Engineering Organizations Do This in Production

While building multi-platform images locally works for solo projects, **engineering organizations never build production images on local developer laptops**.

Here is how modern production workflows operate:

```text
┌─────────────────┐       git push       ┌──────────────────────┐
│ Developer Laptop│ ───────────────────> │ GitHub / GitLab Repo │
└─────────────────┘                      └──────────┬───────────┘
                                                    │ Triggers
                                                    ▼
┌─────────────────┐    Pushes Image      ┌──────────────────────┐
│  Container Reg. │ <─────────────────── │ CI/CD Cloud Runner   │
│ (AWS ECR/GHCR)  │                      │(GitHub Actions/Build)│
└────────┬────────┘                      └──────────────────────┘
         │ Pulls Image
         ▼
┌─────────────────┐
│ Target Cloud Host│
│ (AWS ECS / EC2) │
└─────────────────┘
```

1. **Source Control Trigger**: Developers write code locally and push git commits to a shared repository (GitHub, GitLab, Bitbucket).
2. **Automated CI/CD Pipeline**: Cloud build runners (such as **GitHub Actions**, **AWS CodeBuild**, or **Google Cloud Build**) automatically trigger on code push.
3. **Cloud Cross-Building**: The CI/CD runner executes tests and runs `docker buildx build --platform linux/amd64,linux/arm64 --push` in a clean, reproducible cloud environment.
4. **Private Container Registry**: Built images are pushed to a private, secure **Container Registry** (such as **AWS ECR**, **GitHub Container Registry (GHCR)**, or **Google Artifact Registry**).
---

### Key Takeaways

* **Check Architectures**: Apple Silicon Macs use `linux/arm64`; standard cloud VMs use `linux/amd64`.
* **Use `buildx` for Cross-Building**: Use `docker buildx build --platform linux/amd64 --push` when building on Mac for x86 cloud servers.
* **CI/CD Belongs in the Cloud**: Build production images via automated CI/CD runners (GitHub Actions / AWS CodeBuild) rather than local laptops.
* **Use Container Registries**: Store and version images in registries (AWS ECR, Docker Hub, GHCR).

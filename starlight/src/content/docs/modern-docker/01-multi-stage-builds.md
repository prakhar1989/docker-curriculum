---
title: Multi-Stage Builds
---

When you start building applications with languages like Go, Rust, Java, or modern JavaScript frameworks (React, Vue, Next.js), you quickly notice something frustrating: the tools required to **build** your code (compilers, build kits, SDKs, `node_modules` devDependencies) are rarely needed to **run** your application.

If you include all those build tools in your final Docker image, your container image ends up bloated, slow to push/pull, and packed with unnecessary security attack surface.

This is where **Multi-Stage Builds** come to the rescue!

### What are Multi-Stage Builds?

With multi-stage builds, you can use multiple `FROM` statements in a single `Dockerfile`. Each `FROM` instruction begins a new stage of the build using a different base image. Crucially, you can selectively copy artifacts (like compiled binaries or minified frontend bundles) from one stage to another, leaving behind everything you don't need!

```text
┌─────────────────────────────────────────┐
│ Stage 1: Builder (Full SDK / Compilers) │
│ - Installs dependencies & compiles app  │
└────────────────────┬────────────────────┘
                     │ Copy ONLY built binary
                     ▼
┌─────────────────────────────────────────┐
│ Stage 2: Runtime (Minimal Base Image)   │
│ - Ultra-small, secure runtime image     │
└─────────────────────────────────────────┘
```

---

### A Practical Example: Go App

Let's look at a classic example of a compiled Go application. Without multi-stage builds, a single-stage Dockerfile might look like this:

```dockerfile
# Single-Stage Dockerfile (Heavy ~800MB Image)
FROM golang:1.22

WORKDIR /app
COPY . .
RUN go build -o server .

CMD ["./server"]
```

Because the `golang` image contains the full Go compiler and toolchain, the resulting image is nearly **800 MB** for a simple 10MB app!

Now, let's rewrite it using a **Multi-Stage Build**:

```dockerfile
# Stage 1: Build Stage
FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o server .

# Stage 2: Production Stage
FROM alpine:3.19

WORKDIR /app
# Copy only the compiled binary from the builder stage
COPY --from=builder /app/server .

EXPOSE 8080
CMD ["./server"]
```

Let's break down what's happening here:
1. `FROM golang:1.22-alpine AS builder`: Names the first stage `builder`. This image has the full Go compiler needed to build the binary.
2. `COPY --from=builder /app/server .`: In the second stage (`alpine:3.19`), we copy **only** the compiled `server` binary from the `builder` stage.

The result? The final container image drops from **~800 MB to less than 15 MB**!

---

### Try It Yourself: Hands-On Walkthrough

Let's build a tiny HTTP web server on your machine so you can see multi-stage builds in action!

#### Step 1: Create a Project Directory

Open your terminal and create a folder for this walkthrough:

```bash
$ mkdir multistage-demo && cd multistage-demo
```

#### Step 2: Write a Simple Web Server (`main.go`)

Create a file named `main.go` and paste the following code:

```go
package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Hello from a multi-stage Docker container!")
	})
	fmt.Println("Server running on port 8080...")
	http.ListenAndServe(":8080", nil)
}
```

#### Step 3: Create the Multi-Stage `Dockerfile`

Create a `Dockerfile` in the same directory:

```dockerfile
# Stage 1: Build the Go binary
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go

# Stage 2: Create lightweight production image
FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/server .
EXPOSE 8080
CMD ["./server"]
```

#### Step 4: Build the Image

Run `docker build` to compile the app and construct your multi-stage image:

```bash
$ docker build -t multistage-demo .
[+] Building 3.2s (10/10) FINISHED
 => [1/4] FROM docker.io/library/golang:1.22-alpine AS builder
 => [2/4] COPY main.go .
 => [3/4] RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go
 => [4/4] COPY --from=builder /app/server .
 => naming to docker.io/library/multistage-demo
```

#### Step 5: Check the Image Size!

Now list your local Docker images to verify the image size:

```bash
$ docker image ls multistage-demo
REPOSITORY         TAG       IMAGE ID       CREATED         SIZE
multistage-demo   latest    a1b2c3d4e5f6   15 seconds ago  14.2MB
```

Notice the size: **only 14.2 MB**! You built a fully functional web server container that takes up less disk space than a single high-resolution photo.

#### Step 6: Run the Container

Test your lightweight container:

```bash
$ docker run -d -p 8080:8080 multistage-demo
```

Open `http://localhost:8080` in your browser, or test it with `curl`:

```bash
$ curl http://localhost:8080
Hello from a multi-stage Docker container!
```

Clean up when you're done testing:

```bash
$ docker stop $(docker ps -q --filter ancestor=multistage-demo)
```

---

### Multi-Stage Builds for Node.js / React Frontend Apps

Multi-stage builds are equally powerful for frontend web applications. Consider a React or Next.js app where `npm run build` compiles your JSX into static HTML/JS/CSS files:

```dockerfile
# Stage 1: Build static assets
FROM node:20-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Serve static assets with Nginx
FROM nginx:alpine
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Notice how Node.js and `node_modules` are completely left behind in Stage 1! The production container contains only high-performance Nginx and the static assets.

---

### Key Takeaways

* **Dramatically Smaller Images**: Faster deployment, quicker `docker push`/`docker pull` cycles, and reduced storage costs.
* **Better Security**: Fewer installed build tools mean fewer potential vulnerabilities (CVEs) in production containers.
* **Single Dockerfile**: No need to maintain separate build scripts or intermediary container cleanup tasks.

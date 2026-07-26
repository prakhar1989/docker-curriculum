---
title: Development with Compose Watch
---

In the earlier Docker Compose section, we used volume mounts (`volumes: - ./app:/usr/src/app`) to map source code from your computer into running containers for live development.

While volume mounts work for simple scripts, they have known limitations:
* File-sync performance on macOS and Windows can lag with large projects (e.g. big `node_modules` or vendor folders).
* Files added or removed locally don't automatically trigger dependency installs or container rebuilds.
* File permissions between host OS and container users often clash.

To solve this, Docker Compose V2 introduced **Compose Watch**.

### What is `docker compose watch`?

Compose Watch automatically monitors your local project directory for file changes and syncs them intelligently into your running service containers. Depending on the type of file changed, Compose Watch can either:

1. **`sync`**: Instantly copy updated source files into the container (great for Python, JavaScript, CSS, HTML).
2. **`rebuild`**: Automatically rebuild and restart the container service when configuration files change (e.g. `requirements.txt` or `package.json`).
3. **`sync+restart`**: Copy files into the container and restart the application process.

### Configuring Compose Watch

To enable Compose Watch, add a `develop` block to your service definition in `docker-compose.yml`:

```yaml
services:
  web:
    build: .
    ports:
      - "5000:5000"
    develop:
      watch:
        # Sync Python source code edits instantly
        - path: .
          target: /usr/src/app
          action: sync
          ignore:
            - __pycache__/
            - .git/

        # Automatically rebuild service if requirements.txt changes
        - path: ./requirements.txt
          action: rebuild
```

### Running Compose Watch

Launch your application with the `--watch` flag:

```bash
$ docker compose up --watch
```

Output:

```text
[+] Running 2/2
 ✔ Container es   Running
 ✔ Container web  Running
Watch enabled for service "web"
```

Now, whenever you edit a Python file inside your text editor, Docker Compose instantly syncs the updated file into the container in milliseconds. If you add a new package to `requirements.txt`, Compose automatically rebuilds the service image for you!

Compose Watch makes local development inside Docker containers feel as fast as running software directly on your host machine.

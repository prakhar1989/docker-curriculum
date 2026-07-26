---
title: Setting up your computer
---

Getting all the tooling setup on your computer can be a daunting task, but thankfully getting Docker up and running on your favorite OS is straightforward with [Docker Desktop](https://www.docker.com/products/docker-desktop/).

The _getting started_ guide on Docker has detailed instructions for setting up Docker on [Mac](https://docs.docker.com/desktop/install/mac-install/), [Linux](https://docs.docker.com/desktop/install/linux-install/) and [Windows](https://docs.docker.com/desktop/install/windows-install/).

> **Windows Note:** Docker Desktop on Windows uses **WSL 2** (Windows Subsystem for Linux 2) as its default backend, providing full Linux kernel compatibility and near-native speed. Ensure WSL 2 is enabled during installation.
>
> **Mac Note:** In addition to [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/), macOS users can also use **[OrbStack](https://orbstack.dev/)** — a fast, lightweight alternative to Docker Desktop that starts in seconds and uses minimal CPU and battery. You can install it via Homebrew:
> ```bash
> brew install --cask orbstack
> ```
> Both Docker Desktop and OrbStack provide the standard `docker` CLI and `docker compose` out of the box.

Once you are done installing Docker, test your Docker installation by running the following in your terminal:

```bash
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

---

## Instant Setup with Devcontainers & GitHub Codespaces

If you prefer not to configure your local development tools manually, you can launch an instant cloud development environment via **GitHub Codespaces**, powered by the repository's `.devcontainer` configuration.

> **Zero Local Setup:** Does **not** require Docker, Node.js, Python, or any developer tools installed on your computer.

1. Open the [docker-curriculum repository on GitHub](https://github.com/prakhar1989/docker-curriculum).
2. Click the green **Code** button, select the **Codespaces** tab, and click **Create codespace on main**.
3. A full browser-based IDE will launch directly in your browser with Docker and Node pre-configured.

> **Note:** On initial creation, GitHub Codespaces may take a few minutes to build the container environment, start the Docker daemon, and finish installing dependencies.

![GitHub Codespaces setup](/codespaces.png)
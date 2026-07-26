---
title: Docker Compose
---

Till now we've spent all our time exploring the single-container Docker client. In the Docker ecosystem, however, there are powerful orchestration tools which play very nicely with Docker:

1. [Docker Compose](https://docs.docker.com/compose/) — A tool for defining and running multi-container Docker applications.
2. [Kubernetes](https://kubernetes.io) — An open-source system for automating deployment, scaling, and management of containerized applications.
3. [Docker Swarm](https://docs.docker.com/engine/swarm/) — Native clustering for Docker.

In this section, we are going to look at Docker Compose, and see how it can make dealing with multi-container apps easy.

### What is Docker Compose?

Compose is a tool that is used for defining and running multi-container Docker apps. It uses a YAML configuration file called `docker-compose.yml` to configure your application's services. Then, with a single command, you create and start all the services from your configuration. Compose works in all environments: production, staging, development, testing, as well as CI workflows.

Let's see how we can create a `docker-compose.yml` file for our SF-Foodtrucks app and evaluate whether Docker Compose lives up to its promise.

### Installation

If you are using Docker Desktop (Mac, Windows, or Linux), **Docker Compose V2** is already included out of the box as a subcommand plugin (`docker compose`).

You can verify your installation by checking the version:

```bash
$ docker compose version
Docker Compose version v2.27.0
```

> **Note on V1 vs V2:** Earlier versions of Docker Compose used a separate hyphenated command (`docker-compose`). Docker officially retired V1 in 2023. Today, Compose is invoked directly via `docker compose` with a space.

### The `docker-compose.yml` File

Now that we have Docker Compose ready, let's look at the `docker-compose.yml` file:

```yaml
services:
  es:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.18
    container_name: es
    environment:
      - discovery.type=single-node
    ports:
      - 9200:9200
    volumes:
      - esdata1:/usr/share/elasticsearch/data
  web:
    image: prakhar1989/foodtrucks-web
    command: python3 app.py
    depends_on:
      - es
    ports:
      - 5000:5000
    volumes:
      - ./flask-app:/opt/flask-app
volumes:
  esdata1:
    driver: local
```

Let's breakdown what this file means:
- At the top level, under `services:`, we define the names of our services: `es` and `web`.
- For each service, `image` specifies the Docker image to use. For `es`, we use the official Elasticsearch image. For `web`, we use our Flask app image.
- `ports` maps container ports to host ports.
- `depends_on` tells Docker to start the `es` container before starting `web`.
- `volumes` defines persistent data mounts so data survives container restarts.

> **Note:** The top-level `version: "3"` schema attribute used in older tutorials is now deprecated in the modern [Compose Specification](https://docs.docker.com/compose/compose-file/) and can be safely omitted.

### Running Docker Compose

Make sure any existing standalone containers are stopped before launching:

```bash
$ docker stop es foodtrucks-web
$ docker rm es foodtrucks-web
```

Now, navigate to the directory containing your `docker-compose.yml` file and run:

```bash
$ docker compose up
[+] Running 3/3
 ✔ Network foodtrucks_default  Created
 ✔ Container es                Created
 ✔ Container foodtrucks-web-1  Created
Attaching to es, foodtrucks-web-1
```

Head over to `http://localhost:5000` to see your app live! With just one command, Docker Compose created a private network (`foodtrucks_default`), initialized both containers, attached their logging outputs, and wired up DNS service discovery between them.

To run the services in the background (detached mode):

```bash
$ docker compose up -d
[+] Running 2/2
 ✔ Container es                Started
 ✔ Container foodtrucks-web-1  Started
```

You can inspect running services with:

```bash
$ docker compose ps
NAME                IMAGE                                                   COMMAND                  SERVICE             CREATED             STATUS              PORTS
es                  docker.elastic.co/elasticsearch/elasticsearch:7.17.18   "/bin/tini -- /usr/l…"   es                  2 minutes ago       Up 2 minutes        0.0.0.0:9200->9200/tcp
foodtrucks-web-1    prakhar1989/foodtrucks-web                              "python3 app.py"         web                 2 minutes ago       Up 2 minutes        0.0.0.0:5000->5000/tcp
```

To stop and remove all containers, networks, and volumes created by Compose:

```bash
$ docker compose down -v
[+] Running 3/3
 ✔ Container foodtrucks-web-1  Removed
 ✔ Container es                Removed
 ✔ Network foodtrucks_default  Removed
 ✔ Volume foodtrucks_esdata1   Removed
```

Congratulations! You have successfully configured and managed a multi-container environment using Docker Compose.

---
title: Playing With Busybox
---

Now that we have everything setup, it's time to get our hands dirty. In this section, we are going to run a [Busybox](https://en.wikipedia.org/wiki/BusyBox) container on our system and get a taste of the `docker run` command.

To get started, let's run the following in our terminal:

```bash
$ docker pull busybox
```

> Note: Depending on how you've installed docker on your system, you might see a `permission denied` error after running the above command. If you're on a Mac, make sure the Docker engine is running. If you're on Linux, then prefix your `docker` commands with `sudo`. Alternatively, you can [create a docker group](https://docs.docker.com/engine/installation/linux/linux-postinstall/) to get rid of this issue.

The `pull` command fetches the busybox [**image**](https://hub.docker.com/_/busybox/) from the [**Docker registry**](https://hub.docker.com/explore/) and saves it to our system. You can use the `docker images` command to see a list of all images on your system.

```bash
$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
busybox                 latest              c51f86c28340        4 weeks ago         1.109 MB
```
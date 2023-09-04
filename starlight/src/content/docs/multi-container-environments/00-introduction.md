---
title: Introduction
---

In the last section, we saw how easy and fun it is to run applications with Docker. We started with a simple static website and then tried a Flask app. Both of which we could run locally and in the cloud with just a few commands. One thing both these apps had in common was that they were running in a **single container**.

Those of you who have experience running services in production know that usually apps nowadays are not that simple. There's almost always a database (or any other kind of persistent storage) involved. Systems such as [Redis](http://redis.io/) and [Memcached](http://memcached.org/) have become _de rigueur_ of most web application architectures. Hence, in this section we are going to spend some time learning how to Dockerize applications which rely on different services to run.

In particular, we are going to see how we can run and manage **multi-container** docker environments. Why multi-container you might ask? Well, one of the key points of Docker is the way it provides isolation. The idea of bundling a process with its dependencies in a sandbox (called containers) is what makes this so powerful.

Just like it's a good strategy to decouple your application tiers, it is wise to keep containers for each of the **services** separate. Each tier is likely to have different resource needs and those needs might grow at different rates. By separating the tiers into different containers, we can compose each tier using the most appropriate instance type based on different resource needs. This also plays in very well with the whole [microservices](http://martinfowler.com/articles/microservices.html) movement which is one of the main reasons why Docker (or any other container technology) is at the [forefront](https://medium.com/aws-activate-startup-blog/using-containers-to-build-a-microservices-architecture-6e1b8bacb7d1#.xl3wryr5z) of modern microservices architectures.

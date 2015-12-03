<a id="top"></a>
<img src="https://raw.githubusercontent.com/prakhar1989/docker-curriculum/master/images/logo.png" alt="docker logo">

*Build and deploy your distributed applications easily to the cloud with Docker*

Written and developed by [Prakhar Srivastav](http://prakhar.me) and [ADI](https://adicu.com/).

<a href="#top" class="top" id="getting-started">Top</a>

## Getting Started: FAQs

### What is Docker?
Wikipedia defines [Docker](https://www.docker.com/) as 

> an open-source project that automates the deployment of software applications inside **containers** by providing an additional layer of abstraction and automation of **OS-level virtualization** on Linux.

Wow! That's a mouthful. In simpler words, Docker is a tool that allows developers, sys-admins etc. to easily deploy their applications in a sandbox (called *containers*) to run on the host operating system i.e. Linux. The key benefit of Docker is that it allows users to **package an application with all of its dependencies into a standardized unit** for software development. Unlike virtual machines, containers do not have the high overhead and hence enable more efficient usage of the underlying system and resources.


### What are containers?

The industry standard today is to use Virtual Machines (VMs) to run software applications. VMs run applications inside a guest Operating System, which runs on virtual hardware powered by the server’s host OS.

VMs are great at providing full process isolation for applications: there are very few ways a problem in the host operating system can affect the software running in the guest operating system, and vice-versa. But this isolation comes at great cost — the computational overhead spent virtualizing hardware for a guest OS to use is substantial.

Containers take a different approach: by leveraging the low-level mechanics of the host operating system, containers provide most of the isolation of virtual machines at a fraction of the computing power.


### Why should I use it?

As developers, we are cognizant of the power we hold in our hands - the ability to build apps to share with the entire world is very empowering. However, one key aspect of that realization involves deploying our application either on the cloud, a datacenter or even a single server. Given that apps today involve so many components - an application server, a database, a caching layer etc. deploying and managing these architectures is extremely complex.

<img src="https://raw.githubusercontent.com/prakhar1989/docker-curriculum/master/images/interest.png" title="interest">

By standardizing an application and its dependencies into a container, Docker enables us to build, test and release our apps quickly and easily. Due to its benefits of efficiency and portability, Docker has been gaining mindshare rapidly is now leading the **Containerization** movement. As a developer going out into the world, it is important that we understand this trend and see how we can benefit from it.

### What will this tutorial teach me?
This tutorial will give you a hands-on experience with deploying a docker container on the public cloud (AWS). It will demystify the docker landscape, clarify the differences between images and containers and finally, deploy a RESTful API written in node.js on the cloud.

## Using this Document

### Running the Sample Code

You can find sample code on [GitHub][github]

<a href="#top" class="top" id="table-of-contents">Top</a>
## Table of Contents

-	[1.0 Section](#section)
	-	[1.1 Subsection](#subsection)
-	[2.0 Another Section](#another-section)
	-	[2.1 Another Subsection](#another-subsection)
-   [Additional Resources](#additionalresources)


------------------------------
<a href="#top" class="top" id="section">Top</a>
## 1.0 Section


<a id="subsection"></a>
### 1.1 Subsection

___________
<a href="#top" class="top" id="another-section">Top</a>
## 2.0 Another Section

<a id="another-subsection"></a>
### 2.1 Another Subsection

___________
<a href="#top" class="top" id="additionalresources">Top</a>
## Additional Resources

Along with this tutorial, there is a wealth of information available on Python all across the web. Below are some good places to start:

- [ADI Resources][learn]
- [Codecademy][codecademy]



[github]: https://github.com/prakhar1989/docker-curriculum
[learn]: http://adicu.com/learn
[codecademy]: http://www.codecademy.com
[adi]: http://adicu.com
 
## References
- [What containers can do for you](http://radar.oreilly.com/2015/01/what-containers-can-do-for-you.html)
- [What is docker](https://www.docker.com/what-docker)

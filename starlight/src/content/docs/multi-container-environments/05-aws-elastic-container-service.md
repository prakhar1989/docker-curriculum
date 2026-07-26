---
title: AWS ECS & Copilot CLI
---

In the last section we used `docker compose` to run our app locally with a single command: `docker compose up`. Now that we have a functioning multi-container app, let's explore how to deploy containerized applications to production on AWS.

AWS provides multiple modern options for running containers:

1. **[AWS App Runner](https://aws.amazon.com/apprunner/)** — Fully managed service for building and running containerized web applications directly from source or image repositories.
2. **[AWS Elastic Container Service (ECS) with Fargate](https://aws.amazon.com/ecs/)** — Serverless compute for containers that provisions and scales Amazon ECS tasks automatically without needing EC2 instances.
3. **[AWS Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/)** — Managed Kubernetes on AWS.

In this section, we will look at **AWS Elastic Container Service (ECS)** running on **AWS Fargate**, using AWS's official developer tool: **AWS Copilot CLI**.

### What is AWS Copilot?

[AWS Copilot CLI](https://aws.amazon.com/containers/copilot/) is the modern, official CLI for building, releasing, and operating production-ready containerized apps on AWS App Runner and AWS ECS Fargate. It automates setting up infrastructure like VPCs, load balancers, security groups, and ECS services using best-practice architecture.

> **Note on `ecs-cli`:** Earlier versions of AWS tutorials recommended `ecs-cli`. AWS has officially deprecated `ecs-cli` in favor of AWS Copilot.

### Installing AWS Copilot

Install the AWS Copilot CLI following the [official guide](https://aws.amazon.com/containers/copilot/):

* **Mac (Homebrew):** `brew install aws/tap/copilot-cli`
* **Linux:** Download the binary from AWS GitHub releases:
  ```bash
  curl -Lo copilot https://github.com/aws/copilot-cli/releases/latest/download/copilot-linux
  chmod +x copilot
  sudo mv copilot /usr/local/bin/copilot
  ```

Verify installation:

```bash
$ copilot --version
copilot version: v1.34.0
```

### Deploying with Copilot

Ensure you have your AWS CLI configured with active credentials (`aws configure`).

#### 1. Initialize Your Application

Inside your project directory containing your Dockerfile, initialize Copilot:

```bash
$ copilot init
```

Copilot will guide you through an interactive prompt:
- **Application name:** `foodtrucks`
- **Workload type:** `Load Balanced Web Service`
- **Service name:** `web`
- **Dockerfile:** `./Dockerfile` or `./flask-app/Dockerfile`

Copilot creates an infrastructure blueprint in a `copilot/` directory and sets up your build pipeline.

#### 2. Deploy to Environment

To launch your service on AWS Fargate:

```bash
$ copilot deploy
```

AWS Copilot will:
1. Build your Docker container image locally.
2. Push your image to Amazon ECR (Elastic Container Registry).
3. Provision an AWS Fargate cluster, VPC, subnets, and Application Load Balancer.
4. Deploy your container and return a public HTTPS URL.

```bash
✔ Deployed service web
Recommended follow-up actions:
  - View service status: copilot svc status
  - Access your service at: http://foodtrucks-publi-123456789.us-east-1.elb.amazonaws.com
```

### Monitoring & Status

Inspect running containers and view CloudWatch logs straight from your terminal:

```bash
# View service status and health
$ copilot svc status

# Stream container logs live
$ copilot svc logs --follow
```

### Cleanup

When you're finished testing your application, tear down all AWS resources and infrastructure to prevent ongoing charges:

```bash
$ copilot app delete --yes
✔ Deleted service web from environment test
✔ Deleted environment test from application foodtrucks
✔ Deleted application foodtrucks
```

AWS Copilot makes running production containerized applications on AWS simple, secure, and fully automated!

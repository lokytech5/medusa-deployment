# Medusa on AWS with Terraform

Production-style Medusa deployment on AWS using Terraform, ECS Fargate, RDS PostgreSQL, Redis, ALB, ACM, and Route 53.

This project documents my journey of taking a Medusa starter application and deploying it into a structured AWS environment with reusable Terraform, private/public networking, HTTPS, and operational building blocks.

---

## Project Objective

The goal of this project is to build a repeatable cloud infrastructure foundation for a containerized Medusa application and progressively move it toward a more production-shaped deployment.

This project focuses on:

- AWS infrastructure design
- Terraform infrastructure as code
- ECS Fargate deployment
- PostgreSQL and Redis integration
- HTTPS with ACM and ALB
- Route 53 DNS routing
- reusable Terraform modules
- deployment workflow and operational readiness

---

## Current Architecture

The application is deployed on AWS with the following core components:

- **VPC**
- **Public and private subnets across 2 AZs**
- **Internet Gateway**
- **NAT Gateway**
- **Route tables and associations**
- **Security groups**
- **ECR** for container images
- **ECS Fargate** for application runtime
- **Application Load Balancer**
- **RDS PostgreSQL**
- **ElastiCache Redis**
- **CloudWatch logs**
- **ACM certificate**
- **Route 53 hosted zone and DNS record**

Traffic flow is structured as follows:

1. User accesses the Medusa app through the public domain
2. Route 53 resolves the domain to the ALB
3. ACM provides TLS certificate for HTTPS
4. ALB forwards traffic to ECS tasks
5. ECS tasks run Medusa in private subnets
6. Medusa connects privately to RDS PostgreSQL and Redis

---

## What Has Been Completed

### Module 2 — AWS Infrastructure Foundation
Built the AWS networking and runtime foundation:

- VPC
- public/private subnets
- internet gateway
- NAT gateway
- route tables
- security groups
- ECR
- ECS cluster
- CloudWatch log group
- IAM roles
- ALB
- ECS task definition
- ECS service

### Module 3 — Application Dependency Completion
Completed the missing dependency and runtime alignment:

- RDS PostgreSQL
- ECS-to-database connectivity
- Medusa production build/runtime correction
- startup script correction
- `/health` health check alignment
- successful Admin access behind ALB

### Module 4 — Production Runtime Hardening
Added important production-style pieces:

- Redis with ElastiCache
- HTTPS listener with ACM
- Route 53 DNS
- working secure domain access
- verified Medusa Admin login over HTTPS

### Terraform Refactoring Progress
Started refactoring the infrastructure into reusable Terraform modules.

Completed so far:

- networking moved into a reusable Terraform module
- clearer separation between root configuration and module logic
- improved understanding of how to scale Terraform structure for future projects

---

## Tech Stack

### Application
- Medusa v2
- Node.js
- PostgreSQL
- Redis

### AWS
- VPC
- ECS Fargate
- ECR
- RDS PostgreSQL
- ElastiCache Redis
- Application Load Balancer
- ACM
- Route 53
- CloudWatch
- IAM

### Infrastructure as Code
- Terraform

---

## Repository Purpose

This repository is not just an application repository.

It is also a hands-on infrastructure learning project that demonstrates:

- how AWS services connect together in practice
- how containerized applications are deployed on AWS
- how Terraform can evolve from single files to reusable modules
- how to think about repeatability, deployment workflow, observability, and production readiness

---

## Deployment Status

At this stage, the Medusa application has been successfully deployed and tested behind:

- **ALB**
- **HTTPS**
- **custom domain**
- **RDS PostgreSQL**
- **Redis**

The Admin application loads successfully, authentication works, and the runtime path has been validated through CloudWatch logs and browser testing.

---

## Domain

Application domain:

- `https://plugfolio.cloud`
- Medusa Admin available at `/app`

---

## Project Structure

Example high-level structure:

```bash
.
├── .github/
│   └── workflows/
├── modules/
│   └── networking/
├── *.tf
├── Dockerfile
├── medusa-config.ts
├── package.json
└── README.md
```

### Infrastructure Notes

A key part of this project is learning how infrastructure pieces relate to each other.

Important design choices include:

- ALB stays public
- ECS tasks stay private
- database stays private
- Redis stays private
- Redis stays private
- NAT is used for outbound access from private workloads
- ALB handles external traffic routing
- ACM handles TLS certificates
- Route 53 handles DNS
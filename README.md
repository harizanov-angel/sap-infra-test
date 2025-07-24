# SAP Technical Interview Task - SOLUTION

## Descisions
- Git Repo - **GitHub**
- Cloud provider - **AWS**
- IaS tool - **Terraform**
- Load Balancer - **AWS ALB**
- Web server - **AWS ECS Fargate**
- Docker image repo - **AWS ECR**
- Database - **AWS RDS**
- Fail-over - **Provided by ECS**
- Scripting language - **Bash**

## Fail-over
ECS provides automatic failover out of the box in several ways, which helps ensure high availability and resilience for the services.
- Task Replacement - ECS will replace failing tasks automatically to maintain the desired number of tasks up to a maximum limit.
- Health checks - The ELB which is in front of ECS requires health checks, which the app should provide.
- Service Placement - ECS will place tasks in different Availability Zones to ensure high availability.

## Extras
- Stress test - a Bash script to increase CPU usage to demonstrate scalability

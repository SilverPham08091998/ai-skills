# aws/vpc.md — AWS VPC Standard

## Objective

Design AWS VPC foundation for EKS, RDS, Redis, MSK, Kong, and platform services.

## When To Use

- Creating VPC Terraform module
- Reviewing AWS network design
- Preparing EKS networking
- Designing public/private/database subnets

## Scope

- VPC CIDR
- Public subnets
- Private app subnets
- Private database subnets
- Internet Gateway
- NAT Gateway
- Route tables
- Security groups
- VPC endpoints
- Kubernetes subnet tags

## Core Rules

1. EKS worker nodes must run in private subnets.
2. RDS, Redis, and MSK must run in private subnets.
3. Public subnets are for load balancers and NAT gateways.
4. Use at least 2 AZs for non-prod and 3 AZs for production if budget allows.
5. Enable DNS hostnames and DNS support.

## Security Rules

1. Never expose database/cache/message broker subnets publicly.
2. Avoid broad 0.0.0.0/0 ingress rules.
3. Use security group references when possible.
4. Restrict VPC endpoint policies for sensitive services.

## Anti-patterns

- Putting EKS nodes in public subnets.
- Opening PostgreSQL/Redis/Kafka ports to the internet.
- Using one flat subnet layer for all resources.
- Missing Kubernetes subnet tags for load balancers.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Terraform VPC module
2. Subnet outputs for EKS/RDS/Redis/MSK
3. Security group baseline
4. NAT/IGW routing
5. Validation commands

## Review Checklist

- [ ] Terraform VPC module
- [ ] Subnet outputs for EKS/RDS/Redis/MSK
- [ ] Security group baseline
- [ ] NAT/IGW routing
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/aws/vpc.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/aws/vpc.md`.

Task:
<describe what you want to create or review>

Context:
- Project: <project-name>
- Environment: <dev|staging|prod>
- Runtime: <runtime>
- Dependencies: <aws/kubernetes/platform dependencies>

Requirements:
- Follow production-grade defaults
- Include security considerations
- Include validation commands
- Include rollback notes where applicable
```

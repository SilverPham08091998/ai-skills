# aws/eks.md — Amazon EKS Standard

## Objective

Define production-grade Amazon EKS cluster provisioning and operation standards.

## When To Use

- Creating new EKS cluster
- Reviewing EKS Terraform module
- Designing node groups
- Configuring IRSA
- Installing EKS add-ons
- Preparing Kubernetes platform

## Scope

- EKS cluster
- Managed node groups or Karpenter
- OIDC provider
- IRSA
- AWS Load Balancer Controller
- EBS CSI Driver
- Metrics Server
- External Secrets Operator
- Cert Manager
- ArgoCD
- Istio
- Kong

## Core Rules

1. Worker nodes must be placed in private subnets.
2. Enable OIDC provider for IRSA.
3. Use managed node groups for baseline stability.
4. Use Karpenter only after platform baseline is stable.
5. Separate system, app, and observability node groups when needed.
6. Enable audit logs for production.
7. Restrict cluster endpoint access for production.

## Security Rules

1. Avoid node IAM role with broad permissions.
2. Use RBAC least privilege.
3. Separate CI/CD deployment role from human admin role.
4. Do not expose Kubernetes API publicly to the world in production.

## Anti-patterns

- Placing worker nodes in public subnets.
- Giving AdministratorAccess to node IAM role.
- Skipping OIDC provider.
- Installing production add-ons manually without GitOps.
- Deploying business services before platform baseline is ready.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. EKS Terraform configuration
2. Managed node groups
3. OIDC provider
4. IRSA examples
5. EKS add-ons
6. Security groups
7. Outputs for Kubernetes/Helm providers
8. Validation commands

## Review Checklist

- [ ] EKS Terraform configuration
- [ ] Managed node groups
- [ ] OIDC provider
- [ ] IRSA examples
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/aws/eks.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/aws/eks.md`.

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

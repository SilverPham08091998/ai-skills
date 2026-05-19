# aws/iam.md — AWS IAM Standard

## Objective

Define IAM rules for AWS infrastructure, CI/CD, and Kubernetes workloads.

## When To Use

- Creating IAM Terraform module
- Configuring IRSA
- Reviewing AWS permissions
- Creating Jenkins deployment role

## Scope

- IAM roles
- IAM policies
- Trust policies
- IRSA
- CI/CD roles
- Human access roles
- Permission boundaries

## Core Rules

1. Prefer IAM roles over long-lived access keys.
2. Use IRSA for EKS workloads.
3. Create separate role per service and environment.
4. Apply least privilege.
5. Separate human admin access from CI/CD access.
6. Require approval for production permissions.

## Security Rules

1. Avoid wildcard resources unless justified.
2. Do not attach AdministratorAccess to application workloads.
3. Use scoped trust policies.
4. Rotate and remove unused credentials.

## Anti-patterns

- One shared IAM role for all services.
- Static AWS keys in Jenkins or Git.
- Overly broad sts:AssumeRole trust.
- Wildcard actions and resources without reason.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. IAM roles and policies
2. Trust policy
3. IRSA service account annotation
4. Security review notes
5. Validation commands

## Review Checklist

- [ ] IAM roles and policies
- [ ] Trust policy
- [ ] IRSA service account annotation
- [ ] Security review notes
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/aws/iam.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/aws/iam.md`.

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

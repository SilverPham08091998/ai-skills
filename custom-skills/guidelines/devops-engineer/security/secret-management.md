# security/secret-management.md — Secret Management Security Standard

## Objective

Define secure handling of secrets across AWS, Kubernetes, Helm, and CI/CD.

## When To Use

- Designing secret flow
- Reviewing Helm values
- Creating ExternalSecret
- Securing CI/CD credentials

## Scope

- AWS Secrets Manager
- SSM Parameter Store
- External Secrets Operator
- Kubernetes Secret
- IRSA
- Rotation

## Core Rules

1. No secret in Git.
2. No secret in Docker image.
3. No secret in plain Helm values.
4. Use AWS Secrets Manager or SSM.
5. Use External Secrets Operator for Kubernetes.
6. Use IRSA to read only required secrets.
7. Rotate production secrets.

## Security Rules

1. Mask secrets in logs.
2. Limit who can read production secrets.
3. Avoid storing secrets in Terraform state outputs.

## Anti-patterns

- Plaintext passwords in Git.
- kubectl create secret manually for prod.
- Shared secret role for all apps.
- Secret printed in pipeline logs.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Secret flow design
2. ExternalSecret manifest
3. IAM policy
4. Rotation checklist

## Review Checklist

- [ ] Secret flow design
- [ ] ExternalSecret manifest
- [ ] IAM policy
- [ ] Rotation checklist
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/security/secret-management.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/security/secret-management.md`.

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

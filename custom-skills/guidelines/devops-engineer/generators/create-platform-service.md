# generators/create-platform-service.md — Generator — Create Platform Service Package

## Objective

Generate full DevOps deployment package for a new service.

## When To Use

- Onboarding new Spring Boot service
- Creating full K8s/Helm/GitOps package
- Preparing service for EKS platform

## Scope

- Helm values
- Deployment
- Service
- HPA
- PDB
- ServiceAccount
- ExternalSecret
- NetworkPolicy
- Istio
- ServiceMonitor
- ArgoCD

## Core Rules

1. Load all relevant Kubernetes, Helm, Istio, Observability, Security, GitOps skills.
2. No secret in Git.
3. No latest tag.
4. Include probes/resources/securityContext.
5. Support observability and GitOps.

## Security Rules

1. Use least privilege service account.
2. Use ExternalSecrets.
3. Restrict network policy.
4. Avoid public exposure unless through Kong.

## Anti-patterns

- Only Deployment/Service.
- No HPA/PDB.
- No ExternalSecret.
- No observability.
- No ArgoCD app.
- No rollback steps.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Full service deployment package
2. Validation commands
3. Production checklist
4. Rollback steps

## Review Checklist

- [ ] Full service deployment package
- [ ] Validation commands
- [ ] Production checklist
- [ ] Rollback steps
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/generators/create-platform-service.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/generators/create-platform-service.md`.

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

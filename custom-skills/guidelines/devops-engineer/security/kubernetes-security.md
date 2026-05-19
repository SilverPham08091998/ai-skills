# security/kubernetes-security.md — Kubernetes Security Standard

## Objective

Define Kubernetes workload and cluster security checks.

## When To Use

- Reviewing manifests
- Hardening workloads
- Preparing prod readiness
- Securing namespaces

## Scope

- RBAC
- SecurityContext
- Pod Security
- NetworkPolicy
- Secrets
- Service exposure
- ResourceQuota

## Core Rules

1. Use RBAC least privilege.
2. Use non-root containers.
3. Apply Pod Security Standards.
4. Use NetworkPolicy.
5. Use ResourceQuota and LimitRange.
6. Do not expose NodePort randomly.
7. Restrict cluster-admin.

## Security Rules

1. Protect secrets.
2. Avoid privileged pods.
3. Review service account token usage.
4. Restrict admin access.

## Anti-patterns

- Privileged containers.
- cluster-admin for app.
- No NetworkPolicy.
- Secrets in env without external management.
- NodePort public exposure.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Security review checklist
2. Manifest fixes
3. Validation commands

## Review Checklist

- [ ] Security review checklist
- [ ] Manifest fixes
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/security/kubernetes-security.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/security/kubernetes-security.md`.

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

# kubernetes/deployment-standard.md — Kubernetes Deployment Standard

## Objective

Define production-ready Deployment rules for Spring Boot services.

## When To Use

- Creating Deployment manifest
- Creating Helm deployment template
- Reviewing app rollout config
- Preparing production readiness

## Scope

- Deployment
- Pod labels
- ServiceAccount
- ConfigMap/Secret env
- Probes
- Resources
- SecurityContext
- RollingUpdate

## Core Rules

1. Never use image tag latest.
2. Always define requests and limits.
3. Always define readiness and liveness probes.
4. Use ConfigMap for non-sensitive config.
5. Use Secret/ExternalSecret for sensitive config.
6. Run container as non-root.
7. Use safe RollingUpdate strategy.

## Security Rules

1. Use securityContext with allowPrivilegeEscalation false.
2. Drop Linux capabilities.
3. Prefer read-only root filesystem when possible.
4. Avoid privileged containers.

## Anti-patterns

- No probes.
- No resource limits.
- Running as root.
- Hard-coded secrets.
- Recreate strategy for critical service without reason.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Deployment manifest/template
2. SecurityContext
3. Probes
4. Resources
5. Env references
6. RollingUpdate strategy
7. Validation commands

## Review Checklist

- [ ] Deployment manifest/template
- [ ] SecurityContext
- [ ] Probes
- [ ] Resources
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kubernetes/deployment-standard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kubernetes/deployment-standard.md`.

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

# kubernetes/namespace-standard.md — Kubernetes Namespace Standard

## Objective

Define namespace strategy and baseline controls for EKS workloads.

## When To Use

- Creating platform namespaces
- Separating dev/staging/prod
- Setting Istio injection
- Applying quota/limits

## Scope

- Application namespaces
- Platform namespaces
- Labels
- ResourceQuota
- LimitRange
- NetworkPolicy
- Istio injection

## Core Rules

1. Separate platform components from application workloads.
2. Production must not share namespace with dev/staging.
3. Use labels consistently.
4. Apply ResourceQuota/LimitRange where appropriate.
5. Enable Istio injection only where needed.

## Security Rules

1. Restrict namespace RBAC.
2. Apply NetworkPolicy for sensitive namespaces.
3. Avoid default namespace for real workloads.

## Anti-patterns

- Deploying all workloads to default namespace.
- Mixing prod and dev workloads.
- No quota/limits.
- Uncontrolled sidecar injection.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Namespace manifests
2. Labels
3. Quota/LimitRange
4. Istio injection config
5. Validation commands

## Review Checklist

- [ ] Namespace manifests
- [ ] Labels
- [ ] Quota/LimitRange
- [ ] Istio injection config
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kubernetes/namespace-standard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kubernetes/namespace-standard.md`.

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

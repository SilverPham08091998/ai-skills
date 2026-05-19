# istio/virtual-service.md — Istio VirtualService Standard

## Objective

Define HTTP routing, timeout, retry, and traffic split rules.

## When To Use

- Creating service route
- Adding timeout/retry
- Canary release
- Header routing
- Public or internal routing

## Scope

- Hosts
- Gateways
- HTTP routes
- Timeout
- Retries
- Route weights
- Match rules

## Core Rules

1. Always define timeout.
2. Retry only idempotent/safe operations.
3. Use weighted routing for canary.
4. Host must match Kubernetes service DNS or gateway host.
5. Keep route rules simple and auditable.

## Security Rules

1. Avoid unsafe retries for money movement.
2. Do not mirror state-changing traffic unless guaranteed safe.
3. Validate gateway exposure.

## Anti-patterns

- No timeout.
- Retry attempts too high.
- Canary without metrics.
- Wrong host namespace.
- Routing all traffic to canary by mistake.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. VirtualService manifest
2. Timeout/retry policy
3. Canary weights if requested
4. Validation commands

## Review Checklist

- [ ] VirtualService manifest
- [ ] Timeout/retry policy
- [ ] Canary weights if requested
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/istio/virtual-service.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/istio/virtual-service.md`.

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

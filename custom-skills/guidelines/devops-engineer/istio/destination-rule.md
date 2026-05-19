# istio/destination-rule.md — Istio DestinationRule Standard

## Objective

Define traffic policy, mTLS, connection pool, outlier detection, and subsets.

## When To Use

- Creating mesh traffic policy
- Configuring mTLS
- Adding circuit breaking
- Creating canary subsets

## Scope

- Host
- TLS mode
- Connection pool
- Outlier detection
- Subsets
- Load balancer policy

## Core Rules

1. Use ISTIO_MUTUAL when mTLS is enabled.
2. Configure connection pool for high traffic services.
3. Use outlier detection for unhealthy endpoints.
4. Define subsets for stable/canary deployments.

## Security Rules

1. Avoid disabling TLS in production mesh.
2. Tune outlier detection carefully.
3. Prevent overly aggressive ejection.

## Anti-patterns

- No DestinationRule with STRICT mTLS.
- Wrong host.
- Subsets not matching pod labels.
- Connection pool too small.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. DestinationRule manifest
2. Traffic policy
3. Subsets
4. Validation commands

## Review Checklist

- [ ] DestinationRule manifest
- [ ] Traffic policy
- [ ] Subsets
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/istio/destination-rule.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/istio/destination-rule.md`.

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

# istio/service-mesh.md — Istio Service Mesh Standard

## Objective

Define Istio usage for internal service-to-service traffic.

## When To Use

- Designing internal traffic
- Enabling mTLS
- Configuring retries/timeouts
- Preparing canary routing
- Reviewing mesh readiness

## Scope

- Sidecar injection
- mTLS
- VirtualService
- DestinationRule
- PeerAuthentication
- Telemetry

## Core Rules

1. Internal service traffic should go through Istio sidecar.
2. Enable mTLS for production namespaces.
3. Define timeout explicitly.
4. Retry only safe/idempotent operations.
5. Use DestinationRule for connection pool/outlier detection.

## Security Rules

1. Use STRICT mTLS in production after migration.
2. Do not bypass mesh for sensitive internal calls.
3. Avoid exposing mesh internals publicly.

## Anti-patterns

- Using public gateway for internal service-to-service traffic.
- Retrying non-idempotent payment operations blindly.
- No timeout.
- No mTLS for production.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Istio manifests
2. mTLS policy
3. VirtualService
4. DestinationRule
5. Validation commands

## Review Checklist

- [ ] Istio manifests
- [ ] mTLS policy
- [ ] VirtualService
- [ ] DestinationRule
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/istio/service-mesh.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/istio/service-mesh.md`.

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

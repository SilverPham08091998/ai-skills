# kong/gateway-standard.md — Kong Gateway Standard

## Objective

Define Kong Gateway responsibilities and public API exposure rules.

## When To Use

- Exposing public API
- Configuring API gateway
- Reviewing ingress design
- Adding auth/rate-limit/CORS

## Scope

- Kong service
- Kong route
- Plugins
- Consumers
- Upstream service
- Ingress Controller

## Core Rules

1. External client traffic enters through Kong.
2. Internal service-to-service traffic should not use public gateway.
3. Gateway enforces auth/rate limit/request policies.
4. Gateway propagates correlation ID.
5. Gateway must not contain business logic.

## Security Rules

1. Sanitize identity headers from clients.
2. Protect admin API.
3. Use TLS for public APIs.
4. Apply least exposure for routes.

## Anti-patterns

- Exposing internal services publicly.
- Business logic in gateway plugins.
- No auth on sensitive API.
- No rate limit on public API.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Kong service/route/plugin config
2. Security policy
3. Validation commands

## Review Checklist

- [ ] Kong service/route/plugin config
- [ ] Security policy
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kong/gateway-standard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kong/gateway-standard.md`.

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

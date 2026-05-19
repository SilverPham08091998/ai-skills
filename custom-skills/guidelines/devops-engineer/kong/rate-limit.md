# kong/rate-limit.md — Kong Rate Limit Standard

## Objective

Define API rate limiting strategy for public and sensitive APIs.

## When To Use

- Protecting public APIs
- Securing login/OTP/payment endpoints
- Preventing abuse
- Configuring distributed Kong

## Scope

- Rate limiting plugin
- Consumer-based limit
- IP/client/user key
- Redis-backed policy
- Error response

## Core Rules

1. Public APIs must have rate limit.
2. Sensitive APIs need stricter limits.
3. Login/OTP/payment APIs require abuse protection.
4. Use per consumer/client/user where possible.
5. Use Redis-backed policy for distributed Kong nodes.

## Security Rules

1. Avoid leaking rate limit internals.
2. Use stricter policy for auth and payment endpoints.
3. Monitor rejection spikes.

## Anti-patterns

- No rate limit on public API.
- Global limit too high.
- IP-only limit behind NAT without strategy.
- Local policy in multi-node Kong when consistency required.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Rate limit plugin config
2. Limit recommendation
3. Monitoring notes
4. Validation commands

## Review Checklist

- [ ] Rate limit plugin config
- [ ] Limit recommendation
- [ ] Monitoring notes
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kong/rate-limit.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kong/rate-limit.md`.

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

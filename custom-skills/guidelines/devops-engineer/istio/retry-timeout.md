# istio/retry-timeout.md — Istio Retry Timeout Standard

## Objective

Define safe retry and timeout policies for distributed systems.

## When To Use

- Configuring service call resilience
- Reviewing payment/wallet APIs
- Tuning latency
- Avoiding retry storms

## Scope

- Timeout
- Retry attempts
- Per-try timeout
- Retry conditions
- Idempotency
- Upstream/downstream alignment

## Core Rules

1. Every service call must have timeout.
2. Retry only safe/idempotent operations.
3. Do not retry money mutation blindly.
4. Use idempotency keys for retryable business operations.
5. Timeout must be shorter than upstream client timeout.

## Security Rules

1. Prevent retry storms.
2. Avoid retrying POST/write operations unless business idempotency exists.
3. Set conservative attempts for critical flows.

## Anti-patterns

- No timeout.
- Attempts too high.
- Retrying non-idempotent payment calls.
- Per-try timeout larger than total timeout.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Timeout/retry policy
2. Risk notes
3. Idempotency requirement
4. Validation commands

## Review Checklist

- [ ] Timeout/retry policy
- [ ] Risk notes
- [ ] Idempotency requirement
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/istio/retry-timeout.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/istio/retry-timeout.md`.

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

# observability/logging.md — Logging Standard

## Objective

Define structured logging rules for production services.

## When To Use

- Reviewing logs
- Designing service observability
- Adding trace/correlation IDs
- Masking sensitive data

## Scope

- JSON logs
- traceId
- spanId
- requestId
- correlationId
- errorCode
- latency
- masking

## Core Rules

1. Use structured JSON logs.
2. Include traceId and correlationId.
3. Log business error code.
4. Mask sensitive data.
5. Avoid noisy logs in hot path.

## Security Rules

1. Never log password/token/OTP/PIN/CVV/private key.
2. Avoid logging full request body for sensitive APIs.
3. Control debug logs in prod.

## Anti-patterns

- Plain text unstructured logs.
- Missing traceId.
- Logging Authorization header.
- Excessive logs causing cost explosion.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Logging fields
2. Masking rules
3. Review checklist
4. Example config notes

## Review Checklist

- [ ] Logging fields
- [ ] Masking rules
- [ ] Review checklist
- [ ] Example config notes
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/observability/logging.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/observability/logging.md`.

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

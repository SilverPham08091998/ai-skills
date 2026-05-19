# observability/tracing.md — Distributed Tracing Standard

## Objective

Define OpenTelemetry tracing for gateway, mesh, services, DB, and Kafka.

## When To Use

- Adding tracing
- Debugging distributed flow
- Connecting logs and traces
- Reviewing observability

## Scope

- OpenTelemetry
- Trace propagation
- Kong
- Istio
- Spring Boot
- Kafka
- PostgreSQL
- Jaeger/Tempo

## Core Rules

1. Every external request must create or propagate trace.
2. Trace must pass through gateway, service, DB, Kafka, downstream services.
3. Do not put sensitive data in span attributes.
4. Use traceId in logs.
5. Sampling must be environment-aware.

## Security Rules

1. Avoid tracing payloads with sensitive data.
2. Protect tracing backend.
3. Use sampling to manage cost.

## Anti-patterns

- No trace propagation through Kafka.
- Sensitive attributes in spans.
- No traceId in logs.
- 100% tracing in high-volume prod without cost review.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Tracing setup plan
2. Propagation rules
3. Sampling recommendation
4. Validation commands

## Review Checklist

- [ ] Tracing setup plan
- [ ] Propagation rules
- [ ] Sampling recommendation
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/observability/tracing.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/observability/tracing.md`.

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

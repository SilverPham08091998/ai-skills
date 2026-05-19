# observability/metrics.md — Metrics Standard

## Objective

Define Prometheus metrics requirements for services and platform.

## When To Use

- Adding service metrics
- Creating alerts
- Reviewing production readiness
- Debugging performance

## Scope

- HTTP metrics
- JVM metrics
- DB pool
- Kafka lag
- Redis latency
- Business metrics
- Prometheus endpoint

## Core Rules

1. Every service must expose Prometheus metrics.
2. Metrics names must be meaningful.
3. Avoid high cardinality labels.
4. Alert on symptoms and SLO impact.
5. Include business success/failure metrics for critical flows.

## Security Rules

1. Do not put PII in metric labels.
2. Avoid userId/accountId as labels.
3. Protect metrics endpoints from public exposure.

## Anti-patterns

- No /actuator/prometheus.
- High-cardinality labels.
- Only infrastructure metrics, no business metrics.
- No Kafka lag metric.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Metrics checklist
2. Actuator config notes
3. ServiceMonitor requirement
4. Alert candidates

## Review Checklist

- [ ] Metrics checklist
- [ ] Actuator config notes
- [ ] ServiceMonitor requirement
- [ ] Alert candidates
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/observability/metrics.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/observability/metrics.md`.

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

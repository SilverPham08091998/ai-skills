# observability/grafana-dashboard.md — Grafana Dashboard Standard

## Objective

Define standard dashboards for services and platform components.

## When To Use

- Creating dashboards
- Reviewing service health
- Incident debugging
- Production readiness

## Scope

- Request rate
- Error rate
- Latency p50/p95/p99
- CPU/memory
- Pod restarts
- JVM
- DB pool
- Kafka lag
- Redis
- Business metrics

## Core Rules

1. Dashboard must answer: is service healthy?
2. Dashboard must support incident debugging.
3. Use consistent layout across services.
4. Include environment and service filters.
5. Highlight SLO indicators.

## Security Rules

1. Avoid exposing sensitive labels.
2. Control dashboard permissions.
3. Avoid too many panels with no purpose.

## Anti-patterns

- Dashboard without filters.
- No latency percentile.
- No error rate.
- Only CPU/memory dashboard.
- No business metric.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Dashboard panel list
2. PromQL candidates
3. Layout recommendation
4. Review checklist

## Review Checklist

- [ ] Dashboard panel list
- [ ] PromQL candidates
- [ ] Layout recommendation
- [ ] Review checklist
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/observability/grafana-dashboard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/observability/grafana-dashboard.md`.

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

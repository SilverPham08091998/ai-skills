# kong/observability.md — Kong Observability Standard

## Objective

Define metrics, logs, tracing, and alerting for Kong Gateway.

## When To Use

- Monitoring API gateway
- Creating Grafana dashboard
- Debugging API traffic
- Adding gateway alerts

## Scope

- Prometheus plugin
- Access logs
- Correlation ID
- Latency metrics
- Auth failures
- Rate limit rejections

## Core Rules

1. Enable Prometheus plugin.
2. Propagate correlation ID.
3. Log request metadata but not sensitive data.
4. Create dashboard for gateway traffic.
5. Alert on 5xx, latency, auth/rate-limit anomalies.

## Security Rules

1. Mask tokens and sensitive headers.
2. Protect admin API metrics/logs.
3. Avoid logging full payloads.

## Anti-patterns

- No gateway metrics.
- No correlation ID.
- Logging Authorization header.
- No alert on upstream 5xx.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Kong observability config
2. Dashboard checklist
3. Alert checklist
4. Validation commands

## Review Checklist

- [ ] Kong observability config
- [ ] Dashboard checklist
- [ ] Alert checklist
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kong/observability.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kong/observability.md`.

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

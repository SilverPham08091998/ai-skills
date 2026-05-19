# observability/alerting.md — Alerting Standard

## Objective

Define actionable alerting rules and severity model.

## When To Use

- Creating PrometheusRule
- Reviewing incident readiness
- Mapping SLO alerts
- Reducing alert noise

## Scope

- Availability
- Latency
- Error rate
- Saturation
- Kafka lag
- DB pool
- Redis
- Pod restarts
- Node pressure

## Core Rules

1. Alerts must be actionable.
2. Every critical alert must have runbook link.
3. Avoid alert noise.
4. Use severity levels.
5. Alert on SLO impact and user symptoms.

## Security Rules

1. Do not alert on every transient event.
2. Protect on-call from noise.
3. Include owner/team labels.

## Anti-patterns

- No runbook links.
- Too many noisy warnings.
- Only infrastructure alerts, no user-impact alerts.
- No Kafka lag alert.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Prometheus alert rules
2. Severity labels
3. Runbook annotations
4. Validation commands

## Review Checklist

- [ ] Prometheus alert rules
- [ ] Severity labels
- [ ] Runbook annotations
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/observability/alerting.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/observability/alerting.md`.

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

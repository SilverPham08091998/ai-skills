# observability/architecture-observability.md — Architecture Observability Standard

## Objective

Design logs, metrics, traces, dashboards, and alerts at architecture level.

## When To Use

- Designing production architecture
- Preparing SRE handoff
- Reviewing operability

## Scope

- Logging
- Metrics
- Tracing
- Dashboard
- Alerting
- SLO
- Audit events

## Architecture Rules

1. Observability must cover user journey and infrastructure.
2. Define trace propagation.
3. Define business metrics for critical flows.
4. Every critical alert needs runbook.
5. Use SLO-based alerting where possible.

## Security / Compliance Rules

1. Do not log sensitive data.
2. Protect observability backends.
3. Mask PII in logs/traces.

## Anti-patterns

- No observability section.
- Only CPU/memory metrics.
- No trace propagation.
- No business metrics.

## Expected Output

1. Observability design
2. Signal matrix
3. Dashboard list
4. Alert list

## Review Checklist

- [ ] Observability design
- [ ] Signal matrix
- [ ] Dashboard list
- [ ] Alert list

## Prompt

```text
Use `.sa/observability/architecture-observability.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/observability/architecture-observability.md`.

Task:
<describe the architecture task>

Context:
- Domain:
- Actors:
- Existing systems:
- Constraints:
- NFR:
- Security/compliance concerns:

Output:
- Assumptions
- Architecture/design
- Diagrams if useful
- Trade-offs
- Risks
- Implementation handoff
```

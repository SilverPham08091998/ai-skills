# production/observability-check.md — Observability Check Standard

## Objective

Ensure changes are observable in production.

## When To Use

- Before release
- PR review
- Incident prevention

## Scope

- Logs
- Metrics
- Traces
- Dashboards
- Alerts
- Business events

## Tech Lead Rules

1. Critical flow must have useful logs.
2. Metrics should show rate/error/latency.
3. Trace should connect services.
4. Alerts should be actionable.
5. Business events should be auditable when needed.

## Security / Production Rules

1. Do not log sensitive data.
2. Mask PII.
3. Protect audit logs.

## Anti-patterns

- No logs for failure.
- No metrics.
- No trace propagation.
- No alert for critical failure.

## Expected Output

1. Observability checklist
2. Missing signals
3. Recommended additions

## Review Checklist

- [ ] Observability checklist
- [ ] Missing signals
- [ ] Recommended additions

## Prompt

```text
Use `.techlead/production/observability-check.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/production/observability-check.md`.

Task:
<describe the planning/review/leadership task>

Context:
- Feature/change:
- Existing architecture:
- Team constraints:
- Risk level:
- Deadline:
- Production impact:

Output:
- Assumptions
- Findings or plan
- Risks
- Action items
- Definition of Done
```

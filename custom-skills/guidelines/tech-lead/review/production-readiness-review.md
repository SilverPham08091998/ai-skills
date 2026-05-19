# review/production-readiness-review.md — Production Readiness Review Standard

## Objective

Review whether a change is ready for production.

## When To Use

- Before release
- Go-live checklist
- Reviewing service readiness

## Scope

- Config
- Secrets
- Logs
- Metrics
- Tracing
- Alerts
- Rollback
- Migration
- Runbook
- SLO

## Tech Lead Rules

1. Production release needs observability.
2. Secrets/config must be externalized.
3. Rollback path must exist.
4. DB migration must be safe.
5. Alerts/runbook needed for critical service.
6. Smoke test must be defined.

## Security / Production Rules

1. Block production if critical security or data loss risk exists.
2. Verify audit and masking.

## Anti-patterns

- No rollback.
- No metrics.
- No alert.
- No runbook.
- Unsafe DB migration.

## Expected Output

1. Readiness findings
2. Required fixes
3. Approval status

## Review Checklist

- [ ] Readiness findings
- [ ] Required fixes
- [ ] Approval status

## Prompt

```text
Use `.techlead/review/production-readiness-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/review/production-readiness-review.md`.

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

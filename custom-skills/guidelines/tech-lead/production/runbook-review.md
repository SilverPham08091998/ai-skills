# production/runbook-review.md — Runbook Review Standard

## Objective

Review runbooks for operational usefulness.

## When To Use

- Before release
- On-call readiness
- Incident preparation

## Scope

- Health check
- Logs
- Metrics
- Traces
- Common failures
- Mitigation
- Rollback
- Escalation

## Tech Lead Rules

1. Runbook must be executable by on-call.
2. Commands must be safe and clear.
3. Include dashboard/log links.
4. Include rollback and escalation.
5. Update after incidents.

## Security / Production Rules

1. No secrets in runbook.
2. Mark dangerous commands.
3. Protect production access.

## Anti-patterns

- Runbook only says check logs.
- No commands.
- No escalation.
- No rollback.

## Expected Output

1. Runbook findings
2. Missing sections
3. Fix suggestions

## Review Checklist

- [ ] Runbook findings
- [ ] Missing sections
- [ ] Fix suggestions

## Prompt

```text
Use `.techlead/production/runbook-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/production/runbook-review.md`.

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

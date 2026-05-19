# production/feature-flag.md — Feature Flag Standard

## Objective

Use feature flags for safe rollout, testing, and rollback.

## When To Use

- Risky release
- Canary rollout
- Gradual enablement
- Emergency disable

## Scope

- Flag type
- Targeting
- Default
- Owner
- Expiry
- Monitoring
- Rollback

## Tech Lead Rules

1. Feature flags must have owner and removal plan.
2. Default should be safe.
3. Flag evaluation must be reliable.
4. Monitor behavior after enablement.
5. Do not keep stale flags forever.

## Security / Production Rules

1. Do not expose sensitive targeting data.
2. Protect admin control of flags.

## Anti-patterns

- Permanent stale flag.
- Flag default unsafe.
- No monitoring.
- Business logic unreadable due to flags.

## Expected Output

1. Flag plan
2. Rollout steps
3. Removal task

## Review Checklist

- [ ] Flag plan
- [ ] Rollout steps
- [ ] Removal task

## Prompt

```text
Use `.techlead/production/feature-flag.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/production/feature-flag.md`.

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

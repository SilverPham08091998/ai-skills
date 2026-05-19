# delivery/rollback-plan.md — Rollback Plan Standard

## Objective

Define rollback strategy for code, config, database, and dependency changes.

## When To Use

- Before production release
- Incident mitigation
- PR/release review

## Scope

- Code rollback
- Config rollback
- DB rollback
- Feature flag
- Data correction
- Smoke test

## Tech Lead Rules

1. Rollback should be planned before release.
2. Prefer feature flags for risky changes.
3. DB migrations must be backward compatible.
4. Know previous image/version.
5. Define smoke test after rollback.

## Security / Production Rules

1. Protect data integrity during rollback.
2. Do not reverse financial records destructively.

## Anti-patterns

- Rollback by hope.
- Irreversible migration with no plan.
- No previous artifact.
- No validation after rollback.

## Expected Output

1. Rollback steps
2. Owner
3. Validation
4. Risk notes

## Review Checklist

- [ ] Rollback steps
- [ ] Owner
- [ ] Validation
- [ ] Risk notes

## Prompt

```text
Use `.techlead/delivery/rollback-plan.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/delivery/rollback-plan.md`.

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

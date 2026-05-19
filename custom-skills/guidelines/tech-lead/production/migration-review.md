# production/migration-review.md — Migration Review Standard

## Objective

Review database/data/schema/config migrations before release.

## When To Use

- DB migration PR
- Data migration
- Backward compatibility review

## Scope

- Schema change
- Data migration
- Backward compatibility
- Rollback
- Locking
- Performance
- Validation

## Tech Lead Rules

1. Migrations must be backward compatible when rolling deploys are used.
2. Avoid long locks.
3. Test migration on realistic data size.
4. Define rollback or forward-fix plan.
5. Separate destructive changes into later release.

## Security / Production Rules

1. Protect data integrity.
2. Backup before risky migration.
3. Audit financial data migrations.

## Anti-patterns

- Drop column before code stops using it.
- Large blocking migration.
- No rollback.
- No data validation.

## Expected Output

1. Migration review
2. Risk
3. Safe rollout plan

## Review Checklist

- [ ] Migration review
- [ ] Risk
- [ ] Safe rollout plan

## Prompt

```text
Use `.techlead/production/migration-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/production/migration-review.md`.

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

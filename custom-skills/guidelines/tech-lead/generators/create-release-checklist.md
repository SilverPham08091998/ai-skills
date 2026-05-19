# generators/create-release-checklist.md — Generator — Create Release Checklist

## Objective

Generate release readiness checklist for a feature/service.

## When To Use

- Before release
- Go-live preparation
- Production review

## Scope

- Scope
- Tests
- Migration
- Config
- Observability
- Rollback
- Communication

## Tech Lead Rules

1. Checklist must be specific to change.
2. Include test evidence.
3. Include rollback and monitoring.
4. Include owner for each item.
5. Call out go/no-go criteria.

## Security / Production Rules

1. Security-sensitive releases require security review evidence.

## Anti-patterns

- Generic checklist.
- No rollback.
- No monitoring.
- No owner.

## Expected Output

1. Release checklist
2. Go/no-go criteria
3. Risk list

## Review Checklist

- [ ] Release checklist
- [ ] Go/no-go criteria
- [ ] Risk list

## Prompt

```text
Use `.techlead/generators/create-release-checklist.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/generators/create-release-checklist.md`.

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

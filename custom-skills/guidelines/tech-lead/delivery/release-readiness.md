# delivery/release-readiness.md — Release Readiness Standard

## Objective

Assess whether a feature/service can be released safely.

## When To Use

- Before staging/prod release
- Release planning
- Go-live review

## Scope

- Scope
- Change impact
- Test evidence
- Migration
- Rollback
- Monitoring
- Communication

## Tech Lead Rules

1. Know what is being released.
2. Test evidence must exist.
3. Rollback path must be clear.
4. Monitoring must be ready.
5. Migration must be backward compatible.
6. Stakeholders must be informed.

## Security / Production Rules

1. Critical flows require audit and incident response readiness.

## Anti-patterns

- No test evidence.
- No rollback.
- No monitoring.
- Unknown migration impact.

## Expected Output

1. Release checklist
2. Go/no-go decision
3. Risks

## Review Checklist

- [ ] Release checklist
- [ ] Go/no-go decision
- [ ] Risks

## Prompt

```text
Use `.techlead/delivery/release-readiness.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/delivery/release-readiness.md`.

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

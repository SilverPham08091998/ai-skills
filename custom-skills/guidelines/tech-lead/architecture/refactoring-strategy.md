# architecture/refactoring-strategy.md — Refactoring Strategy Standard

## Objective

Plan safe refactoring with incremental changes and regression protection.

## When To Use

- Cleaning code
- Migrating architecture
- Improving module boundaries

## Scope

- Current state
- Target state
- Steps
- Tests
- Compatibility
- Rollback
- Risk

## Tech Lead Rules

1. Refactor in small steps.
2. Protect behavior with tests.
3. Separate mechanical refactor from behavior change.
4. Keep backward compatibility.
5. Document migration path.

## Security / Production Rules

1. Do not refactor security-sensitive behavior without test and review.
2. Preserve audit behavior.

## Anti-patterns

- Big bang refactor.
- No tests.
- Feature and refactor mixed heavily.
- No rollback.

## Expected Output

1. Refactor plan
2. Steps
3. Test strategy
4. Risk notes

## Review Checklist

- [ ] Refactor plan
- [ ] Steps
- [ ] Test strategy
- [ ] Risk notes

## Prompt

```text
Use `.techlead/architecture/refactoring-strategy.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/architecture/refactoring-strategy.md`.

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

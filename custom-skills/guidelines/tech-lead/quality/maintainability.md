# quality/maintainability.md — Maintainability Standard

## Objective

Review how easy the system is to understand, change, and operate.

## When To Use

- Architecture review
- Code review
- Refactor planning

## Scope

- Modularity
- Coupling
- Cohesion
- Documentation
- Tests
- Ownership
- Observability

## Tech Lead Rules

1. Low coupling and high cohesion.
2. Clear ownership.
3. Good tests protect change.
4. Docs explain non-obvious decisions.
5. Observability helps maintain production.

## Security / Production Rules

1. Maintainability includes secure operations and auditability.

## Anti-patterns

- Tangled dependencies.
- No tests.
- No docs.
- Hidden side effects.
- Shared mutable state.

## Expected Output

1. Maintainability findings
2. Risk
3. Improvement plan

## Review Checklist

- [ ] Maintainability findings
- [ ] Risk
- [ ] Improvement plan

## Prompt

```text
Use `.techlead/quality/maintainability.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/quality/maintainability.md`.

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

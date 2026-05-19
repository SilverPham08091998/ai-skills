# quality/clean-code.md — Clean Code Review Standard

## Objective

Define clean code review heuristics for Tech Lead feedback.

## When To Use

- Code review
- Refactoring
- Mentoring

## Scope

- Naming
- Function size
- Cohesion
- Duplication
- Readability
- Abstraction

## Tech Lead Rules

1. Code should express intent.
2. Avoid unnecessary abstraction.
3. Remove duplication with care.
4. Keep functions cohesive.
5. Prefer explicit over clever.
6. Use domain language.

## Security / Production Rules

1. Clean code must not hide security/validation logic.

## Anti-patterns

- Clever one-liners.
- Generic helper soup.
- Duplicated business rules.
- Long nested conditionals.

## Expected Output

1. Clean code comments
2. Refactor suggestions
3. Examples

## Review Checklist

- [ ] Clean code comments
- [ ] Refactor suggestions
- [ ] Examples

## Prompt

```text
Use `.techlead/quality/clean-code.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/quality/clean-code.md`.

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

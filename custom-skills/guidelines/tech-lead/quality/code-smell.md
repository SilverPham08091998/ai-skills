# quality/code-smell.md — Code Smell Standard

## Objective

Detect code smells and recommend pragmatic fixes.

## When To Use

- Code review
- Refactor planning
- Mentoring

## Scope

- Long method
- God class
- Feature envy
- Shotgun surgery
- Duplicate logic
- Primitive obsession

## Tech Lead Rules

1. Identify smell and impact.
2. Recommend smallest useful fix.
3. Do not refactor unrelated code in risky PR.
4. Preserve behavior with tests.

## Security / Production Rules

1. Flag smells that cause security or data consistency risk.

## Anti-patterns

- Huge service class.
- Many flags controlling behavior.
- Duplicated validation.
- Leaky abstraction.

## Expected Output

1. Code smell findings
2. Fix suggestion
3. Priority

## Review Checklist

- [ ] Code smell findings
- [ ] Fix suggestion
- [ ] Priority

## Prompt

```text
Use `.techlead/quality/code-smell.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/quality/code-smell.md`.

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

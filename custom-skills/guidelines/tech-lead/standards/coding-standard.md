# standards/coding-standard.md — Coding Standard

## Objective

Define maintainable code standards independent of language.

## When To Use

- Creating team standard
- Reviewing code quality
- Guiding generated code

## Scope

- Readability
- Naming
- Functions
- Errors
- Tests
- Logging
- Dependencies

## Tech Lead Rules

1. Code should be easy to read and change.
2. Names must express intent.
3. Functions should do one thing at one abstraction level.
4. Error handling must be explicit.
5. Avoid unnecessary cleverness.
6. Keep dependencies intentional.

## Security / Production Rules

1. Never log secrets.
2. Validate input at boundaries.
3. Avoid unsafe defaults.

## Anti-patterns

- Magic names.
- Huge functions.
- Silent catch.
- Overengineering.
- Copy-paste logic.

## Expected Output

1. Coding checklist
2. Review rules
3. Examples

## Review Checklist

- [ ] Coding checklist
- [ ] Review rules
- [ ] Examples

## Prompt

```text
Use `.techlead/standards/coding-standard.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/standards/coding-standard.md`.

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

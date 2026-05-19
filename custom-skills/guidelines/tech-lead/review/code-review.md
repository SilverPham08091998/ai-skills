# review/code-review.md — Code Review Standard

## Objective

Review code for correctness, maintainability, security, testability, and production behavior.

## When To Use

- Reviewing PR
- Reviewing generated code
- Mentoring engineer

## Scope

- Correctness
- Architecture
- Readability
- Errors
- Security
- Tests
- Performance
- Observability

## Tech Lead Rules

1. Review behavior first, style second.
2. Check architecture boundaries.
3. Check edge cases and errors.
4. Check tests match risk.
5. Give actionable comments.
6. Distinguish blocking vs suggestion.

## Security / Production Rules

1. Block secret leaks, auth bypass, data exposure, unsafe financial behavior.
2. Check logging for sensitive data.

## Anti-patterns

- Nitpicking only format.
- Approving no tests.
- Ignoring failure paths.
- Vague comments.

## Expected Output

1. Review findings
2. Blocking comments
3. Suggestions
4. Approval status

## Review Checklist

- [ ] Review findings
- [ ] Blocking comments
- [ ] Suggestions
- [ ] Approval status

## Prompt

```text
Use `.techlead/review/code-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/review/code-review.md`.

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

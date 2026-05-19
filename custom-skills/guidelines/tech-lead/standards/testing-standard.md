# standards/testing-standard.md — Testing Standard

## Objective

Define testing expectations for maintainable and production-safe code.

## When To Use

- Reviewing PR tests
- Planning feature tests
- Creating DoD

## Scope

- Unit tests
- Integration tests
- Contract tests
- E2E tests
- Test data
- Mocks
- Edge cases

## Tech Lead Rules

1. Test business rules near domain/application layer.
2. Test API contract for controllers.
3. Test integration with external adapters using contract/mocks.
4. Include negative cases.
5. Tests must be deterministic.

## Security / Production Rules

1. Add security tests for authorization and validation.
2. Add idempotency tests for financial commands.

## Anti-patterns

- Only happy path tests.
- Flaky tests.
- No negative cases.
- Mocking everything so test proves nothing.

## Expected Output

1. Testing strategy
2. Test checklist
3. Missing test comments

## Review Checklist

- [ ] Testing strategy
- [ ] Test checklist
- [ ] Missing test comments

## Prompt

```text
Use `.techlead/standards/testing-standard.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/standards/testing-standard.md`.

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

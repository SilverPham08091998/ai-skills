# quality/test-strategy.md — Test Strategy Standard

## Objective

Define testing approach by risk, layer, and confidence.

## When To Use

- Planning tests
- Reviewing feature quality
- Before release

## Scope

- Unit
- Integration
- Contract
- E2E
- Performance
- Security
- Regression

## Tech Lead Rules

1. Test strategy depends on risk.
2. Business rules need unit tests.
3. Adapters need integration/contract tests.
4. Critical user journeys need E2E or scenario tests.
5. Sensitive flows need negative/security tests.

## Security / Production Rules

1. Financial flows require idempotency and duplicate tests.
2. Auth flows require authorization tests.

## Anti-patterns

- Only unit tests for integration-heavy feature.
- No negative tests.
- No regression for bug fix.

## Expected Output

1. Test matrix
2. Required tests
3. Gaps

## Review Checklist

- [ ] Test matrix
- [ ] Required tests
- [ ] Gaps

## Prompt

```text
Use `.techlead/quality/test-strategy.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/quality/test-strategy.md`.

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

# planning/estimation.md — Engineering Estimation Standard

## Objective

Estimate engineering work with assumptions, complexity, risk, and confidence.

## When To Use

- Sprint planning
- Sizing feature
- Comparing options

## Scope

- Scope
- Complexity
- Unknowns
- Dependencies
- Risk
- Confidence
- Buffer

## Tech Lead Rules

1. Estimate based on scope and uncertainty.
2. State assumptions.
3. Separate implementation, testing, review, and release effort.
4. Use ranges when uncertainty is high.
5. Call out unknowns instead of pretending precision.

## Security / Production Rules

1. Include security/compliance/release review effort for sensitive features.

## Anti-patterns

- Single exact estimate with many unknowns.
- No testing/review time.
- Ignoring dependency risk.

## Expected Output

1. Estimate range
2. Assumptions
3. Risk/unknowns
4. Confidence level

## Review Checklist

- [ ] Estimate range
- [ ] Assumptions
- [ ] Risk/unknowns
- [ ] Confidence level

## Prompt

```text
Use `.techlead/planning/estimation.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/planning/estimation.md`.

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

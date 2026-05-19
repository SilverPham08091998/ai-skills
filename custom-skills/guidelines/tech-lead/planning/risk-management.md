# planning/risk-management.md — Engineering Risk Management Standard

## Objective

Identify and manage technical, delivery, security, and production risks.

## When To Use

- Before implementation
- Before release
- Reviewing high-risk feature

## Scope

- Risk
- Impact
- Likelihood
- Severity
- Mitigation
- Owner
- Status

## Tech Lead Rules

1. Identify risk early.
2. Classify severity.
3. Every high risk needs mitigation or explicit acceptance.
4. Assign owner.
5. Review risk throughout delivery.

## Security / Production Rules

1. Security, data loss, financial loss, and production outage risks require escalation.

## Anti-patterns

- Risk list with no owner.
- Ignoring low-likelihood high-impact risk.
- No mitigation.

## Expected Output

1. Risk register
2. Mitigation plan
3. Escalation list

## Review Checklist

- [ ] Risk register
- [ ] Mitigation plan
- [ ] Escalation list

## Prompt

```text
Use `.techlead/planning/risk-management.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/planning/risk-management.md`.

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

# quality/technical-debt.md — Technical Debt Management Standard

## Objective

Identify, classify, and manage technical debt intentionally.

## When To Use

- Reviewing debt
- Planning refactor
- Balancing delivery

## Scope

- Debt item
- Impact
- Interest
- Risk
- Owner
- Paydown plan
- Deadline

## Tech Lead Rules

1. Not all debt must be fixed immediately.
2. Classify debt by impact and urgency.
3. Make debt visible.
4. Link debt to business/production risk.
5. Schedule paydown for high-interest debt.

## Security / Production Rules

1. Security debt and data integrity debt require stronger urgency.

## Anti-patterns

- Hidden debt.
- Fixing random debt without priority.
- Using debt as excuse for rewrite.
- No owner.

## Expected Output

1. Debt register
2. Priority
3. Paydown plan

## Review Checklist

- [ ] Debt register
- [ ] Priority
- [ ] Paydown plan

## Prompt

```text
Use `.techlead/quality/technical-debt.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/quality/technical-debt.md`.

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

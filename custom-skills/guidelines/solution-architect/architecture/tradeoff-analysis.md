# architecture/tradeoff-analysis.md — Trade-off Analysis Standard

## Objective

Compare architecture options with decision criteria and explicit trade-offs.

## When To Use

- Choosing between tools/patterns
- Explaining why one design wins
- Reviewing options with stakeholders

## Scope

- Options
- Criteria
- Pros/cons
- Risks
- Costs
- Complexity
- Operational impact

## Architecture Rules

1. Define decision criteria first.
2. Compare options against same criteria.
3. Include operational and cost impact.
4. Do not hide disadvantages of preferred option.
5. Recommend with rationale.

## Security / Compliance Rules

1. Include security and compliance as criteria.
2. Flag vendor lock-in and data risk.

## Anti-patterns

- Only listing pros of favorite option.
- No cost/ops analysis.
- No risk comparison.
- No recommendation.

## Expected Output

1. Option comparison table
2. Recommendation
3. Risks
4. Mitigation
5. Decision notes

## Review Checklist

- [ ] Option comparison table
- [ ] Recommendation
- [ ] Risks
- [ ] Mitigation
- [ ] Decision notes

## Prompt

```text
Use `.sa/architecture/tradeoff-analysis.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/architecture/tradeoff-analysis.md`.

Task:
<describe the architecture task>

Context:
- Domain:
- Actors:
- Existing systems:
- Constraints:
- NFR:
- Security/compliance concerns:

Output:
- Assumptions
- Architecture/design
- Diagrams if useful
- Trade-offs
- Risks
- Implementation handoff
```

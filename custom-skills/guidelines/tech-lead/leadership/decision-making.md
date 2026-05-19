# leadership/decision-making.md — Technical Decision Making Standard

## Objective

Make technical decisions with context, options, trade-offs, and explicit consequences.

## When To Use

- Choosing library/framework
- Resolving design disagreement
- Documenting important decision

## Scope

- Context
- Options
- Decision criteria
- Trade-offs
- Risks
- Decision
- Follow-up

## Tech Lead Rules

1. Define decision criteria before choosing.
2. Compare realistic alternatives.
3. Document consequences.
4. Use ADR for long-lived/high-impact decisions.
5. Prefer reversible decisions when uncertainty is high.

## Security / Production Rules

1. Include security and compliance impact in criteria.
2. Do not choose risky option without mitigation.

## Anti-patterns

- Decision based only on preference.
- No alternatives.
- No risk analysis.
- No owner for follow-up.

## Expected Output

1. Decision summary
2. Options table
3. Recommendation
4. ADR if needed

## Review Checklist

- [ ] Decision summary
- [ ] Options table
- [ ] Recommendation
- [ ] ADR if needed

## Prompt

```text
Use `.techlead/leadership/decision-making.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/leadership/decision-making.md`.

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

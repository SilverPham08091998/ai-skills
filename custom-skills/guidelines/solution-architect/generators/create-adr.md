# generators/create-adr.md — Generator — Create ADR

## Objective

Generate architecture decision record.

## When To Use

- Choosing technology/pattern
- Documenting decision
- Architecture governance

## Scope

- Status
- Context
- Options
- Decision
- Consequences
- Risks
- Review date

## Architecture Rules

1. Compare alternatives.
2. Explain decision criteria.
3. Document trade-offs.
4. Include consequences.
5. Make decision reviewable.

## Security / Compliance Rules

1. Include security/compliance impact.
2. Flag migration risk.

## Anti-patterns

- ADR with only final decision.
- No alternatives.
- No consequences.
- No review date.

## Expected Output

1. ADR markdown
2. Option comparison
3. Decision rationale
4. Consequences

## Review Checklist

- [ ] ADR markdown
- [ ] Option comparison
- [ ] Decision rationale
- [ ] Consequences

## Prompt

```text
Use `.sa/generators/create-adr.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/generators/create-adr.md`.

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

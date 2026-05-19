# architecture/adr.md — Architecture Decision Record Standard

## Objective

Capture important architecture decisions with context, options, decision, consequences, and review date.

## When To Use

- Choosing technology
- Documenting trade-offs
- Reviewing architecture history

## Scope

- Context
- Decision
- Options
- Consequences
- Trade-offs
- Status
- Review date

## Architecture Rules

1. Every major decision needs an ADR.
2. Compare alternatives fairly.
3. Explain why rejected options were rejected.
4. Document consequences and risks.
5. Keep ADR short but clear.

## Security / Compliance Rules

1. Include security impact for relevant decisions.
2. Include compliance or data impact when applicable.

## Anti-patterns

- Decision without alternatives.
- ADR after implementation only.
- No consequence section.
- No owner/review date.

## Expected Output

1. ADR document
2. Options table
3. Decision rationale
4. Consequences
5. Follow-up actions

## Review Checklist

- [ ] ADR document
- [ ] Options table
- [ ] Decision rationale
- [ ] Consequences
- [ ] Follow-up actions

## Prompt

```text
Use `.sa/architecture/adr.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/architecture/adr.md`.

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

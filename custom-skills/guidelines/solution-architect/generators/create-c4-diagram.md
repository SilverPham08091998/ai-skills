# generators/create-c4-diagram.md — Generator — Create C4 Diagrams

## Objective

Generate C4 context/container/component diagrams using Mermaid.

## When To Use

- User asks for diagrams
- Architecture visualization
- Explaining system boundaries

## Scope

- Context diagram
- Container diagram
- Component diagram
- Relationship labels
- Boundaries

## Architecture Rules

1. Use correct C4 level.
2. Keep diagrams readable.
3. Label relationships with protocol/purpose.
4. Show external systems.
5. Separate public/internal boundaries.

## Security / Compliance Rules

1. Show trust boundaries.
2. Mark sensitive data flow.

## Anti-patterns

- One giant unreadable diagram.
- No relationship labels.
- No external systems.
- No boundary.

## Expected Output

1. Mermaid diagrams
2. Diagram explanation
3. Legend

## Review Checklist

- [ ] Mermaid diagrams
- [ ] Diagram explanation
- [ ] Legend

## Prompt

```text
Use `.sa/generators/create-c4-diagram.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/generators/create-c4-diagram.md`.

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

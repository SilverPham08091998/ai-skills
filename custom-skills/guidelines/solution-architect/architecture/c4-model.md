# architecture/c4-model.md — C4 Model Standard

## Objective

Use C4 diagrams to describe architecture at context, container, component, and code levels.

## When To Use

- Creating architecture diagrams
- Explaining system layers
- Communicating with mixed audience

## Scope

- System context
- Container diagram
- Component diagram
- Code/class diagram
- Relationships
- Responsibilities

## Architecture Rules

1. Use C4 level appropriate to audience.
2. Context shows users and external systems.
3. Container shows deployable units.
4. Component shows internals.
5. Code diagram only when useful.

## Security / Compliance Rules

1. Show trust boundaries and external dependencies.
2. Mark sensitive data flows.

## Anti-patterns

- Mixing all details into one diagram.
- No relationship labels.
- No boundaries.
- No legend.

## Expected Output

1. C4 diagrams
2. Descriptions
3. Boundary explanation
4. Diagram notes

## Review Checklist

- [ ] C4 diagrams
- [ ] Descriptions
- [ ] Boundary explanation
- [ ] Diagram notes

## Prompt

```text
Use `.sa/architecture/c4-model.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/architecture/c4-model.md`.

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

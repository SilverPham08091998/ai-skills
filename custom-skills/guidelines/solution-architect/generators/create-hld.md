# generators/create-hld.md — Generator — Create HLD

## Objective

Generate a high-level design document from requirements.

## When To Use

- User asks for HLD
- Starting architecture doc
- Explaining system to stakeholders

## Scope

- Overview
- Context
- C4 diagrams
- Components
- Data flow
- NFR
- Security
- Risks
- Roadmap

## Architecture Rules

1. Load requirements, HLD, C4, NFR, security, deployment, observability skills.
2. Explain assumptions.
3. Include Mermaid diagrams.
4. Keep HLD understandable to both business and engineering.

## Security / Compliance Rules

1. Mark trust boundaries.
2. Do not expose sensitive details unnecessarily.
3. Include audit/security section.

## Anti-patterns

- No diagrams.
- No NFR.
- No security.
- No risks.
- Too implementation-heavy.

## Expected Output

1. Full HLD markdown
2. Mermaid diagrams
3. NFR mapping
4. Risk register

## Review Checklist

- [ ] Full HLD markdown
- [ ] Mermaid diagrams
- [ ] NFR mapping
- [ ] Risk register

## Prompt

```text
Use `.sa/generators/create-hld.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/generators/create-hld.md`.

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

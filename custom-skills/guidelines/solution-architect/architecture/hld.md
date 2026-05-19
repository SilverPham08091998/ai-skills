# architecture/hld.md — High-Level Design Standard

## Objective

Create HLD that communicates system context, major components, flows, integrations, and NFR alignment.

## When To Use

- Creating architecture proposal
- Explaining system to stakeholders
- Designing new platform or major feature

## Scope

- Context
- Actors
- External systems
- Major components
- Data flow
- Deployment view
- NFR mapping
- Risks

## Architecture Rules

1. HLD focuses on why and what at system level.
2. Show boundaries and dependencies.
3. Include data flow and control flow.
4. Explain major decisions and alternatives.
5. Map architecture to NFRs.

## Security / Compliance Rules

1. Show trust boundaries.
2. Include authentication and authorization overview.
3. Identify sensitive data flow.

## Anti-patterns

- Only a component diagram with no explanation.
- No external systems.
- No NFR mapping.
- No failure handling.

## Expected Output

1. HLD document
2. C4 context/container diagrams
3. Sequence overview
4. NFR mapping
5. Risk list

## Review Checklist

- [ ] HLD document
- [ ] C4 context/container diagrams
- [ ] Sequence overview
- [ ] NFR mapping
- [ ] Risk list

## Prompt

```text
Use `.sa/architecture/hld.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/architecture/hld.md`.

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

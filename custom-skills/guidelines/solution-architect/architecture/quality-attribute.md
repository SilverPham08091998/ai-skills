# architecture/quality-attribute.md — Quality Attribute Standard

## Objective

Translate quality attributes into architecture tactics and measurable targets.

## When To Use

- Designing resilient system
- Mapping NFRs to tactics
- Reviewing production architecture

## Scope

- Availability
- Performance
- Scalability
- Security
- Modifiability
- Testability
- Operability

## Architecture Rules

1. Every important quality attribute needs tactics.
2. Quality attributes often trade off with each other.
3. Make target measurable.
4. Show how design supports target.

## Security / Compliance Rules

1. Security quality must cover identity, authorization, data, audit, network, and operations.

## Anti-patterns

- Quality attributes mentioned but not designed.
- No metrics.
- No tactics.
- No trade-offs.

## Expected Output

1. Quality attribute scenario
2. Tactics
3. Metrics
4. Design impact
5. Validation plan

## Review Checklist

- [ ] Quality attribute scenario
- [ ] Tactics
- [ ] Metrics
- [ ] Design impact
- [ ] Validation plan

## Prompt

```text
Use `.sa/architecture/quality-attribute.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/architecture/quality-attribute.md`.

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

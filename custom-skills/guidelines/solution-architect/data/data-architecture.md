# data/data-architecture.md — Data Architecture Standard

## Objective

Design data ownership, storage, flow, retention, and consistency.

## When To Use

- Choosing database
- Designing storage
- Reviewing data flow
- Splitting service data

## Scope

- Data owner
- Data model
- Storage type
- Consistency
- Retention
- Replication
- Audit
- Data classification

## Architecture Rules

1. Each domain should own its data.
2. Avoid shared database across bounded contexts.
3. Choose storage by access pattern.
4. Define consistency requirements.
5. Define retention and archival.

## Security / Compliance Rules

1. Classify sensitive data.
2. Encrypt at rest/in transit.
3. Mask logs and analytics.
4. Define access controls.

## Anti-patterns

- Shared database for all services.
- No data owner.
- No retention policy.
- No audit model.

## Expected Output

1. Data ownership map
2. Storage recommendation
3. Consistency model
4. Retention/audit plan

## Review Checklist

- [ ] Data ownership map
- [ ] Storage recommendation
- [ ] Consistency model
- [ ] Retention/audit plan

## Prompt

```text
Use `.sa/data/data-architecture.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/data/data-architecture.md`.

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

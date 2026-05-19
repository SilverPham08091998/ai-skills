# integration/event-driven.md — Event-Driven Architecture Standard

## Objective

Design event-driven systems with clear event ownership, schema, delivery, and consistency rules.

## When To Use

- Kafka architecture
- Domain event design
- Async notification flow
- Decoupling services

## Scope

- Domain event
- Integration event
- Topic
- Consumer group
- Schema
- Outbox
- DLQ
- Idempotent consumer

## Architecture Rules

1. Events represent facts that happened.
2. Producer owns event schema.
3. Consumer must be idempotent.
4. Use outbox for DB+event consistency.
5. Define retry and DLQ.
6. Version event schema.

## Security / Compliance Rules

1. Avoid putting secrets in events.
2. Classify event data.
3. Protect topics with ACLs.

## Anti-patterns

- Command disguised as event.
- No schema version.
- No DLQ.
- Consumer not idempotent.
- Using Kafka as database.

## Expected Output

1. Event catalog
2. Topic design
3. Schema example
4. Retry/DLQ strategy

## Review Checklist

- [ ] Event catalog
- [ ] Topic design
- [ ] Schema example
- [ ] Retry/DLQ strategy

## Prompt

```text
Use `.sa/integration/event-driven.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/integration/event-driven.md`.

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

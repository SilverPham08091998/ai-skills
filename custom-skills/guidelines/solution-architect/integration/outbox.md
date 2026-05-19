# integration/outbox.md — Outbox Pattern Standard

## Objective

Design reliable event publishing when database update and message publish must be consistent.

## When To Use

- DB update plus Kafka event
- Reliable event publishing
- Avoiding dual-write

## Scope

- Outbox table
- Transaction boundary
- Publisher
- Status
- Retry
- Deduplication
- Cleanup

## Architecture Rules

1. Write business data and outbox record in same DB transaction.
2. Publish asynchronously from outbox.
3. Mark published only after broker ack.
4. Retry failed publishes.
5. Consumers still must be idempotent.

## Security / Compliance Rules

1. Do not store sensitive full payload unnecessarily.
2. Control outbox growth.
3. Audit failed publishes.

## Anti-patterns

- DB update then Kafka publish directly.
- No retry.
- No cleanup.
- No idempotent consumer.

## Expected Output

1. Outbox schema
2. Publisher flow
3. Retry policy
4. Cleanup strategy

## Review Checklist

- [ ] Outbox schema
- [ ] Publisher flow
- [ ] Retry policy
- [ ] Cleanup strategy

## Prompt

```text
Use `.sa/integration/outbox.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/integration/outbox.md`.

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

# data/transaction-consistency.md — Transaction Consistency Standard

## Objective

Define consistency strategies for local and distributed transactions.

## When To Use

- Money movement
- DB plus event
- Multi-service write
- Consistency review

## Scope

- ACID transaction
- Eventual consistency
- Saga
- Outbox
- Idempotency
- Locking
- Reconciliation

## Architecture Rules

1. Keep strong consistency inside one service boundary.
2. Use saga/outbox for cross-service consistency.
3. Define transaction boundary explicitly.
4. Use idempotency for retries.
5. Use reconciliation for uncertain external outcomes.

## Security / Compliance Rules

1. Prevent duplicate financial effects.
2. Audit state changes.
3. Avoid distributed locks for core money correctness unless carefully designed.

## Anti-patterns

- Distributed transaction assumption across services.
- No reconciliation.
- No idempotency.
- No transaction boundary.

## Expected Output

1. Consistency design
2. Transaction boundary
3. Failure cases
4. Reconciliation plan

## Review Checklist

- [ ] Consistency design
- [ ] Transaction boundary
- [ ] Failure cases
- [ ] Reconciliation plan

## Prompt

```text
Use `.sa/data/transaction-consistency.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/data/transaction-consistency.md`.

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

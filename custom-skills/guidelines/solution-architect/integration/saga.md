# integration/saga.md — Saga Pattern Standard

## Objective

Design distributed transaction flows using choreography or orchestration.

## When To Use

- Money movement flow
- Multi-service transaction
- Long-running business process
- Compensation design

## Scope

- Saga steps
- State machine
- Compensation
- Orchestrator
- Choreography
- Timeout
- Idempotency

## Architecture Rules

1. Use saga when transaction spans multiple services/resources.
2. Define each step and compensation.
3. Persist saga state.
4. Make steps idempotent.
5. Define terminal states.
6. Prefer orchestration for complex critical flows.

## Security / Compliance Rules

1. Do not compensate blindly for financial postings.
2. Audit every state transition.
3. Define reconciliation for uncertain states.

## Anti-patterns

- No saga state store.
- No compensation.
- Ambiguous processing state.
- Duplicate step execution.
- No timeout.

## Expected Output

1. Saga flow
2. State machine
3. Compensation matrix
4. Failure handling

## Review Checklist

- [ ] Saga flow
- [ ] State machine
- [ ] Compensation matrix
- [ ] Failure handling

## Prompt

```text
Use `.sa/integration/saga.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/integration/saga.md`.

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

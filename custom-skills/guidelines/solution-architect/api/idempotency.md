# api/idempotency.md — Idempotency Standard

## Objective

Define idempotency strategy for commands, payments, wallet, partner integrations, and retries.

## When To Use

- Designing payment command
- Handling retry
- Partner API integration
- Preventing duplicate effects

## Scope

- Idempotency key
- Request hash
- TTL
- State
- Duplicate handling
- Replay response
- Conflict detection

## Architecture Rules

1. Every retryable command that changes state needs idempotency.
2. Idempotency key must be scoped.
3. Store request fingerprint/hash.
4. Return same result for duplicate same request.
5. Reject duplicate key with different payload.
6. TTL must match business risk.

## Security / Compliance Rules

1. Protect money movement from duplicate posting.
2. Audit idempotency decisions.
3. Do not expose sensitive request body in idempotency store.

## Anti-patterns

- Retry without idempotency.
- Key not scoped by user/action.
- Same key accepts different payload.
- No TTL.
- Only client-side duplicate prevention.

## Expected Output

1. Idempotency design
2. Storage model
3. State machine
4. Error cases
5. Sequence flow

## Review Checklist

- [ ] Idempotency design
- [ ] Storage model
- [ ] State machine
- [ ] Error cases
- [ ] Sequence flow

## Prompt

```text
Use `.sa/api/idempotency.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/api/idempotency.md`.

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

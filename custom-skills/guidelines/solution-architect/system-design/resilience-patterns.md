# system-design/resilience-patterns.md — Resilience Patterns Standard

## Objective

Apply resilience patterns correctly for distributed systems.

## When To Use

- Adding resilience4j
- Designing service integration
- Handling partner instability

## Scope

- Timeout
- Retry
- Circuit breaker
- Rate limiter
- Bulkhead
- Fallback
- Idempotency
- Outbox

## Architecture Rules

1. Timeout before retry.
2. Retry only safe operations.
3. Circuit breaker protects downstream and callers.
4. Bulkhead isolates resources.
5. Fallback must be business-approved.
6. Outbox protects event publishing consistency.

## Security / Compliance Rules

1. Do not retry non-idempotent financial operation without idempotency key.
2. Audit compensation and failure states.

## Anti-patterns

- Retry storm.
- Fallback returning fake success.
- Circuit breaker with no metrics.
- No outbox for DB+event consistency.

## Expected Output

1. Pattern recommendation
2. Config guideline
3. Risk notes
4. Validation plan

## Review Checklist

- [ ] Pattern recommendation
- [ ] Config guideline
- [ ] Risk notes
- [ ] Validation plan

## Prompt

```text
Use `.sa/system-design/resilience-patterns.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/system-design/resilience-patterns.md`.

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

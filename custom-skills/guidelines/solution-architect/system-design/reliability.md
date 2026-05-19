# system-design/reliability.md — Reliability Design Standard

## Objective

Design systems for failure tolerance, recovery, and predictable behavior under dependency failure.

## When To Use

- Designing critical flow
- Reviewing failure modes
- Improving uptime

## Scope

- Redundancy
- Timeout
- Retry
- Circuit breaker
- Fallback
- Bulkhead
- Idempotency
- Recovery

## Architecture Rules

1. Assume dependencies fail.
2. Define timeout and retry for every integration.
3. Use circuit breaker for unstable dependency.
4. Use idempotency for retryable commands.
5. Define fallback only when business-safe.

## Security / Compliance Rules

1. Avoid retrying money movement blindly.
2. Protect against duplicate transaction effects.
3. Log/audit failure states.

## Anti-patterns

- No timeout.
- Infinite retry.
- Fallback that hides financial failure.
- No idempotency.
- No reconciliation.

## Expected Output

1. Failure mode table
2. Reliability tactics
3. Retry/timeout policy
4. Recovery plan

## Review Checklist

- [ ] Failure mode table
- [ ] Reliability tactics
- [ ] Retry/timeout policy
- [ ] Recovery plan

## Prompt

```text
Use `.sa/system-design/reliability.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/system-design/reliability.md`.

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

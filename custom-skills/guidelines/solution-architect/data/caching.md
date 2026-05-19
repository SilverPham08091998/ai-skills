# data/caching.md — Caching Standard

## Objective

Define caching strategy, invalidation, TTL, and risk controls.

## When To Use

- Adding Redis cache
- Improving performance
- Reducing DB load
- Reviewing stale data risk

## Scope

- Cache-aside
- Write-through
- TTL
- Invalidation
- Key design
- Stampede protection
- Sensitive data

## Architecture Rules

1. Cache only when access pattern benefits.
2. Define TTL and invalidation.
3. Use key prefix convention.
4. Prevent cache stampede.
5. Measure hit ratio.
6. Do not cache source-of-truth critical state blindly.

## Security / Compliance Rules

1. Do not cache sensitive data without encryption/masking.
2. Avoid leaking user data across keys.
3. Protect Redis access.

## Anti-patterns

- Cache with no TTL.
- No invalidation.
- Caching wallet balance without correctness strategy.
- User ID missing in key scope.

## Expected Output

1. Cache strategy
2. Key naming
3. TTL matrix
4. Invalidation plan

## Review Checklist

- [ ] Cache strategy
- [ ] Key naming
- [ ] TTL matrix
- [ ] Invalidation plan

## Prompt

```text
Use `.sa/data/caching.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/data/caching.md`.

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

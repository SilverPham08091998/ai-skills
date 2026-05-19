# system-design/scalability.md — Scalability Design Standard

## Objective

Design systems to handle growth in traffic, data, users, and integrations.

## When To Use

- Scaling API/service
- Designing high traffic system
- Capacity planning architecture

## Scope

- Horizontal scaling
- Stateless service
- Cache
- Queue
- Partitioning
- Read replica
- Backpressure

## Architecture Rules

1. Prefer stateless services for horizontal scaling.
2. Separate read/write scaling strategies.
3. Use queues for async load smoothing.
4. Use cache carefully with invalidation rules.
5. Define backpressure strategy.

## Security / Compliance Rules

1. Avoid scaling insecurely by exposing internals.
2. Protect cache from sensitive data leakage.
3. Rate limit public APIs.

## Anti-patterns

- Scaling by only increasing instance size.
- No backpressure.
- Cache with no invalidation.
- Single database bottleneck ignored.

## Expected Output

1. Scalability plan
2. Bottleneck analysis
3. Capacity assumptions
4. Scaling strategy

## Review Checklist

- [ ] Scalability plan
- [ ] Bottleneck analysis
- [ ] Capacity assumptions
- [ ] Scaling strategy

## Prompt

```text
Use `.sa/system-design/scalability.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/system-design/scalability.md`.

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

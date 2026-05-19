# system-design/performance.md — Performance Design Standard

## Objective

Design and review latency, throughput, resource usage, and bottlenecks.

## When To Use

- Latency-sensitive API
- High-throughput service
- Performance review

## Scope

- Latency budget
- Throughput
- Concurrency
- DB query
- Cache
- Connection pool
- Payload size

## Architecture Rules

1. Define latency target per flow.
2. Create latency budget across components.
3. Optimize bottlenecks based on measurement.
4. Avoid chatty service calls.
5. Design connection pools consciously.

## Security / Compliance Rules

1. Do not trade security for performance without approval.
2. Avoid logging sensitive full payloads for debugging performance.

## Anti-patterns

- No latency target.
- Many synchronous calls in critical path.
- Unbounded concurrency.
- No DB index strategy.

## Expected Output

1. Latency budget
2. Performance risks
3. Optimization plan
4. Measurement strategy

## Review Checklist

- [ ] Latency budget
- [ ] Performance risks
- [ ] Optimization plan
- [ ] Measurement strategy

## Prompt

```text
Use `.sa/system-design/performance.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/system-design/performance.md`.

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

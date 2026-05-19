# review/performance-review.md — Performance Review Standard

## Objective

Review code/design for latency, throughput, memory, and scalability risks.

## When To Use

- Reviewing hot path
- High traffic API
- Production performance issue

## Scope

- DB queries
- N+1
- Cache
- Payload
- Loops
- Concurrency
- Connection pool
- Memory

## Tech Lead Rules

1. Identify bottlenecks based on path.
2. Check DB query count and indexes.
3. Avoid unnecessary synchronous calls.
4. Control payload size.
5. Review thread/concurrency use.
6. Measure before complex optimization.

## Security / Production Rules

1. Do not sacrifice correctness/security for performance without approval.

## Anti-patterns

- N+1 queries.
- Unbounded list load.
- Blocking call in hot path.
- No timeout.
- Large payload.

## Expected Output

1. Performance findings
2. Risk
3. Suggested fix
4. Measurement plan

## Review Checklist

- [ ] Performance findings
- [ ] Risk
- [ ] Suggested fix
- [ ] Measurement plan

## Prompt

```text
Use `.techlead/review/performance-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/review/performance-review.md`.

Task:
<describe the planning/review/leadership task>

Context:
- Feature/change:
- Existing architecture:
- Team constraints:
- Risk level:
- Deadline:
- Production impact:

Output:
- Assumptions
- Findings or plan
- Risks
- Action items
- Definition of Done
```

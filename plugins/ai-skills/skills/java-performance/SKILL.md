---
name: java-performance
description: Java performance standards for allocation, collections, streams, IO, concurrency, and profiling. Use when optimizing or reviewing Java code.
---

# Java Performance Guidelines

This skill converts `backend-engineer/java/performance.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Java Performance Guidelines

## Purpose

Define practical Java performance rules for production systems.

Goals:

- low latency
- high throughput
- efficient memory usage
- stable CPU utilization
- scalable services
- predictable behavior under load

Applies to:

- Spring Boot APIs
- Kafka consumers/producers
- batch jobs
- schedulers
- high traffic services
- fintech transaction systems

---

# 1. Core Principle

Do not optimize blindly.

Measure first, optimize second.

Use:

- metrics
- profiling
- load testing
- tracing
- GC logs

Avoid guessing.

---

# 2. Optimize Hot Paths Only

Focus on code executed frequently or under high traffic.

Examples:

- request validation in every API call
- serialization
- DB-heavy endpoints
- payment transaction flow
- Kafka consumers

Do not micro-optimize cold admin features.

---

# 3. Big Wins First

Prioritize:

1. Database optimization
2. Network calls reduction
3. Algorithm complexity
4. Caching
5. Thread contention reduction
6. Object allocation reduction
7. Micro code tuning

---

# 4. Algorithm Complexity Matters

Prefer correct data structures.

Bad:

nested loops O(n²)

Good:

Map lookup O(n)

Example:

Use HashMap for customer lookup instead of scanning list repeatedly.

---

# 5. Database Performance

Most backend slowness comes from database.

Rules:

- use indexes correctly
- avoid SELECT *
- fetch only needed columns
- paginate large queries
- batch writes when possible
- avoid N+1 queries
- use connection pooling

---

# 6. N+1 Query Prevention

Bad:

Load 100 orders then query customer for each order.

Good:

join fetch / batch fetch / preload map.

---

# 7. Reduce Network Calls

Remote calls are expensive.

Prefer:

- batching
- caching
- parallel independent calls
- timeout control

Avoid chaining many synchronous calls.

---

# 8. Use Timeouts

Always set timeouts for:

- HTTP clients
- DB calls
- messaging requests
- async futures

Protect threads from hanging.

---

# 9. Caching Strategy

Use caching for expensive repeated reads.

Examples:

- config data
- reference data
- exchange rates
- product metadata

Avoid caching volatile transactional truth blindly.

Need:

- TTL
- invalidation strategy
- memory limit

---

# 10. Object Allocation Awareness

Excessive allocations increase GC pressure.

Avoid:

creating many temporary objects in loops.

Bad:

for (...) {
new BigDecimal(...)
}

Reuse when reasonable.

---

# 11. String Performance

Bad:

String s = "";
for (...) s += item;

Good:

StringBuilder builder = new StringBuilder();

Use String.format sparingly in hot paths.

---

# 12. Primitive vs Wrapper

Prefer primitives in hot paths when null not needed.

Good:

int count

Avoid unnecessary boxing:

Integer total += 1

---

# 13. Collections Performance

Choose right structure.

ArrayList:
fast iteration/random access

HashSet:
fast contains()

HashMap:
fast key lookup

Avoid LinkedList unless justified.

---

# 14. Pre-size Collections

When size known:

new ArrayList<>(1000)
new HashMap<>(500)

Reduces resizing overhead.

---

# 15. Stream API Performance

Streams are fine for readability.

But in hot loops:
benchmark vs loop.

Avoid giant nested streams with allocations.

Use simple loops when faster and clearer.

---

# 16. Logging Performance

Logging can be expensive.

Use parameterized logs.

Good:

log.info("txnId={} status={}", txnId, status);

Bad:

log.info("txnId=" + txnId + status);

Avoid debug spam in high traffic paths.

---

# 17. Serialization Performance

JSON serialization can be costly.

Rules:

- return only needed fields
- avoid giant object graphs
- avoid recursive lazy loading issues
- use DTOs

---

# 18. Thread Pool Tuning

Too many threads = worse performance.

Watch:

- CPU saturation
- context switching
- blocked threads
- queue growth

Tune executors intentionally.

---

# 19. Lock Contention

Shared locks reduce throughput.

Prefer:

- stateless design
- lock-free structures
- smaller critical sections
- partitioned workloads

---

# 20. Async For I/O Workloads

Use async/parallel calls for independent I/O tasks.

Examples:

- call 3 providers in parallel
- enrich response concurrently

Avoid async complexity for trivial flows.

---

# 21. Garbage Collection Awareness

High allocation rate = more GC.

Watch:

- full GC pauses
- memory spikes
- object churn

Use metrics and GC logs.

---

# 22. Memory Usage

Avoid:

- giant in-memory lists
- unbounded caches
- retaining references
- loading full datasets unnecessarily

Prefer:

- paging
- streaming
- chunk processing

---

# 23. Batch Processing

For large workloads:

Use chunk size strategy.

Example:

process 1000 rows at a time.

Avoid loading 1 million rows into memory.

---

# 24. Pagination

Always paginate large APIs and DB reads.

Bad:

GET /transactions returns 500k rows

Good:

GET /transactions?page=1&size=50

---

# 25. Use Connection Pools

For DB / HTTP clients.

Tune:

- max pool size
- timeout
- idle settings

Monitor saturation.

---

# 26. Warmup and JIT

JVM performance improves after warmup.

Benchmark after warmup, not first request only.

Use realistic load tests.

---

# 27. Benchmark Correctly

Use:

- JMH for microbenchmarks
- load test tools for APIs
- production-like datasets

Avoid naive System.currentTimeMillis single runs.

---

# 28. Fintech Critical Paths

Optimize especially:

- payment authorization
- balance checks
- fraud rules
- OTP verification
- transaction persistence
- reconciliation jobs

---

# 29. Observability Metrics

Track:

- p50 / p95 / p99 latency
- throughput
- error rate
- CPU
- heap usage
- GC pause time
- DB latency
- queue depth

---

# 30. Common Performance Smells

Refactor when you see:

- repeated DB calls in loop
- nested loops on large lists
- synchronized everywhere
- no caching for hot reads
- loading giant objects
- huge logs
- no timeout external calls
- unbounded queues

---

# 31. Startup Performance

For microservices:

- reduce unnecessary bean creation
- lazy init where suitable
- trim scanning scope
- avoid heavy startup queries

---

# 32. Security vs Performance

Do not remove security for speed.

Instead optimize implementation:

- token cache
- connection reuse
- efficient crypto usage

---

# 33. Example Improvements

Bad:

for each payment:
call DB
call provider
call DB

Better:

batch preload + parallel provider calls + batch update

---

# 34. Review Checklist

Before merge ask:

- Measured bottleneck?
- Any N+1 query risk?
- Correct data structure?
- Excessive allocations?
- Logging too noisy?
- Timeouts configured?
- Pools tuned?
- Large memory load?
- Metrics available?

---

# 35. Mandatory For AI Code Generation

When generating Java code:

- Prefer efficient algorithms
- Avoid N+1 access patterns
- Use proper collections
- Use pagination for large reads
- Use BigDecimal for money safely
- Add timeout awareness
- Avoid unnecessary allocations
- Keep code readable first, optimize real bottlenecks second

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

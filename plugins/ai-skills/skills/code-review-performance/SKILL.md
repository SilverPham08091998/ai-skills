---
name: code-review-performance
description: Performance review standards for backend services. Use when reviewing database, API, concurrency, memory, and production latency risks.
---

# Code Review Performance Guidelines

This skill converts `backend-engineer/code-review/performance-review.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Performance Review Guidelines

## Objective

Ensure backend systems are efficient, scalable, stable, and cost-effective under real production load.

---

## Review Priority Order

1. Correctness under load
2. Latency
3. Throughput
4. Resource usage
5. Scalability
6. Cost efficiency
7. Maintainability

---

## 1. API Performance Review

### Must Check

* [ ] P95 / P99 latency acceptable
* [ ] Timeout values defined
* [ ] No unnecessary synchronous chaining
* [ ] Request/response payload size reasonable
* [ ] Compression enabled if needed
* [ ] Pagination for list APIs

### Red Flags

* Sequential remote calls
* Large payload responses
* Chatty APIs
* Blocking long-running requests

---

## 2. Database Performance Review

### Must Check

* [ ] Slow queries analyzed
* [ ] Proper indexes exist
* [ ] Pagination used
* [ ] Avoid SELECT *
* [ ] Join count reasonable
* [ ] Query plan reviewed for critical flows
* [ ] Batch write/read where possible

### Red Flags

* Full table scan
* N+1 query problem
* Missing index on search columns
* Row-by-row update loops

---

## 3. Application Performance Review

### Must Check

* [ ] Expensive loops optimized
* [ ] Avoid repeated object creation in hot path
* [ ] Serialization cost reviewed
* [ ] Reflection-heavy code minimized
* [ ] Proper data structures selected
* [ ] String concatenation optimized in loops

### Example

Use HashMap lookup instead of nested loops when possible.

---

## 4. Concurrency Review

### Must Check

* [ ] Thread pool bounded
* [ ] Queue size controlled
* [ ] Locks minimized
* [ ] Deadlock risk reviewed
* [ ] Shared mutable state protected
* [ ] Parallelism justified

### Red Flags

* new Thread() in request flow
* Unbounded executor
* Global synchronized bottleneck
* Parallel stream on blocking I/O

---

## 5. Memory Review

### Must Check

* [ ] No large object retention
* [ ] Streams/resources closed
* [ ] Cache size limited
* [ ] Collections pre-sized when useful
* [ ] Large response objects avoided
* [ ] Heap pressure reviewed

### Red Flags

* Static map growing forever
* Huge in-memory lists
* Loading full table into memory

---

## 6. Cache Review

### Must Check

* [ ] Correct cache key strategy
* [ ] TTL defined
* [ ] Invalidation plan exists
* [ ] Hot data identified
* [ ] Cache stampede considered
* [ ] Fallback if cache unavailable

### Red Flags

* Cache never expires
* Inconsistent stale data risk
* Cache sensitive data without controls

---

## 7. External Integration Review

### Must Check

* [ ] Timeout configured
* [ ] Retry with backoff
* [ ] Circuit breaker where needed
* [ ] Bulkhead isolation
* [ ] Connection pooling enabled
* [ ] Response size reasonable

### Red Flags

* Infinite wait on HTTP call
* Retry storm
* Shared pool exhaustion

---

## 8. Kafka / Async Performance Review

### Must Check

* [ ] Consumer concurrency tuned
* [ ] Batch consume strategy reviewed
* [ ] Producer linger/batch config appropriate
* [ ] Partition count sufficient
* [ ] Lag monitoring enabled
* [ ] Backpressure considered

### Red Flags

* Single consumer for heavy topic
* Large message payloads
* Blocking DB call per message without batching

---

## 9. Fintech / Banking Review

### Must Check

* [ ] Performance does not break consistency
* [ ] Retry does not duplicate money movement
* [ ] Ledger writes remain atomic
* [ ] Reconciliation jobs scalable
* [ ] Peak-hour traffic tested

### Golden Rule

Never trade financial correctness for speed.

---

## 10. Observability Review

### Must Check

* [ ] Metrics for latency, error, throughput
* [ ] Slow query logs enabled
* [ ] GC metrics visible
* [ ] CPU / memory dashboards exist
* [ ] Tracing for critical flows

---

## 11. Load Testing Review

### Must Check

* [ ] Baseline throughput measured
* [ ] Stress test executed
* [ ] Spike test executed
* [ ] Soak test executed
* [ ] Failure recovery tested
* [ ] Capacity limit documented

### Common Targets

* P95 latency
* P99 latency
* Error rate
* CPU usage
* Memory usage
* DB connection usage

---

## 12. Code Review Questions

* Can this endpoint handle 10x traffic?
* What is the slowest dependency?
* What happens under retry storm?
* Can memory usage grow unbounded?
* Where is the bottleneck?
* Is scaling horizontal or vertical?

---

## 13. Blockers

* [ ] Critical slow query unresolved
* [ ] No timeout on external calls
* [ ] Memory leak risk obvious
* [ ] Load test failed badly
* [ ] Throughput below business need
* [ ] CPU saturation under normal load

---

## 14. Optimization Order

1. Measure first
2. Fix biggest bottleneck
3. Re-test
4. Compare metrics
5. Keep readable code

---

## Golden Rule

Do not optimize guesses. Optimize measured bottlenecks.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

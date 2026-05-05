---
name: java-concurrency
description: Java concurrency standards for thread safety, executors, async flows, locks, and shared state. Use when writing concurrent backend code.
---

# Java Concurrency Guidelines

This skill converts `backend-engineer/java/concurrency.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Java Concurrency Guidelines

## Purpose

Define safe and efficient concurrency practices for Java applications.

Goals:

- thread safety
- predictable behavior
- performance
- scalability
- production stability

Applies to:

- Spring Boot services
- async jobs
- schedulers
- Kafka consumers
- batch systems
- high throughput APIs

---

# 1. Core Principle

Concurrency is hard.

Prefer simple designs first.

Use multithreading only when it provides clear value:

- parallel work
- non-blocking throughput
- background processing
- I/O overlap

Avoid threads for unnecessary complexity.

---

# 2. Prefer Stateless Design

Best thread-safe object = stateless object.

Good:

PaymentFeeCalculator.calculate(...)

No mutable shared fields.

Bad:

class FeeService {
private BigDecimal lastFee;
}

---

# 3. Prefer Immutability

Immutable objects are naturally thread-safe.

Use:

- final fields
- records
- no setters

Good for:

- DTOs
- configs
- events
- value objects

---

# 4. Avoid Shared Mutable State

Most concurrency bugs come from shared mutable objects.

Avoid:

static HashMap cache = new HashMap<>();

shared ArrayList writes

Prefer:

- local variables
- immutable objects
- thread-safe collections
- proper synchronization

---

# 5. Understand Race Conditions

Race condition = outcome depends on thread timing.

Bad:

count++;

This is not atomic.

Use:

- AtomicInteger
- synchronization
- locks

---

# 6. Use ExecutorService, Not Manual Threads

Bad:

new Thread(() -> work()).start();

Good:

ExecutorService executor = Executors.newFixedThreadPool(10);

Use managed thread pools.

---

# 7. Choose Correct Thread Pool

## Fixed Pool

Stable worker count.

Good for controlled workloads.

## Cached Pool

Dynamic threads.
Use carefully.

## Scheduled Pool

Delayed/repeated tasks.

## Virtual Threads (Java 21+)

Excellent for many blocking I/O tasks.

Use where supported.

---

# 8. Prefer CompletableFuture

For async composition.

Good:

CompletableFuture
.supplyAsync(...)
.thenApply(...)
.exceptionally(...);

Use for:

- parallel remote calls
- async workflows

Avoid callback hell.

---

# 9. Use Atomic Types

For simple shared counters/state.

Examples:

AtomicInteger
AtomicLong
AtomicBoolean
AtomicReference

Good:

retryCount.incrementAndGet();

---

# 10. synchronized Usage

Use when protecting shared critical sections.

Good:

synchronized(lock) {
updateBalance();
}

Avoid coarse giant synchronized blocks.

Too much locking reduces throughput.

---

# 11. Use Locks When Needed

Use ReentrantLock when advanced control needed.

Examples:

- tryLock
- timed lock
- interruptible lock

Prefer synchronized if simple.

---

# 12. ReadWriteLock

Use when:

- many readers
- few writers

Example:
config cache

Avoid unless real contention exists.

---

# 13. Concurrent Collections

Use thread-safe collections for shared access.

Examples:

ConcurrentHashMap
BlockingQueue
CopyOnWriteArrayList

Avoid:

HashMap with concurrent writes

---

# 14. BlockingQueue

Use producer-consumer workflows.

Examples:

- job processing
- retry queues
- background tasks

Types:

LinkedBlockingQueue
ArrayBlockingQueue

---

# 15. CopyOnWriteArrayList

Use when:

- reads frequent
- writes rare

Examples:

- listeners
- configuration snapshots

Avoid heavy write workloads.

---

# 16. ThreadLocal

Use carefully for per-thread context.

Examples:

- request correlation id
- security context (framework-managed)

Must clean up in pooled threads.

Bad:
memory leaks from forgotten remove().

---

# 17. Deadlock Prevention

Deadlock = threads waiting forever.

Avoid:

Thread A locks X then Y
Thread B locks Y then X

Use:

- consistent lock ordering
- timeout locks
- smaller lock scope

---

# 18. Minimize Lock Scope

Bad:

lock around network call

Good:

lock only shared state mutation

Keep critical sections short.

---

# 19. Visibility Problems

Without synchronization, one thread may not see latest value.

Use:

- volatile
- atomic classes
- locks
- concurrent collections

---

# 20. volatile Usage

Use for simple visibility flags.

Good:

volatile boolean running = true;

Not enough for compound operations like count++.

---

# 21. Parallel Streams

Use carefully.

Good for CPU-heavy independent computations.

Bad for:

- blocking I/O
- shared mutable state
- tiny lists

Avoid by default in server apps.

---

# 22. Timeouts Everywhere

Never wait forever on external systems.

Use timeouts for:

- Future.get()
- HTTP calls
- DB calls
- lock acquisition

Good:

future.get(3, TimeUnit.SECONDS);

---

# 23. Cancellation Support

Long-running tasks should support interruption.

Check:

Thread.currentThread().isInterrupted()

Restore interrupt when caught.

Good:

catch (InterruptedException e) {
Thread.currentThread().interrupt();
}

---

# 24. Exception Handling in Async Code

Always handle async failures.

Bad:

submit task and ignore exceptions

Good:

future.whenComplete(...)
log errors

---

# 25. Backpressure

When producers faster than consumers:

Need:

- bounded queues
- throttling
- rate limiting
- retry strategy

Avoid infinite queues.

---

# 26. Scheduler Guidelines

Use ScheduledExecutorService or framework scheduler.

Use for:

- polling
- cleanup jobs
- retries
- metrics refresh

Prevent overlapping jobs unless intended.

---

# 27. Spring Boot Considerations

Use:

@Async carefully
TaskExecutor config
bounded thread pools

Avoid default unbounded behavior without review.

---

# 28. Kafka Consumer Concurrency

Ensure:

- partition strategy understood
- idempotent processing
- thread-safe handlers
- offset commit correctness

Do not share unsafe mutable state across consumers.

---

# 29. Database + Concurrency

Thread safety in memory does not replace DB consistency.

Use:

- transactions
- optimistic locking
- pessimistic locking where needed

Example:
wallet balance update

---

# 30. Performance Rules

Too many threads can be slower.

Watch:

- context switching
- lock contention
- memory pressure
- blocked threads

Measure with profiling.

---

# 31. Monitoring

Track:

- active threads
- queue size
- rejected tasks
- task latency
- deadlocks
- blocked threads

Use metrics.

---

# 32. Common Mistakes

Avoid:

- new Thread everywhere
- static mutable lists
- synchronized entire service methods
- ignoring interrupts
- no timeout waits
- HashMap in concurrent writes
- hidden shared state

---

# 33. Testing Concurrent Code

Prefer deterministic design.

Use:

- unit tests for logic
- stress tests for race conditions
- integration tests for thread pools

Avoid flaky timing sleeps.

Bad:

Thread.sleep(1000)

---

# 34. Safe Patterns

Good:

stateless services

immutable DTOs

executor-managed async

ConcurrentHashMap cache

bounded queue worker model

---

# 35. Review Checklist

Before merge ask:

- Is concurrency necessary?
- Shared mutable state present?
- Correct collection type?
- Timeouts set?
- Interrupt handled?
- Lock scope minimal?
- Pool size controlled?
- Async exceptions handled?
- Observable metrics added?

---

# 36. Mandatory For AI Code Generation

When generating concurrent Java code:

- Prefer stateless design
- Prefer ExecutorService / CompletableFuture
- Use concurrent collections when shared
- Avoid manual thread creation
- Add timeouts
- Handle interruption properly
- Keep locking minimal
- Optimize for safety over cleverness

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

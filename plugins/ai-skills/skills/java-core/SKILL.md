---
name: java-core
description: Java core coding standards covering types, null safety, exceptions, streams, immutability, and modern Java. Use when writing any Java code.
---

# Java Core Guidelines

This skill converts `backend-engineer/java/java-core.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Java Core Guidelines

## Purpose

Define Java core coding standards and best practices for all Java projects.

Applies to:

- Spring Boot services
- Libraries
- Batch jobs
- Kafka consumers/producers
- Internal tools

Goals:

- clean code
- performance
- maintainability
- thread safety
- production readiness

---

# 1. Java Version Standard

Use project approved LTS version.

Preferred:

- Java 17
- Java 21

Use modern Java features when stable and readable.

Avoid legacy style when newer language features improve clarity.

---

# 2. Basic Coding Rules

Use:

- explicit readable code
- small methods
- immutable objects where possible
- constructor injection
- meaningful naming

Avoid:

- giant classes
- static mutable state
- hidden side effects
- deep inheritance

---

# 3. Primitive vs Wrapper Types

Use primitives when null is not needed.

Good:

int retryCount;
long timeoutMs;
boolean active;

Use wrappers only when needed:

Integer score;
Long customerId;

Cases:

- nullable values
- generic collections
- ORM mapping

---

# 4. String Handling

Use String for text.

Use StringBuilder for repeated concatenation in loops.

Bad:

String s = "";
for (...) {
s += item;
}

Good:

StringBuilder sb = new StringBuilder();

Rules:

- String is immutable
- avoid excessive concatenation in loops

---

# 5. equals and hashCode

Always implement together when needed.

Use for:

- entities
- value objects
- map keys
- set elements

Prefer Lombok or records when suitable.

Bad:

override equals only

---

# 6. toString

Provide safe readable toString.

Do not expose:

- passwords
- tokens
- secrets
- personal sensitive data

---

# 7. Immutability First

Prefer immutable classes.

Use:

- final fields
- no setters
- constructor initialization

Good:

public final class Money {
private final BigDecimal amount;
}

Benefits:

- safer concurrency
- easier debugging
- predictable behavior

---

# 8. Records

Use record for immutable DTO/value objects when appropriate.

Good:

public record PaymentRequest(
String customerId,
BigDecimal amount
) {}

Use for:

- request/response models
- commands
- simple value carriers

Avoid record for complex mutable domain entities.

---

# 9. Enums

Use enum instead of String constants.

Good:

enum PaymentStatus {
PENDING, SUCCESS, FAILED
}

Bad:

String status = "SUCCESS";

Benefits:

- type safety
- autocomplete
- safer refactor

---

# 10. Optional

Use Optional for return values where absence is valid.

Good:

Optional<Customer> findById(String id);

Avoid:

- Optional field in entity
- Optional parameter
- Optional in serialization models unless required

Bad:

void save(Optional<Customer> customer)

---

# 11. Null Handling

Prefer:

- validation
- Optional
- empty collections

Avoid returning null unexpectedly.

Good:

return Collections.emptyList();

---

# 12. Collections

Prefer interface types:

List
Set
Map

Good:

List<String> names = new ArrayList<>();

Bad:

ArrayList<String> names = new ArrayList<>();

Use concrete types internally when needed.

---

# 13. Collection Selection

Use:

List -> ordered sequence

Set -> unique values

Map -> key/value lookup

Queue -> FIFO processing

Deque -> stack/queue dual use

Choose by behavior, not habit.

---

# 14. BigDecimal for Money

Never use float/double for currency.

Bad:

double amount = 10.25;

Good:

BigDecimal amount = new BigDecimal("10.25");

Use proper rounding mode.

---

# 15. Date and Time API

Use java.time package.

Preferred:

Instant
LocalDate
LocalDateTime
ZonedDateTime
Duration

Avoid old Date / Calendar unless required.

Good:

Instant now = Instant.now();

---

# 16. Exception Handling

Use checked/unchecked intentionally.

Prefer runtime exceptions for business/application errors unless policy differs.

Rules:

- fail fast
- meaningful messages
- preserve root cause

Good:

throw new PaymentException("Insufficient balance", ex);

Bad:

throw new Exception();

---

# 17. Custom Exceptions

Create domain-specific exceptions.

Examples:

PaymentFailedException
FraudDetectedException
CustomerNotFoundException

Avoid generic RuntimeException everywhere.

---

# 18. try-with-resources

Use for closable resources.

Good:

try (InputStream in = ...) {
}

Use with:

- files
- streams
- DB/manual resources

---

# 19. Streams API

Use streams when clearer than loops.

Good:

var activeUsers =
users.stream()
.filter(User::isActive)
.toList();

Avoid streams for overly complex logic.

Bad:

giant nested stream pipelines no one understands.

Use loop when simpler.

---

# 20. Lambdas

Use concise functional behavior.

Good:

items.forEach(this::process);

Avoid unreadable inline logic blocks.

---

# 21. Generics

Use generics for type safety.

Good:

List<Customer>

Avoid raw types:

List list = new ArrayList();

---

# 22. var Usage

Use var only when type is obvious.

Good:

var customers = customerRepository.findAll();

Bad:

var x = computeSomethingComplicated();

Prefer explicit type when readability improves.

---

# 23. Static Usage

Use static for:

- constants
- pure utility methods
- factory methods

Avoid static mutable shared state.

Bad:

public static Map cache = new HashMap();

---

# 24. Thread Safety Basics

Know object mutability.

Shared mutable state requires synchronization strategy.

Prefer:

- immutable objects
- concurrent collections
- scoped state

Avoid random synchronized everywhere.

---

# 25. Serialization

Be explicit for JSON models.

Avoid exposing internal domain models directly.

Use DTOs.

---

# 26. Performance Basics

Watch for:

- unnecessary object creation
- repeated string concat
- boxing/unboxing hot paths
- N+1 DB queries
- large stream overhead in hot loops

Measure before optimizing.

---

# 27. Memory Awareness

Avoid retaining unused references.

Examples:

- large static caches
- listeners not removed
- giant in-memory lists unnecessarily

---

# 28. Logging

Use structured logs.

Good:

log.info("Payment created txnId={} customerId={}", txnId, customerId);

Never log:

- passwords
- tokens
- secret keys
- card full numbers

---

# 29. Testing Friendly Code

Prefer:

- dependency injection
- deterministic methods
- small classes
- pure functions where possible

Avoid:

new dependency inside method when injectable.

---

# 30. Package Structure

Use domain-based packages.

Good:

payment/
customer/
wallet/

Avoid:

utils/
misc/
temp/

---

# 31. Code Smells

Refactor when you see:

- class > 500 lines
- method > 50 lines
- too many constructor args
- primitive obsession
- duplicated logic
- many null checks everywhere

---

# 32. Review Checklist

Before merge ask:

- Modern Java used appropriately?
- Null safe?
- Correct collection type?
- BigDecimal for money?
- Clear exception handling?
- Readable streams?
- Immutable where possible?
- Logs safe?
- Easy to test?

---

# 33. Mandatory For AI Code Generation

When generating Java code:

- Use modern Java LTS style
- Prefer records for DTO when suitable
- Use BigDecimal for money
- Use java.time for dates
- Use Optional for optional returns
- Prefer constructor injection
- Avoid legacy APIs
- Keep code production-ready

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

# CODEX.md — Engineering Agent System Contract

## Purpose

This file defines the **global operating system rules** for AI-assisted software generation in this repository.

It acts as the **highest authority rule set** overriding all other guidelines.

It is designed for:

* AI coding agents (Codex / GPT / internal generators)
* Senior backend engineering standards
* Fintech / banking / microservice production systems

---

# 1. Global Engineering Philosophy

## 1.1 Core Principles

* Correctness > Performance > Convenience
* Deterministic behavior > clever optimizations
* Explicit > implicit
* Production safety is mandatory
* Simplicity is a system feature

---

## 1.2 Engineering Mindset

Every generated system must assume:

* Real users
* Real money (fintech context)
* Real failure scenarios
* Distributed systems instability

---

# 2. Architecture Rules (STRICT)

## 2.1 Clean Architecture Enforcement

```text
Controller → Application → Domain → Infrastructure
```

### Rules

* Domain is framework-free
* Application orchestrates use cases only
* Controller is a thin adapter
* Infrastructure is replaceable

---

## 2.2 Dependency Rule

* Inner layers must NOT depend on outer layers
* Domain must NOT import Spring, JPA, Kafka
* Infrastructure implements ports only

---

## 2.3 Communication Rule

* All inter-layer communication via:

    * Command
    * DTO
    * Port interfaces
* MapStruct is mandatory for mapping

---

# 3. Code Generation Rules

## 3.1 Mandatory Structure

Every generated module MUST include:

* Controller layer
* Application (use case) layer
* Domain layer
* Infrastructure layer
* Mapper layer (MapStruct)
* Validation layer
* Exception handling

---

## 3.2 Clean Code Rules

* Small functions (< 30 lines preferred)
* Single responsibility
* No duplication
* No magic numbers
* Early return preferred
* Meaningful naming

---

## 3.3 Naming Rules

* Class: PascalCase
* Method: camelCase verb-based
* Constant: UPPER_SNAKE_CASE
* Package: domain-based structure

---

# 4. Java Standards

## 4.1 Core Rules

* Use BigDecimal for money
* Avoid float/double for financial data
* Prefer immutable objects
* Avoid raw types

---

## 4.2 Concurrency Rules

* No unmanaged thread creation
* Use framework-managed executor pools
* Avoid shared mutable state

---

# 5. Spring Boot Rules

## 5.1 Controller Rules

* No business logic
* No DB access
* Only validation + delegation

---

## 5.2 Validation Rules

* Use Bean Validation (@Valid)
* Fail fast on invalid input

---

## 5.3 Exception Handling

* Centralized global exception handler required
* No raw exception exposure
* Standardized error response format

---

# 6. Microservice Rules

## 6.1 Communication

* Sync: REST / gRPC
* Async: Kafka

---

## 6.2 Mandatory Patterns

When applicable:

* Outbox Pattern
* Saga Pattern
* CQRS
* Idempotency Key Pattern

---

## 6.3 Reliability Rules

* All external calls must have timeout
* Retry with exponential backoff
* Circuit breaker for critical dependencies

---

# 7. Fintech / Banking Rules (CRITICAL)

## 7.1 Money Rules

* Always use BigDecimal
* Never use floating types
* Ensure precision and rounding rules explicitly defined

---

## 7.2 Ledger Rules

* Double-entry accounting MUST balance
* Debit == Credit always
* Every transaction must be traceable

---

## 7.3 Idempotency

* All payment APIs must be idempotent
* Duplicate requests must NOT duplicate money movement

---

# 8. Kafka / Event Rules

## 8.1 Producer

* Must define event key strategy
* Must include metadata:

    * eventId
    * traceId
    * timestamp

---

## 8.2 Consumer

* Must be idempotent
* Must support retry + DLQ
* Must tolerate duplicate events

---

# 9. Observability Rules

## 9.1 Logging

* Structured logging required
* Must include traceId
* No sensitive data logging

---

## 9.2 Metrics

* latency (P95 / P99)
* throughput
* error rate
* system resource usage

---

## 9.3 Tracing

* Distributed tracing mandatory
* Correlation ID required across all services

---

# 10. Security Rules

## 10.1 API Security

* JWT authentication required
* Role-based authorization
* Input validation mandatory

---

## 10.2 Data Security

* No secrets in code
* Mask sensitive logs
* Encrypt sensitive data when needed

---

## 10.3 Threat Prevention

* SQL Injection protection
* XSS protection
* Rate limiting for public APIs

---

# 11. Testing Rules

## 11.1 Test Pyramid

* Unit tests (primary)
* Integration tests (secondary)
* E2E tests (minimal critical flows)

---

## 11.2 Required Coverage

* Business logic
* Edge cases
* Failure scenarios
* Idempotency
* Concurrency safety

---

# 12. Infrastructure Rules

* Data sources are infrastructure only
* No business logic allowed in infrastructure
* Must support retry / timeout / observability

---

# 13. Performance Rules

* Measure before optimizing
* DB optimization first
* Avoid premature optimization

---

# 14. Code Review Standards

Priority order:

1. Security
2. Correctness
3. Architecture compliance
4. Performance
5. Readability

---

# 15. STRICT Anti-Patterns

* Business logic in controller
* Direct DB access from domain
* Missing idempotency in payment flows
* Hardcoded secrets
* No timeout on external calls
* God classes / services

---

# 16. AI Generation Contract

When generating code:

* Always follow Clean Architecture
* Always separate layers
* Always include mapping layer (MapStruct)
* Always include validation
* Always include exception handling
* Always assume production usage

---

# 17. Fintech Safety Rule

> If money is involved, correctness is non-negotiable.

---

# 18. SYSTEM RULE

This file overrides ALL other guidelines in case of conflict.

---

# 19. Golden Rule

Every generated system must be safe for production financial workloads.

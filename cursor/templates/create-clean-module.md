# create-clean-module.md — Clean Module (DDD Bounded Context) Generator Template

## Purpose

This template defines how to generate a **complete Clean Architecture module (bounded context)** following DDD
principles for enterprise Spring Boot microservices.

A module represents a **self-contained business domain unit** such as:

* payment
* wallet
* ledger
* transfer
* reconciliation

---

# 1. INPUT SPECIFICATION

## 1.1 Required Input

```text
moduleName: string
boundedContext: string
description: string
entities: list
useCases: list
integrations: list (Kafka / DB / External API)
consistencyLevel: EVENTUAL | STRONG
securityLevel: HIGH | MEDIUM | LOW
```

---

## 1.2 Example Input

```text
moduleName: payment-module
boundedContext: payment
description: "Handle payment lifecycle from initiation to completion"
entities: Payment, PaymentStatus
useCases: CreatePayment, ConfirmPayment, CancelPayment
integrations: Kafka, MySQL
consistencyLevel: EVENTUAL
securityLevel: HIGH
```

---

# 2. OUTPUT STRUCTURE

Generated module MUST follow:

```text
module/
 ├── controller/
 ├── application/
 ├── domain/
 ├── infrastructure/
 ├── mapper/
 ├── dto/
 ├── exception/
 ├── config/
 └── test/
```

---

# 3. DOMAIN-DRIVEN DESIGN RULES

## 3.1 Bounded Context

* Each module is isolated
* No direct dependency on other domain models
* Integration only via events or ports

---

## 3.2 Aggregates

* Each entity must belong to an aggregate
* Only aggregate root can be modified externally

Example:

```text
Payment (Aggregate Root)
 └── PaymentItem (Entity)
```

---

## 3.3 Value Objects

* Immutable
* No identity
* Encapsulate business rules

Examples:

* Money
* Currency
* AccountNumber

---

# 4. CLEAN ARCHITECTURE RULES

## Layer Flow

```text
Controller → Application → Domain → Infrastructure
```

## Rules

* Domain is framework-free
* Application orchestrates use cases
* Infrastructure implements ports
* Controller is thin only

---

# 5. MODULE GENERATION STEPS

## Step 1: Domain Modeling

Generate:

* Entities
* Value Objects
* Aggregates
* Domain rules

---

## Step 2: Use Case Design

Each use case MUST be explicit:

* CreateX
* UpdateX
* CancelX
* QueryX

Rules:

* No framework dependency
* One responsibility per use case

---

## Step 3: Ports Definition

Define interfaces:

```java
PaymentRepositoryPort
        EventPublisherPort
ExternalGatewayPort
        IdempotencyPort
```

---

## Step 4: Infrastructure Layer

Implement:

* JPA repositories
* Kafka producers/consumers
* External API clients
* Redis cache adapters

---

## Step 5: Application Layer

Rules:

* Transaction boundary here
* Orchestrate domain + infrastructure
* No technical logic leakage

---

## Step 6: Controller Layer

Rules:

* Validate request
* Call use case
* Return response DTO

---

## Step 7: Mapping Layer

Use MapStruct:

* DTO → Command
* Entity → Response

---

# 6. EVENT-DRIVEN RULES

If integrations include Kafka:

* Use Outbox Pattern
* Ensure eventId + traceId included
* Guarantee idempotent consumers

---

# 7. FINTECH RULES (CRITICAL)

## 7.1 Money Safety

* Always use BigDecimal
* Never use float/double

---

## 7.2 Ledger Consistency

* Debit must equal Credit
* No partial state allowed

---

## 7.3 Idempotency

* All write operations must support idempotency key

---

## 7.4 Transaction Safety

* Use DB transaction in application layer
* Ensure atomic business operations

---

# 8. SECURITY RULES

If securityLevel = HIGH:

* JWT authentication required
* Role-based access control
* Input validation mandatory

---

# 9. CONSISTENCY MODEL

## STRONG

* Immediate consistency required
* No eventual delay allowed

## EVENTUAL

* Kafka/event-driven allowed
* Read-after-write may be delayed

---

# 10. OBSERVABILITY

Must include:

* structured logging
* traceId propagation
* metrics hooks
* audit logs (for financial actions)

---

# 11. TESTING REQUIREMENTS

## Must generate:

* Domain unit tests
* Use case tests
* Integration tests
* API tests

---

# 12. PERFORMANCE RULES

* Avoid N+1 queries
* Batch writes when possible
* Use pagination for queries
* Optimize hot paths first

---

# 13. ANTI-PATTERNS (FORBIDDEN)

* Business logic in controller
* Direct DB access from domain
* Missing idempotency
* No transaction boundaries
* God module design
* Cross-module tight coupling

---

# 14. OUTPUT REQUIREMENTS

Generated module MUST include:

* Full Clean Architecture structure
* Complete domain model
* Use cases
* Ports & adapters
* DTOs + mappers
* Tests
* Configurations

---

# 15. GOLDEN RULE

A module must be independently deployable, testable, and safe for production financial workloads.

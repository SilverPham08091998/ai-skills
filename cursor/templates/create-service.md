# create-service.md — Microservice Generator Template

## Purpose

This template defines the **standardized process to generate a production-ready Spring Boot microservice** following
Clean Architecture, Fintech-grade standards, and enterprise patterns.

It is used by AI agents to scaffold full services consistently.

---

# 1. INPUT SPECIFICATION

## 1.1 Required Input

When generating a service, the following inputs MUST be provided:

```text
serviceName: string
domain: string (e.g. payment, wallet, banking)
useCase: string (business description)
apiType: REST | Kafka | Hybrid
dataStore: MySQL | PostgreSQL | MongoDB
asyncRequired: boolean
securityLevel: HIGH | MEDIUM | LOW
```

---

## 1.2 Example Input

```text
serviceName: payment-service
domain: payment
useCase: "Process payment transaction with idempotency"
apiType: REST + Kafka
dataStore: MySQL
asyncRequired: true
securityLevel: HIGH
```

---

# 2. OUTPUT REQUIREMENTS

Generated service MUST include:

## 2.1 Layer Structure

```text
controller/
application/
domain/
infrastructure/
mapper/
config/
exception/
```

---

## 2.2 Mandatory Components

* REST Controllers
* Use Cases (Application layer)
* Domain Model
* Repository Ports
* Infrastructure Adapters
* MapStruct Mappers
* DTOs (Request/Response)
* Global Exception Handler
* Validation layer
* Configuration classes

---

# 3. ARCHITECTURE RULES

## 3.1 Clean Architecture Enforcement

```text
Controller → Application → Domain → Infrastructure
```

### Rules

* Domain MUST NOT depend on Spring
* Application MUST NOT access DB directly
* Infrastructure implements Ports
* Controller is thin only

---

## 3.2 Dependency Rule

* No cyclic dependency
* No framework leakage into domain
* Ports define contracts

---

# 4. SERVICE GENERATION STEPS

## Step 1: Domain Modeling

Create:

* Entity
* Value Objects
* Domain Rules

Example:

```text
Payment
- amount
- currency
- status
- createdAt
```

---

## Step 2: Application Layer (Use Cases)

Create business flows:

* CreatePaymentUseCase
* ConfirmPaymentUseCase
* CancelPaymentUseCase

Rules:

* No framework dependency
* Pure orchestration logic

---

## Step 3: Ports Definition

Define interfaces:

```java
PaymentRepositoryPort
        EventPublisherPort
IdempotencyPort
```

---

## Step 4: Infrastructure Implementation

Implement:

* JPA Repository
* Kafka Producer
* External API clients

---

## Step 5: Controller Layer

Rules:

* Validate input
* Call UseCase only
* No business logic

---

## Step 6: Mapping Layer

Use MapStruct:

* DTO → Command
* Entity → Response

---

## Step 7: Exception Handling

Must include:

* BusinessException
* ValidationException
* GlobalExceptionHandler

---

## Step 8: Security Layer

If securityLevel = HIGH:

* JWT authentication
* Role-based authorization
* Request validation

---

## Step 9: Observability

Must include:

* Structured logging
* traceId propagation
* metrics hooks

---

# 5. FINTECH RULES (CRITICAL)

## 5.1 Idempotency

* Every write API MUST support idempotency key

---

## 5.2 Money Handling

* Use BigDecimal only
* No float/double allowed

---

## 5.3 Transaction Safety

* Use DB transaction boundary in application layer
* Ensure consistency before event publish

---

## 5.4 Event Publishing

If asyncRequired = true:

* Use Outbox Pattern
* Ensure at-least-once delivery

---

# 6. KAFKA INTEGRATION RULES

If apiType includes Kafka:

* Define event schema
* Include eventId + traceId
* Ensure consumer idempotency

---

# 7. DATABASE RULES

* Use repository abstraction (Port)
* No direct JPA usage in domain/application
* Index critical query fields

---

# 8. ERROR HANDLING RULES

## Standard Error Response

```json
{
  "code": "ERROR_CODE",
  "message": "Human readable message",
  "traceId": "xxx"
}
```

---

# 9. TESTING REQUIREMENTS

## Must generate:

* Unit tests (domain + use case)
* Integration tests (controller + DB)
* API tests (RestAssured)

---

# 10. CODE QUALITY RULES

* Small methods
* No duplication
* Explicit naming
* No magic values
* Early return

---

# 11. OUTPUT FORMAT

Generated output MUST include:

```text
- Full folder structure
- All source code
- DTOs
- Mappers
- Tests
- Configuration
```

---

# 12. ANTI-PATTERNS (FORBIDDEN)

* Business logic in controller
* Direct DB access in domain
* Missing idempotency in payment services
* No exception handler
* God service class

---

# 13. FINAL RULE

Generated service must be:

* Production ready
* Fintech safe
* Clean Architecture compliant
* Testable
* Observable
* Scalable

---

# 14. GOLDEN RULE

If a service cannot safely handle real money flows, it is considered invalid.

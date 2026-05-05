# create-endpoint.md — API Endpoint Generator Template

## Purpose

This template defines how to generate a **single production-ready REST API endpoint** following Clean Architecture,
Fintech-grade safety rules, and enterprise Spring Boot standards.

It is used by AI agents to generate:

* Controller
* Use Case
* Domain logic
* Infrastructure adapters
* DTOs
* Mapper
* Tests

---

# 1. INPUT SPECIFICATION

## 1.1 Required Input

```text
endpointName: string
httpMethod: GET | POST | PUT | DELETE
path: string
domain: string
useCase: string
requestModel: object structure
responseModel: object structure
security: PUBLIC | AUTHENTICATED | ADMIN
asyncFlow: boolean
idempotent: boolean
```

---

## 1.2 Example Input

```text
endpointName: createPayment
httpMethod: POST
path: /api/v1/payments
domain: payment
useCase: "Create payment transaction with idempotency"
requestModel: { amount, currency, fromAccount, toAccount }
responseModel: { paymentId, status }
security: AUTHENTICATED
asyncFlow: true
idempotent: true
```

---

# 2. OUTPUT STRUCTURE

Generated endpoint MUST include:

```text
controller/
application/
domain/
infrastructure/
mapper/
dto/
exception/
test/
```

---

# 3. CLEAN ARCHITECTURE RULES

## Flow

```text
Controller → Application → Domain → Infrastructure
```

## Rules

* Controller = thin layer only
* Application = use case orchestration
* Domain = business rules only
* Infrastructure = external systems

---

# 4. GENERATION STEPS

## Step 1: Define DTOs

* Request DTO
* Response DTO

Rules:

* Validation annotations required
* No business logic

---

## Step 2: Create Use Case

Example:

```text
CreatePaymentUseCase
```

Rules:

* No Spring dependency
* Transaction boundary here
* Calls domain logic

---

## Step 3: Domain Logic

Define:

* Entity
* Value objects
* Business rules

Example:

```text
Payment.validateAmount()
Payment.process()
```

---

## Step 4: Ports Definition

```java
PaymentRepositoryPort
        PaymentEventPublisherPort
IdempotencyPort
```

---

## Step 5: Infrastructure Implementation

* JPA repository
* Kafka producer (if asyncFlow)
* External API client (if needed)

---

## Step 6: Controller

Rules:

* Only request validation
* Delegate to UseCase
* Return response DTO

---

## Step 7: Mapping Layer

Use MapStruct:

* Request → Command
* Entity → Response

---

## Step 8: Exception Handling

Must support:

* ValidationException
* BusinessException
* Global error response

---

# 5. FINTECH RULES (CRITICAL)

## 5.1 Idempotency

If idempotent = true:

* Require Idempotency-Key header
* Store request hash
* Prevent duplicate execution

---

## 5.2 Money Handling

* Use BigDecimal only
* No float/double allowed
* Explicit rounding rules

---

## 5.3 Transaction Safety

* DB transaction inside UseCase
* No partial state commits

---

## 5.4 Async Flow

If asyncFlow = true:

* Use Outbox Pattern
* Ensure at-least-once delivery
* Consumer must be idempotent

---

# 6. SECURITY RULES

## If security = AUTHENTICATED

* JWT validation required
* User context required

## If security = ADMIN

* Role-based authorization required

---

# 7. VALIDATION RULES

* Use Bean Validation (@Valid)
* Validate at controller boundary
* Reject invalid input early

---

# 8. ERROR HANDLING

## Standard Response

```json
{
  "code": "ERROR_CODE",
  "message": "Human readable message",
  "traceId": "xxx"
}
```

---

# 9. OBSERVABILITY

Must include:

* traceId propagation
* structured logs
* latency metrics

---

# 10. TESTING REQUIREMENTS

Generate:

## Unit Tests

* Domain logic
* UseCase logic

## Integration Tests

* Controller + DB

## API Tests

* REST validation (RestAssured)

---

# 11. PERFORMANCE RULES

* Avoid N+1 queries
* Use pagination for list APIs
* Index key fields

---

# 12. ANTI-PATTERNS (FORBIDDEN)

* Business logic in controller
* Direct DB access in domain
* Missing idempotency for payment APIs
* No exception handling
* Hardcoded secrets

---

# 13. OUTPUT REQUIREMENT

Generated endpoint MUST include:

* Full working code
* DTOs
* Mapper
* UseCase
* Domain logic
* Repository ports
* Infrastructure adapters
* Tests

---

# 14. GOLDEN RULE

A single endpoint must be safe for production financial traffic if deployed as-is.

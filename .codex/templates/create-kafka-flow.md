# create-kafka-flow.md — Kafka Event Flow Generator Template

## Purpose

This template defines how to generate a **production-ready Kafka-based event-driven flow** in a Clean Architecture +
Fintech system.

It includes:

* Producer service
* Outbox pattern (optional but recommended)
* Kafka topics design
* Consumer service
* Retry / DLQ strategy
* Idempotency handling
* Observability

---

# 1. INPUT SPECIFICATION

## 1.1 Required Input

```text
flowName: string
eventDomain: string
producerService: string
consumerService: string
eventType: string
payloadSchema: object
consistency: EVENTUAL | STRONG (via sync fallback)
reliability: AT_LEAST_ONCE | EXACTLY_ONCE (logical)
idempotencyRequired: boolean
useOutbox: boolean
```

---

## 1.2 Example Input

```text
flowName: payment-created-flow
eventDomain: payment
producerService: payment-service
consumerService: ledger-service
eventType: PaymentCreated
payloadSchema: { paymentId, amount, currency, status }
consistency: EVENTUAL
reliability: AT_LEAST_ONCE
idempotencyRequired: true
useOutbox: true
```

---

# 2. OUTPUT ARTIFACTS

Generated flow MUST include:

```text
producer/
consumer/
event/
config/
infrastructure/
application/
domain/
retry/
dlq/
test/
```

---

# 3. KAFKA DESIGN RULES

## 3.1 Topic Naming Convention

```text
{domain}.{eventType}.v1
```

Example:

```text
payment.payment-created.v1
```

---

## 3.2 Event Structure (MANDATORY)

```json
{
  "eventId": "uuid",
  "eventType": "PaymentCreated",
  "timestamp": "ISO-8601",
  "traceId": "string",
  "version": 1,
  "payload": {}
}
```

---

## 3.3 Partition Strategy

* Use aggregateId (e.g. paymentId)
* Ensures ordering per entity

---

# 4. PRODUCER DESIGN

## 4.1 Responsibility

* Publish event to Kafka
* Attach metadata
* Ensure retry-safe publishing

---

## 4.2 With Outbox Pattern (if enabled)

Flow:

```text
DB Transaction
  ├── business table update
  ├── outbox_event insert
COMMIT

Outbox Publisher
  ├── read events
  ├── publish Kafka
  ├── mark SENT
```

---

## 4.3 Producer Rules

* Never publish directly inside business transaction (if useOutbox = true)
* Always include traceId
* Must be retry-safe

---

# 5. CONSUMER DESIGN

## 5.1 Responsibility

* Consume event
* Apply business logic
* Ensure idempotency
* Persist state changes

---

## 5.2 Idempotency Rule (CRITICAL)

Must check:

```text
eventId uniqueness OR business key uniqueness
```

---

## 5.3 Processing Flow

```text
Receive Event
 → Validate
 → Check Idempotency
 → Execute UseCase
 → Save state
 → Acknowledge
```

---

# 6. RETRY & DLQ STRATEGY

## 6.1 Retry Policy

* Retry on transient errors
* Exponential backoff
* Max retry count defined

---

## 6.2 Dead Letter Queue (DLQ)

* Move failed messages after max retries
* Must store error reason
* Must support manual replay

---

# 7. CLEAN ARCHITECTURE INTEGRATION

## Producer Side

```text
Application → Domain → OutboxRepositoryPort → Infrastructure
```

## Consumer Side

```text
Kafka Listener → Application UseCase → Domain → Repository
```

---

# 8. FINTECH RULES (CRITICAL)

## 8.1 Money Safety

* Never update balance twice for same event
* Always idempotent consumer

---

## 8.2 Ledger Consistency

* Every debit must have credit
* No partial updates

---

## 8.3 Event Trust

* Events are NOT source of truth
* Database is source of truth

---

# 9. ERROR HANDLING

## Types

* Deserialization error → DLQ
* Business error → skip or compensating flow
* System error → retry

---

# 10. OBSERVABILITY

## Must include:

* traceId propagation
* eventId logging
* consumer lag metrics
* retry count metrics
* DLQ count

---

# 11. CONFIGURATION RULES

* Kafka consumer group per service
* Separate topics per domain event
* Enable auto commit = false

---

# 12. TESTING STRATEGY

## Must generate:

* Producer unit tests
* Consumer unit tests
* Integration tests with Testcontainers Kafka
* Idempotency tests
* DLQ scenario tests

---

# 13. PERFORMANCE RULES

* Batch consumption preferred
* Avoid heavy processing in consumer thread
* Use async processing when needed

---

# 14. ANTI-PATTERNS (FORBIDDEN)

* No idempotency check
* Direct DB update without event safety
* No retry strategy
* Blocking long processing in Kafka listener
* Ignoring DLQ

---

# 15. OUTPUT REQUIREMENTS

Generated flow MUST include:

* Producer implementation
* Consumer implementation
* Event schema
* Kafka config
* Retry/DLQ config
* Tests

---

# 16. GOLDEN RULE

Kafka flow must be safe under duplicate, retry, and failure conditions without data corruption.

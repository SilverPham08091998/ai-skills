---
name: microservice-outbox
description: Transactional outbox pattern rules for microservices. Use when publishing reliable events from database-backed business transactions.
---

# Microservice Outbox Guidelines

This Cursor skill adapts `backend-engineer/microservice-pattern/outbox.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Transactional Outbox Pattern Guidelines

## Objective

Guarantee reliable event/message publishing when business data changes are committed to a database, avoiding dual-write
inconsistency between database and message broker.

---

## Problem Statement

A service needs to:

1. Save business data to database
2. Publish event to Kafka/RabbitMQ

### Risky Dual Write Flow

```text
Save DB SUCCESS
Publish Event FAILED
```

Result:

* data changed
* downstream systems unaware
* inconsistent distributed state

### Another Risk

```text
Publish SUCCESS
Save DB FAILED
```

Result:

* event exists without real data

---

## Solution Overview

Write business data **and** outbox event record in the **same local database transaction**.

Then a separate publisher process reads pending outbox rows and publishes to broker.

---

## Core Flow

### Step 1: Inside Transaction

* save order/payment/transaction data
* insert outbox row
* commit once

### Step 2: Async Publisher

* poll outbox table
* publish message
* mark row as sent

---

## Architecture

```text
Controller
 -> UseCase
 -> Domain Logic
 -> DB Transaction:
      - business tables
      - outbox table

Outbox Publisher
 -> read pending rows
 -> publish Kafka
 -> mark SENT
```

---

## Outbox Table Example

```sql
CREATE TABLE outbox_event
(
    id             VARCHAR(64) PRIMARY KEY,
    aggregate_type VARCHAR(50),
    aggregate_id   VARCHAR(64),
    event_type     VARCHAR(100),
    payload        JSON,
    status         VARCHAR(20),
    retry_count    INT,
    created_at     TIMESTAMP,
    sent_at        TIMESTAMP NULL
);
```

---

## Recommended Columns

* id
* aggregate_type (PAYMENT, ORDER)
* aggregate_id
* event_type
* payload
* status (NEW, SENT, FAILED)
* retry_count
* next_retry_at
* created_at
* sent_at
* trace_id
* version

---

## Spring Boot Example Flow

## Use Case

```java

@Transactional
public void createPayment(Command cmd) {
    paymentRepo.save(payment);
    outboxRepo.save(event);
}
```

## Publisher Job

```java
List<OutboxEvent> events = repo.findPending();
for(...){
        kafkaTemplate.

send(...);
   repo.

markSent(id);
}
```

---

## Delivery Semantics

Usually:

* At least once delivery

Meaning duplicate publish may happen.

Consumers must be idempotent.

---

## Why It Works

Because DB commit is atomic:

* business data saved
* outbox record saved together

No partial success between DB and event intent.

---

## Publisher Strategies

## 1. Polling Publisher

Periodic scheduler reads NEW rows.

Pros:

* simple
* common

Cons:

* slight delay

## 2. CDC (Change Data Capture)

Use Debezium reads outbox table changes.

Pros:

* near real-time
* scalable

Cons:

* more infrastructure complexity

---

## Kafka Usage Guidance

### Topic Key

Use aggregate_id for ordering.

### Example

paymentId as partition key.

### Include Metadata

* eventId
* occurredAt
* version
* traceId

---

## Consumer Requirements

### Must Be Idempotent

Handle duplicate event safely.

Examples:

* ignore processed eventId
* upsert by business key
* maintain processed_event table

---

## Fintech / Banking Use Cases

### Excellent For

* payment created -> notify ledger
* transfer success -> notify notification service
* bill paid -> reward points event
* wallet topup -> reconciliation event
* refund completed -> accounting event

### Golden Rule

Never lose financial events after money state changes.

---

## Failure Handling

### Publish Failed

* increment retry_count
* exponential backoff
* move to DEAD status after threshold
* alert support team

### DB Commit Failed

Nothing saved. Safe rollback.

---

## Retry Strategy

Example:

* retry after 1m
* 5m
* 15m
* 1h
* dead-letter/manual review

---

## Ordering Considerations

For same aggregate:

* publish in created order
* use partition key consistently
* sequence/version field useful

---

## Performance Considerations

* batch publish rows
* index status + created_at
* archive old SENT rows
* shard outbox if huge scale

---

## Security Considerations

* payload encryption if sensitive
* mask PII
* access control to outbox table
* audit manual replay actions

---

## Observability

### Metrics

* pending rows count
* publish success rate
* publish latency
* retry count
* dead rows count
* oldest pending age

### Alerts

* backlog growing
* retries spike
* dead events > threshold

---

## Testing Strategy

### Must Test

* transaction rollback means no outbox row
* commit creates row
* publisher marks sent
* duplicate publish tolerated by consumer
* retry logic works
* crash between send and markSent handled

---

## Common Anti Patterns

* Save DB then direct publish in same method only
* Delete row before broker ack
* No retry_count tracking
* Non-idempotent consumers
* Huge payload blobs without need
* No monitoring backlog

---

## Related Patterns

* Saga
* CDC / Debezium
* Idempotent Consumer
* Event Sourcing (different purpose)

---

## Review Checklist

* [ ] DB + outbox same transaction
* [ ] Publisher reliable
* [ ] Consumer idempotent
* [ ] Retry/backoff defined
* [ ] Metrics/alerts ready
* [ ] Ordering considered
* [ ] Financial events protected

---

## Golden Rule

If data commit matters, the corresponding event must be recoverably publishable.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

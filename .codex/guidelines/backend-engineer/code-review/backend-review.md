# Backend Code Review Guidelines

## Objective

Ensure backend source code is:

* Correct
* Maintainable
* Secure
* Performant
* Testable
* Production-ready
* Clean Architecture compliant
* Fintech / Banking safe

---

## Review Priority Order

1. Security
2. Data correctness
3. Business logic
4. Transaction consistency
5. Performance
6. Maintainability
7. Style

---

## 1. Architecture Review

### Must Check

* Controller -> Application -> Domain -> Port -> Infrastructure
* No controller business logic
* No controller direct repository call
* Domain must not depend on Spring
* Application must not depend on controller DTO

### Red Flags

* God service class
* Utility class contains business logic
* Mixed responsibilities

---

## 2. Controller Review

### Must Check

* Thin controller
* Validate request input
* Correct HTTP method usage
* Correct status codes
* DTO mapped to Command / Query object

### Example Good

```java

@PostMapping
public ResponseEntity<?> create(@Valid @RequestBody Request req) {
    return ResponseEntity.ok(useCase.execute(mapper.toCommand(req)));
}
```

---

## 3. Application Layer Review

### Must Check

* Use case oriented naming
* Clear transaction boundary
* Idempotency for retryable requests
* Coordinates flow only
* No framework leakage

### Good Names

* CreateWalletUseCase
* TransferMoneyUseCase
* RefundPaymentUseCase

---

## 4. Domain Review

### Must Check

* Rich domain model
* Business rules inside entity/domain service
* Invariants protected
* Use value objects

### Good Example

```java
wallet.debit(amount);
wallet.

credit(amount);
```

### Bad Example

```java
wallet.setBalance(...);
```

---

## 5. Infrastructure Review

### Must Check

* Repository implementation clean
* Timeout / retry / circuit breaker for external APIs
* Avoid N+1 query
* Proper indexes
* Use MapStruct for mapping

---

## 6. Security Review

### Must Check

* JWT validated
* Authorization enforced
* Secrets not hardcoded
* Sensitive data not logged
* SQL Injection prevention
* XSS prevention

### Never Log

* password
* OTP
* PIN
* token
* secret key

---

## 7. Performance Review

### Must Check

* Pagination exists
* Batch insert/update where needed
* No repeated remote calls
* Caching opportunities reviewed
* Executor/thread pool bounded

---

## 8. Kafka / Async Review

### Must Check

* Producer key strategy
* Schema versioning
* Consumer idempotency
* Retry + DLQ flow
* Offset commit strategy

---

## 9. Fintech Specific Review

### Must Check

* Debit total == Credit total
* BigDecimal for money
* Currency rounding rules
* Reconciliation reference IDs
* Audit trail available

### Need Traceability

* who
* when
* request id
* before state
* after state

---

## 10. Testing Review

### Must Check

* Unit tests for business rules
* Integration tests for DB / Kafka / APIs
* Edge cases covered
* Duplicate request tests
* Timeout tests
* Concurrency tests

---

## 11. Readability Review

### Must Check

* Clear naming
* Small focused methods
* Guard clauses over nested if
* Duplicate logic extracted

### Bad Names

* doStuff()
* handle()
* process2()

---

## Pull Request Checklist

* [ ] Build passes
* [ ] Tests pass
* [ ] No security leak
* [ ] No architecture violation
* [ ] Proper transaction boundary
* [ ] Logging adequate
* [ ] Error handling clear
* [ ] Backward compatible
* [ ] Performance acceptable
* [ ] Docs updated

---

## Severity Levels

### Blocker

* Money duplication risk
* Security hole
* Broken transaction consistency

### Major

* Architecture violation
* Missing tests
* Slow query

### Minor

* Naming
* Formatting
* Refactor suggestion

---

## Golden Rule

Review code as if it will process millions of real customer transactions tomorrow.

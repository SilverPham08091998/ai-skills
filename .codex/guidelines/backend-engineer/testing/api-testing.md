# API Testing Guidelines

## Objective

Validate APIs for correctness, reliability, security, backward compatibility, and business behavior across normal and
edge scenarios.

---

## Core Principles

* Test contract and behavior
* Validate happy path and failure path
* Automate repeatable scenarios
* Keep tests deterministic
* Protect consumers from breaking changes
* Verify production-like behavior

---

## Scope of API Testing

### Functional

* Request accepted correctly
* Response data correct
* Business rules enforced
* State changes persisted

### Non-Functional

* Performance
* Security
* Idempotency
* Rate limiting
* Observability

### Compatibility

* Backward compatibility
* Schema stability
* Version migration

---

## Test Levels

## 1. Component API Test

Controller + application layer with mocks.

## 2. Integration API Test

API + DB + real app context.

## 3. End-to-End API Test

Gateway to downstream systems.

---

## What to Test

## Request Validation

* Required fields
* Null values
* Invalid format
* Max length
* Enum values
* Negative numbers
* Precision rules

## Response Validation

* HTTP status code
* JSON schema
* Required fields present
* Data type correct
* Timestamp format
* Error structure consistent

---

## HTTP Semantics

### Must Verify

* GET is read only
* POST creates/actions
* PUT replaces
* PATCH partial update
* DELETE removes/deactivates

### Status Codes

* 200 OK
* 201 Created
* 204 No Content
* 400 Bad Request
* 401 Unauthorized
* 403 Forbidden
* 404 Not Found
* 409 Conflict
* 422 Unprocessable Entity
* 429 Too Many Requests
* 500 Internal Server Error

---

## Security Testing

### Must Test

* Missing token
* Invalid token
* Expired token
* Wrong role/permission
* Input injection attempts
* Sensitive fields masked
* CORS rules (if public API)

---

## Idempotency Testing

Critical for payments and money movement.

### Scenarios

* Same request retried twice
* Network timeout then retry
* Callback replayed

### Expected

* No duplicate transaction
* Same result returned safely

---

## Pagination / Search Testing

### Must Test

* page / size boundaries
* sorting
* filtering combinations
* empty result
* large dataset behavior

---

## Async API Testing

### Example

POST /payment -> event published -> final status updated later

Validate using polling / Awaitility.

---

## Contract Testing

### Validate

* Field names unchanged
* Required fields preserved
* Types unchanged
* Deprecated fields handled safely

Tools:

* Pact
* OpenAPI schema validation

---

## Fintech / Banking API Cases

### Must Cover

* Transfer money success
* Insufficient balance
* Daily limit exceeded
* Duplicate request id
* Currency mismatch
* Callback signature invalid
* Refund after settlement rules
* Transaction inquiry consistency

### Golden Rule

Money APIs need stricter tests than ordinary CRUD APIs.

---

## Example Test Matrix

## Create Transfer API

### Happy Path

* valid request returns success

### Validation

* amount = 0
* amount < 0
* missing account
* invalid currency

### Business Rule

* insufficient balance
* frozen account
* duplicate reference

### Security

* no token
* wrong user access

### Reliability

* retry same request

---

## Tools (Java Ecosystem)

* RestAssured
* MockMvc
* WebTestClient
* JUnit 5
* Testcontainers
* WireMock
* Awaitility

---

## Example RestAssured

```java
given()
  .

header("Authorization",token)
  .

body(req)
.

when()
  .

post("/api/transfers")
.

then()
  .

statusCode(200);
```

---

## Test Data Strategy

* Unique IDs per run
* Seed known accounts/users
* Cleanup after test
* Avoid shared mutable state

---

## CI/CD Usage

### PR Pipeline

* Fast component tests
* Critical smoke API tests

### Nightly / Pre-release

* Full regression suite
* Compatibility suite
* Negative scenarios

---

## Observability Validation

### Verify

* Trace ID returned/propagated
* Logs generated for failures
* Metrics incremented
* Audit events created if needed

---

## Anti Patterns

* Testing only 200 responses
* Ignoring error body structure
* Hardcoded sleep for async flow
* Shared environment flaky data
* No auth testing
* No backward compatibility checks

---

## Review Checklist

* [ ] Happy path covered
* [ ] Validation errors covered
* [ ] Security cases covered
* [ ] Idempotency covered
* [ ] Response contract validated
* [ ] Financial edge cases covered
* [ ] Stable in CI

---

## Golden Rule

An API is successful only when consumers can rely on it safely under normal and abnormal conditions.

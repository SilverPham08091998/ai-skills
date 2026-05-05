---
name: testing-e2e
description: End-to-end testing standards for backend systems. Use when validating complete user journeys across services and infrastructure.
---

# Testing E2E Guidelines

This Codex skill adapts `backend-engineer/testing/e2e-testing.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# End-to-End (E2E) Testing Guidelines

## Objective

Validate complete business flows across multiple components, services, databases, queues, and external integrations as
close to real production behavior as possible.

---

## Core Principles

* Test real user journeys
* Validate cross-service integration
* Verify data consistency end-to-end
* Detect environment/configuration issues
* Focus on critical business flows
* Keep suite stable and maintainable

---

## What E2E Tests Validate

* API Gateway -> Service -> DB flow
* Multi-service orchestration
* Async event processing
* External partner integrations (sandbox/mock)
* Security/authentication flows
* Notifications/webhooks/callbacks
* Final persisted business state

---

## What E2E Tests Should NOT Replace

* Unit tests
* Integration tests
* Contract tests
* Performance tests

Use E2E for high-value critical journeys only.

---

## Test Pyramid Guidance

* Many unit tests
* Some integration tests
* Few E2E tests

Avoid hundreds of slow brittle E2E tests.

---

## Common E2E Scenarios

## User / Product Systems

* Register -> Verify -> Login
* Create order -> Pay -> Confirm
* Cancel order -> Refund

## Fintech / Banking

* Login -> Check balance -> Transfer money
* Bill payment -> Callback -> Receipt generated
* QR payment -> Settlement -> Ledger updated
* Wallet topup -> Partner callback -> Balance updated
* Refund request -> Approval -> Reversal posted

---

## Architecture Coverage

### Typical Flow

Client -> Gateway -> BFF -> Services -> DB -> Kafka -> Consumers -> Notifications

Validate each handoff succeeds.

---

## Environment Rules

### Recommended

* Dedicated test environment
* Production-like configs
* Real databases
* Real message brokers
* Sandbox partner systems
* Stable test accounts/data

### Avoid

* Running E2E only on developer laptop
* Shared unstable environments without isolation

---

## Test Data Strategy

* Seed known data before tests
* Use unique IDs per run
* Auto cleanup after run
* Separate test accounts
* Re-runnable scenarios

### Good Example

transactionId = E2E-20260427-001

---

## Validation Types

### Functional Validation

* Correct response returned
* Correct status transitions
* Correct final balance/state

### Technical Validation

* Events published
* DB rows created
* Logs/traces visible
* Notifications sent

### Security Validation

* Unauthorized access blocked
* Token expiry handled

---

## Async Flow Testing

### Example

Payment request -> Kafka event -> Consumer -> Ledger update

Validate with timeout polling.

### Use Retry Polling

* Wait until expected state
* Fail after max timeout

Avoid fixed sleep when possible.

---

## UI + API E2E (Optional)

If frontend included:

* Browser/mobile automation
* Validate screen + backend state

Tools:

* Playwright
* Cypress
* Selenium
* Appium

---

## API E2E Tools

* RestAssured
* Postman/Newman
* Karate
* Pact flow (for contracts)
* Custom JUnit flows

---

## Java / Spring Boot Recommended Stack

* JUnit 5
* RestAssured
* Testcontainers
* Awaitility
* WireMock

---

## Stability Rules

### Must Do

* Independent tests
* Deterministic assertions
* Retry transient network checks carefully
* Unique data per run
* Clear teardown

### Avoid

* Shared mutable data
* Hardcoded sleep(30s)
* Order-dependent tests
* Reusing expired auth tokens

---

## Example Scenario Template

## Transfer Money Success

### Given

* Sender balance = 1000
* Receiver balance = 500

### When

* Transfer 200

### Then

* Sender = 800
* Receiver = 700
* Transaction status = SUCCESS
* Ledger entries balanced
* Notification sent

---

## Fintech Critical Assertions

* No duplicate money movement
* Debit = Credit totals
* Audit log exists
* Idempotency works on retry
* Callback replay safe
* Reconciliation reference stored

---

## Failure Scenarios

### Must Cover

* Partner timeout
  n- Duplicate callback
* Invalid token
* Insufficient balance
* Consumer failure then retry
* DB failover/restart
* Partial dependency outage

---

## CI/CD Usage

### Suggested Pipeline

1. Unit tests
2. Integration tests
3. Contract tests
4. Smoke E2E
5. Full E2E nightly / pre-release

---

## Reporting

Include:

* Passed / failed flows
* Duration
* Screenshots/logs if UI
* Trace IDs
* Root cause for failures
* Flaky test count

---

## Review Checklist

* [ ] Real business flow covered
* [ ] Assertions meaningful
* [ ] Stable test data
* [ ] Async handled correctly
* [ ] Financial integrity verified
* [ ] Fast enough for pipeline stage
* [ ] Easy to debug on failure

---

## Anti Patterns

* Too many E2E tests replacing unit tests
* One giant scenario testing everything
* Sleep-based waiting everywhere
* No cleanup strategy
* Flaky tests ignored
* No logs captured on failure

---

## Golden Rule

E2E tests should prove the business works in reality, not just in code.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

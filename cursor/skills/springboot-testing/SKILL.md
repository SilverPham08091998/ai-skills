---
name: springboot-testing
description: Spring Boot testing standards. Use when writing unit, slice, integration, controller, repository, or application tests.
---

# Spring Boot Testing Guidelines

This Cursor skill adapts `backend-engineer/springboot/testing.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# .claude/guidelines/springboot/testing.md

# Spring Boot Testing Standards

---

# STEP 1 — OBJECTIVE

Testing is mandatory in every Spring Boot project.

Goals:

* Ensure business logic correctness
* Prevent regression bugs
* Enable safe refactoring
* Increase deployment confidence
* Detect bugs early
* Reduce production incidents
* Improve maintainability

Rule:
`No production code without tests.`

---

# STEP 2 — TESTING PYRAMID

```text
             E2E Tests
        Integration Tests
             Unit Tests
```

Recommended ratio:

* Unit Tests = 70%
* Integration Tests = 20%
* E2E/API Tests = 10%

---

# STEP 3 — MANDATORY RULES

## 3.1 Every UseCase must have unit tests

Required for:

* Application services
* UseCases
* Domain services
* Validators
* Business calculators

## 3.2 Every Controller must have API tests

Use:

```java
@WebMvcTest
MockMvc
```

Must verify:

* HTTP status
* Request body
* Response body
* Validation error
* Headers
* Security behavior

## 3.3 Repository must have integration tests

Use:

```java
@DataJpaTest
Testcontainers
```

Must verify:

* Insert
* Update
* Delete
* Custom query
* Rollback
* Constraints
* Locking behavior

## 3.4 External systems must be mocked

Examples:

* Kafka
* Redis
* Payment Gateway
* REST APIs
* Email service

Use:

```java
Mockito
        WireMock
MockWebServer
```

## 3.5 Every bug fix must include test case

Flow:

1. Write failing test
2. Fix bug
3. Test passes
4. Prevent recurrence

---

# STEP 4 — UNIT TEST STANDARD

Naming:

```java
should_success_when_valid_request()

should_throw_when_balance_not_enough()

should_reject_when_wallet_locked()
```

Pattern:

```java
Arrange /Act /Assert
```

Example:

```java

@Test
void should_success_when_valid_request() {
    when(repo.findById("1")).thenReturn(wallet);
    Result result = useCase.execute(cmd);
    assertThat(result.status()).isEqualTo("SUCCESS");
}
```

---

# STEP 5 — CONTROLLER TESTING

Example:

```java

@WebMvcTest(TransferController.class)
class TransferControllerTest {

    @Autowired
    MockMvc mockMvc;
    @MockBean
    TransferUseCase useCase;
}
```

Validate:

* 200 / 400 / 401 / 403 / 500
* JSON schema
* Validation message
* Header content

---

# STEP 6 — INTEGRATION TESTING

Use real infrastructure when possible:

* MySQL / PostgreSQL via Testcontainers
* Kafka Testcontainers
* Redis container

Example:

```java

@SpringBootTest
@Testcontainers
class PaymentIntegrationTest {
}
```

Validate:

* Transaction commit/rollback
* Query correctness
* Startup wiring
* Full business flow

---

# STEP 7 — KAFKA TESTING

Validate:

* Producer sends correct payload
* Consumer receives message
* Retry topic works
* DLQ works
* Duplicate message handling

---

# STEP 8 — SECURITY TESTING

Must test:

* Unauthorized = 401
* Forbidden = 403
* JWT valid/invalid
* Role based access
* Expired token

Example:

```java
@WithMockUser(roles = "ADMIN")
```

---

# STEP 9 — COVERAGE STANDARD

Minimum:

* Line Coverage >= 80%
* Branch Coverage >= 70%

Critical modules:

* Payment
* Transfer
* Wallet
* Ledger
* OTP

Required:

* Coverage >= 90%

---

# STEP 10 — CI/CD RULES

Pipeline must run:

```text
mvn clean test
integration-test
coverage-report
```

Fail pipeline when:

* Any test fails
* Coverage below threshold
* Flaky tests detected

---

# STEP 11 — FINTECH CRITICAL CASES

## Transfer

* Duplicate request
* Insufficient balance
* Debit success but credit timeout
* Idempotency duplicate key

## Wallet

* Concurrent spending
* Negative balance reject
* Ledger mismatch detection

## Payment Gateway

* Callback duplicate
* Refund twice
* Provider timeout
* Signature invalid

---

# STEP 12 — GENERATOR RULES FOR AI

When generating code:

1. Generate unit tests for every UseCase
2. Generate controller tests for every endpoint
3. Generate integration tests for repositories
4. Use JUnit5 + Mockito + AssertJ
5. Cover success + fail + edge cases
6. Follow clean architecture boundaries
7. Avoid unnecessary SpringBootTest

---

# FINAL CHECKLIST

* [ ] UseCase tested
* [ ] Controller tested
* [ ] Repository tested
* [ ] Validation tested
* [ ] Security tested
* [ ] Kafka tested
* [ ] Retry tested
* [ ] Duplicate request tested
* [ ] Coverage passed
* [ ] CI pipeline green

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

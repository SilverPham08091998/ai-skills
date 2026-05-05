---
name: testing-unit
description: Unit testing standards for backend code. Use when writing isolated tests for domain logic, use cases, services, validators, and mappers.
---

# Testing Unit Guidelines

This Codex skill adapts `backend-engineer/testing/unit-test.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Unit Testing Guidelines

## Objective

Ensure business logic is validated quickly, reliably, and repeatedly through isolated automated tests.

---

## Core Principles

* Unit tests must be fast
* Unit tests must be deterministic
* Unit tests must run without network/database
* Unit tests should validate behavior, not implementation details
* Tests must be easy to read and maintain

---

## What Should Be Unit Tested

### Must Cover

* Domain business rules
* Use case logic
* Validation rules
* Money calculations
* Mapping logic (critical/custom)
* Error handling branches
* Retry decision logic
* Idempotency logic

### Usually Not Unit Test Target

* Framework annotations
* Spring wiring
* JPA repository queries
* Real HTTP integrations

(Use integration tests instead)

---

## Naming Standard

### Preferred Format

```text
methodName_condition_expectedResult
```

### Examples

```text
transfer_whenBalanceInsufficient_shouldThrowException
createWallet_whenValidRequest_shouldCreateSuccessfully
refund_whenDuplicateRequest_shouldReturnExistingResult
```

---

## Test Structure (AAA)

### Arrange

Prepare data

### Act

Execute target method

### Assert

Verify result

### Example

```java

@Test
void debit_whenBalanceEnough_shouldReduceBalance() {
    // Arrange
    Wallet wallet = new Wallet(100);

    // Act
    wallet.debit(30);

    // Assert
    assertEquals(70, wallet.getBalance());
}
```

---

## Domain Testing Rules

### Must Test

* Valid state changes
* Invalid state rejected
* Boundary values
* Equality/value object behavior

### Example Cases

* debit exact balance
* debit more than balance
* transfer zero amount
* negative amount
* max limit exceeded

---

## Use Case Testing Rules

### Mock External Dependencies

Use mocks for:

* Repository ports
* Kafka producer ports
* External API clients
* Clock / UUID generators

### Example

```java
when(walletRepo.findById(id)).

thenReturn(wallet);
```

### Verify

* Correct dependency called
* Correct arguments passed
* Correct output returned

---

## Mockito Guidelines

### Good Use

* Mock ports/interfaces
* Stub expected responses
* Verify important interactions

### Avoid

* Mocking value objects
* Mocking entity behavior unnecessarily
* Over-verification of every line

### Bad Example

Testing internal private calls indirectly by excessive verify()

---

## Assertions Standard

### Prefer Specific Assertions

```java
assertEquals(expected, actual)

assertThrows(...)

assertTrue(...)

assertFalse(...)
```

### Better Libraries (Optional)

* AssertJ
* Hamcrest

---

## Exception Testing

### Example

```java

@Test
void debit_whenInsufficientBalance_shouldThrow() {
    Wallet wallet = new Wallet(10);

    assertThrows(InsufficientBalanceException.class,
            () -> wallet.debit(100));
}
```

---

## Parameterized Tests

Use for repetitive rules.

### Example Targets

* invalid amounts
* currency formats
* fee tiers
* input length validation

---

## Time Dependent Code

Do not use real current time directly.

Inject:

* Clock
* TimeProvider

Then mock in tests.

---

## Random / UUID Code

Inject generators.

Avoid unstable tests caused by random values.

---

## Fintech / Banking Unit Tests

### Must Cover

* BigDecimal precision
* Rounding rules
* Currency scale
* Ledger balancing
* Duplicate request handling
* Fee calculation
* Cutoff time rules
* Daily transfer limits

### Golden Rule

Every money rule needs tests.

---

## Test Data Builder Pattern

### Prefer Builders

```java
Wallet wallet = WalletTestBuilder.aWallet()
        .withBalance(100)
        .active()
        .build();
```

Better than huge constructors.

---

## Anti Patterns

### Avoid

* Sleep in unit tests
* Real DB usage
* Real HTTP calls
* Shared mutable static state
* Random failures
* Overly long test methods
* One test validating many scenarios

---

## Coverage Guidance

### Focus on Critical Logic, not Percentage Only

Good:

* 90% domain logic tested
* all critical payment flows covered

Bad:

* 100% coverage but meaningless assertions

---

## CI Rules

* Tests run on every PR
* Fast execution preferred
* Fail build if broken
* Parallelize where useful

---

## Review Checklist

* [ ] Test name clear
* [ ] Single scenario per test
* [ ] Assertions meaningful
* [ ] No flaky dependency
* [ ] Business edge cases covered
* [ ] Readable setup
* [ ] Negative cases included

---

## Recommended Stack (Java)

* JUnit 5
* Mockito
* AssertJ
* Instancio / Builder Pattern

---

## Golden Rule

Unit tests are executable business documentation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

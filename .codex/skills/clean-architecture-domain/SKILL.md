---
name: clean-architecture-domain
description: Domain-layer rules for Clean Architecture backend services. Use when modeling entities, value objects, invariants, and pure business behavior.
---

# Clean Architecture Domain Guidelines

This Codex skill adapts `backend-engineer/clean-architecture/domain-rule.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# .claude/guidelines/clean-architecture/domain-rule.md

# Clean Architecture Domain Layer Rules

---

# STEP 1 — OBJECTIVE

Domain layer is the heart of the system.

It contains core business knowledge and rules independent from frameworks.

Goals:

* Represent real business concepts
* Protect invariants
* Encapsulate business behavior
* Keep business logic reusable
* Stay independent from technical details

Rule:
`If framework changes, domain should remain almost unchanged.`

---

# STEP 2 — RESPONSIBILITIES

Domain layer should contain:

* Domain Models
* Value Objects
* Domain Services
* Domain Events
* Specifications / Policies
* Business Exceptions
* Core calculations
* State transitions

Examples:

* Wallet
* Transaction
* Payment
* Money
* TransferPolicy

---

# STEP 3 — STRICTLY FORBIDDEN

Domain must NOT contain:

* Spring annotations
* Controller logic
* ResponseEntity
* JPA repository calls
* SQL
* KafkaTemplate
* RedisTemplate
* HTTP clients
* DTO mapping concerns

Bad Example:

```java

@Autowired
Repository repo;
```

---

# STEP 4 — ENTITY RULES

Entity has identity + behavior.

Examples:

* Wallet(id)
* Account(id)
* Payment(id)

Behavior inside entity:

```java
wallet.debit(amount)
wallet.

credit(amount)
payment.

refund()
```

Do not create anemic domains with only getters/setters.

---

# STEP 5 — VALUE OBJECT RULES

Immutable objects without identity.

Examples:

* Money
* Email
* AccountNumber
* Currency
* PhoneNumber

Example:

```java
public record Money(BigDecimal amount, String currency) {
}
```

Use value objects to increase safety.

---

# STEP 6 — INVARIANTS

Domain must protect impossible states.

Examples:

* Balance cannot be negative
* Amount must be positive
* Refunded payment cannot refund again
* Locked wallet cannot transfer

Example:

```java
if(balance.compareTo(amount) < 0)
        throw new

InsufficientBalanceException();
```

---

# STEP 7 — DOMAIN SERVICES

Use when logic does not belong to one entity.

Examples:

* TransferService
* FeeCalculationService
* FraudDecisionService

Example:

```java
fee =feeService.

calculate(sender, amount);
```

---

# STEP 8 — DOMAIN EVENTS

Represent meaningful business events.

Examples:

* PaymentCreated
* TransferCompleted
* WalletLocked
* RefundApproved

Used for:

* Outbox
* Notification
* Audit
* Async integrations

---

# STEP 9 — CLEAN EXAMPLE

```java
public class Wallet {

    private BigDecimal balance;

    public void debit(BigDecimal amount) {
        validatePositive(amount);
        if (balance.compareTo(amount) < 0) {
            throw new InsufficientBalanceException();
        }
        balance = balance.subtract(amount);
    }

    public void credit(BigDecimal amount) {
        validatePositive(amount);
        balance = balance.add(amount);
    }
}
```

---

# STEP 10 — FINTECH DOMAIN MODELS

Common Domain Models:

* Wallet
* LedgerEntry
* BankAccount
* Beneficiary
* PaymentOrder
* RefundRequest
* OtpChallenge

Value Objects:

* Money
* Currency
* AccountNumber
* TransactionId

---

# STEP 11 — TESTING RULES

Domain tests should be pure unit tests.

No Spring context.
No database.
No mocks unless needed for service collaborators.

Test:

* Invariants
* Edge cases
* State changes
* Calculations

---

# STEP 12 — ANTI PATTERNS

Avoid:

* Anemic domain model (getters/setters only)
* Business logic in controller/service only
* Entity exposing mutable internal state carelessly
* Primitive obsession (String everywhere)
* Huge god entity with many responsibilities
* Domain depending on framework classes

---

# STEP 13 — GENERATOR RULES FOR AI

When generating domain layer:

1. Create rich domain models with behavior
2. Use value objects where meaningful
3. Protect invariants in constructors/methods
4. Throw business exceptions
5. Keep framework independent
6. Add unit tests for domain rules
7. Prefer expressive names

---

# FINAL CHECKLIST

* [ ] Domain independent from framework
* [ ] Models contain behavior
* [ ] Value objects used
* [ ] Invariants protected
* [ ] Business exceptions clear
* [ ] No infra dependency
* [ ] Unit tested
* [ ] Real business language used

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

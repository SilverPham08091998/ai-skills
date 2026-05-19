# Coding Principles

## 1. Readability First

Code must be easy to read and understand.

Rules:

- Prefer clarity over cleverness
- Use meaningful names
- Keep logic straightforward
- Reduce mental overhead
- Optimize for future maintainers

Example:

Bad:
int x = a + b;

Good:
int totalAmount = amount + fee;

---

## 2. Simplicity

Use the simplest correct solution.

Rules:

- Avoid over-engineering
- Avoid unnecessary patterns
- Avoid speculative abstractions
- Prefer direct implementations

Ask:
Can this be simpler?

---

## 3. Single Responsibility

Each class or method should have one responsibility.

Good:

- PaymentValidator
- PaymentProcessor
- PaymentRepository

Bad:

- PaymentManager (validate + save + call API + log + retry)

---

## 4. Separation of Concerns

Keep responsibilities separated.

Do not mix:

- Controller with business logic
- Repository with validation logic
- Domain with framework code

Preferred:
Controller -> Application -> Domain -> Infrastructure

---

## 5. Consistency

Use one style across project.

Keep consistent:

- naming
- package structure
- logging
- testing style
- exception handling

---

## 6. SOLID Principles

### S - Single Responsibility

One class = one reason to change.

### O - Open / Closed

Prefer extension over modifying stable code.

### L - Liskov Substitution

Subtypes must behave correctly.

### I - Interface Segregation

Prefer focused interfaces.

### D - Dependency Inversion

Depend on abstractions.

---

## 7. Clean Method Design

Rules:

- Keep methods short
- One purpose per method
- Avoid nested complexity
- Extract reusable logic

Bad:

process() {
validate();
save();
if(...) {
...
}
}

Good:

process() {
validate();
persist();
publishEvent();
}

---

## 8. Naming Standards

### Class Names

Use nouns.

Examples:

- PaymentService
- UserRepository
- OrderValidator

### Method Names

Use verbs.

Examples:

- createPayment()
- validateRequest()
- findById()

### Variables

Be explicit.

Bad:
x, d, tmp

Good:
retryCount
customerId
totalAmount

---

## 9. Avoid Magic Numbers

Bad:
if (retry > 3)

Good:
if (retry > MAX_RETRY_COUNT)

---

## 10. Error Handling

Rules:

- Fail fast
- Use explicit exceptions
- Never swallow exceptions
- Return useful messages

Bad:

catch(Exception e) {}

Good:

catch(Exception e) {
log.error("Payment failed", e);
throw e;
}

---

## 11. Null Safety

Prefer:

- Optional
- Empty collections
- Validation

Avoid random null returns.

Bad:
return null;

Good:
return Optional.empty();

---

## 12. Immutability First

Prefer immutable objects.

Use:

- final fields
- builder
- records
- no unnecessary setters

Benefits:

- safer
- easier debugging
- thread friendly

---

## 13. DRY

Do not duplicate logic.

But do not over-abstract tiny duplication.

Use balance.

---

## 14. YAGNI

Do not build features for imaginary future needs.

Avoid:

- unused extension points
- unused generic engines
- dead config flags

---

## 15. Comments Rule

Prefer self-explanatory code.

Use comments only for:

- why decision exists
- external constraints
- complex business rules

Bad:
// increment i
i++;

Good:
// Required by provider retry contract
retryCount++;

---

## 16. Logging Standards

Log:

- key business actions
- external calls
- retries
- failures
- unexpected state

Do not log:

- password
- token
- secret
- PII sensitive data

Use structured logs.

---

## 17. Testing Principles

All logic should be testable.

Prefer:

- unit tests
- deterministic tests
- isolated tests

Avoid:

- flaky tests
- timing-based tests
- giant integration-only strategy

---

## 18. Performance Awareness

Measure before optimizing.

Watch:

- N+1 queries
- repeated API calls
- unnecessary loops
- blocking operations

---

## 19. Refactoring Rule

Improve code continuously.

Steps:

1. Add tests
2. Refactor small parts
3. Verify behavior
4. Commit often

---

## 20. Forbidden Practices

Never:

- God classes
- 500+ line methods
- deep nested if else
- duplicate business logic everywhere
- hardcoded secrets
- misleading names
- dead commented code

---

## 21. Good Code Definition

Good code is:

- readable
- testable
- maintainable
- predictable
- secure
- observable
- scalable

---

## 22. Review Checklist

Before merge:

- Is naming clear?
- Is logic simple?
- Any duplicate code?
- Any side effects?
- Proper error handling?
- Proper logs?
- Test included?
- Secure?
- Easy to maintain?

---

## 23. Mandatory For AI Code Generation

When generating code:

- Prefer clarity over complexity
- Follow existing project style
- Respect architecture boundaries
- Include tests when logic exists
- No speculative abstractions
- Production-ready by default
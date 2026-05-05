---
name: springboot-validation
description: Spring Boot validation standards. Use when adding Bean Validation, request validation, business validation, and validation error handling.
---

# Spring Boot Validation Guidelines

This Codex skill adapts `backend-engineer/springboot/validation.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Spring Boot Validation Guidelines

## Purpose

Define enterprise-grade validation standards for Spring Boot applications.

Goals:

- reject bad input early
- protect business logic
- improve API quality
- prevent security issues
- keep validation consistent
- provide clear client feedback

Applies to:

- REST APIs
- internal commands
- event consumers
- batch jobs
- fintech transaction flows

---

# 1. Core Principles

Validate as early as possible.

Layers:

1. Transport Validation (controller/request)
2. Application Validation (use case rules)
3. Domain Validation (business invariants)
4. Infrastructure Validation (external contracts)

Do not rely on only one layer.

---

# 2. Validation Categories

## Syntax Validation

Format correctness.

Examples:

- required field
- email format
- numeric range
- string length

## Semantic Validation

Meaning correctness.

Examples:

- currency supported
- account exists
- amount > minimum transfer

## Security Validation

Examples:

- payload size
- dangerous input
- unauthorized field changes

## Business Validation

Examples:

- insufficient balance
- OTP expired
- payment already completed

---

# 3. Controller Validation

Use Bean Validation annotations.

Example:

public class CreatePaymentRequest {

@NotBlank
private String customerId;

@NotNull
@Positive
private BigDecimal amount;
}

Controller:

@PostMapping("/payments")
public ResponseEntity<?> create(
@Valid @RequestBody CreatePaymentRequest request
)

Reject invalid requests before business logic.

---

# 4. Common Bean Validation Annotations

Use:

@NotNull
@NotBlank
@NotEmpty
@Positive
@PositiveOrZero
@Negative
@Size
@Min
@Max
@Email
@Pattern
@Past
@Future

Choose most specific annotation.

---

# 5. @NotNull vs @NotBlank vs @NotEmpty

@NotNull:
value must not be null

@NotEmpty:
not null and size > 0

@NotBlank:
not null and contains non-whitespace text

Use correctly.

---

# 6. Numeric Validation

Money / counts / limits:

@Positive
@PositiveOrZero
@DecimalMin
@DecimalMax

Example:

@DecimalMin("1000")
private BigDecimal amount;

---

# 7. Enum Validation

Avoid free-form strings.

Preferred:

PaymentStatus enum

If string input required:
validate allowed values.

---

# 8. Nested Object Validation

Use @Valid.

Example:

public class OrderRequest {

@Valid
@NotNull
private AddressRequest address;
}

Without @Valid nested fields may skip validation.

---

# 9. Collection Validation

Example:

@NotEmpty
private List<@NotBlank String> accountIds;

Use item-level constraints.

---

# 10. Query Param Validation

Use @Validated on controller.

Example:

@RestController
@Validated
public class PaymentController {

@GetMapping
public List<?> list(
@Min(1) int page,
@Max(100) int size
)
}

---

# 11. Path Variable Validation

Example:

@GetMapping("/{id}")
public ResponseEntity<?> get(
@PathVariable @NotBlank String id
)

---

# 12. Application Layer Validation

Use case must validate rules beyond syntax.

Examples:

- customer active
- duplicate transaction check
- idempotency key uniqueness
- amount within daily limit

Bean validation alone is not enough.

---

# 13. Domain Validation

Domain model protects invariants.

Examples:

Money amount cannot be negative

Payment cannot move from SUCCESS to PENDING

Wallet balance cannot be below zero (if rule applies)

---

# 14. Fail Fast

Reject invalid requests immediately.

Bad:

process 5 steps then fail missing currency.

Good:

validate upfront.

---

# 15. Custom Validators

Use when standard annotations insufficient.

Examples:

@ValidCurrency
@ValidPhoneNumber
@SupportedBankCode

Implement ConstraintValidator.

---

# 16. Cross-Field Validation

Use custom class-level validation.

Example:

If paymentType = CARD then cardToken required.

If scheduleDate present then recurring=true.

---

# 17. Conditional Validation

Examples:

If provider = BANK_A -> accountNumber mandatory

Use custom validator or service validation.

---

# 18. Sanitization vs Validation

Validation checks correctness.

Sanitization cleans safe formatting.

Examples:

- trim spaces
- normalize phone
- lowercase email

Do not confuse them.

---

# 19. Security Validation

Validate:

- max payload size
- string lengths
- dangerous patterns when relevant
- unauthorized mutable fields

Prevent abuse.

---

# 20. Error Response Standard

Return structured errors.

Example:

{
"code": "VALIDATION_ERROR",
"message": "Invalid request",
"errors": [
{
"field": "amount",
"message": "must be greater than zero"
}
]
}

---

# 21. User-Friendly Messages

Bad:

must satisfy constraint

Good:

Amount must be greater than zero

Use clear messages.

---

# 22. Localization

If product supports i18n:
validation messages should support localization.

---

# 23. Logging Validation Failures

Log metadata only.

Good:

validation failed traceId=abc field=amount

Never log:

- password
- otp
- token
- secret data

---

# 24. Event Consumer Validation

Validate incoming Kafka/event payloads.

Check:

- schema version
- required fields
- duplicate events
- business consistency

Send invalid events to DLQ if policy requires.

---

# 25. Batch Job Validation

Validate imported files:

- row count
- required columns
- numeric format
- duplicates
- business rules

Fail safely with report.

---

# 26. Fintech Critical Validation

For payment flows validate:

- amount > 0
- supported currency
- customer ownership
- account status
- limits
- fraud flags
- idempotency key
- OTP when required

---

# 27. Null Handling

Never assume external input non-null.

Validate explicitly.

Prefer empty collections over null internally when appropriate.

---

# 28. Validation Placement Rules

Controller:
shape/format/basic constraints

Application:
workflow rules

Domain:
state invariants

Infrastructure:
provider response contract checks

---

# 29. Anti-Patterns

Avoid:

- validation only in frontend
- controller with huge custom logic blocks
- duplicated validation in many places
- returning raw stack traces
- trusting client-calculated amounts blindly

---

# 30. Testing Validation

Add tests for:

- missing required field
- invalid formats
- boundary values
- business rejection cases
- custom validators
- nested objects

---

# 31. Example Good Flow

Request received
-> Bean validation
-> Map to command
-> Use case business validation
-> Domain invariant checks
-> Execute

---

# 32. Review Checklist

Before merge ask:

- Required fields validated?
- Numeric ranges checked?
- Nested objects validated?
- Business rules enforced?
- Clear error response?
- Sensitive data hidden?
- Duplicate validation minimized?
- Tests added?

---

# 33. Mandatory For AI Code Generation

When generating Spring Boot validation:

- Use Bean Validation annotations
- Add @Valid on request bodies
- Use @Validated for params
- Separate syntax vs business validation
- Return structured field errors
- Add custom validators when needed
- Protect fintech transaction flows with strict checks
- Fail fast with clear messages

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

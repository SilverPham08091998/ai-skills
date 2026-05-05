---
name: springboot-exception-handler
description: Spring Boot exception handling standards. Use when designing global handlers, error responses, domain exceptions, and API error mapping.
---

# Spring Boot Exception Handler Guidelines

This skill converts `backend-engineer/springboot/exception-handler.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Spring Boot Exception Handler Guidelines

## Purpose

Define enterprise-grade exception handling standards for Spring Boot applications.

Goals:

- consistent error responses
- clear failure semantics
- safer production behavior
- easier debugging
- clean architecture boundaries
- better client experience

Applies to:

- REST APIs
- microservices
- batch jobs
- Kafka consumers
- fintech transaction systems

---

# 1. Core Principles

Errors must be:

- predictable
- structured
- observable
- secure
- meaningful

Do not leak internals.

Do not return random error formats.

---

# 2. Exception Layers

Use different exception types by layer.

Controller:
request / validation errors

Application:
use case / orchestration errors

Domain:
business rule violations

Infrastructure:
DB / provider / network failures

---

# 3. Centralized Handling Required

Use global exception handling.

Preferred:

@RestControllerAdvice

Benefits:

- one response standard
- less duplicate try/catch
- cleaner controllers

---

# 4. Controllers Must Stay Thin

Bad:

try {
...
} catch (Exception e) {
return ...
}

Good:

Throw meaningful exception.
Handle centrally.

---

# 5. Standard Error Response

Recommended:

{
"code": "PAYMENT_NOT_FOUND",
"message": "Payment not found",
"traceId": "abc123",
"timestamp": "2026-04-27T10:00:00Z"
}

Optional:

errors: []   // field errors

---

# 6. Include Traceability

Return:

- traceId
- timestamp
- path (optional)

Useful for support and debugging.

---

# 7. HTTP Status Mapping

## 400 Bad Request

Malformed request
validation error
missing parameter

## 401 Unauthorized

Authentication required / invalid auth

## 403 Forbidden

No permission

## 404 Not Found

Resource missing

## 409 Conflict

Duplicate / invalid state conflict

## 422 Unprocessable Entity

Business rule rejection

## 429 Too Many Requests

Rate limited

## 500 Internal Server Error

Unexpected issue

## 503 Service Unavailable

Dependency unavailable

---

# 8. Validation Exception Handling

Handle:

MethodArgumentNotValidException
ConstraintViolationException

Return field errors.

Example:

{
"code": "VALIDATION_ERROR",
"errors": [
{
"field": "amount",
"message": "must be positive"
}
]
}

---

# 9. Custom Business Exceptions

Create explicit exceptions.

Examples:

PaymentNotFoundException
InsufficientBalanceException
DuplicateTransactionException
OtpExpiredException

Avoid generic RuntimeException everywhere.

---

# 10. Exception Naming Rules

Use clear names ending with Exception.

Good:

WalletLockedException

Bad:

WalletError
SomethingWrongException

---

# 11. Domain Exceptions

Represent business rule violations.

Examples:

CannotRefundCompletedRefundException
BalanceBelowMinimumException

These are expected failures, not system crashes.

---

# 12. Infrastructure Exceptions

Wrap technical failures.

Examples:

ProviderTimeoutException
DatabaseUnavailableException
KafkaPublishFailedException

Preserve root cause internally.

---

# 13. Preserve Cause

Good:

throw new ProviderTimeoutException("Timeout calling bank", ex);

Do not lose stack context.

---

# 14. Do Not Catch Throwable Blindly

Bad:

catch (Exception e) { ignore }

Bad:

catch (Throwable t)

Catch specific exceptions intentionally.

---

# 15. Never Swallow Exceptions

Bad:

try {
...
} catch (Exception e) {
}

Always log / rethrow / handle intentionally.

---

# 16. Safe Error Messages

External message:

"Payment cannot be processed"

Internal logs may contain technical detail.

Do not expose:

- SQL statements
- stack traces
- secrets
- provider credentials

---

# 17. Logging Rules

Log once at proper boundary.

Avoid duplicate logs at 5 layers.

Include:

- traceId
- exception type
- business identifiers (safe)
- latency/context

---

# 18. Sensitive Data Protection

Never log:

- password
- token
- OTP
- PIN
- full card number
- secret keys

---

# 19. Idempotency Errors

For payment APIs:

Duplicate idempotency key should return deterministic response or conflict per API contract.

Do not double charge.

---

# 20. Retryable vs Non-Retryable Errors

Classify errors.

Retryable:
timeout
temporary network issue
503 dependency down

Non-retryable:
validation
insufficient balance
not found (usually)

Important for queues/jobs.

---

# 21. Async / Kafka Handling

Consumer exceptions need strategy:

- retry
- dead letter queue
- skip with alert
- stop consumer (rare)

Do not infinite-loop poison messages.

---

# 22. Transaction Boundaries

Unchecked exceptions often trigger rollback.

Be explicit with transactional rules.

Examples:
business reject may rollback
validation before transaction preferred

---

# 23. Use Error Codes

Stable machine-readable codes.

Examples:

PAYMENT_NOT_FOUND
INSUFFICIENT_BALANCE
VALIDATION_ERROR
PROVIDER_TIMEOUT

Messages can vary, code should stay stable.

---

# 24. Internationalization

If needed:
map code -> localized message.

Do not hardwire only one language if product needs multi-language support.

---

# 25. Fallback Handling

For external provider failure:

- fallback provider
- queued retry
- graceful degraded response

Depends on business flow.

---

# 26. Batch Job Exceptions

Collect row-level errors when possible.

Example:

1000 rows processed
5 failed rows report generated

Do not always fail whole batch.

---

# 27. Common Anti-Patterns

Avoid:

throw new Exception()
return 200 for failures
stack trace in API response
generic "Something went wrong"
catch and ignore
duplicate logging everywhere

---

# 28. Example Global Handler

@RestControllerAdvice
public class GlobalExceptionHandler {

@ExceptionHandler(PaymentNotFoundException.class)
ResponseEntity<?> handle(...) { ... }

}

---

# 29. Clean Architecture Rule

Controller handles HTTP mapping only.

Application/domain throw meaningful exceptions.

Infrastructure translates vendor exceptions.

---

# 30. Monitoring & Alerts

Track:

- error rate
- exception type counts
- 5xx spikes
- dependency timeout counts
- top business failures

---

# 31. Fintech Critical Cases

Special handling for:

- duplicate transfer request
- insufficient balance
- provider timeout after debit attempt
- OTP mismatch
- reconciliation mismatch

Need auditability.

---

# 32. Testing Exception Handling

Add tests for:

- validation errors
- not found
- forbidden
- business rejection
- dependency timeout
- generic fallback 500

Verify response contract.

---

# 33. Review Checklist

Before merge ask:

- Centralized handler used?
- Correct HTTP status?
- Stable error code?
- Sensitive info hidden?
- Logs useful but safe?
- Custom exception clear?
- Retryability classified?
- Tests added?

---

# 34. Mandatory For AI Code Generation

When generating Spring Boot exception handling:

- Use @RestControllerAdvice
- Return structured error responses
- Use custom domain exceptions
- Map correct HTTP statuses
- Include traceId/timestamp
- Hide internals from clients
- Preserve causes internally
- Keep controllers free of try/catch clutter

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

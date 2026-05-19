---
name: springboot-rest-api
description: Spring Boot REST API standards. Use when designing controllers, endpoints, request/response models, status codes, and API behavior.
---

# Spring Boot Rest API Guidelines

This Cursor skill adapts `backend-engineer/springboot/rest-api-standard.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Spring Boot REST API Standard

## Purpose

Define enterprise-grade REST API standards for Spring Boot services.

Goals:

- consistency
- predictable contracts
- secure APIs
- maintainable integrations
- good developer experience
- production readiness

Applies to:

- internal APIs
- public APIs
- mobile backend APIs
- fintech payment APIs
- BFF services

---

# 1. Core Principles

APIs must be:

- clear
- versionable
- consistent
- secure
- observable
- backward compatible where possible

Design for consumers, not server convenience.

---

# 2. Resource-Oriented Design

Use nouns, not verbs.

Good:

GET /payments/{id}
POST /payments
GET /customers/{id}
POST /refunds

Bad:

/getPayment
/createPayment
/doTransferNow

---

# 3. HTTP Method Usage

## GET

Read data only.

Must be safe and idempotent.

## POST

Create resource or trigger command.

## PUT

Full replace resource.

## PATCH

Partial update.

## DELETE

Delete resource.

Avoid misuse.

---

# 4. URI Naming Rules

Use:

- lowercase
- hyphen-separated when needed
- plural resources

Good:

/payment-methods
/customer-accounts
/transactions/{id}

Bad:

/PaymentMethods
/getCustomers
/customer_account

---

# 5. API Versioning

Use when needed.

Recommended:

/api/v1/payments

Or gateway/header versioning by company standard.

Do not version prematurely unless contract exposed broadly.

---

# 6. Request Body Standards

Use JSON by default.

POST /payments

{
"customerId": "123",
"amount": 100000,
"currency": "VND"
}

Rules:

- explicit field names
- validate input
- avoid ambiguous formats

---

# 7. Response Standards

Use consistent structure.

Recommended:

{
"code": "SUCCESS",
"message": "Success",
"data": {...},
"traceId": "abc123"
}

For internal APIs direct body may be acceptable if standard agreed.

---

# 8. HTTP Status Codes

## 200 OK

Successful GET / normal success.

## 201 Created

Resource created.

## 202 Accepted

Async accepted.

## 204 No Content

Success without body.

## 400 Bad Request

Validation/input issue.

## 401 Unauthorized

Missing/invalid authentication.

## 403 Forbidden

Authenticated but not allowed.

## 404 Not Found

Resource missing.

## 409 Conflict

Duplicate/state conflict.

## 422 Unprocessable Entity

Business rule validation failure.

## 429 Too Many Requests

Rate limit exceeded.

## 500 Internal Server Error

Unexpected server issue.

## 503 Service Unavailable

Dependency/system unavailable.

---

# 9. Idempotency For Transactions

Mandatory for money movement APIs.

Examples:

POST /payments
POST /transfers
POST /refunds

Use:

Idempotency-Key header

Repeated request returns original result.

Prevent double charge.

---

# 10. Validation Standards

Use Bean Validation.

Examples:

@NotBlank
@NotNull
@Positive
@Size

Reject invalid input early.

Return clear field errors.

---

# 11. Error Response Standard

Recommended:

{
"code": "INVALID_AMOUNT",
"message": "Amount must be greater than zero",
"errors": [
{
"field": "amount",
"message": "must be positive"
}
],
"traceId": "abc123"
}

---

# 12. Field Naming Convention

Use camelCase JSON unless org standard differs.

Good:

customerId
totalAmount
createdAt

Avoid mixed styles.

---

# 13. Pagination Standard

For list APIs.

GET /payments?page=1&size=20&sort=createdAt,desc

Response:

{
"data": [...],
"page": 1,
"size": 20,
"totalElements": 120,
"totalPages": 6
}

---

# 14. Filtering Standard

Use query params.

GET /payments?status=SUCCESS&customerId=123

Avoid complex POST search unless necessary.

---

# 15. Sorting Standard

GET /payments?sort=createdAt,desc

Allow whitelist fields only.

---

# 16. Date / Time Standard

Use ISO-8601.

Good:

2026-04-27T10:15:30Z

Avoid custom string formats.

---

# 17. Money Standard

Use decimal-safe representation.

Preferred:

string decimal or integer minor units based on company standard.

Examples:

"amount": "100000.50"

or

"amount": 100050 // cents

Never use float semantics.

---

# 18. Security Headers

Use:

Authorization: Bearer <token>

For sensitive operations consider:

X-Request-Id
Idempotency-Key
X-Client-Version

---

# 19. Authentication & Authorization

Use JWT / OAuth2 / session according to system standard.

Controller must enforce access control.

Never trust client role claims blindly without validation.

---

# 20. Traceability

Every request should have trace/correlation id.

Headers:

X-Request-Id
X-Correlation-Id

Return in response.

Useful for debugging.

---

# 21. Logging Rules

Log:

- request start/end metadata
- status code
- latency
- errors
- traceId

Never log:

- password
- token
- OTP
- PIN
- card full number

---

# 22. Timeouts and Resilience

APIs depending on downstream systems need:

- timeout
- retry policy (safe operations only)
- circuit breaker
- fallback where appropriate

---

# 23. Async API Pattern

If long-running:

POST /settlements

Return:

202 Accepted

{
"jobId": "...",
"status": "PENDING"
}

Then query:

GET /settlements/{jobId}

---

# 24. File Upload APIs

Use multipart/form-data.

Validate:

- size
- type
- malware/security rules

---

# 25. Backward Compatibility

Avoid breaking consumers.

Breaking examples:

- rename field
- remove field
- change type
- change semantics

Prefer additive changes.

---

# 26. Controller Standards

Controllers should only handle:

- routing
- request parsing
- validation
- response mapping

No business logic.

---

# 27. DTO Separation

Use:

Request DTO
Response DTO

Do not expose JPA entities directly.

---

# 28. Documentation

Use OpenAPI / Swagger.

Every endpoint should define:

- purpose
- request
- response
- errors
- auth requirement

---

# 29. Rate Limiting

Sensitive APIs should support limits.

Examples:

/login
/otp/send
/payments

Use 429 on exceed.

---

# 30. Fintech Critical APIs

Need extra care:

- transfer
- payment
- refund
- balance inquiry
- OTP verify

Require:

- idempotency
- audit logs
- stronger auth
- fraud checks

---

# 31. Anti-Patterns

Avoid:

GET /createPayment
POST /getPayments
200 for all errors
stack trace in response
null fields everywhere
inconsistent response shapes

---

# 32. Example Controller Style

@PostMapping("/payments")
public ResponseEntity<CreatePaymentResponse> create(
@Valid @RequestBody CreatePaymentRequest request
)

Thin controller only.

---

# 33. Review Checklist

Before merge ask:

- Resource-oriented URI?
- Correct HTTP method?
- Validation present?
- Correct status codes?
- Consistent response shape?
- Secure auth applied?
- TraceId included?
- No sensitive logs?
- Idempotency for transactions?
- Backward compatible?

---

# 34. Mandatory For AI Code Generation

When generating Spring Boot REST APIs:

- Use nouns in URIs
- Use correct HTTP verbs
- Add @Valid validation
- Return proper status codes
- Separate request/response DTOs
- Keep controllers thin
- Add idempotency for money operations
- Include traceability and safe error responses

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

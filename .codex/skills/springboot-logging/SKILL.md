---
name: springboot-logging
description: Spring Boot logging standards. Use when adding structured logs, correlation IDs, masking, and production-safe diagnostics.
---

# Spring Boot Logging Guidelines

This Codex skill adapts `backend-engineer/springboot/logging.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# .claude/guidelines/springboot/logging.md

# Spring Boot Logging Standards

---

# STEP 1 — OBJECTIVE

Standardize logging for Spring Boot services.

Goals:

* Fast troubleshooting
* Production observability
* Request tracing
* Business audit visibility
* Easier debugging in distributed systems

Rule:
`Logs must help operators solve problems quickly.`

---

# STEP 2 — REQUIRED STACK

Use:

* SLF4J API
* Logback (default)
* JSON logging preferred in production
* MDC for correlation ids

Dependencies usually included:

```xml
spring-boot-starter-logging
```

---

# STEP 3 — LOGGER USAGE

Use class logger:

```java
private static final Logger log = LoggerFactory.getLogger(PaymentService.class);
```

With Lombok:

```java

@Slf4j
@Service
public class PaymentService {
}
```

---

# STEP 4 — LOG LEVEL RULES

## ERROR

* Unhandled exceptions
* Critical failures
* Data inconsistency risk

## WARN

* Retry attempt
* Slow dependency
* Invalid external callback
* Recoverable issue

## INFO

* Startup / shutdown
* Key business milestones
* Scheduled job summary

## DEBUG

* Detailed diagnostics
* Lower env troubleshooting

## TRACE

* Rare deep framework diagnostics

---

# STEP 5 — STRUCTURED LOGGING

Recommended fields:

* timestamp
* level
* service
* env
* traceId
* spanId
* thread
* logger
* message

Use JSON encoder in production.

---

# STEP 6 — MDC CORRELATION

Store per-request identifiers:

* traceId
* requestId
* userId (masked if needed)

Example:

```java
MDC.put("traceId",traceId);
```

Clear after request completion.

---

# STEP 7 — REQUEST LOGGING FILTER

Log summary only:

* HTTP method
* URI
* status
* latencyMs
* traceId

Avoid full body logging by default.

Example:

```text
POST /payments status=200 latency=45ms traceId=abc123
```

---

# STEP 8 — GOOD CODE EXAMPLES

```java
log.info("Payment created. paymentId={}, amount={}",paymentId, amount);
log.

warn("Gateway timeout. provider={}, retry={}",provider, retry);
log.

error("Transfer failed. txId={}",txId, ex);
```

---

# STEP 9 — BAD CODE EXAMPLES

```java
log.info("here");
log.

error("error");
System.out.

println("debug");
log.

info(request.toString());
```

---

# STEP 10 — EXCEPTION LOGGING RULES

Log once at correct boundary.

Good:

* Log in controller advice / scheduler / consumer boundary
* Add context identifiers

Bad:

* Same exception logged in 5 layers repeatedly

---

# STEP 11 — SECURITY RULES

Never log:

* password
* OTP
* JWT token
* card full PAN
* CVV
* secret key

Mask sensitive values.

---

# STEP 12 — SPRING BOOT CONFIG EXAMPLE

application.yml:

```yaml
logging:
  level:
    root: INFO
    com.company.payment: INFO
    org.springframework.web: WARN
```

---

# STEP 13 — LOGBACK EXAMPLE

Use rolling policy:

* daily rotation
* size cap
* retention days

Prefer stdout in containers + centralized collector.

---

# STEP 14 — FINTECH EVENTS TO LOG

* Payment created/completed/failed
* Transfer submitted/completed/reversed
* Duplicate idempotency key
* Fraud check decision summary
* Callback signature invalid
* Reconciliation result summary
* OTP attempt counters (no OTP value)

---

# STEP 15 — TESTING & OPERATIONS

Validate:

* Logs contain traceId
* No secrets leak
* Error logs searchable
* JSON parseable
* Volume acceptable under load

---

# STEP 16 — ANTI PATTERNS

Avoid:

* println in production code
* Huge object dump logs
* Chatty INFO logs every loop iteration
* Missing context ids
* Logging then swallowing exceptions silently

---

# STEP 17 — GENERATOR RULES FOR AI

When generating Spring Boot code:

1. Use @Slf4j or SLF4J logger
2. Log start/end of critical flows
3. Log failures with identifiers
4. Add MDC correlation support
5. Avoid sensitive data
6. Use proper levels
7. Keep messages concise

---

# FINAL CHECKLIST

* [ ] SLF4J/Logback used
* [ ] Structured logs enabled
* [ ] MDC traceId present
* [ ] Correct levels configured
* [ ] Sensitive data masked
* [ ] Central aggregation ready
* [ ] Useful business events logged
* [ ] No noisy spam logs

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

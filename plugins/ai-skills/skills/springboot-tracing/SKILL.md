---
name: springboot-tracing
description: Spring Boot tracing standards. Use when adding distributed tracing, spans, correlation propagation, and observability instrumentation.
---

# Spring Boot Tracing Guidelines

This skill converts `backend-engineer/springboot/tracing.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# .claude/guidelines/sre/tracing.md

# Distributed Tracing Standards

---

# STEP 1 — OBJECTIVE

Tracing is mandatory for distributed systems and microservices.

Goals:

* Track end-to-end request flow
* Detect latency bottlenecks
* Find failing service quickly
* Debug async/event driven systems
* Improve observability with logs + metrics
* Reduce MTTR during incidents

Rule:
`No critical service without tracing.`

---

# STEP 2 — CORE CONCEPTS

## Trace

A full request journey across multiple services.

## Span

A single operation inside a trace.
Examples:

* HTTP request
* DB query
* Kafka publish
* Redis call

## Parent / Child Span

Used to represent call hierarchy.

## Trace ID

Unique id for full request.

## Span ID

Unique id for single span.

---

# STEP 3 — MANDATORY RULES

## 3.1 Propagate Trace Context Everywhere

Across:

* HTTP
* gRPC
* Kafka
* RabbitMQ
* Scheduled jobs

Headers:

* traceparent
* tracestate
* x-b3-traceid (legacy)

## 3.2 Every inbound request creates root span

## 3.3 Every outbound dependency creates child span

Dependencies:

* DB
* Cache
* REST API
* Kafka
* File storage

## 3.4 Errors must be marked on span

Include:

* exception type
* message
* status code

## 3.5 Sensitive data must never be traced

Never store:

* password
* OTP
* token
* card number
* CVV
* secret keys

---

# STEP 4 — REQUIRED TAGS / ATTRIBUTES

Common tags:

* service.name
* env
* version
* http.method
* http.route
* http.status_code
* user.id (masked if needed)
* tenant.id
* db.system
* db.operation
* messaging.system
* error=true/false

---

# STEP 5 — SPRING BOOT STANDARD

Use:

* OpenTelemetry
* Micrometer Tracing
* Zipkin / Jaeger / Tempo backend

Dependencies:

```xml
spring-boot-starter-actuator
        micrometer-tracing-bridge-otel
        opentelemetry-exporter-otlp
```

---

# STEP 6 — TRACE NAMING RULES

Good span names:

* POST /api/v1/payment
* WalletService.debit
* ProductRepository.findById
* Kafka publish payment.created

Bad:

* test123
* method1
* run

---

# STEP 7 — LATENCY ANALYSIS

Use traces to identify:

* Slow DB query
* External API timeout
* Retry storms
* N+1 queries
* Thread pool starvation
* Kafka consumer lag side effects

---

# STEP 8 — FINTECH CRITICAL FLOWS

Must trace end-to-end:

* Login + OTP verify
* Transfer money
* Bill payment
* QR payment
* Refund flow
* Ledger posting
* Callback webhook
* Reconciliation batch

---

# STEP 9 — SAMPLING STRATEGY

Production:

* Normal traffic: 1% to 10%
* Error traces: always keep
* Slow traces: always keep
* VIP transactions: configurable keep

Never sample out critical fraud/security traces.

---

# STEP 10 — LOG CORRELATION

Every log line should include:

* traceId
* spanId
* service
* env

Example:

```text
traceId=abc123 spanId=xyz999 Payment success
```

---

# STEP 11 — ALERTING RULES

Create alerts for:

* p95 latency spike
* error rate increase
* missing traces from service
* exporter failure
* dependency timeout surge

---

# STEP 12 — ANTI PATTERNS

Avoid:

* Tracing only gateway
* Missing async propagation
* Huge payload in span attributes
* Sensitive data leakage
* 100% sampling with huge traffic
* Random span names

---

# STEP 13 — GENERATOR RULES FOR AI

When generating code:

1. Add tracing interceptor/filter
2. Propagate trace headers
3. Create spans for outbound calls
4. Add error status on exception
5. Correlate logs with traceId
6. Avoid sensitive data tags

---

# FINAL CHECKLIST

* [ ] Root span created
* [ ] Child spans for dependencies
* [ ] Context propagated
* [ ] Errors tagged
* [ ] Logs correlated
* [ ] Sampling configured
* [ ] Dashboard connected
* [ ] Sensitive data masked
* [ ] Critical flows traced

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

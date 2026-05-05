---
name: code-review-production-readiness
description: Production readiness review standards for backend services. Use when validating reliability, observability, security, rollback, and operational safety.
---

# Code Review Production Readiness Guidelines

This Codex skill adapts `backend-engineer/code-review/production-readiness.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Production Readiness Checklist

## Objective

Ensure a service or feature is safe to deploy to production, observable, scalable, recoverable, and supportable.

---

## Release Gate

Deploy only when all critical items are complete.

* [ ] Functional correctness verified
* [ ] Security review passed
* [ ] Performance acceptable
* [ ] Monitoring ready
* [ ] Rollback plan ready
* [ ] Ownership clear

---

## 1. Architecture Readiness

### Must Check

* [ ] Clear service responsibility
* [ ] Dependencies documented
* [ ] No forbidden tight coupling
* [ ] Horizontal scaling supported
* [ ] Stateless where possible
* [ ] Failure isolation considered

### Red Flags

* Single point of failure
* Hidden dependency chain
* Shared mutable local state

---

## 2. Configuration Readiness

### Must Check

* [ ] All configs externalized
* [ ] Environment-specific config separated
* [ ] Sensible defaults defined
* [ ] Feature flags documented
* [ ] Timeout values configured
* [ ] Connection pools tuned

### Red Flags

* Hardcoded environment URLs
* Secrets in source code
* Magic numbers without explanation

---

## 3. Security Readiness

### Must Check

* [ ] Authentication enabled
* [ ] Authorization enforced
* [ ] Secrets managed securely
* [ ] TLS/mTLS where required
* [ ] Sensitive data masked in logs
* [ ] Dependency vulnerabilities reviewed
* [ ] Input validation implemented

### Never Expose

* Passwords
* OTP/PIN
* Tokens
* API keys
* Customer sensitive data

---

## 4. Database Readiness

### Must Check

* [ ] Migration scripts reviewed
* [ ] Backward compatible schema changes
* [ ] Indexes added where needed
* [ ] Connection limits sized
* [ ] Backup strategy confirmed
* [ ] Restore procedure tested

### Red Flags

* Destructive migration without plan
* Locking migration on large tables
* No rollback path

---

## 5. API Readiness

### Must Check

* [ ] Contract documented
* [ ] Versioning strategy clear
* [ ] Idempotency for retryable endpoints
* [ ] Rate limiting considered
* [ ] Proper error codes returned
* [ ] Backward compatibility maintained

---

## 6. Reliability Readiness

### Must Check

* [ ] Retries with backoff configured
* [ ] Circuit breaker for unstable dependencies
* [ ] Timeouts on all remote calls
* [ ] Bulkhead/isolation strategy considered
* [ ] Graceful degradation plan exists
* [ ] Startup/shutdown behavior safe

### Red Flags

* Infinite retry loops
* No timeout on HTTP/database calls
* Cascading failure risk

---

## 7. Performance Readiness

### Must Check

* [ ] Load test completed
* [ ] P95/P99 latency acceptable
* [ ] Capacity estimate documented
* [ ] CPU/memory usage acceptable
* [ ] Slow queries optimized
* [ ] Caching reviewed if needed

---

## 8. Observability Readiness

### Must Check

* [ ] Structured logs implemented
* [ ] Correlation/trace ID propagated
* [ ] Metrics exported
* [ ] Dashboards created
* [ ] Alerts configured
* [ ] Runbook available

### Key Metrics

* Request rate
* Error rate
* Latency
* CPU
* Memory
* DB pool usage
* Kafka lag (if used)

---

## 9. Deployment Readiness

### Must Check

* [ ] CI/CD pipeline green
* [ ] Immutable artifact built
* [ ] Health checks configured
* [ ] Readiness probe configured
* [ ] Liveness probe configured
* [ ] Rolling deploy supported
* [ ] Zero/low downtime strategy defined

### Red Flags

* Manual prod-only steps undocumented
* No health checks
* Direct hotfix on server

---

## 10. Data Integrity Readiness (Fintech/Banking)

### Must Check

* [ ] Double-entry consistency maintained
* [ ] Money uses BigDecimal/precise decimal
* [ ] Duplicate request protection exists
* [ ] Reconciliation job prepared
* [ ] Audit trail complete
* [ ] Timezone/cutoff rules validated

### Golden Rule

Financial correctness before release speed.

---

## 11. Support Readiness

### Must Check

* [ ] Service owner defined
* [ ] On-call rotation known
* [ ] Escalation path documented
* [ ] Common incidents documented
* [ ] Dashboard links shared
* [ ] Support contacts available

---

## 12. Rollback Readiness

### Must Check

* [ ] Rollback steps documented
* [ ] Previous artifact available
* [ ] DB rollback/forward-fix strategy known
* [ ] Feature flag disable option exists
* [ ] Communication plan ready

### Ask Before Release

* If deploy fails, how fast can we recover?

---

## 13. Final Go/No-Go Checklist

* [ ] Business signoff complete
* [ ] Engineering signoff complete
* [ ] Risk acceptable
* [ ] Peak traffic window considered
* [ ] Team available during release
* [ ] Monitoring active during release

---

## Severity Levels

### Blocker

* Missing rollback plan
* Security gap
* Data corruption risk
* No monitoring
* Critical tests failing

### Major

* Incomplete docs
* Weak alerting
* Capacity uncertain

### Minor

* Nice-to-have dashboard improvements
* Non-critical refactor follow-up

---

## Golden Rule

Production readiness means being ready not only to deploy, but to operate, detect, recover, and scale safely.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

---
name: code-review-pr-checklist
description: Pull request checklist standards for backend changes. Use before approving or submitting PRs that affect production service behavior.
---

# Code Review PR Checklist Guidelines

This Codex skill adapts `backend-engineer/code-review/pr-checklist.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Pull Request Checklist

## Objective

Ensure every Pull Request is safe, reviewable, testable, maintainable, and ready for production deployment.

---

## 1. Before Creating PR

* [ ] Branch is up to date with target branch
* [ ] Code builds successfully
* [ ] All tests pass locally
* [ ] No debug code left behind
* [ ] No commented dead code
* [ ] No temporary hacks
* [ ] Feature works end-to-end
* [ ] Config changes documented

---

## 2. PR Title Standard

Use clear action-based titles.

### Good Examples

* feat: add wallet transfer limit validation
* fix: prevent duplicate payment callback processing
* refactor: split ledger posting service
* chore: upgrade spring boot version
* test: add integration tests for refund flow

### Bad Examples

* update code
* fix bug
* changes
* final version

---

## 3. PR Description Template

## Summary

Describe what changed.

## Why

Describe business or technical reason.

## Scope

List impacted modules/services.

## Testing

Explain how it was tested.

## Risk

Low / Medium / High

## Rollback Plan

How to revert safely.

---

## 4. Code Quality Checklist

* [ ] Naming is clear
* [ ] No duplicated logic
* [ ] Methods are focused and small
* [ ] No unnecessary complexity
* [ ] No unused imports / code
* [ ] Logging is meaningful
* [ ] Exceptions handled correctly
* [ ] Constants extracted properly

---

## 5. Architecture Checklist

* [ ] Clean Architecture respected
* [ ] Controller remains thin
* [ ] Application layer handles use case orchestration
* [ ] Domain contains business rules
* [ ] Infrastructure only for technical concerns
* [ ] Dependency direction correct
* [ ] No forbidden cross-layer imports

---

## 6. Security Checklist

* [ ] No hardcoded secrets
* [ ] No sensitive data logged
* [ ] Auth checks included
* [ ] Authorization enforced
* [ ] Input validated
* [ ] SQL injection safe
* [ ] External calls protected with timeout

---

## 7. Data & Transaction Checklist

* [ ] Transaction boundary correct
* [ ] Idempotency considered
* [ ] Retry safe behavior confirmed
* [ ] Migration script reviewed (if any)
* [ ] Backward compatibility maintained
* [ ] No data corruption risk

---

## 8. API Checklist

* [ ] API contract documented
* [ ] Request validation added
* [ ] Response structure consistent
* [ ] Correct HTTP status codes
* [ ] Swagger/OpenAPI updated
* [ ] Backward compatible changes only

---

## 9. Kafka / Async Checklist

* [ ] Topic names correct
* [ ] Schema version considered
* [ ] Consumer idempotent
* [ ] Retry / DLQ defined
* [ ] Ordering impact reviewed
* [ ] Duplicate event handling covered

---

## 10. Performance Checklist

* [ ] Query performance reviewed
* [ ] Index needed checked
* [ ] Pagination applied
* [ ] Batch processing optimized
* [ ] Remote calls minimized
* [ ] Cache opportunity reviewed
* [ ] No memory leak risk

---

## 11. Testing Checklist

* [ ] Unit tests added/updated
* [ ] Integration tests added if needed
* [ ] Manual QA completed
* [ ] Edge cases tested
* [ ] Negative cases tested
* [ ] Regression risk checked

---

## 12. Observability Checklist

* [ ] Logs useful for debugging
* [ ] Metrics added if needed
* [ ] Trace ID propagated
* [ ] Alerts impacted reviewed
* [ ] Dashboard update needed assessed

---

## 13. Reviewer Checklist

* [ ] Understand requirement clearly
* [ ] Read code flow end-to-end
* [ ] Challenge risky assumptions
* [ ] Check business correctness
* [ ] Check production readiness
* [ ] Give actionable comments
* [ ] Approve only when safe

---

## 14. Blockers (Do Not Merge)

* [ ] Build failing
* [ ] Tests failing
* [ ] Security issue exists
* [ ] Data loss risk
* [ ] Money duplication risk
* [ ] Breaking API without agreement
* [ ] Missing rollback path
* [ ] Unreviewed migration risk

---

## 15. Merge Rule

Merge only when:

* Code is understandable
* Tests are green
* Risk is acceptable
* Reviewer confidence is high
* Production can support release

---

## Golden Rule

A PR should reduce future problems, not create future incidents.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

# CODEX.md — Engineering Agent System Contract

## Purpose

This file defines the **global operating system rules** for AI-assisted software generation using the ai-skills rule set.

It acts as the **highest authority rule set** overriding all other guidelines.

It is designed for:

* AI coding agents (Codex / GPT / internal generators)
* Senior backend engineering standards
* Fintech / banking / microservice production systems
* Centralized multi-assistant skill and rule management
* Codex work launched from any project folder

---

# 0. Repository Operating Rules

## 0.1 Centralized AI Skills Model

This repository is the source of truth for multiple AI assistants:

* Codex rules and skills live under `.codex/`
* Claude Code plugin rules and skills live under `plugins/ai-skills/`
* Shared engineering intent must remain aligned across assistants
* Assistant-specific files must remain isolated

## 0.1.1 Global Rule Root

Codex may be invoked from any project folder. In that case:

* The ai-skills repository is the **rule root**
* The user's current project is the **target project**
* Codex reads `.codex/` rules, workflows, commands, templates, and skills from the rule root
* Codex edits and validates files in the target project

Resolve the rule root in this order:

1. `AI_SKILLS_HOME`
2. `CODEX_AI_SKILLS_HOME`
3. `/home/tinhpn2/Documents/ai-skills`
4. Current repository root, only if it contains `.codex/CODEX.md`

Never assume the target project contains these rules. Do not copy rules into the target project unless the user explicitly requests installation.

## 0.2 Planning Gate

Before implementing any code, refactor, generated artifact, or repository rule update, Codex MUST:

1. Present a TODO list with the full steps.
2. Present the files expected to be created or modified.
3. Wait for explicit user confirmation such as `ok`, `confirm`, `làm đi`, `yes`, or `proceed`.
4. Implement only after approval and follow the workflow order.

Files already listed in an approved TODO/file scope may be edited without asking again. After approval, Codex must continue task-by-task without repeated yes/no confirmations unless there is a real blocker, validation failure, or required out-of-scope file change.

Ask/explanation workflows do not use the Planning Gate because they must not edit files. If an Ask response leads to a requested change, switch to the matching edit workflow and apply the Planning Gate before editing.

## 0.3 Out-of-Scope File Changes

If a required edit is outside the approved TODO/file list, Codex MUST stop and ask first:

```text
Cần sửa thêm file ngoài scope đã approve:
- File: `path/to/file.ts`
- Việc cần làm: mô tả thay đổi cụ thể
- Vì sao cần sửa: lý do kỹ thuật bắt buộc phải sửa file này
- Nếu thêm thay đổi này thì làm được gì: capability/behavior unblock được
- Hướng giải quyết: cách sửa dự kiến
- Rủi ro nếu không sửa: hậu quả hoặc giới hạn nếu giữ nguyên scope

Bạn có đồng ý thêm file này vào scope không?
```

Only proceed after clear user approval.

## 0.4 Mandatory Implementation Workflow

For feature implementation, code generation, or meaningful refactor work, execute these steps in order:

1. `<ai-skills-rule-root>/.codex/workflow/implement/00-context-alignment.md`
2. `<ai-skills-rule-root>/.codex/workflow/implement/01-architecture.md`
3. `<ai-skills-rule-root>/.codex/workflow/implement/02-structure-check.md`
4. `<ai-skills-rule-root>/.codex/workflow/implement/03-task-breakdown.md`
5. `<ai-skills-rule-root>/.codex/workflow/implement/04-coding.md`
6. `<ai-skills-rule-root>/.codex/workflow/implement/05-unit-tests.md`
7. `<ai-skills-rule-root>/.codex/workflow/implement/06-coverage.md`
8. `<ai-skills-rule-root>/.codex/workflow/implement/07-version-guide.md`
9. `<ai-skills-rule-root>/.codex/workflow/implement/08-pre-commit.md`

Each step must be completed before moving to the next. If tests, build, or coverage fail, stop, report the failure, and fix before continuing. Step 07 version guide is mandatory. Step 08 is mandatory before any user-requested commit.

## 0.5 Mandatory Ask Workflow

For questions, explanations, skill/rule reading, repository orientation, or pre-implementation discovery, use:

1. `<ai-skills-rule-root>/.codex/workflow/ask.md`

Ask must research local target-project or ai-skills context first when it may answer the question. Outside knowledge is secondary and should be used only as support or fallback. Ask must not edit files, run implementation validation, or create version guides.

## 0.5b Mandatory Fix-Bug Workflow

For bug diagnosis, defect fixing, failing tests, runtime errors, or regressions, execute these steps in order:

1. `<ai-skills-rule-root>/.codex/workflow/fix-bug/00-context-alignment.md`
2. `<ai-skills-rule-root>/.codex/workflow/fix-bug/01-reproduce.md`
3. `<ai-skills-rule-root>/.codex/workflow/fix-bug/02-root-cause.md`
4. `<ai-skills-rule-root>/.codex/workflow/fix-bug/03-impact-analysis.md`
5. `<ai-skills-rule-root>/.codex/workflow/fix-bug/04-fix.md`
6. `<ai-skills-rule-root>/.codex/workflow/fix-bug/05-verify.md`
7. `<ai-skills-rule-root>/.codex/workflow/fix-bug/06-pre-commit.md`

Do not jump to fixing before reproducing and identifying root cause. Step 06 is mandatory before any user-requested commit.

## 0.5c Mandatory Refactor Workflow

For code refactoring, code quality improvement, or restructuring layers per Clean Architecture, execute these steps in order:

1. `<ai-skills-rule-root>/.codex/workflow/refactor/00-context-alignment.md`
2. `<ai-skills-rule-root>/.codex/workflow/refactor/01-behavior-baseline.md`
3. `<ai-skills-rule-root>/.codex/workflow/refactor/02-analysis.md`
4. `<ai-skills-rule-root>/.codex/workflow/refactor/03-refactor-plan.md`
5. `<ai-skills-rule-root>/.codex/workflow/refactor/04-coding.md`
6. `<ai-skills-rule-root>/.codex/workflow/refactor/05-verify.md`
7. `<ai-skills-rule-root>/.codex/workflow/refactor/06-pre-commit.md`

Refactor must never add new behavior. Behavior baseline (test coverage ≥ 90%) is mandatory before any code change. Step 06 is mandatory before any user-requested commit.

## 0.5d Mandatory Review Workflow

For code review, PR review, risk assessment, or quality findings, execute these steps in order:

1. `<ai-skills-rule-root>/.codex/workflow/review/00-context-alignment.md`
2. `<ai-skills-rule-root>/.codex/workflow/review/01-collect.md`
3. `<ai-skills-rule-root>/.codex/workflow/review/02-analyze.md`
4. `<ai-skills-rule-root>/.codex/workflow/review/03-report.md`
5. `<ai-skills-rule-root>/.codex/workflow/review/04-fix-suggestions.md`

Review must not edit files unless the user explicitly requests a fix after reading the report.

## 0.6 Intent Routing

Before choosing an ask, implementation, review, refactor, bug-fix, skill-update, or sync workflow, use:

1. `<ai-skills-rule-root>/.codex/workflow/router.md`

If the user's intent is clear, route directly. If the intent is ambiguous, ask the user to choose the workflow before proceeding.

---

# 1. Global Engineering Philosophy

## 1.1 Core Principles

* Correctness > Performance > Convenience
* Deterministic behavior > clever optimizations
* Explicit > implicit
* Production safety is mandatory
* Simplicity is a system feature

---

## 1.2 Engineering Mindset

Every generated system must assume:

* Real users
* Real money (fintech context)
* Real failure scenarios
* Distributed systems instability

---

# 2. Architecture Rules (STRICT)

## 2.1 Clean Architecture Enforcement

```text
Controller → Application → Domain → Infrastructure
```

### Rules

* Domain is framework-free
* Application orchestrates use cases only
* Controller is a thin adapter
* Infrastructure is replaceable

---

## 2.2 Dependency Rule

* Inner layers must NOT depend on outer layers
* Domain must NOT import Spring, JPA, Kafka
* Infrastructure implements ports only

---

## 2.3 Communication Rule

* All inter-layer communication via:

    * Command
    * DTO
    * Port interfaces
* MapStruct is mandatory for mapping

---

# 3. Code Generation Rules

## 3.1 Mandatory Structure

Every generated module MUST include:

* Controller layer
* Application (use case) layer
* Domain layer
* Infrastructure layer
* Mapper layer (MapStruct)
* Validation layer
* Exception handling

---

## 3.2 Clean Code Rules

* Small functions (< 30 lines preferred)
* Single responsibility
* No duplication
* No magic numbers
* Early return preferred
* Meaningful naming

---

## 3.3 Naming Rules

* Class: PascalCase
* Method: camelCase verb-based
* Constant: UPPER_SNAKE_CASE
* Package: domain-based structure

---

# 4. Java Standards

## 4.1 Core Rules

* Use BigDecimal for money
* Avoid float/double for financial data
* Prefer immutable objects
* Avoid raw types

---

## 4.2 Concurrency Rules

* No unmanaged thread creation
* Use framework-managed executor pools
* Avoid shared mutable state

---

# 5. Spring Boot Rules

## 5.1 Controller Rules

* No business logic
* No DB access
* Only validation + delegation

---

## 5.2 Validation Rules

* Use Bean Validation (@Valid)
* Fail fast on invalid input

---

## 5.3 Exception Handling

* Centralized global exception handler required
* No raw exception exposure
* Standardized error response format

---

# 6. Microservice Rules

## 6.1 Communication

* Sync: REST / gRPC
* Async: Kafka

---

## 6.2 Mandatory Patterns

When applicable:

* Outbox Pattern
* Saga Pattern
* CQRS
* Idempotency Key Pattern

---

## 6.3 Reliability Rules

* All external calls must have timeout
* Retry with exponential backoff
* Circuit breaker for critical dependencies

---

# 7. Fintech / Banking Rules (CRITICAL)

## 7.1 Money Rules

* Always use BigDecimal
* Never use floating types
* Ensure precision and rounding rules explicitly defined

---

## 7.2 Ledger Rules

* Double-entry accounting MUST balance
* Debit == Credit always
* Every transaction must be traceable

---

## 7.3 Idempotency

* All payment APIs must be idempotent
* Duplicate requests must NOT duplicate money movement

---

# 8. Kafka / Event Rules

## 8.1 Producer

* Must define event key strategy
* Must include metadata:

    * eventId
    * traceId
    * timestamp

---

## 8.2 Consumer

* Must be idempotent
* Must support retry + DLQ
* Must tolerate duplicate events

---

# 9. Observability Rules

## 9.1 Logging

* Structured logging required
* Must include traceId
* No sensitive data logging

---

## 9.2 Metrics

* latency (P95 / P99)
* throughput
* error rate
* system resource usage

---

## 9.3 Tracing

* Distributed tracing mandatory
* Correlation ID required across all services

---

# 10. Security Rules

## 10.1 API Security

* JWT authentication required
* Role-based authorization
* Input validation mandatory

---

## 10.2 Data Security

* No secrets in code
* Mask sensitive logs
* Encrypt sensitive data when needed

---

## 10.3 Threat Prevention

* SQL Injection protection
* XSS protection
* Rate limiting for public APIs

---

# 11. Testing Rules

## 11.1 Test Pyramid

* Unit tests (primary)
* Integration tests (secondary)
* E2E tests (minimal critical flows)

---

## 11.2 Required Coverage

* Business logic
* Edge cases
* Failure scenarios
* Idempotency
* Concurrency safety

---

# 12. Infrastructure Rules

* Data sources are infrastructure only
* No business logic allowed in infrastructure
* Must support retry / timeout / observability

---

# 13. Performance Rules

* Measure before optimizing
* DB optimization first
* Avoid premature optimization

---

# 14. Code Review Standards

Priority order:

1. Security
2. Correctness
3. Architecture compliance
4. Performance
5. Readability

---

# 15. STRICT Anti-Patterns

* Business logic in controller
* Direct DB access from domain
* Missing idempotency in payment flows
* Hardcoded secrets
* No timeout on external calls
* God classes / services

---

# 16. AI Generation Contract

When generating code:

* Always follow Clean Architecture
* Always separate layers
* Always include mapping layer (MapStruct)
* Always include validation
* Always include exception handling
* Always assume production usage

---

# 17. Fintech Safety Rule

> If money is involved, correctness is non-negotiable.

---

# 18. SYSTEM RULE

This file overrides ALL other guidelines in case of conflict.

---

# 19. Golden Rule

Every generated system must be safe for production financial workloads.

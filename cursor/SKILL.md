---
# SKILL.md — Generator Skill Index

## Purpose

This document is the **central registry (map)** of all engineering skill files under `cursor/`.
It can be loaded from the ai-skills rule root while Cursor works in any target project folder.

It defines:

  * What each file is for
  * When AI should use it
  * What code it influences

> `[PLANNED]` = file chưa tồn tại, chưa được tạo. AI không nên cố đọc các file này.

---

# 0. Cursor-Specific Skills

Cursor-ready skills live in:

```text
<ai-skills-rule-root>/cursor/skills/<skill-name>/SKILL.md
```

Use these first when the task clearly matches a specific backend, mobile, Java, Spring Boot, Clean Architecture, testing, code-review, React Native, or state-management skill.

These files are intentionally separate from Claude Code plugin skills:

```text
plugins/ai-skills/skills/<skill-name>/SKILL.md
```

Do not modify or rely on the Claude plugin copy when updating Cursor behavior. Keep Cursor skill changes under `cursor/skills`.

Cursor workflow rules live in:

```text
<ai-skills-rule-root>/cursor/workflow/*.md
```

These mirror the intent of Claude plugin workflow rules under `plugins/ai-skills/workflow/*.md`
without depending on the Claude plugin copy.

Current Cursor catalog mirrors the Claude plugin skill catalog: **173 skills** under `cursor/skills`.

Primary Cursor skill groups include:

* Backend: `clean-architecture-*`, `code-review-*`, `engineering-*`, `infrastructure-datasource`, `java-*`, `microservice-*`, `springboot-*`, `testing-*`
* Mobile: `mobile-*`, `react-native-*`, `state-*`
* API/backend platforms: `api-design-principles`, `fastapi-templates`, `nodejs-backend-patterns`, `openapi-spec-generation`, `postgresql`
* Cloud/infra/devops: `cloudflare*`, `github-actions-templates`, `gitlab-ci-patterns`, `gitops-workflow`, `helm-chart-scaffolding`, `k8s-*`, `terraform-module-library`, `wrangler`
* Security/reliability/observability: `anti-reversing-techniques`, `attack-tree-construction`, `distributed-tracing`, `grafana-dashboards`, `incident-runbook-templates`, `pci-compliance`, `sast-configuration`, `secrets-management`, `slo-implementation`, `sonar-*`, `stride-analysis-patterns`, `threat-mitigation-mapping`
* Frontend/design: `angular-migration`, `design-system-patterns`, `figma-*`, `frontend-design`, `interaction-design`, `nextjs-app-router-patterns`, `react-*`, `responsive-design`, `tailwind-design-system`, `typescript-advanced-types`, `visual-design-foundations`, `web-*`
* Workflow/productivity: `architecture-*`, `capture-tasks-from-meeting-notes`, `changelog-automation`, `context-driven-development`, `generate-*`, `spec-to-backlog`, `track-management`, `triage-issue`, `workflow-*`
* Payments/domain integrations: `billing-automation`, `paypal-integration`, `stripe-integration`

Use `find cursor/skills -mindepth 2 -maxdepth 2 -name SKILL.md | sort` when an exact skill inventory is required.

---

# 1. Root Files

## CURSOR.md

### Purpose

Global engineering rules + AI behavior contract.

### When used

* ALWAYS (default context for all generation)

---

## COMMANDS.md

* Cursor execution entrypoints for implementation, review, rule sync, and skill updates

Use when:

* selecting what Cursor must read and execute before touching files
* translating Claude plugin workflow into Cursor tool-driven behavior

---

## generator-pipeline.md

* Code generation pipeline orchestration

Use when:

* running end-to-end code generation flow

---

# 1.5 Workflow Files

Use `cursor/workflow/*.md` by command intent. Do not read every workflow file for every request.

| File | Purpose |
|------|---------|
| `workflow/router.md` | Classify user intent and route to ask, implement, fix-bug, review, refactor, update-skill, or sync-rules |
| `workflow/ask.md` | Answer questions by researching local context first, then using outside knowledge only as support or fallback |
| `workflow/implement/00-context-alignment.md` | Research project context, restate understanding, identify prompt gaps, and align solution direction before architecture |
| `workflow/implement/01-architecture.md` | Decide when architecture diagrams/contracts are required |
| `workflow/implement/02-structure-check.md` | Scan current structure and list file scope before coding |
| `workflow/implement/03-task-breakdown.md` | Break approved file scope into detailed dependency-ordered tasks before coding |
| `workflow/implement/04-coding.md` | Implement inside-out with clean code and security rules |
| `workflow/implement/05-unit-tests.md` | Add behavior-focused tests |
| `workflow/implement/06-coverage.md` | Run tests/build and verify >= 90% coverage for changed code where tooling supports it |
| `workflow/implement/07-version-guide.md` | Write implementation documentation, rollback notes, and deploy checklist |
| `workflow/implement/08-pre-commit.md` | Re-run tests, protect environment branches, verify final file changes report, and prepare commit message/body |

---

# 2. Engineering Core

## guidelines/engineering/coding-principles.md

* Core coding philosophy
* Clean code enforcement

Use when:

* generating any backend code

---

## guidelines/engineering/clean-code.md

* Readability rules
* Code simplicity standards

Use when:

* reviewing or generating business logic

---

## guidelines/engineering/naming-convention.md

* Naming rules for classes, methods, variables

Use when:

* generating DTOs, services, entities

---

## guidelines/engineering/design-patterns.md

* Standard patterns (Factory, Strategy, Builder)

Use when:

* designing reusable components

---

# 3. Java Core

## guidelines/java/java-core.md

* Java best practices
* OOP fundamentals

Use when:

* writing any Java code

---

## guidelines/java/collections.md

* Collection usage rules

Use when:

* working with lists/maps/sets

---

## guidelines/java/concurrency.md

* Thread safety rules
* Executor usage

Use when:

* async or parallel processing

---

## guidelines/java/performance.md

* JVM optimization
* memory + GC awareness

Use when:

* performance critical code

---

## guidelines/java/lombok-mapstruct.md

* Lombok usage rules
* MapStruct mapping rules

Use when:

* DTO mapping / boilerplate reduction

---

# 4. Spring Boot

## guidelines/springboot/project-structure.md

* Layer structure standard

Use when:

* creating new services/modules

---

## guidelines/springboot/rest-api-standard.md

* API design rules

Use when:

* creating REST endpoints

---

## guidelines/springboot/validation.md

* input validation rules

Use when:

* request DTO creation

---

## guidelines/springboot/security.md

* authentication/authorization

Use when:

* secure endpoints

---

## guidelines/springboot/exception-handler.md

* global exception handling

Use when:

* API error handling design

---

## guidelines/springboot/testing.md

* testing strategy

Use when:

* writing Spring Boot tests

---

## guidelines/springboot/tracing.md

* distributed tracing setup (OpenTelemetry / Micrometer Tracing)

Use when:

* adding tracing to services

---

## guidelines/springboot/logging.md

* structured logging standard (SLF4J / Logback / MDC)

Use when:

* adding or reviewing logging in services

---

# 5. Clean Architecture

## guidelines/clean-architecture/layers.md

* layer definition

Use when:

* designing system architecture

---

## guidelines/clean-architecture/common.md

* shared rules across all layers

Use when:

* cross-cutting concerns, shared utilities

---

## guidelines/clean-architecture/controller-rule.md

* controller rules

Use when:

* writing API controllers

---

## guidelines/clean-architecture/application-rule.md

* use case rules

Use when:

* implementing business workflows

---

## guidelines/clean-architecture/domain-rule.md

* domain logic rules

Use when:

* writing business entities

---

## guidelines/clean-architecture/infrastructure-rule.md

* infrastructure rules

Use when:

* DB / Kafka / external API implementation

---

## guidelines/clean-architecture/mapper-rule.md

* mapping rules

Use when:

* DTO ↔ domain conversion

---

# 6. Infrastructure

## guidelines/infrastructure/data-source.md

* datasource configuration rules (HikariCP, multi-datasource)

Use when:

* configuring database connections

---

# 7. Templates

## templates/create-clean-module.md

* scaffold template for a new clean-architecture module

Use when:

* creating a new feature module from scratch

---

## templates/create-endpoint.md

* scaffold template for a new REST endpoint

Use when:

* adding a new API endpoint

---

## templates/create-service.md

* scaffold template for a new service class

Use when:

* creating application/domain service

---

## templates/create-kafka-flow.md

* scaffold template for Kafka producer/consumer flow

Use when:

* implementing event publishing or consuming

---

# 8. Fintech Domain `[PLANNED]`

## guidelines/fintech/transaction-flow.md `[PLANNED]`

* transaction lifecycle

---

## guidelines/fintech/wallet-ledger.md `[PLANNED]`

* ledger system rules

---

## guidelines/fintech/reconciliation.md `[PLANNED]`

* reconciliation process

---

## guidelines/fintech/gl-posting.md `[PLANNED]`

* accounting GL posting rules

---

## guidelines/fintech/idempotency.md `[PLANNED]`

* idempotency rules

---

# 9. Banking Domain `[PLANNED]`

## guidelines/banking/account-transfer.md `[PLANNED]`

* transfer flow rules

---

## guidelines/banking/bill-payment.md `[PLANNED]`

* bill payment flow

---

## guidelines/banking/otp-softotp.md `[PLANNED]`

* OTP authentication

---

## guidelines/banking/fraud-check.md `[PLANNED]`

* fraud detection rules

---

# 10. Payment Domain `[PLANNED]`

## guidelines/payment/payment-gateway.md `[PLANNED]`

* gateway integration

---

## guidelines/payment/qr-payment.md `[PLANNED]`

* QR payment flow

---

## guidelines/payment/callback-webhook.md `[PLANNED]`

* webhook handling

---

## guidelines/payment/refund-flow.md `[PLANNED]`

* refund processing

---

# 11. Kafka / Event Streaming `[PLANNED]`

## guidelines/kafka/producer-standard.md `[PLANNED]`

* producer rules

---

## guidelines/kafka/consumer-standard.md `[PLANNED]`

* consumer rules

---

## guidelines/kafka/retry-dlq.md `[PLANNED]`

* retry and dead letter queue

---

## guidelines/kafka/schema-versioning.md `[PLANNED]`

* schema evolution

---

# 12. SRE / Observability `[PLANNED]`

## guidelines/sre/observability.md `[PLANNED]`

* observability strategy

---

## guidelines/sre/logging-standard.md `[PLANNED]`

* logging rules

---

## guidelines/sre/monitoring-standard.md `[PLANNED]`

* monitoring metrics

---

## guidelines/sre/alerting.md `[PLANNED]`

* alert rules

---

## guidelines/sre/incident-checklist.md `[PLANNED]`

* incident response

---

# 13. Kubernetes `[PLANNED]`

## guidelines/kubernetes/deployment-standard.md `[PLANNED]`

* deployment rules

---

## guidelines/kubernetes/hpa.md `[PLANNED]`

* autoscaling rules

---

## guidelines/kubernetes/ingress.md `[PLANNED]`

* ingress rules

---

## guidelines/kubernetes/secrets.md `[PLANNED]`

* secrets management

---

## guidelines/kubernetes/probes.md `[PLANNED]`

* health checks

---

# 14. Terraform `[PLANNED]`

## guidelines/terraform/module-standard.md `[PLANNED]`

* infra module structure

---

## guidelines/terraform/naming.md `[PLANNED]`

* naming convention infra

---

## guidelines/terraform/env-structure.md `[PLANNED]`

* environment separation

---

## guidelines/terraform/state-management.md `[PLANNED]`

* state handling rules

---

# 15. Security `[PLANNED]`

## guidelines/security/oauth2-jwt.md `[PLANNED]`

* auth system design

---

## guidelines/security/secure-coding.md `[PLANNED]`

* secure coding practices

---

## guidelines/security/secret-management.md `[PLANNED]`

* secrets handling

---

## guidelines/security/sql-injection.md `[PLANNED]`

* SQL injection prevention

---

## guidelines/security/api-security.md `[PLANNED]`

* API protection

---

# 16. Code Review

## guidelines/code-review/backend-review.md

* backend review checklist

Use when:

* PR review

---

## guidelines/code-review/pr-checklist.md

* PR merge checklist

Use when:

* pull request validation

---

## guidelines/code-review/performance-review.md

* performance review

Use when:

* performance audit

---

## guidelines/code-review/production-readiness.md

* production checklist

Use when:

* release approval

---

# 17. Microservice Patterns

## guidelines/microservice-pattern/master-slave.md

* master-slave architecture

Use when:

* leader-based systems

---

## guidelines/microservice-pattern/outbox.md

* transactional outbox

Use when:

* event publishing reliability

---

# 18. Testing

## guidelines/testing/unit-test.md

* unit testing rules

Use when:

* writing unit tests

---

## guidelines/testing/api-testing.md

* API testing rules

Use when:

* API validation tests

---

## guidelines/testing/e2e-testing.md

* end-to-end tests

Use when:

* full system testing

---

## guidelines/testing/performance-testing.md

* performance testing

Use when:

* load/stress testing

---

## Golden Rule

This index is the **routing table for AI code generation behavior**.

Always select the most specific rule file before generating code.
Do NOT attempt to read files marked `[PLANNED]`.

---

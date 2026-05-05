# generator-pipeline.md — Ultimate AI Backend Generation Pipeline

## Purpose

This document defines the **end-to-end generation pipeline** that converts a single business request into a complete *
*production-ready Fintech Microservice System**.

It orchestrates all templates in this repository:

* create-service.md
* create-clean-module.md
* create-endpoint.md
* create-kafka-flow.md
* SKILL.md
* CODEX.md

---

# 1. SYSTEM OVERVIEW

## 1.1 Goal

Given a single input requirement, the pipeline MUST generate:

* Full microservice architecture
* Clean Architecture layers
* REST APIs
* Kafka event flows
* Domain model
* Tests
* Infrastructure config

---

## 1.2 Input → Output Flow

```text
Business Requirement
        ↓
Domain Analyzer
        ↓
Skill Index Router (SKILL.md)
        ↓
Template Selector
        ↓
Code Generator Engine
        ↓
Validation Engine
        ↓
Production-ready System Output
```

---

# 2. INPUT SPECIFICATION

## 2.1 Required Input

```text
systemName: string
description: string
domain: payment | wallet | banking | ledger
features: list
apiType: REST | Kafka | Hybrid
consistency: STRONG | EVENTUAL
securityLevel: HIGH | MEDIUM | LOW
scalability: LOW | MEDIUM | HIGH
```

---

## 2.2 Example Input

```text
systemName: payment-platform
description: "Handle full payment lifecycle with ledger and Kafka events"
domain: payment
features:
  - create payment
  - confirm payment
  - publish payment event
apiType: REST + Kafka
consistency: EVENTUAL
securityLevel: HIGH
scalability: HIGH
```

---

# 3. PIPELINE STAGES

# STAGE 1 — DOMAIN ANALYSIS

## Responsibilities

* Identify bounded contexts
* Define aggregates
* Extract entities & value objects

## Output

```text
Domain Model
- Entities
- Value Objects
- Aggregates
- Business rules
```

---

# STAGE 2 — SKILL ROUTING

## Uses

* SKILL.md
* CODEX.md rules

## Responsibilities

* Select required guidelines:

    * fintech/
    * banking/
    * kafka/
    * clean-architecture/

---

# STAGE 3 — ARCHITECTURE DESIGN

## Output

* Service boundaries
* Module separation
* API design
* Event design

## Decision Rules

If:

* HIGH domain complexity → use modular DDD
* EVENTUAL consistency → Kafka required
* HIGH security → JWT + RBAC mandatory

---

# STAGE 4 — CODE GENERATION

## Uses Templates

### If full service:

→ create-service.md

### If module:

→ create-clean-module.md

### If API:

→ create-endpoint.md

### If event system:

→ create-kafka-flow.md

---

## Output Layers (MANDATORY)

```text
controller
application
domain
infrastructure
mapper
dto
exception
config
test
```

---

# STAGE 5 — FINTECH ENFORCEMENT

## Rules Applied

* BigDecimal for money
* Idempotency required for write APIs
* Ledger consistency enforced
* No partial transaction state

---

# STAGE 6 — EVENT INTEGRATION (IF APPLICABLE)

If Kafka is used:

* Generate event schema
* Add traceId + eventId
* Apply Outbox Pattern (if required)
* Ensure idempotent consumers

---

# STAGE 7 — VALIDATION ENGINE

## Checks

* Clean Architecture compliance
* No business logic in controller
* No framework leakage into domain
* Idempotency implemented
* Kafka safety rules applied
* Transaction boundaries correct

---

# STAGE 8 — TEST GENERATION

Must include:

* Unit tests (domain + application)
* Integration tests (DB + Kafka)
* API tests
* Idempotency tests
* Failure scenario tests

---

# STAGE 9 — OBSERVABILITY INJECTION

Automatically add:

* structured logging
* traceId propagation
* metrics hooks
* audit logs for financial actions

---

# 4. DECISION MATRIX

## Service Type Selection

| Condition      | Output                 |
|----------------|------------------------|
| Simple CRUD    | create-service.md      |
| Complex domain | create-clean-module.md |
| Single API     | create-endpoint.md     |
| Event-driven   | create-kafka-flow.md   |

---

# 5. OUTPUT CONTRACT

Final output MUST include:

* Full source code
* Folder structure
* Config files
* Tests
* README (optional)

---

# 6. ANTI-PATTERNS (STRICTLY FORBIDDEN)

* Skipping domain modeling
* Mixing layers
* No idempotency in financial flows
* Missing Kafka retry/DLQ
* No transaction boundaries
* Hardcoded secrets

---

# 7. SYSTEM RULE

This pipeline overrides all individual templates when full system generation is requested.

---

# 8. GOLDEN RULE

One input must be able to generate a complete production-grade microservice system without manual intervention.

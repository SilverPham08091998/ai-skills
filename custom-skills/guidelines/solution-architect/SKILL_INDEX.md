# SKILL_INDEX.md — SA Skill Index

## Objective

Map each architecture task to the correct `.sa` skill files.

## Recommended Workflow

```text
Step 1: Analyze business requirements
Step 2: Discover domain and boundaries
Step 3: Define NFRs and constraints
Step 4: Create HLD
Step 5: Create LLD for implementation
Step 6: Define API/integration/data/security/deployment design
Step 7: Capture ADRs
Step 8: Review architecture before implementation
Step 9: Handoff to backend/mobile/devops teams
```

## Task Routing

| Task | Recommended Skills |
|---|---|
| Analyze business idea | `.sa/requirements/business-requirement.md`, `.sa/requirements/functional-requirement.md` |
| Define NFR | `.sa/requirements/non-functional-requirement.md`, `.sa/architecture/quality-attribute.md` |
| Discover domain boundaries | `.sa/requirements/domain-discovery.md`, `.sa/data/data-architecture.md` |
| Create HLD | `.sa/generators/create-hld.md`, `.sa/architecture/hld.md`, `.sa/architecture/c4-model.md` |
| Create LLD | `.sa/generators/create-lld.md`, `.sa/architecture/lld.md`, `.sa/api/api-design.md` |
| Create C4 diagrams | `.sa/generators/create-c4-diagram.md`, `.sa/architecture/c4-model.md` |
| Create ADR | `.sa/generators/create-adr.md`, `.sa/architecture/adr.md`, `.sa/architecture/tradeoff-analysis.md` |
| Design partner integration | `.sa/generators/create-integration-design.md`, `.sa/integration/external-partner.md`, `.sa/api/idempotency.md` |
| Design event-driven system | `.sa/integration/event-driven.md`, `.sa/integration/outbox.md`, `.sa/integration/saga.md` |
| Design payment/wallet flow | `.sa/api/idempotency.md`, `.sa/data/transaction-consistency.md`, `.sa/data/audit-ledger.md`, `.sa/integration/saga.md` |
| Security review | `.sa/security/security-architecture.md`, `.sa/security/threat-modeling.md`, `.sa/security/data-protection.md` |
| Deployment architecture | `.sa/deployment/deployment-architecture.md`, `.sa/deployment/cloud-architecture.md`, `.sa/deployment/devops-handoff.md` |
| Production architecture review | `.sa/generators/create-architecture-review.md`, `.sa/review/production-readiness.md`, `.sa/review/architecture-review.md` |

## Full File Map

| File | Purpose | Use When |
|---|---|---|
| `.sa/README.md` | SA Skill Pack Overview | Onboarding AI agent, Explaining SA folder structure |
| `.sa/SA.md` | Solution Architect Master Skill | Starting any architecture design task, Transforming business requirements into system architecture |
| `.sa/api/api-design.md` | API Design Standard | Creating API contract, Reviewing endpoint design |
| `.sa/api/error-contract.md` | API Error Contract Standard | Designing API errors, Reviewing API consistency |
| `.sa/api/idempotency.md` | Idempotency Standard | Designing payment command, Handling retry |
| `.sa/api/versioning.md` | API Versioning Standard | Designing public API, Changing contract |
| `.sa/architecture/adr.md` | Architecture Decision Record Standard | Choosing technology, Documenting trade-offs |
| `.sa/architecture/c4-model.md` | C4 Model Standard | Creating architecture diagrams, Explaining system layers |
| `.sa/architecture/hld.md` | High-Level Design Standard | Creating architecture proposal, Explaining system to stakeholders |
| `.sa/architecture/lld.md` | Low-Level Design Standard | Preparing implementation, Breaking down service internals |
| `.sa/architecture/quality-attribute.md` | Quality Attribute Standard | Designing resilient system, Mapping NFRs to tactics |
| `.sa/architecture/risk-assessment.md` | Architecture Risk Assessment Standard | Before implementation, Before production |
| `.sa/architecture/tradeoff-analysis.md` | Trade-off Analysis Standard | Choosing between tools/patterns, Explaining why one design wins |
| `.sa/data/audit-ledger.md` | Audit and Ledger Standard | Wallet/payment design, Compliance audit |
| `.sa/data/caching.md` | Caching Standard | Adding Redis cache, Improving performance |
| `.sa/data/data-architecture.md` | Data Architecture Standard | Choosing database, Designing storage |
| `.sa/data/database-selection.md` | Database Selection Standard | Choosing DB, Comparing PostgreSQL/Redis/Kafka/NoSQL/TigerBeetle |
| `.sa/data/transaction-consistency.md` | Transaction Consistency Standard | Money movement, DB plus event |
| `.sa/deployment/cloud-architecture.md` | Cloud Architecture Standard | Designing AWS platform, Choosing managed services |
| `.sa/deployment/deployment-architecture.md` | Deployment Architecture Standard | Creating deployment view, Planning AWS/EKS deployment |
| `.sa/deployment/devops-handoff.md` | DevOps Handoff Standard | After HLD/LLD, Before Terraform/Helm generation |
| `.sa/generators/create-adr.md` | Generator — Create ADR | Choosing technology/pattern, Documenting decision |
| `.sa/generators/create-architecture-review.md` | Generator — Create Architecture Review | Reviewing HLD/LLD, Before implementation |
| `.sa/generators/create-c4-diagram.md` | Generator — Create C4 Diagrams | User asks for diagrams, Architecture visualization |
| `.sa/generators/create-hld.md` | Generator — Create HLD | User asks for HLD, Starting architecture doc |
| `.sa/generators/create-integration-design.md` | Generator — Create Integration Design | Partner integration, Service-to-service integration |
| `.sa/generators/create-lld.md` | Generator — Create LLD | User asks for LLD, Preparing Codex/Claude implementation |
| `.sa/integration/event-driven.md` | Event-Driven Architecture Standard | Kafka architecture, Domain event design |
| `.sa/integration/external-partner.md` | External Partner Integration Standard | Partner API integration, Payment gateway integration |
| `.sa/integration/integration-patterns.md` | Integration Patterns Standard | Integrating services, Choosing sync/async |
| `.sa/integration/outbox.md` | Outbox Pattern Standard | DB update plus Kafka event, Reliable event publishing |
| `.sa/integration/saga.md` | Saga Pattern Standard | Money movement flow, Multi-service transaction |
| `.sa/integration/webhook.md` | Webhook Standard | Partner callback, Outbound notification |
| `.sa/observability/architecture-observability.md` | Architecture Observability Standard | Designing production architecture, Preparing SRE handoff |
| `.sa/observability/operability.md` | Operability Standard | Production architecture, SRE review |
| `.sa/requirements/business-requirement.md` | Business Requirement Analysis | Starting architecture from raw business idea, Clarifying stakeholder goals |
| `.sa/requirements/domain-discovery.md` | Domain Discovery Standard | Before microservice decomposition, Designing DDD architecture |
| `.sa/requirements/functional-requirement.md` | Functional Requirement Standard | Writing feature requirements, Creating API/module design |
| `.sa/requirements/non-functional-requirement.md` | NFR Standard | Designing production system, Reviewing architecture quality |
| `.sa/review/architecture-review.md` | Architecture Review Standard | Reviewing HLD/LLD, Before implementation |
| `.sa/review/design-smell.md` | Architecture Design Smell Standard | Reviewing design quality, Refactoring architecture |
| `.sa/review/production-readiness.md` | Production Readiness Architecture Review | Before go-live, Before detailed implementation |
| `.sa/security/compliance-review.md` | Compliance Review Standard | Before production, Architecture approval |
| `.sa/security/data-protection.md` | Data Protection Standard | Handling PII/payment data, Designing storage/logging |
| `.sa/security/identity-access.md` | Identity and Access Architecture Standard | Login/auth design, Service-to-service security |
| `.sa/security/security-architecture.md` | Security Architecture Standard | Any production architecture, Threat modeling |
| `.sa/security/threat-modeling.md` | Threat Modeling Standard | Reviewing sensitive system, Designing fintech feature |
| `.sa/system-design/availability-dr.md` | Availability and DR Standard | Production architecture, Critical business flow |
| `.sa/system-design/performance.md` | Performance Design Standard | Latency-sensitive API, High-throughput service |
| `.sa/system-design/reliability.md` | Reliability Design Standard | Designing critical flow, Reviewing failure modes |
| `.sa/system-design/resilience-patterns.md` | Resilience Patterns Standard | Adding resilience4j, Designing service integration |
| `.sa/system-design/scalability.md` | Scalability Design Standard | Scaling API/service, Designing high traffic system |

## Prompt Pattern

```text
Use these skills:
- .sa/SA.md
- .sa/SKILL_INDEX.md
- <specific skill files>

Task:
<what architecture artifact you want>

Context:
- Business goal:
- Actors:
- Existing systems:
- Constraints:
- NFR:
- Security/compliance:
- Target stack:

Output:
- Assumptions
- Diagrams in Mermaid
- Architecture/design sections
- Trade-offs
- Risks
- Implementation handoff
```

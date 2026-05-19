# generators/create-hld-lld-document.md — Create HLD + LLD Technical Document

## Objective

Generate a combined HLD + LLD technical document for a feature, module, service, or platform capability.

This is useful when the user wants one document that is both architecture-level and implementation-ready.

## When To Use

Use this generator when the user says:

- Create HLD and LLD
- Design this feature end-to-end
- Create technical document for implementation
- Create architecture and implementation design
- Write document for Claude/Codex to code
- Make technical spec with diagrams

## Required Output

```markdown
# <Feature/System> — HLD + LLD Technical Document

## Part A — HLD

### 1. Objective
### 2. Context
### 3. Scope
### 4. Actors and Systems
### 5. C4 Context Diagram
### 6. C4 Container Diagram
### 7. High-Level Components
### 8. High-Level Data Flow
### 9. NFR
### 10. Security Overview
### 11. Risks and Trade-offs

## Part B — LLD

### 12. Module Structure
### 13. Component Responsibilities
### 14. API Contracts
### 15. Sequence Diagrams
### 16. State Machine
### 17. Data Model
### 18. Transaction Boundary
### 19. Error Handling
### 20. Idempotency
### 21. Observability
### 22. Test Strategy
### 23. Implementation Checklist
### 24. Codex/Claude Implementation Prompt
```

## Mandatory Diagrams

Include at least:

1. C4-style context/container diagram
2. Main sequence diagram
3. Error/alternative sequence diagram if needed
4. State diagram if status/lifecycle exists
5. ER diagram if data model is involved
6. Deployment diagram if runtime topology matters

## Rules

1. HLD explains system-level design.
2. LLD explains implementation-level design.
3. Do not mix too much code detail into HLD.
4. Do not leave LLD vague.
5. Every API must have request, response, validation, and error contract.
6. Every write flow must define transaction boundary.
7. Every retryable command must define idempotency.
8. Every external integration must define timeout, retry, failure, and reconciliation.
9. Every production flow must define logs, metrics, traces, and alerts.

## Prompt

```text
Use `.sa/generators/create-hld-lld-document.md`.

You are a Senior Solution Architect.

Create a combined HLD + LLD technical document for: <FEATURE_OR_SYSTEM>.

Context:
- Business goal:
- Domain:
- Actors:
- Existing systems:
- Target stack:
- Constraints:
- External integrations:
- Data stores:
- NFR:
- Security/compliance concerns:

Required:
- Part A: HLD
- Part B: LLD
- Mermaid diagrams
- API contracts
- Sequence diagrams
- State machine if needed
- Data model if needed
- Security design
- Failure handling
- Observability
- Implementation checklist
- Codex/Claude implementation prompt

Rules:
- Make it implementation-ready.
- Every diagram must have explanation.
- Include risks and trade-offs.
- Include open questions if assumptions are made.
```

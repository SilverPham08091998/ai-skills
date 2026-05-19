# documentation/technical-document.md — Technical Document Writing Standard

## Objective

Define the mandatory standard for writing technical documents as a Solution Architect.

This skill is used to produce clear, structured, implementation-ready technical documents for engineering teams, including HLD, LLD, integration design, API design, deployment design, and production review documents.

## When To Use

Use this skill when:

- Writing any technical document
- Creating HLD
- Creating LLD
- Creating integration design
- Creating API design
- Creating deployment architecture
- Creating technical proposal
- Creating implementation handoff for backend/mobile/devops
- Converting messy notes into structured architecture documentation
- Preparing document for Confluence, Markdown, or engineering review

## Mandatory Rule

Every Solution Architect output that is intended for engineering must be written as a technical document, not just an explanation.

A technical document must answer:

1. What problem are we solving?
2. Why does this solution exist?
3. Who are the actors/systems involved?
4. What is in scope and out of scope?
5. What are the components?
6. How does data flow?
7. How do components communicate?
8. What are the APIs/events/contracts?
9. What are the failure scenarios?
10. How is the system secured?
11. How is the system monitored?
12. How will engineers implement it?
13. What are the risks and trade-offs?

## Document Structure

Use this structure by default:

```markdown
# <Document Title>

## 1. Objective

## 2. Background / Context

## 3. Scope

### 3.1 In Scope

### 3.2 Out of Scope

## 4. Business / Technical Requirements

### 4.1 Functional Requirements

### 4.2 Non-Functional Requirements

## 5. Assumptions

## 6. Constraints

## 7. Actors and External Systems

## 8. High-Level Architecture

## 9. Component Responsibilities

## 10. Data Flow

## 11. API / Event / Integration Contracts

## 12. Sequence Flows

## 13. Data Model / State Model

## 14. Security Design

## 15. Error Handling and Failure Scenarios

## 16. Observability

## 17. Deployment / Runtime View

## 18. Risks and Trade-offs

## 19. Implementation Plan

## 20. Open Questions

## 21. Appendix
```

## Writing Rules

1. Start with business and system context before diagrams.
2. Use diagrams to explain, not decorate.
3. Every diagram must have a short explanation.
4. Every component must have a clear responsibility.
5. Every integration must define protocol, owner, timeout, retry, and failure behavior.
6. Every API must define request, response, validation, error contract, and idempotency if applicable.
7. Every data write flow must define transaction boundary.
8. Every async flow must define retry, DLQ, idempotency, and observability.
9. Every sensitive flow must define authentication, authorization, audit, masking, and encryption.
10. Every production document must include observability and rollback consideration.

## Style Rules

Write in a style that is:

- Clear
- Structured
- Engineering-ready
- Reviewable
- Implementation-oriented
- Not too academic
- Not too vague
- Not only diagram-based

Avoid:

- Long paragraphs without structure
- Vague terms like “handle properly”
- Architecture buzzwords without explanation
- Diagrams without flow explanation
- Components without ownership
- API design without error contract
- Integration design without failure handling

## Required Sections by Document Type

### HLD Document

Must include:

- Objective
- Context
- Scope
- Actors
- External systems
- C4 Context Diagram
- C4 Container Diagram
- Major components
- Main data flows
- NFR
- Security overview
- Observability overview
- Deployment overview
- Risks and trade-offs
- Implementation roadmap

### LLD Document

Must include:

- Objective
- Scope
- Module structure
- Component responsibilities
- API contract
- Request/response DTOs
- Command/use case design
- Data model
- State machine if needed
- Sequence diagrams
- Transaction boundary
- Error handling
- Idempotency if needed
- Tests
- Implementation checklist

### Integration Design Document

Must include:

- Objective
- Systems involved
- Ownership
- Protocol
- Authentication
- Request/response contract
- Timeout
- Retry
- Idempotency
- Error mapping
- Callback/webhook if any
- Reconciliation
- Monitoring
- Sequence diagrams

### API Design Document

Must include:

- Endpoint list
- Method and path
- Authentication
- Authorization
- Headers
- Request schema
- Response schema
- Validation
- Error codes
- Idempotency
- Pagination/filtering if applicable
- Backward compatibility

## Diagram Rules

Technical documents should use Mermaid diagrams by default unless the user asks for draw.io.

Recommended diagram types:

- `flowchart` for high-level flow and component relationships
- `sequenceDiagram` for request/response and integration flow
- `stateDiagram-v2` for transaction/status lifecycle
- `erDiagram` for data model
- `C4Context` / `C4Container` style if supported, or regular flowchart as C4-style fallback

Every diagram must include:

1. Title or section heading
2. Diagram code
3. Explanation
4. Important notes or constraints

## Engineering Handoff Rules

A technical document is incomplete if engineers cannot implement from it.

Always include:

- Module boundaries
- Required APIs
- Required database changes
- Required events
- External dependencies
- Config/secrets
- Error scenarios
- Test cases
- Observability requirement
- Rollback or migration notes

## Security Checklist

- [ ] Authentication defined
- [ ] Authorization defined
- [ ] Sensitive data classified
- [ ] Data masking defined
- [ ] Audit events defined
- [ ] Encryption in transit defined
- [ ] Encryption at rest defined
- [ ] Secret management defined
- [ ] External callbacks verified
- [ ] Logs do not expose sensitive data

## Technical Document Checklist

- [ ] Objective is clear
- [ ] Scope is clear
- [ ] Assumptions are listed
- [ ] Actors are defined
- [ ] External systems are defined
- [ ] Components have responsibilities
- [ ] Diagrams are included
- [ ] Diagrams have explanation
- [ ] API/event contracts are defined
- [ ] Failure scenarios are defined
- [ ] Security is covered
- [ ] Observability is covered
- [ ] Risks and trade-offs are listed
- [ ] Implementation plan is actionable
- [ ] Open questions are listed

## Prompt

```text
Use `.sa/documentation/technical-document.md`.

You are a Senior Solution Architect.

Create a technical document for: <TOPIC>.

Context:
- Domain: <domain>
- System: <system name>
- Actors: <actors>
- Existing systems: <systems>
- Target stack: <stack>
- Constraints: <constraints>
- NFR: <availability, latency, security, scalability>
- Compliance/security concerns: <concerns>

Required output:
1. Objective
2. Background / Context
3. Scope
4. Requirements
5. Assumptions
6. Architecture diagrams using Mermaid
7. Component responsibilities
8. Data flow
9. API/event/integration contracts
10. Sequence flows
11. Data/state model if needed
12. Security design
13. Failure scenarios
14. Observability
15. Deployment/runtime view
16. Risks and trade-offs
17. Implementation plan
18. Open questions

Rules:
- Write as an implementation-ready technical document.
- Every diagram must have explanation.
- Do not only explain; structure it as a document.
- Include security, observability, and failure handling.
```

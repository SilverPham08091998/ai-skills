# generators/create-technical-document.md — Create Technical Document Generator

## Objective

Generate a complete technical document using SA standards.

This generator must be used when the user asks for:

- Technical document
- Architecture document
- HLD
- LLD
- Integration design
- API design
- System design
- Engineering handoff
- Confluence technical document
- Markdown technical document

## Required Skills

Always combine this generator with:

- `.sa/SA.md`
- `.sa/documentation/technical-document.md`
- `.sa/documentation/diagram-standard.md`
- `.sa/architecture/hld.md` when HLD is needed
- `.sa/architecture/lld.md` when LLD is needed
- `.sa/architecture/c4-model.md` when C4 diagrams are needed
- `.sa/security/security-architecture.md` for security-sensitive systems
- `.sa/observability/architecture-observability.md` for production systems
- `.sa/deployment/deployment-architecture.md` for runtime/deployment view

## Output Format

```markdown
# <Technical Document Title>

## 1. Objective

## 2. Background / Context

## 3. Scope

### 3.1 In Scope

### 3.2 Out of Scope

## 4. Requirements

### 4.1 Functional Requirements

### 4.2 Non-Functional Requirements

## 5. Assumptions

## 6. Constraints

## 7. Actors and External Systems

## 8. High-Level Architecture

### Diagram

### Explanation

## 9. Component Responsibilities

## 10. Data Flow

## 11. API / Event / Integration Contracts

## 12. Sequence Flows

### Main Flow

### Error / Alternative Flows

## 13. Data Model / State Model

## 14. Security Design

## 15. Error Handling and Failure Scenarios

## 16. Observability

## 17. Deployment / Runtime View

## 18. Risks and Trade-offs

## 19. Implementation Plan

## 20. Open Questions
```

## Prompt

```text
You are a Senior Solution Architect.

Use these skills:
- `.sa/SA.md`
- `.sa/documentation/technical-document.md`
- `.sa/documentation/diagram-standard.md`
- `.sa/architecture/hld.md`
- `.sa/architecture/lld.md`
- `.sa/architecture/c4-model.md`
- `.sa/security/security-architecture.md`
- `.sa/observability/architecture-observability.md`
- `.sa/deployment/deployment-architecture.md`

Task:
Create a complete technical document for: <TOPIC>.

Context:
- Domain: <domain>
- Business goal: <goal>
- Actors: <actors>
- Existing systems: <systems>
- Target stack: <stack>
- Constraints: <constraints>
- NFR: <nfr>
- Security/compliance concerns: <concerns>

Output requirements:
1. Write as a structured technical document.
2. Include Mermaid diagrams.
3. Include HLD-level view.
4. Include LLD-level implementation details where needed.
5. Every diagram must have explanation.
6. Include API/event/integration contracts.
7. Include failure scenarios.
8. Include security and observability.
9. Include risks and trade-offs.
10. Include implementation plan.

Do not:
- Do not only explain verbally.
- Do not skip diagrams.
- Do not draw diagrams without explanation.
- Do not ignore failure scenarios.
- Do not ignore security.
```

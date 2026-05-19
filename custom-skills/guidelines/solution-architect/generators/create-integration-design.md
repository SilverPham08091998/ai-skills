# generators/create-integration-design.md — Generator — Create Integration Design

## Objective

Generate integration design for internal or external systems.

## When To Use

- Partner integration
- Service-to-service integration
- Webhook/Kafka/API design

## Scope

- Integration style
- Sequence
- Contracts
- Auth
- Timeout
- Retry
- Idempotency
- Reconciliation
- Monitoring

## Architecture Rules

1. Choose sync/async intentionally.
2. Define contracts.
3. Define error/retry behavior.
4. Define idempotency and reconciliation for external commands.
5. Separate adapter from domain.

## Security / Compliance Rules

1. Validate callback signatures.
2. Protect sensitive payloads.
3. Audit external requests/responses.

## Anti-patterns

- No timeout.
- No retry policy.
- No idempotency.
- No reconciliation.
- Partner logic mixed in core domain.

## Expected Output

1. Integration design markdown
2. Sequence diagram
3. Failure matrix
4. Contract outline

## Review Checklist

- [ ] Integration design markdown
- [ ] Sequence diagram
- [ ] Failure matrix
- [ ] Contract outline

## Prompt

```text
Use `.sa/generators/create-integration-design.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/generators/create-integration-design.md`.

Task:
<describe the architecture task>

Context:
- Domain:
- Actors:
- Existing systems:
- Constraints:
- NFR:
- Security/compliance concerns:

Output:
- Assumptions
- Architecture/design
- Diagrams if useful
- Trade-offs
- Risks
- Implementation handoff
```

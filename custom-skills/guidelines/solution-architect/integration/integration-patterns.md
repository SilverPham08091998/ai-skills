# integration/integration-patterns.md — Integration Patterns Standard

## Objective

Choose integration style based on coupling, latency, reliability, and ownership.

## When To Use

- Integrating services
- Choosing sync/async
- Designing partner integration

## Scope

- REST
- gRPC
- Kafka/event
- Webhook
- Batch
- File transfer
- Polling
- Saga

## Architecture Rules

1. Use synchronous call when immediate response is required.
2. Use async event when decoupling and eventual consistency are acceptable.
3. Use webhook for external callbacks.
4. Use batch for bulk scheduled exchange.
5. Document ownership and SLA.

## Security / Compliance Rules

1. Secure external integrations.
2. Define auth, encryption, timeout, retry, idempotency.
3. Do not trust partner callback blindly.

## Anti-patterns

- Everything synchronous.
- Everything Kafka.
- No timeout/retry contract.
- No ownership/SLA.

## Expected Output

1. Integration style recommendation
2. Sequence flow
3. Failure handling
4. Contract notes

## Review Checklist

- [ ] Integration style recommendation
- [ ] Sequence flow
- [ ] Failure handling
- [ ] Contract notes

## Prompt

```text
Use `.sa/integration/integration-patterns.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/integration/integration-patterns.md`.

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

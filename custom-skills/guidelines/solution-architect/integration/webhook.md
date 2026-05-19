# integration/webhook.md — Webhook Standard

## Objective

Define inbound/outbound webhook architecture with security, retry, and audit.

## When To Use

- Partner callback
- Outbound notification
- Payment status webhook
- Async external response

## Scope

- Signature
- Timestamp
- Replay protection
- Retry
- DLQ
- Callback URL
- Audit
- Idempotency

## Architecture Rules

1. Verify webhook signature.
2. Protect against replay.
3. Return fast response.
4. Process asynchronously if heavy.
5. Use idempotency for duplicate callbacks.
6. Audit payload safely.

## Security / Compliance Rules

1. Do not trust callback status blindly.
2. Mask sensitive data.
3. Validate source/IP if applicable.

## Anti-patterns

- No signature verification.
- Processing long task synchronously.
- No duplicate handling.
- No replay protection.

## Expected Output

1. Webhook contract
2. Security validation
3. Retry strategy
4. Sequence diagram

## Review Checklist

- [ ] Webhook contract
- [ ] Security validation
- [ ] Retry strategy
- [ ] Sequence diagram

## Prompt

```text
Use `.sa/integration/webhook.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/integration/webhook.md`.

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

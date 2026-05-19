# integration/external-partner.md — External Partner Integration Standard

## Objective

Define architecture rules for integrating banks, billers, payment gateways, vendors, and third parties.

## When To Use

- Partner API integration
- Payment gateway integration
- Bank/biller integration
- Webhook callback flow

## Scope

- Authentication
- Encryption
- IP allowlist
- Timeout
- Retry
- Idempotency
- Callback
- Reconciliation
- Audit

## Architecture Rules

1. Treat partner as unreliable dependency.
2. Define timeout and retry per API.
3. Use idempotency for commands.
4. Persist request/response audit safely.
5. Design reconciliation job.
6. Separate adapter from domain logic.

## Security / Compliance Rules

1. Mask sensitive partner payloads.
2. Use mTLS/signature if required.
3. Validate callback signature.
4. Restrict outbound/inbound network path.

## Anti-patterns

- Calling partner directly from domain service everywhere.
- No reconciliation.
- No callback verification.
- No audit trail.
- Blind retry of debit/credit.

## Expected Output

1. Partner integration architecture
2. Adapter responsibilities
3. Failure matrix
4. Reconciliation plan

## Review Checklist

- [ ] Partner integration architecture
- [ ] Adapter responsibilities
- [ ] Failure matrix
- [ ] Reconciliation plan

## Prompt

```text
Use `.sa/integration/external-partner.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/integration/external-partner.md`.

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

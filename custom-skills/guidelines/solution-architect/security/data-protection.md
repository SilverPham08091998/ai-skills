# security/data-protection.md — Data Protection Standard

## Objective

Define protection of sensitive data at rest, in transit, in logs, and in analytics.

## When To Use

- Handling PII/payment data
- Designing storage/logging
- Compliance review

## Scope

- Classification
- Encryption
- Masking
- Tokenization
- Retention
- Access control
- Audit

## Architecture Rules

1. Classify data before storing.
2. Encrypt sensitive data at rest and in transit.
3. Mask sensitive logs.
4. Restrict access by role.
5. Define retention and deletion policies.
6. Avoid unnecessary data collection.

## Security / Compliance Rules

1. Never log OTP/PIN/token/CVV/private key.
2. Protect backups.
3. Review analytics exports.

## Anti-patterns

- No data classification.
- Plain sensitive logs.
- No retention policy.
- Broad DB access.

## Expected Output

1. Data classification table
2. Protection controls
3. Logging rules
4. Retention plan

## Review Checklist

- [ ] Data classification table
- [ ] Protection controls
- [ ] Logging rules
- [ ] Retention plan

## Prompt

```text
Use `.sa/security/data-protection.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/security/data-protection.md`.

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

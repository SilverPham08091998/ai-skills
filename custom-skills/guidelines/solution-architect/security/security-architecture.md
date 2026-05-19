# security/security-architecture.md — Security Architecture Standard

## Objective

Design security controls across identity, network, application, data, and operations.

## When To Use

- Any production architecture
- Threat modeling
- Security review

## Scope

- Identity
- Authentication
- Authorization
- Network
- Data protection
- Audit
- Secrets
- Monitoring

## Architecture Rules

1. Use defense in depth.
2. Identify trust boundaries.
3. Authenticate users/services.
4. Authorize at service/domain level.
5. Encrypt sensitive data.
6. Audit critical actions.
7. Manage secrets securely.

## Security / Compliance Rules

1. Protect PII and financial data.
2. Never trust client/gateway headers blindly.
3. Validate partner signatures.

## Anti-patterns

- Security only at gateway.
- No service authorization.
- Secrets in config.
- No audit logs.
- No threat model.

## Expected Output

1. Security architecture section
2. Trust boundaries
3. Control matrix
4. Risks

## Review Checklist

- [ ] Security architecture section
- [ ] Trust boundaries
- [ ] Control matrix
- [ ] Risks

## Prompt

```text
Use `.sa/security/security-architecture.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/security/security-architecture.md`.

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

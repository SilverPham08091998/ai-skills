# security/compliance-review.md — Compliance Review Standard

## Objective

Review architecture against fintech/banking governance and audit needs.

## When To Use

- Before production
- Architecture approval
- Security/compliance review

## Scope

- Audit
- Access control
- Encryption
- Data retention
- Change management
- Incident response
- Evidence

## Architecture Rules

1. Production changes must be traceable.
2. Critical actions must be audited.
3. Access must be reviewable.
4. Encryption and backup must be documented.
5. Evidence must be collectible.

## Security / Compliance Rules

1. Protect audit logs from tampering.
2. Mask sensitive data.
3. Restrict privileged access.

## Anti-patterns

- No audit evidence.
- No access review.
- No backup/restore proof.
- No change record.

## Expected Output

1. Compliance checklist
2. Evidence list
3. Risks
4. Approval recommendation

## Review Checklist

- [ ] Compliance checklist
- [ ] Evidence list
- [ ] Risks
- [ ] Approval recommendation

## Prompt

```text
Use `.sa/security/compliance-review.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/security/compliance-review.md`.

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

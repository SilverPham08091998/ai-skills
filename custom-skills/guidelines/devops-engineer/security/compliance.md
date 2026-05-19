# security/compliance.md — Compliance Review Standard

## Objective

Define fintech/banking compliance review checklist for platform changes.

## When To Use

- Production readiness review
- Security audit
- Fintech platform governance
- Change review

## Scope

- Secrets
- IAM
- Network segmentation
- Audit logs
- Encryption
- Backup
- Access review
- Vulnerability scan
- Change management

## Core Rules

1. Production changes must be traceable.
2. Sensitive data must be masked.
3. Access must be reviewed periodically.
4. Critical infrastructure must have backup.
5. Audit logs must be retained according to policy.

## Security Rules

1. Encrypt data in transit and at rest.
2. Protect audit logs.
3. Avoid excessive access during incident/debugging.

## Anti-patterns

- No audit log.
- No vulnerability scan.
- No change record.
- Unmasked sensitive logs.
- No backup evidence.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Compliance checklist
2. Risk findings
3. Approval recommendation
4. Evidence list

## Review Checklist

- [ ] Compliance checklist
- [ ] Risk findings
- [ ] Approval recommendation
- [ ] Evidence list
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/security/compliance.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/security/compliance.md`.

Task:
<describe what you want to create or review>

Context:
- Project: <project-name>
- Environment: <dev|staging|prod>
- Runtime: <runtime>
- Dependencies: <aws/kubernetes/platform dependencies>

Requirements:
- Follow production-grade defaults
- Include security considerations
- Include validation commands
- Include rollback notes where applicable
```

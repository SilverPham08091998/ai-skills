# generators/production-review.md — Generator — Production Readiness Review

## Objective

Review service/platform artifacts before production release.

## When To Use

- User asks for review
- Before production deployment
- Auditing generated DevOps files

## Scope

- Dockerfile
- Helm
- Kubernetes
- Terraform
- Jenkins
- ArgoCD
- Observability
- Security
- SRE

## Core Rules

1. Classify issues by severity.
2. Give actionable fixes.
3. Do not approve if critical risks exist.
4. Include production approval status.
5. Check security, rollback, observability, migration risk.

## Security Rules

1. Call out secret leaks clearly.
2. Flag public exposure risks.
3. Flag missing rollback/backup.

## Anti-patterns

- Superficial review.
- No severity.
- No fix steps.
- Ignoring DB migration or Kafka DLQ.
- Approving without observability.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Critical/High/Medium/Low findings
2. Fix plan
3. Approval: PASS/PASS WITH RISK/FAIL

## Review Checklist

- [ ] Critical/High/Medium/Low findings
- [ ] Fix plan
- [ ] Approval: PASS/PASS WITH RISK/FAIL
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/generators/production-review.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/generators/production-review.md`.

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

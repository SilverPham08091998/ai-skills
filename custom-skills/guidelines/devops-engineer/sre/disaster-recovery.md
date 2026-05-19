# sre/disaster-recovery.md — Disaster Recovery Standard

## Objective

Define DR plan for EKS platform and managed data services.

## When To Use

- Planning DR
- Reviewing backup/restore
- Preparing production platform
- Auditing resilience

## Scope

- RTO
- RPO
- RDS backup/restore
- Redis snapshot
- Kafka recovery
- Terraform state
- GitOps repo
- Secrets recovery

## Core Rules

1. Production database must have backup.
2. Backup restore must be tested.
3. Critical services need DR plan.
4. Infrastructure must be reproducible from Terraform.
5. GitOps repo must be recoverable.

## Security Rules

1. Protect backup access.
2. Encrypt backups.
3. Test restore in isolated environment.
4. Document secret recovery.

## Anti-patterns

- Backup enabled but never tested.
- No RTO/RPO.
- Terraform state lost risk.
- No GitOps recovery plan.
- No secret backup/rotation plan.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. DR plan
2. RTO/RPO table
3. Restore steps
4. Validation checklist

## Review Checklist

- [ ] DR plan
- [ ] RTO/RPO table
- [ ] Restore steps
- [ ] Validation checklist
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/sre/disaster-recovery.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/sre/disaster-recovery.md`.

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

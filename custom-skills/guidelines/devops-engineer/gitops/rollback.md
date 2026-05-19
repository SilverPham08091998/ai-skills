# gitops/rollback.md — GitOps Rollback Standard

## Objective

Define rollback strategies for ArgoCD/Helm deployments.

## When To Use

- Preparing production release
- Handling failed deployment
- Creating runbook
- Reviewing rollback readiness

## Scope

- Git revert
- Image tag rollback
- Helm chart rollback
- ArgoCD rollback
- DB migration consideration

## Core Rules

1. Prefer Git revert for auditability.
2. Do not patch production manually.
3. Keep previous image tags available.
4. Rollback must be tested in staging.
5. DB migration rollback/compatibility must be reviewed.

## Security Rules

1. Avoid rolling back code incompatible with migrated DB.
2. Protect rollback commits with review for prod.
3. Run smoke tests after rollback.

## Anti-patterns

- No previous image retained.
- Manual hotfix in cluster.
- Irreversible DB migration deployed without plan.
- Rollback not documented.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Rollback steps
2. Commands
3. DB migration warning
4. Smoke test checklist

## Review Checklist

- [ ] Rollback steps
- [ ] Commands
- [ ] DB migration warning
- [ ] Smoke test checklist
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/gitops/rollback.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/gitops/rollback.md`.

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

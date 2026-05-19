# gitops/argocd-standard.md — ArgoCD Standard

## Objective

Define GitOps deployment rules using ArgoCD.

## When To Use

- Creating ArgoCD app
- Designing GitOps repo
- Reviewing deployment process
- Moving from kubectl to GitOps

## Scope

- Application
- AppProject
- Helm source
- Sync policy
- Namespace creation
- Health status

## Core Rules

1. Git is the source of truth.
2. No manual production deployment.
3. ArgoCD apps must be declared in Git.
4. Dev may auto-sync.
5. Staging/prod should use gated/manual sync.
6. Rollback should be Git revert or chart/image rollback.

## Security Rules

1. Restrict ArgoCD project permissions.
2. Protect production app changes through PR approval.
3. Avoid broad destination permissions.

## Anti-patterns

- Manual kubectl apply to prod.
- ArgoCD app with cluster-wide broad permissions.
- Auto-sync prod without policy.
- No rollback strategy.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. ArgoCD Application
2. AppProject if needed
3. Sync policy
4. Rollback notes
5. Validation commands

## Review Checklist

- [ ] ArgoCD Application
- [ ] AppProject if needed
- [ ] Sync policy
- [ ] Rollback notes
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/gitops/argocd-standard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/gitops/argocd-standard.md`.

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

# generators/create-argocd-app.md — Generator — Create ArgoCD Application

## Objective

Generate ArgoCD Application and optional AppProject manifests.

## When To Use

- User asks for ArgoCD app
- Onboarding service to GitOps
- Creating app-of-apps entry

## Scope

- Application manifest
- AppProject
- Helm source
- Values file
- Sync policy
- Namespace

## Core Rules

1. Use dev auto-sync only if requested/allowed.
2. Use safer prod sync.
3. Include rollback notes.
4. Scope project permissions.
5. Use environment-specific values.

## Security Rules

1. Do not give broad cluster permissions.
2. Protect prod sync.
3. Avoid auto-prune without review.

## Anti-patterns

- Application with wrong repo/path.
- No namespace option.
- Prod auto-sync accidentally.
- No rollback plan.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. ArgoCD YAML
2. Sync policy
3. Rollback instruction
4. Validation commands

## Review Checklist

- [ ] ArgoCD YAML
- [ ] Sync policy
- [ ] Rollback instruction
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/generators/create-argocd-app.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/generators/create-argocd-app.md`.

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

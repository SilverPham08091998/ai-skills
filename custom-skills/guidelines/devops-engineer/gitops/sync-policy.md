# gitops/sync-policy.md — ArgoCD Sync Policy Standard

## Objective

Define safe sync policies per environment.

## When To Use

- Choosing auto/manual sync
- Reviewing production GitOps risk
- Configuring prune/selfHeal

## Scope

- Automated sync
- Manual sync
- Prune
- Self-heal
- Sync options
- CreateNamespace

## Core Rules

1. Auto-sync is acceptable for dev.
2. Prod should require approval unless team policy allows automation.
3. Prune must be used carefully.
4. Self-heal in prod must be reviewed.
5. Use CreateNamespace when appropriate.

## Security Rules

1. Avoid accidental deletion with prune.
2. Protect prod from unreviewed changes.
3. Restrict sync permissions.

## Anti-patterns

- Auto-sync prod blindly.
- Prune without understanding impact.
- No sync options for namespace creation.
- Ignoring drift alerts.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Sync policy recommendation
2. Environment matrix
3. Risk notes
4. Validation commands

## Review Checklist

- [ ] Sync policy recommendation
- [ ] Environment matrix
- [ ] Risk notes
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/gitops/sync-policy.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/gitops/sync-policy.md`.

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

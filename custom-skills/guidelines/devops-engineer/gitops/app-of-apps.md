# gitops/app-of-apps.md — ArgoCD App-of-Apps Standard

## Objective

Define app-of-apps structure for platform and service deployments.

## When To Use

- Creating GitOps root app
- Managing many apps
- Separating platform/services
- Bootstrapping cluster

## Scope

- Root app
- Child apps
- Platform apps
- Service apps
- Environment folders

## Core Rules

1. Root app controls child apps.
2. Platform apps are separated from business apps.
3. Production app changes must be reviewed.
4. Avoid circular dependencies.
5. Order platform dependencies carefully.

## Security Rules

1. Protect root app changes.
2. Restrict who can sync platform apps.
3. Avoid deleting root app accidentally.

## Anti-patterns

- Flat unmanaged ArgoCD apps.
- Circular dependencies.
- Business apps deployed before required platform components.
- Root app too broad.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Root Application manifest
2. Folder structure
3. Dependency notes
4. Validation commands

## Review Checklist

- [ ] Root Application manifest
- [ ] Folder structure
- [ ] Dependency notes
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/gitops/app-of-apps.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/gitops/app-of-apps.md`.

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

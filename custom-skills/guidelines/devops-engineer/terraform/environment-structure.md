# terraform/environment-structure.md — Terraform Environment Structure Standard

## Objective

Define dev/staging/prod Terraform layout.

## When To Use

- Creating environment folders
- Separating Terraform states
- Designing platform IaC repo

## Scope

- environments/dev
- environments/staging
- environments/prod
- tfvars
- backend.tf
- module usage

## Core Rules

1. Each environment must have separate state.
2. Each environment must use environment-specific tfvars.
3. Production must not share backend with dev.
4. Use same modules with different values.
5. Avoid copy-paste large resources across envs.

## Security Rules

1. Restrict production backend access.
2. Use state locking.
3. Protect tfvars containing sensitive references.

## Anti-patterns

- One state for all environments.
- Local state for team infra.
- Duplicated resource definitions across envs.
- Prod values mixed in dev.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Environment folder structure
2. Backend config
3. tfvars pattern
4. Validation commands

## Review Checklist

- [ ] Environment folder structure
- [ ] Backend config
- [ ] tfvars pattern
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/terraform/environment-structure.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/terraform/environment-structure.md`.

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

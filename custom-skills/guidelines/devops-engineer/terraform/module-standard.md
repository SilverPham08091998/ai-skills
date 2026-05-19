# terraform/module-standard.md — Terraform Module Standard

## Objective

Define reusable Terraform module design rules.

## When To Use

- Creating Terraform module
- Reviewing module quality
- Refactoring IaC
- Preparing multi-env infra

## Scope

- main.tf
- variables.tf
- outputs.tf
- versions.tf
- README.md
- Examples
- Validation

## Core Rules

1. Module must be reusable.
2. No hard-coded environment values.
3. All important inputs must be variables.
4. Useful integration values must be outputs.
5. Use variable validation where possible.
6. Apply common tags.

## Security Rules

1. Keep provider config outside reusable module unless necessary.
2. Avoid exposing secrets in outputs.
3. Mark sensitive outputs as sensitive.

## Anti-patterns

- Copy-paste modules per environment.
- Untyped variables.
- No outputs.
- No README.
- Hard-coded region/env/name.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Reusable module files
2. Typed variables
3. Outputs
4. README
5. Example usage
6. Validation commands

## Review Checklist

- [ ] Reusable module files
- [ ] Typed variables
- [ ] Outputs
- [ ] README
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/terraform/module-standard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/terraform/module-standard.md`.

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

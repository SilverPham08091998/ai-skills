# terraform/naming-convention.md — Terraform Naming Convention Standard

## Objective

Define predictable naming for AWS resources.

## When To Use

- Naming AWS resources
- Reviewing Terraform consistency
- Creating modules

## Scope

- Project
- Environment
- Component
- Suffix
- AWS name constraints

## Core Rules

1. Names must include project and environment.
2. Use lowercase and hyphen.
3. Avoid random suffix unless required.
4. Keep names within service limits.
5. Name must be predictable from context.

## Security Rules

1. Avoid leaking sensitive business names if not approved.
2. Use consistent environment names.

## Anti-patterns

- Inconsistent names.
- Random names everywhere.
- Missing environment in resource name.
- Overly long names.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Naming pattern
2. Examples
3. Validation/review checklist

## Review Checklist

- [ ] Naming pattern
- [ ] Examples
- [ ] Validation/review checklist
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/terraform/naming-convention.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/terraform/naming-convention.md`.

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

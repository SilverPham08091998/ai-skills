# generators/create-terraform-module.md — Generator — Create Terraform Module

## Objective

Generate a production-grade Terraform module using the relevant standards.

## When To Use

- User asks to create Terraform module
- Implementing AWS infrastructure
- Refactoring IaC into module

## Scope

- Module files
- Variables
- Outputs
- Versions
- README
- Example usage
- Security notes

## Core Rules

1. Load related AWS skill file first.
2. Apply module-standard, naming, tagging, remote state principles.
3. Include validation commands.
4. Explain assumptions.
5. Avoid hard-coded env values.

## Security Rules

1. Do not output secrets.
2. Mark sensitive outputs.
3. Use least privilege.

## Anti-patterns

- Generating only main.tf.
- No variables/outputs.
- Hard-coded names.
- No README.
- No validation.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Full module
2. Example env usage
3. Security notes
4. Validation commands

## Review Checklist

- [ ] Full module
- [ ] Example env usage
- [ ] Security notes
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/generators/create-terraform-module.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/generators/create-terraform-module.md`.

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

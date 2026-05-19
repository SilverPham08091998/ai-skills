# terraform/tagging-standard.md — Terraform Tagging Standard

## Objective

Define mandatory AWS tagging for ownership, cost, and governance.

## When To Use

- Adding Terraform tags
- Reviewing cloud cost governance
- Creating AWS modules

## Scope

- Project
- Environment
- Owner
- ManagedBy
- CostCenter
- Application
- Criticality
- DataClass

## Core Rules

1. Every AWS resource must have common tags when supported.
2. Cost-related resources must have CostCenter.
3. Production resources should include Criticality.
4. Modules must accept and merge common tags.

## Security Rules

1. Avoid sensitive data in tags.
2. Ensure compliance tags are standardized.
3. Prevent tag drift.

## Anti-patterns

- No tags.
- Different tag keys per module.
- Hard-coded owner/cost center.
- Sensitive info in tags.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Tag variable schema
2. Common tags local
3. Merged resource tags
4. Validation checklist

## Review Checklist

- [ ] Tag variable schema
- [ ] Common tags local
- [ ] Merged resource tags
- [ ] Validation checklist
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/terraform/tagging-standard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/terraform/tagging-standard.md`.

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

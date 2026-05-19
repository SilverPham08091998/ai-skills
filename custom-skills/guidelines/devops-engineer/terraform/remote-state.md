# terraform/remote-state.md — Terraform Remote State Standard

## Objective

Define secure remote state storage and locking.

## When To Use

- Setting up Terraform backend
- Reviewing IaC security
- Preparing team collaboration

## Scope

- S3 backend
- DynamoDB lock table
- KMS encryption
- Bucket versioning
- State key pattern

## Core Rules

1. Never store local state for shared infrastructure.
2. Enable state locking.
3. Encrypt state.
4. Restrict state bucket access.
5. Use separate state key per environment/component.

## Security Rules

1. Do not expose state bucket publicly.
2. Restrict who can read state because it may contain sensitive values.
3. Enable bucket versioning.

## Anti-patterns

- Local tfstate committed to Git.
- No lock table.
- Public state bucket.
- Same state key for all envs.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Backend config
2. S3 bucket
3. DynamoDB lock table
4. IAM policy notes
5. Validation commands

## Review Checklist

- [ ] Backend config
- [ ] S3 bucket
- [ ] DynamoDB lock table
- [ ] IAM policy notes
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/terraform/remote-state.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/terraform/remote-state.md`.

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

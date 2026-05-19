# security/iam-rule.md — IAM Security Rule

## Objective

Define least privilege IAM review and implementation rules.

## When To Use

- Reviewing IAM policy
- Creating IRSA role
- Securing CI/CD role
- Auditing AWS access

## Scope

- Least privilege
- IAM role
- IAM policy
- Trust policy
- IRSA
- Access review

## Core Rules

1. Least privilege always.
2. Prefer role over user access key.
3. Use IRSA for EKS workloads.
4. Separate roles by service and environment.
5. Production access must be audited.
6. No wildcard admin for applications.

## Security Rules

1. Restrict trust policies.
2. Avoid long-lived credentials.
3. Review unused permissions.
4. Use condition keys where useful.

## Anti-patterns

- AdministratorAccess for service.
- Static keys in Git/Jenkins.
- Wildcard Resource without need.
- Shared prod/dev role.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. IAM review notes
2. Safer policy
3. IRSA mapping
4. Validation commands

## Review Checklist

- [ ] IAM review notes
- [ ] Safer policy
- [ ] IRSA mapping
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/security/iam-rule.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/security/iam-rule.md`.

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

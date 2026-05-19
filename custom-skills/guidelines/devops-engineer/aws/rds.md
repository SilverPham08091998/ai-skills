# aws/rds.md — Amazon RDS PostgreSQL Standard

## Objective

Define RDS PostgreSQL provisioning and operation standards for transactional fintech workloads.

## When To Use

- Creating RDS Terraform module
- Reviewing database network/security
- Preparing Spring Boot DB integration
- Designing backup/restore

## Scope

- RDS PostgreSQL instance
- Subnet group
- Parameter group
- Security group
- Secrets Manager credential
- Backup policy
- Performance Insights
- Deletion protection

## Core Rules

1. RDS must be in private DB subnets.
2. Production should use Multi-AZ.
3. Do not use master user from application.
4. Each service should have separate database/schema/user.
5. Use Flyway or Liquibase for migration.
6. Enable automated backup.
7. Enable deletion protection for production.

## Security Rules

1. No public access.
2. Restrict port 5432 to app security groups.
3. Store credentials in Secrets Manager.
4. Use SSL where required.
5. Audit production access.

## Anti-patterns

- Public RDS instance.
- App using master user.
- Credentials in application.yml.
- No backup or restore test.
- DB migration not backward compatible.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Terraform RDS module
2. DB subnet group
3. Security group
4. Secret output
5. Connection outputs
6. Backup settings
7. Validation commands

## Review Checklist

- [ ] Terraform RDS module
- [ ] DB subnet group
- [ ] Security group
- [ ] Secret output
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/aws/rds.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/aws/rds.md`.

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

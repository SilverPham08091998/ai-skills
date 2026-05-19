# aws/redis.md — Amazon ElastiCache Redis Standard

## Objective

Define Redis/ElastiCache standards for cache, idempotency, locks, and short-lived state.

## When To Use

- Creating Redis Terraform module
- Implementing idempotency
- Designing distributed lock
- Preparing Spring Boot Redis config

## Scope

- ElastiCache Redis
- Subnet group
- Security group
- Parameter group
- Auth token
- Encryption in transit
- Encryption at rest
- Cluster mode option

## Core Rules

1. Redis must run in private subnets.
2. Every key must have TTL unless explicitly approved.
3. Use key prefix per service/domain.
4. Use cluster mode for production scale when required.
5. Use standalone for simple/dev workloads.
6. Do not use Redis as source of truth.

## Security Rules

1. Do not expose Redis publicly.
2. Enable auth token for production.
3. Enable encryption in transit for production.
4. Do not store sensitive data unless encrypted or masked.

## Anti-patterns

- No TTL keys.
- Public Redis endpoint.
- Shared key namespace with no prefix.
- Storing permanent business records in Redis.
- No memory/eviction monitoring.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Terraform Redis module
2. Standalone/cluster option
3. Security group
4. Outputs for app config
5. Key naming guideline
6. Validation commands

## Review Checklist

- [ ] Terraform Redis module
- [ ] Standalone/cluster option
- [ ] Security group
- [ ] Outputs for app config
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/aws/redis.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/aws/redis.md`.

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

# aws/msk.md — Amazon MSK Kafka Standard

## Objective

Define Kafka/MSK standards for event-driven and asynchronous communication.

## When To Use

- Creating MSK Terraform module
- Designing Kafka topics
- Reviewing event-driven architecture
- Preparing Spring Cloud Stream config

## Scope

- MSK cluster
- Broker subnets
- Security group
- Encryption
- Authentication
- Topic convention
- Consumer group convention
- Monitoring

## Core Rules

1. Kafka must be private.
2. Message schema should be versioned.
3. Producer must include eventId, occurredAt, traceId/correlationId.
4. Consumers must be idempotent.
5. Important flows require retry and DLQ.
6. Monitor consumer lag.
7. Do not use Kafka as database.

## Security Rules

1. Enable encryption in transit and at rest.
2. Restrict broker access.
3. Avoid unauthenticated public brokers.
4. Protect sensitive payloads.

## Anti-patterns

- Public Kafka brokers.
- No DLQ for critical flows.
- No consumer idempotency.
- Unbounded retry loop.
- No schema/versioning strategy.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Terraform MSK module
2. Networking/security
3. Encryption/auth baseline
4. Topic naming rules
5. Monitoring outputs
6. Validation commands

## Review Checklist

- [ ] Terraform MSK module
- [ ] Networking/security
- [ ] Encryption/auth baseline
- [ ] Topic naming rules
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/aws/msk.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/aws/msk.md`.

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

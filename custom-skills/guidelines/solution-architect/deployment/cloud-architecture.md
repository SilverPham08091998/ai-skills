# deployment/cloud-architecture.md — Cloud Architecture Standard

## Objective

Design AWS cloud architecture for scalable, secure, production workloads.

## When To Use

- Designing AWS platform
- Choosing managed services
- Reviewing cloud topology

## Scope

- VPC
- EKS
- RDS
- Redis
- MSK
- S3
- IAM
- Secrets
- Observability
- DR

## Architecture Rules

1. Prefer managed services for operationally heavy components.
2. Use private subnets for workloads/data.
3. Use IAM least privilege.
4. Design for AZ failure.
5. Automate with Terraform.

## Security / Compliance Rules

1. Use encryption at rest/in transit.
2. Restrict network paths.
3. Avoid public data stores.

## Anti-patterns

- Self-managing everything without reason.
- No IaC.
- Public database/cache.
- No tagging/cost controls.

## Expected Output

1. AWS architecture
2. Service selection rationale
3. Security controls
4. Cost/ops trade-offs

## Review Checklist

- [ ] AWS architecture
- [ ] Service selection rationale
- [ ] Security controls
- [ ] Cost/ops trade-offs

## Prompt

```text
Use `.sa/deployment/cloud-architecture.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/deployment/cloud-architecture.md`.

Task:
<describe the architecture task>

Context:
- Domain:
- Actors:
- Existing systems:
- Constraints:
- NFR:
- Security/compliance concerns:

Output:
- Assumptions
- Architecture/design
- Diagrams if useful
- Trade-offs
- Risks
- Implementation handoff
```

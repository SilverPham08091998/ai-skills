# sre/capacity-planning.md — Capacity Planning Standard

## Objective

Define capacity planning for EKS, apps, RDS, Redis, Kafka, and cost.

## When To Use

- Forecasting growth
- Reviewing resource usage
- Planning peak traffic
- Tuning autoscaling

## Scope

- Traffic
- CPU/memory
- Pods
- Nodes
- DB connections
- Kafka throughput
- Redis memory
- HPA
- Cost

## Core Rules

1. Plan based on metrics, not guess only.
2. Keep headroom for traffic spikes.
3. Review HPA and node autoscaling.
4. DB pool must align with RDS max connections.
5. Kafka partition count must support consumer scaling.

## Security Rules

1. Avoid overprovisioning without cost review.
2. Protect critical services with headroom.
3. Monitor saturation trends.

## Anti-patterns

- No capacity model.
- DB connection exhaustion.
- Kafka partitions too few.
- Node group max too low.
- No cost estimate.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Capacity report
2. Sizing recommendation
3. Risk list
4. Cost notes

## Review Checklist

- [ ] Capacity report
- [ ] Sizing recommendation
- [ ] Risk list
- [ ] Cost notes
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/sre/capacity-planning.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/sre/capacity-planning.md`.

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

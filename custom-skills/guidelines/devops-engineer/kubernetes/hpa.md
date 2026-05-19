# kubernetes/hpa.md — Kubernetes HPA Standard

## Objective

Define Horizontal Pod Autoscaler rules for app scalability.

## When To Use

- Adding autoscaling
- Reviewing CPU/memory targets
- Scaling Kafka consumers
- Tuning production service

## Scope

- HPA autoscaling/v2
- CPU metric
- Memory metric
- Custom metrics
- Kafka lag metric
- Scale behavior

## Core Rules

1. HPA requires resource requests.
2. CPU autoscaling is baseline.
3. Memory autoscaling must be used carefully.
4. Kafka consumers may need lag-based scaling.
5. Production minReplicas should usually be at least 2.

## Security Rules

1. Avoid scaling from zero for critical APIs unless designed.
2. Prevent aggressive scale-down for critical traffic.
3. Use maxReplicas to control cost and blast radius.

## Anti-patterns

- HPA without resource requests.
- Max replicas too low for peak traffic.
- CPU target too high.
- Ignoring Kafka lag for consumers.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. HPA manifest
2. Metric strategy
3. Scale behavior
4. Validation commands
5. Tuning notes

## Review Checklist

- [ ] HPA manifest
- [ ] Metric strategy
- [ ] Scale behavior
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kubernetes/hpa.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kubernetes/hpa.md`.

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

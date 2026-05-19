# kubernetes/resource-limit.md — Kubernetes Resource Limit Standard

## Objective

Define CPU/memory request and limit standards for JVM workloads.

## When To Use

- Sizing Spring Boot service
- Creating Helm values
- Reviewing HPA readiness
- Tuning production resources

## Scope

- CPU requests
- Memory requests
- CPU limits
- Memory limits
- JVM container flags
- LimitRange

## Core Rules

1. Every container must have requests and limits.
2. JVM memory must align with container memory limit.
3. Avoid overly tight CPU limits for Java services.
4. Tune based on metrics and load tests.
5. HPA CPU target depends on CPU request.

## Security Rules

1. Prevent OOMKill by setting MaxRAMPercentage.
2. Avoid setting memory limit too close to JVM heap needs.
3. Monitor throttling.

## Anti-patterns

- No resources.
- Memory limit smaller than JVM needs.
- Huge requests wasting nodes.
- CPU throttling hidden by low limits.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Recommended values
2. JVM flags
3. Helm values snippet
4. Validation commands

## Review Checklist

- [ ] Recommended values
- [ ] JVM flags
- [ ] Helm values snippet
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kubernetes/resource-limit.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kubernetes/resource-limit.md`.

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

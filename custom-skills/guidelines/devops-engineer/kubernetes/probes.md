# kubernetes/probes.md — Kubernetes Probes Standard

## Objective

Define readiness, liveness, and startup probe standards.

## When To Use

- Adding health checks
- Reviewing Spring Boot Actuator integration
- Fixing restart storms
- Creating deployment template

## Scope

- Readiness probe
- Liveness probe
- Startup probe
- Spring Boot actuator endpoints

## Core Rules

1. Readiness means pod can receive traffic.
2. Liveness means pod is stuck and should restart.
3. Do not make liveness depend on fragile external dependencies.
4. Readiness may include critical dependencies.
5. Use startupProbe for slow-starting Java apps.

## Security Rules

1. Avoid restart storms caused by DB/Kafka outage in liveness.
2. Do not expose sensitive actuator endpoints publicly.

## Anti-patterns

- No probes.
- Same endpoint for all probes without semantics.
- Liveness checks DB and restarts all pods during DB outage.
- Too aggressive timeout.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Probe YAML
2. Recommended timings
3. Spring Boot actuator config notes
4. Validation commands

## Review Checklist

- [ ] Probe YAML
- [ ] Recommended timings
- [ ] Spring Boot actuator config notes
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kubernetes/probes.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kubernetes/probes.md`.

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

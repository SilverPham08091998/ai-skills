# istio/traffic-management.md — Istio Traffic Management Standard

## Objective

Define canary, blue/green, header routing, mirroring, and fault injection rules.

## When To Use

- Canary release
- Blue/green deployment
- Testing new version
- Routing internal test traffic

## Scope

- VirtualService weights
- DestinationRule subsets
- Header match
- Mirror traffic
- Fault injection

## Core Rules

1. Canary release must have metrics and rollback rule.
2. Do not canary critical money flow without monitoring.
3. Traffic mirroring must not mutate state.
4. Header routing is useful for internal testing.

## Security Rules

1. Restrict test routes.
2. Avoid mirroring sensitive payloads unnecessarily.
3. Define stop condition before rollout.

## Anti-patterns

- Canary with no rollback.
- Mirroring write traffic to real downstream.
- No stable subset.
- No metrics during rollout.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Traffic split manifests
2. Rollback condition
3. Monitoring checklist
4. Validation commands

## Review Checklist

- [ ] Traffic split manifests
- [ ] Rollback condition
- [ ] Monitoring checklist
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/istio/traffic-management.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/istio/traffic-management.md`.

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

# helm/chart-standard.md — Helm Chart Standard

## Objective

Define reusable Helm chart structure and rules.

## When To Use

- Creating Helm chart
- Packaging Spring Boot service
- Preparing GitOps deployment
- Reviewing chart quality

## Scope

- Chart.yaml
- values.yaml
- templates
- helpers
- Deployment
- Service
- HPA
- PDB
- ServiceAccount
- Istio
- ServiceMonitor

## Core Rules

1. No hard-coded image tag.
2. No hard-coded secret value.
3. Values must support environment overrides.
4. Templates must use standard labels.
5. Chart must support probes/resources/HPA/PDB.
6. Optional features should use toggles.

## Security Rules

1. Do not expose secrets through rendered manifests.
2. Avoid unsafe defaults.
3. Use service account and security context.

## Anti-patterns

- Chart per service with copy-paste templates.
- Secrets in values.yaml.
- latest image tag.
- No helper labels.
- No env-specific values.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Reusable chart
2. Values files
3. Templates
4. Helper functions
5. Validation commands

## Review Checklist

- [ ] Reusable chart
- [ ] Values files
- [ ] Templates
- [ ] Helper functions
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/helm/chart-standard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/helm/chart-standard.md`.

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

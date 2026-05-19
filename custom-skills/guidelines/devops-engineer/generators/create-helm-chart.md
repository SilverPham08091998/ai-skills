# generators/create-helm-chart.md — Generator — Create Helm Chart

## Objective

Generate a reusable Helm chart for Spring Boot services.

## When To Use

- User asks for Helm chart
- Packaging new service
- Standardizing deployments

## Scope

- Chart.yaml
- values
- templates
- helpers
- K8s resources
- Istio
- ServiceMonitor

## Core Rules

1. Load Helm, Kubernetes, Istio, Observability, Security skills.
2. No latest tags.
3. No plaintext secrets.
4. Include probes/resources/securityContext/HPA/PDB.
5. Support env values.

## Security Rules

1. Avoid unsafe defaults.
2. Use ExternalSecret references.
3. Validate rendered manifest.

## Anti-patterns

- Only deployment template.
- No values separation.
- No probes.
- No securityContext.
- Secrets in values.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Full chart
2. Values files
3. Validation commands
4. Production checklist

## Review Checklist

- [ ] Full chart
- [ ] Values files
- [ ] Validation commands
- [ ] Production checklist
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/generators/create-helm-chart.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/generators/create-helm-chart.md`.

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

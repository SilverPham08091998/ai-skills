# helm/values-standard.md — Helm Values Standard

## Objective

Define safe values.yaml patterns for environment-specific deployment.

## When To Use

- Creating values files
- Reviewing GitOps values
- Separating dev/staging/prod config

## Scope

- Image
- Replica count
- Service
- Resources
- Autoscaling
- Probes
- Istio
- Observability
- Secrets references

## Core Rules

1. Environment-specific values go to env files.
2. Do not place secret values in values.yaml.
3. Use secret references instead.
4. Defaults must be safe.
5. Image tag must be explicit.

## Security Rules

1. Avoid printing secrets in Helm diff.
2. Use ExternalSecret references.
3. Protect prod values changes through review.

## Anti-patterns

- One giant values file for all envs.
- Plaintext password in values.
- No resource values.
- latest tag.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. values.yaml
2. values-dev/staging/prod.yaml
3. Secret reference pattern
4. Validation commands

## Review Checklist

- [ ] values.yaml
- [ ] values-dev/staging/prod.yaml
- [ ] Secret reference pattern
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/helm/values-standard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/helm/values-standard.md`.

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

# helm/deployment-template.md — Helm Deployment Template Standard

## Objective

Define Helm template rules for Kubernetes Deployment.

## When To Use

- Writing templates/deployment.yaml
- Refactoring chart
- Adding security/probes/resources

## Scope

- Template helpers
- Values interpolation
- toYaml/nindent
- SecurityContext
- Probes
- Resources
- Env/envFrom

## Core Rules

1. Use helper templates for labels and names.
2. Use toYaml/nindent for complex values.
3. Make probes configurable.
4. Make securityContext safe by default.
5. Make image tag required.

## Security Rules

1. Avoid injecting secrets as plain text.
2. Avoid privileged defaults.
3. Validate rendered manifests.

## Anti-patterns

- Bad indentation.
- Hard-coded service name.
- No helper labels.
- Missing required image tag.
- Unsafe securityContext.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. deployment.yaml template
2. helpers usage
3. Values mapping
4. Validation commands

## Review Checklist

- [ ] deployment.yaml template
- [ ] helpers usage
- [ ] Values mapping
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/helm/deployment-template.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/helm/deployment-template.md`.

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

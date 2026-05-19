# helm/reusable-chart.md — Reusable Helm Chart Standard

## Objective

Define principles for one generic Spring Boot chart across many services.

## When To Use

- Building platform chart
- Reducing copy-paste
- Creating service values
- Migrating existing charts

## Scope

- Generic chart
- Service-specific values
- Feature toggles
- Backward compatibility
- Chart versioning

## Core Rules

1. One generic Spring Boot chart can serve many services.
2. Service-specific config belongs to values files.
3. Common labels and annotations must be standardized.
4. Do not fork chart per service unless required.
5. Prefer backward-compatible values changes.

## Security Rules

1. Do not add unsafe features by default.
2. Review chart changes like shared library changes.
3. Version chart releases.

## Anti-patterns

- Duplicating chart per service.
- Breaking values schema without migration.
- Hard-coded app config in chart.
- Optional features always enabled.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Reusable chart structure
2. Values schema
3. Migration notes
4. Validation commands

## Review Checklist

- [ ] Reusable chart structure
- [ ] Values schema
- [ ] Migration notes
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/helm/reusable-chart.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/helm/reusable-chart.md`.

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

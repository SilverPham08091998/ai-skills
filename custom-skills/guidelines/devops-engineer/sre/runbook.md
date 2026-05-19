# sre/runbook.md — Runbook Standard

## Objective

Define production runbook template for services and platform components.

## When To Use

- Creating service runbook
- Preparing on-call handover
- Production readiness review
- Incident mitigation

## Scope

- Service overview
- Owners
- Dependencies
- Health checks
- Logs
- Metrics
- Traces
- Common failures
- Rollback
- Escalation

## Core Rules

1. Every production service needs runbook.
2. Runbook must be executable by on-call engineer.
3. Include commands and dashboard links where possible.
4. Update runbook after incidents.

## Security Rules

1. Do not include secrets in runbooks.
2. Avoid commands that mutate prod without warning.
3. Mark dangerous commands clearly.

## Anti-patterns

- Runbook with only description.
- No rollback steps.
- No dashboard/log links.
- No owner/escalation.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Runbook markdown
2. Command examples
3. Validation checklist
4. Escalation section

## Review Checklist

- [ ] Runbook markdown
- [ ] Command examples
- [ ] Validation checklist
- [ ] Escalation section
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/sre/runbook.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/sre/runbook.md`.

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

# sre/incident-response.md — Incident Response Standard

## Objective

Define production incident process and roles.

## When To Use

- Handling outage
- Creating incident process
- Preparing on-call
- Writing postmortem

## Scope

- Severity
- Incident commander
- Triage
- Mitigation
- Communication
- Resolution
- Postmortem
- Action items

## Core Rules

1. SEV1 needs incident commander.
2. Mitigation comes before root cause analysis.
3. Communication must be frequent and clear.
4. Postmortem must be blameless.
5. Action items need owner and due date.

## Security Rules

1. Protect customer data during incident debugging.
2. Limit production access to approved responders.
3. Record important actions.

## Anti-patterns

- Everyone debugging without commander.
- No timeline.
- Blaming individuals.
- No follow-up actions.
- No customer impact statement.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Incident runbook
2. Severity matrix
3. Communication template
4. Postmortem template

## Review Checklist

- [ ] Incident runbook
- [ ] Severity matrix
- [ ] Communication template
- [ ] Postmortem template
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/sre/incident-response.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/sre/incident-response.md`.

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

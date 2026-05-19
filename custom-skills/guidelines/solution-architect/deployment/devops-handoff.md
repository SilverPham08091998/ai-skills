# deployment/devops-handoff.md — DevOps Handoff Standard

## Objective

Prepare architecture output so DevOps can implement infrastructure and deployment.

## When To Use

- After HLD/LLD
- Before Terraform/Helm generation
- Cross-team handoff

## Scope

- Infrastructure requirements
- Runtime requirements
- Secrets
- Configs
- Scaling
- Observability
- Dependencies
- Environments

## Architecture Rules

1. Architecture handoff must be actionable.
2. List infrastructure components and environment needs.
3. Define ports/protocols.
4. Define secrets/configs.
5. Define scaling and observability requirements.

## Security / Compliance Rules

1. Do not include secret values.
2. Classify sensitive configs.
3. Define access requirements.

## Anti-patterns

- Architecture doc with no infra details.
- Missing ports.
- Missing secret list.
- No scaling expectation.

## Expected Output

1. DevOps handoff checklist
2. Environment matrix
3. Dependency list
4. Config/secrets list

## Review Checklist

- [ ] DevOps handoff checklist
- [ ] Environment matrix
- [ ] Dependency list
- [ ] Config/secrets list

## Prompt

```text
Use `.sa/deployment/devops-handoff.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/deployment/devops-handoff.md`.

Task:
<describe the architecture task>

Context:
- Domain:
- Actors:
- Existing systems:
- Constraints:
- NFR:
- Security/compliance concerns:

Output:
- Assumptions
- Architecture/design
- Diagrams if useful
- Trade-offs
- Risks
- Implementation handoff
```

# cicd/release-strategy.md — Release Strategy Standard

## Objective

Define rolling, blue/green, canary, hotfix, and promotion strategies.

## When To Use

- Planning release
- Designing prod promotion
- Handling hotfix
- Choosing canary/blue-green

## Scope

- Rolling update
- Blue/green
- Canary
- Feature flag
- Hotfix
- Promotion gates
- Release notes

## Core Rules

1. Dev can auto deploy.
2. Staging requires approval or release branch.
3. Production requires approval and release notes.
4. Critical services need rollback plan.
5. DB migration must be backward compatible.

## Security Rules

1. Avoid releasing critical flows without monitoring.
2. Protect prod hotfix process.
3. Require smoke test after release.

## Anti-patterns

- Prod release with no rollback.
- DB breaking change before code compatibility.
- No release notes.
- No approval gate.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Release plan
2. Promotion matrix
3. Rollback plan
4. DB migration safety notes

## Review Checklist

- [ ] Release plan
- [ ] Promotion matrix
- [ ] Rollback plan
- [ ] DB migration safety notes
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/cicd/release-strategy.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/cicd/release-strategy.md`.

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

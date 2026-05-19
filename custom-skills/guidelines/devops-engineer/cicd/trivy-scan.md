# cicd/trivy-scan.md — Trivy Scan Standard

## Objective

Define container and IaC scanning rules using Trivy.

## When To Use

- Adding image scan to CI
- Reviewing vulnerabilities
- Blocking unsafe deployment
- Generating scan report

## Scope

- Image scan
- Filesystem scan
- IaC scan
- Severity threshold
- Report artifact
- Exceptions

## Core Rules

1. Scan image before deployment.
2. Fail pipeline on CRITICAL vulnerabilities.
3. HIGH vulnerabilities require policy decision.
4. Produce scan report as artifact.
5. Base images must be updated regularly.

## Security Rules

1. Document exceptions.
2. Avoid suppressing vulnerabilities silently.
3. Protect report artifacts if sensitive.

## Anti-patterns

- No image scan.
- Ignoring CRITICAL CVEs.
- No report.
- Permanent exception with no owner/date.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Trivy command
2. Jenkins stage
3. Failure policy
4. Report artifact

## Review Checklist

- [ ] Trivy command
- [ ] Jenkins stage
- [ ] Failure policy
- [ ] Report artifact
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/cicd/trivy-scan.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/cicd/trivy-scan.md`.

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

# cicd/deployment-flow.md — CI/CD Deployment Flow Standard

## Objective

Define the end-to-end flow from commit to Kubernetes deployment.

## When To Use

- Designing pipeline
- Explaining release path
- Reviewing deployment safety
- Connecting Jenkins and ArgoCD

## Scope

- Commit
- Build
- Test
- Scan
- Image push
- GitOps update
- ArgoCD sync
- Rollout
- Smoke test
- Notify

## Core Rules

1. CI builds and scans image.
2. CD is controlled by GitOps.
3. Image tag must be immutable.
4. Deployment must be observable.
5. Rollout must be verified.

## Security Rules

1. Avoid direct prod deploy from CI unless policy allows.
2. Protect GitOps repo writes.
3. Use environment approvals.

## Anti-patterns

- CI applies Kubernetes manifest directly to prod.
- No smoke test.
- Mutable tags.
- No rollout verification.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Deployment flow diagram
2. Pipeline stages
3. Validation commands
4. Rollback note

## Review Checklist

- [ ] Deployment flow diagram
- [ ] Pipeline stages
- [ ] Validation commands
- [ ] Rollback note
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/cicd/deployment-flow.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/cicd/deployment-flow.md`.

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

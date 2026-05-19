# generators/create-jenkins-pipeline.md — Generator — Create Jenkins Pipeline

## Objective

Generate Jenkins CI/CD pipeline for Spring Boot service.

## When To Use

- User asks for Jenkinsfile
- Adding CI/CD
- Standardizing build/deploy pipeline

## Scope

- Checkout
- Test
- Build
- SonarQube
- Docker
- Trivy
- ECR
- GitOps update
- ArgoCD sync
- Notify

## Core Rules

1. No secrets in Jenkinsfile.
2. Use immutable image tag.
3. Fail on tests and critical CVEs.
4. Update GitOps instead of applying manifests directly.
5. Support promotion.

## Security Rules

1. Use credentials binding.
2. Mask secrets.
3. Use least privilege deploy role.

## Anti-patterns

- Hard-coded credentials.
- latest tag.
- No scan.
- Direct prod kubectl apply.
- No rollback note.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Jenkinsfile
2. Credential list
3. Pipeline explanation
4. Validation commands

## Review Checklist

- [ ] Jenkinsfile
- [ ] Credential list
- [ ] Pipeline explanation
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/generators/create-jenkins-pipeline.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/generators/create-jenkins-pipeline.md`.

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

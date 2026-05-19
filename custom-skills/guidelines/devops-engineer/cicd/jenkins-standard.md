# cicd/jenkins-standard.md — Jenkins Pipeline Standard

## Objective

Define CI/CD pipeline rules for Spring Boot services.

## When To Use

- Creating Jenkinsfile
- Reviewing pipeline
- Adding build/test/scan/deploy
- Standardizing CI/CD

## Scope

- Checkout
- Test
- Build
- SonarQube
- Docker build
- Trivy
- ECR push
- GitOps update
- ArgoCD sync
- Notify

## Core Rules

1. Jenkinsfile must not contain secret values.
2. Use credentials binding.
3. Fail pipeline if tests fail.
4. Fail pipeline if critical CVE found.
5. Use immutable image tag.
6. Promotion must be controlled for staging/prod.

## Security Rules

1. Mask credentials in logs.
2. Use least privilege deploy credentials.
3. Separate dev/staging/prod credentials.

## Anti-patterns

- Secrets in Jenkinsfile.
- Pushing latest tag.
- Ignoring failed tests.
- Deploying directly with kubectl to prod.
- No scan stage.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Jenkinsfile
2. Pipeline stages
3. Credential references
4. Validation commands
5. Promotion notes

## Review Checklist

- [ ] Jenkinsfile
- [ ] Pipeline stages
- [ ] Credential references
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/cicd/jenkins-standard.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/cicd/jenkins-standard.md`.

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

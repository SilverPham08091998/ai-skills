# aws/secrets-manager.md — AWS Secrets Manager Standard

## Objective

Define secret management using AWS Secrets Manager, SSM Parameter Store, and External Secrets Operator.

## When To Use

- Creating secrets strategy
- Generating ExternalSecret manifests
- Reviewing secret usage
- Configuring app credentials

## Scope

- Secrets Manager paths
- SSM parameters
- External Secrets Operator
- SecretStore/ClusterSecretStore
- ExternalSecret
- IRSA role

## Core Rules

1. No secret in Git.
2. No secret in Helm values.
3. No secret in Docker images.
4. Each service reads only its own secrets.
5. Use External Secrets Operator for Kubernetes sync.
6. Define rotation strategy for production.

## Security Rules

1. Use IRSA least privilege for secret reads.
2. Restrict secret paths per service.
3. Avoid printing secrets in logs/pipeline.
4. Use KMS where required.

## Anti-patterns

- Plaintext secrets in values.yaml.
- Jenkinsfile with credentials embedded.
- Shared secret role for all namespaces.
- Manual kubectl secret creation for production.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Secret naming convention
2. IAM policy for secret access
3. ExternalSecret manifest
4. Validation commands
5. Rotation notes

## Review Checklist

- [ ] Secret naming convention
- [ ] IAM policy for secret access
- [ ] ExternalSecret manifest
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/aws/secrets-manager.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/aws/secrets-manager.md`.

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

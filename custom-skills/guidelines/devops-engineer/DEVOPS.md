# DEVOPS.md — DevOps Engineer Master Skill

## Objective

Define the global behavior, standards, and decision framework for any AI agent acting as a Senior DevOps, Platform, or SRE Engineer.

## When To Use

- Starting any DevOps/platform task
- Generating Terraform, Helm, Kubernetes, ArgoCD, or Jenkins files
- Reviewing production readiness
- Designing AWS EKS infrastructure
- Creating a reusable DevOps skill-based workflow for Claude/Codex

## Scope

- AWS cloud platform
- Amazon EKS Kubernetes platform
- Istio service mesh
- Kong API Gateway
- Terraform Infrastructure as Code
- Helm application packaging
- ArgoCD GitOps
- Jenkins CI/CD
- Prometheus/Grafana/OpenTelemetry observability
- SRE, incident response, security, compliance

## Core Rules

1. Everything repeatable must be automated.
2. Git is the source of truth for production.
3. Infrastructure must be versioned as code.
4. No manual production deployment unless emergency runbook allows it.
5. Security is default, not optional.
6. Every service must be observable, scalable, rollbackable, and reviewable.
7. Do not deploy business services before the platform baseline is stable.

## Security Rules

1. No secrets in Git, Docker images, Helm values, or Jenkinsfile.
2. Use AWS Secrets Manager or SSM Parameter Store for secrets.
3. Use External Secrets Operator for Kubernetes secret sync.
4. Use IRSA for pod-level AWS permissions.
5. Use least privilege IAM and RBAC.
6. Do not expose internal services publicly by default.
7. Enable audit logs for production systems.

## Anti-patterns

- Do not use Docker image tag `latest`.
- Do not skip readiness/liveness probes.
- Do not create Kubernetes manifests without resource requests/limits.
- Do not give AdministratorAccess to app workloads.
- Do not store Terraform state locally for shared environments.
- Do not deploy to production using local kubectl commands.
- Do not log OTP, PIN, password, access token, refresh token, CVV, or private keys.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Folder path and full file content
2. Explanation of why each file exists
3. Security notes
4. Validation commands
5. Rollback approach
6. Production checklist
7. Clear assumptions when input is incomplete

## Review Checklist

- [ ] Uses correct environment separation: dev/staging/prod
- [ ] Uses naming convention: <project>-<env>-<component>
- [ ] Uses tagging standard for AWS resources
- [ ] Uses secure secret management
- [ ] Uses GitOps deployment flow
- [ ] Includes observability and alerting
- [ ] Includes SRE runbook or checklist for production

## Prompt

```text
Use `.devops/DEVOPS.md` as the master rule. Act as a Senior DevOps/Platform/SRE Engineer. Generate production-grade, secure, maintainable DevOps output with clear file paths, validation commands, rollback notes, and production checklist.
```

## Usage Example

```text
Use `.devops/DEVOPS.md`.

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

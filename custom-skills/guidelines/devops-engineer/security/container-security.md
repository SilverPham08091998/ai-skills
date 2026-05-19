# security/container-security.md — Container Security Standard

## Objective

Define Docker/container hardening rules.

## When To Use

- Reviewing Dockerfile
- Hardening Kubernetes container
- Adding image scan
- Fixing vulnerability risk

## Scope

- Non-root user
- Capabilities
- Privilege escalation
- Read-only filesystem
- Base image
- Image scan
- Secrets

## Core Rules

1. Do not run as root.
2. Drop Linux capabilities.
3. Do not allow privilege escalation.
4. Use read-only filesystem where possible.
5. Scan images.
6. Pin base image version.
7. Do not store secrets in image.

## Security Rules

1. Use minimal runtime image.
2. Avoid shell/package manager if unnecessary.
3. Patch base images regularly.

## Anti-patterns

- Root container.
- privileged true.
- Secrets baked into image.
- latest base image.
- No scan.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Dockerfile review
2. SecurityContext patch
3. Scan command
4. Checklist

## Review Checklist

- [ ] Dockerfile review
- [ ] SecurityContext patch
- [ ] Scan command
- [ ] Checklist
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/security/container-security.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/security/container-security.md`.

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

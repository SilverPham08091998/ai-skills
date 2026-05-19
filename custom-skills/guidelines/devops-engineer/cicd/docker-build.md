# cicd/docker-build.md — Docker Build Standard

## Objective

Define production Dockerfile standards for Java/Spring Boot services.

## When To Use

- Writing Dockerfile
- Reviewing image security
- Optimizing build
- Preparing container deployment

## Scope

- Multi-stage build
- Base image
- Non-root user
- JVM flags
- Ports
- Layering
- No secrets

## Core Rules

1. Use multi-stage build when building inside Docker.
2. Do not run as root.
3. Do not use latest base image in production.
4. Use minimal base image.
5. Add JVM container flags.
6. Expose only required port.
7. Do not copy secrets into image.

## Security Rules

1. Pin base image version where possible.
2. Scan image.
3. Drop root privileges.
4. Avoid package managers in final image when possible.

## Anti-patterns

- Running as root.
- latest base image.
- Secrets copied into image.
- Huge image with build tools in runtime.
- No JVM memory config.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Dockerfile
2. Security notes
3. Build command
4. Scan command

## Review Checklist

- [ ] Dockerfile
- [ ] Security notes
- [ ] Build command
- [ ] Scan command
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/cicd/docker-build.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/cicd/docker-build.md`.

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

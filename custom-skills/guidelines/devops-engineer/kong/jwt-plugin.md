# kong/jwt-plugin.md — Kong JWT/OIDC Plugin Standard

## Objective

Define authentication and identity propagation rules at gateway layer.

## When To Use

- Adding JWT validation
- Integrating OIDC provider
- Mapping identity headers
- Securing mobile/public APIs

## Scope

- JWT plugin
- OIDC plugin
- Claims mapping
- Header injection
- Consumer identity
- Token validation

## Core Rules

1. Validate token at gateway for public APIs.
2. Services must still enforce authorization.
3. Do not trust client-provided identity headers.
4. Strip or overwrite identity headers from external requests.
5. Prefer OIDC for enterprise identity provider.

## Security Rules

1. Prevent header spoofing.
2. Validate expiry/audience/issuer.
3. Avoid logging tokens.
4. Separate public and internal routes.

## Anti-patterns

- Forwarding user headers without sanitization.
- Only gateway auth but no service authorization.
- Accepting tokens with wrong issuer/audience.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. JWT/OIDC plugin config
2. Header mapping strategy
3. Security checklist
4. Validation commands

## Review Checklist

- [ ] JWT/OIDC plugin config
- [ ] Header mapping strategy
- [ ] Security checklist
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kong/jwt-plugin.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kong/jwt-plugin.md`.

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

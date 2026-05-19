# kong/cors.md — Kong CORS Standard

## Objective

Define secure CORS policy for public/mobile/frontend APIs.

## When To Use

- Configuring browser API access
- Reviewing public API security
- Creating Kong plugin config

## Scope

- Allowed origins
- Allowed methods
- Allowed headers
- Credentials
- Preflight max-age

## Core Rules

1. Do not use wildcard origin for authenticated production APIs.
2. Allow only approved domains.
3. Allow only required methods.
4. Allow only required headers.
5. Credentials true only when needed.

## Security Rules

1. Avoid exposing Authorization to untrusted origins.
2. Review mobile/web domain list.
3. Do not allow all headers blindly.

## Anti-patterns

- Wildcard origin with credentials.
- All methods allowed without need.
- CORS plugin missing on browser API.
- Leaking sensitive headers.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. CORS plugin config
2. Allowed origin list
3. Security checklist
4. Validation commands

## Review Checklist

- [ ] CORS plugin config
- [ ] Allowed origin list
- [ ] Security checklist
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kong/cors.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kong/cors.md`.

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

# istio/mtls.md — Istio mTLS Standard

## Objective

Define PeerAuthentication and mTLS migration rules.

## When To Use

- Enabling service mesh security
- Migrating PERMISSIVE to STRICT
- Reviewing namespace security

## Scope

- PeerAuthentication
- DestinationRule TLS
- PERMISSIVE mode
- STRICT mode
- Namespace policy

## Core Rules

1. Use STRICT mTLS in production service namespaces.
2. Use PERMISSIVE only during migration.
3. Do not disable mTLS globally.
4. Validate compatibility before STRICT mode.

## Security Rules

1. Monitor plaintext traffic during migration.
2. Ensure DestinationRule uses ISTIO_MUTUAL.
3. Avoid breaking legacy clients unexpectedly.

## Anti-patterns

- Global disable mTLS.
- STRICT mode without validation.
- Mixed TLS policies with unclear ownership.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. PeerAuthentication manifest
2. DestinationRule TLS snippet
3. Migration checklist
4. Validation commands

## Review Checklist

- [ ] PeerAuthentication manifest
- [ ] DestinationRule TLS snippet
- [ ] Migration checklist
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/istio/mtls.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/istio/mtls.md`.

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

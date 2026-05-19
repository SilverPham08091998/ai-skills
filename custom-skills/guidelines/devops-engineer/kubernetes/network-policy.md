# kubernetes/network-policy.md — Kubernetes NetworkPolicy Standard

## Objective

Define network segmentation rules inside Kubernetes namespaces.

## When To Use

- Creating secure namespace
- Restricting service traffic
- Preparing production security
- Reviewing app exposure

## Scope

- Default deny
- Ingress policy
- Egress policy
- DNS egress
- Gateway ingress
- Service-to-service allow rules

## Core Rules

1. Consider default deny in production namespaces.
2. Allow only required ingress/egress.
3. Allow DNS egress explicitly.
4. Scope gateway-to-service traffic by label.
5. Restrict external dependency access.

## Security Rules

1. Do not assume NetworkPolicy works unless CNI supports it.
2. Avoid broad namespace-wide allow all.
3. Review impact before applying default deny.

## Anti-patterns

- No NetworkPolicy in sensitive namespace.
- Blocking DNS accidentally.
- Allow all ingress from all namespaces.
- Policy labels not matching pods.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. NetworkPolicy manifests
2. Ingress/egress rules
3. DNS allow rule
4. Validation commands

## Review Checklist

- [ ] NetworkPolicy manifests
- [ ] Ingress/egress rules
- [ ] DNS allow rule
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kubernetes/network-policy.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kubernetes/network-policy.md`.

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

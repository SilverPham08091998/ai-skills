# kubernetes/pdb.md — Kubernetes PDB Standard

## Objective

Define PodDisruptionBudget standards for availability during voluntary disruptions.

## When To Use

- Adding production resilience
- Preparing node upgrades
- Reviewing HA workload
- Creating Helm chart

## Scope

- PDB
- minAvailable
- maxUnavailable
- Label selector
- Replica compatibility

## Core Rules

1. Production services should have PDB.
2. PDB selector must match deployment labels.
3. PDB must be realistic with replica count.
4. Use minAvailable for simple HA services.

## Security Rules

1. Avoid blocking all voluntary disruptions accidentally.
2. Review single-replica services carefully.
3. Ensure cluster upgrades can proceed.

## Anti-patterns

- PDB selector mismatch.
- minAvailable 2 with only 2 replicas and no surge planning.
- No PDB for critical service.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. PDB manifest
2. Selector validation
3. Replica compatibility note
4. Validation commands

## Review Checklist

- [ ] PDB manifest
- [ ] Selector validation
- [ ] Replica compatibility note
- [ ] Validation commands
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/kubernetes/pdb.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/kubernetes/pdb.md`.

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

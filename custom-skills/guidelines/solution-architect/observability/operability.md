# observability/operability.md — Operability Standard

## Objective

Design systems that can be deployed, monitored, debugged, rolled back, and supported.

## When To Use

- Production architecture
- SRE review
- Engineering handoff

## Scope

- Runbook
- Rollback
- Feature flags
- Health checks
- Admin operations
- Support tools
- Audit

## Architecture Rules

1. Every production system needs runbook.
2. Define rollback strategy.
3. Expose health checks.
4. Define support/debug operations.
5. Make failure states visible.

## Security / Compliance Rules

1. Restrict admin/support operations.
2. Audit manual interventions.
3. Avoid unsafe backdoor operations.

## Anti-patterns

- No rollback plan.
- No runbook.
- No health checks.
- No support visibility.

## Expected Output

1. Operability section
2. Runbook outline
3. Rollback plan
4. Support process

## Review Checklist

- [ ] Operability section
- [ ] Runbook outline
- [ ] Rollback plan
- [ ] Support process

## Prompt

```text
Use `.sa/observability/operability.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/observability/operability.md`.

Task:
<describe the architecture task>

Context:
- Domain:
- Actors:
- Existing systems:
- Constraints:
- NFR:
- Security/compliance concerns:

Output:
- Assumptions
- Architecture/design
- Diagrams if useful
- Trade-offs
- Risks
- Implementation handoff
```

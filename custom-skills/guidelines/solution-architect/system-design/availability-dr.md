# system-design/availability-dr.md — Availability and DR Standard

## Objective

Design availability, failover, backup, restore, RTO, and RPO.

## When To Use

- Production architecture
- Critical business flow
- DR planning

## Scope

- Availability target
- Multi-AZ
- Backup
- Restore
- RTO
- RPO
- Failover
- Runbook

## Architecture Rules

1. Availability target must map to infrastructure design.
2. Multi-AZ for critical components.
3. Backup is not enough; restore must be tested.
4. Define RTO/RPO per data domain.
5. Design graceful degradation.

## Security / Compliance Rules

1. Protect backups with encryption and access control.
2. Audit restore access.
3. Avoid data loss in financial flows.

## Anti-patterns

- 99.99% target on single-AZ design.
- Backup never tested.
- No RTO/RPO.
- No failover runbook.

## Expected Output

1. Availability design
2. DR plan
3. RTO/RPO table
4. Failover validation

## Review Checklist

- [ ] Availability design
- [ ] DR plan
- [ ] RTO/RPO table
- [ ] Failover validation

## Prompt

```text
Use `.sa/system-design/availability-dr.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/system-design/availability-dr.md`.

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

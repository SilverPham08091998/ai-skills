# requirements/non-functional-requirement.md — NFR Standard

## Objective

Define non-functional requirements for availability, latency, scalability, security, auditability, and operability.

## When To Use

- Designing production system
- Reviewing architecture quality
- Defining SLO/SLA target

## Scope

- Availability
- Latency
- Throughput
- Scalability
- Security
- Compliance
- Observability
- Maintainability
- RTO/RPO

## Architecture Rules

1. Every production architecture must define NFRs.
2. NFR must be measurable.
3. NFR must map to architecture decisions.
4. Critical flows need stricter NFRs.
5. NFR trade-offs must be explicit.

## Security / Compliance Rules

1. Include security, privacy, audit, and compliance NFRs.
2. Define data retention and audit needs.
3. Define encryption and access control expectations.

## Anti-patterns

- No measurable targets.
- Only functional design.
- Availability target without DR design.
- Latency target without capacity model.

## Expected Output

1. NFR table
2. SLO/SLA candidates
3. Architecture impact
4. Trade-offs
5. Open risks

## Review Checklist

- [ ] NFR table
- [ ] SLO/SLA candidates
- [ ] Architecture impact
- [ ] Trade-offs
- [ ] Open risks

## Prompt

```text
Use `.sa/requirements/non-functional-requirement.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/requirements/non-functional-requirement.md`.

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

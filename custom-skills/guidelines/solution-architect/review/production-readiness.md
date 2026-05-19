# review/production-readiness.md — Production Readiness Architecture Review

## Objective

Review whether architecture is ready for production implementation and operation.

## When To Use

- Before go-live
- Before detailed implementation
- Architecture sign-off

## Scope

- NFR
- Security
- Scalability
- Reliability
- Observability
- DR
- Runbook
- Rollback
- Compliance

## Architecture Rules

1. Production readiness requires measurable NFRs.
2. Critical flows need failure handling.
3. Security and observability must be designed.
4. DR and rollback must be documented.
5. Operational ownership must be clear.

## Security / Compliance Rules

1. Do not approve missing audit/security for fintech flows.
2. Require mitigation for high risks.

## Anti-patterns

- No SLO.
- No failure handling.
- No security design.
- No rollback.
- No runbook.

## Expected Output

1. Readiness checklist
2. Findings by severity
3. Approval: PASS/PASS WITH RISK/FAIL

## Review Checklist

- [ ] Readiness checklist
- [ ] Findings by severity
- [ ] Approval: PASS/PASS WITH RISK/FAIL

## Prompt

```text
Use `.sa/review/production-readiness.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/review/production-readiness.md`.

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

# review/architecture-review.md — Architecture Review Standard

## Objective

Review architecture for correctness, completeness, risks, and implementation readiness.

## When To Use

- Reviewing HLD/LLD
- Before implementation
- Architecture governance

## Scope

- Scope
- Requirements
- Diagrams
- NFR
- Security
- Data
- Integration
- Operations
- Risks

## Architecture Rules

1. Review against requirements and NFRs.
2. Check boundaries and ownership.
3. Check failure modes.
4. Check security controls.
5. Check implementability.
6. Document risks and required changes.

## Security / Compliance Rules

1. Flag missing trust boundaries.
2. Flag sensitive data risks.
3. Flag auth/audit gaps.

## Anti-patterns

- Review only diagram aesthetics.
- No risk severity.
- No action items.
- Approving incomplete design.

## Expected Output

1. Review findings
2. Severity
3. Recommendations
4. Approval status

## Review Checklist

- [ ] Review findings
- [ ] Severity
- [ ] Recommendations
- [ ] Approval status

## Prompt

```text
Use `.sa/review/architecture-review.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/review/architecture-review.md`.

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

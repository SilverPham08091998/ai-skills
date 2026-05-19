# architecture/risk-assessment.md — Architecture Risk Assessment Standard

## Objective

Identify architecture risks, severity, likelihood, mitigation, and owner.

## When To Use

- Before implementation
- Before production
- Reviewing major design

## Scope

- Risk
- Impact
- Likelihood
- Severity
- Mitigation
- Owner
- Residual risk

## Architecture Rules

1. List both technical and business risks.
2. Prioritize risks by impact and likelihood.
3. Every critical risk needs mitigation.
4. Assign owner for follow-up.
5. Track residual risk.

## Security / Compliance Rules

1. Include security, compliance, data loss, financial loss, and operational risks.

## Anti-patterns

- Risk list with no mitigation.
- Ignoring high impact low probability events.
- No owner.
- No residual risk.

## Expected Output

1. Risk register
2. Mitigation plan
3. Open decisions
4. Approval notes

## Review Checklist

- [ ] Risk register
- [ ] Mitigation plan
- [ ] Open decisions
- [ ] Approval notes

## Prompt

```text
Use `.sa/architecture/risk-assessment.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/architecture/risk-assessment.md`.

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

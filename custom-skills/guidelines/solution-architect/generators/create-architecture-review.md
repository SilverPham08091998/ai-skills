# generators/create-architecture-review.md — Generator — Create Architecture Review

## Objective

Perform architecture review and produce findings.

## When To Use

- Reviewing HLD/LLD
- Before implementation
- Architecture approval

## Scope

- Completeness
- NFR
- Security
- Data
- Integration
- Deployment
- Observability
- Risks

## Architecture Rules

1. Classify findings by severity.
2. Give actionable recommendations.
3. State approval decision.
4. Call out missing information.

## Security / Compliance Rules

1. Flag security and data risks clearly.
2. Do not approve critical gaps.

## Anti-patterns

- Generic feedback.
- No severity.
- No fix recommendation.
- No approval status.

## Expected Output

1. Review report
2. Critical/High/Medium/Low findings
3. Approval decision

## Review Checklist

- [ ] Review report
- [ ] Critical/High/Medium/Low findings
- [ ] Approval decision

## Prompt

```text
Use `.sa/generators/create-architecture-review.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/generators/create-architecture-review.md`.

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

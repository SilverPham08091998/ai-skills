# security/threat-modeling.md — Threat Modeling Standard

## Objective

Identify threats, attack surfaces, mitigations, and residual risks.

## When To Use

- Reviewing sensitive system
- Designing fintech feature
- Before production

## Scope

- Assets
- Actors
- Trust boundaries
- Threats
- Attack vectors
- Mitigations
- Residual risk

## Architecture Rules

1. Identify assets first.
2. Map data flow and trust boundaries.
3. Use STRIDE-like thinking.
4. Prioritize threats by risk.
5. Mitigate or accept explicitly.

## Security / Compliance Rules

1. Focus on identity, payment, wallet, OTP, PII, admin, partner callbacks.
2. Include abuse/fraud scenarios.

## Anti-patterns

- No threat model for payment flow.
- Only infrastructure threats, no business abuse.
- No residual risk owner.

## Expected Output

1. Threat model
2. Risk table
3. Mitigations
4. Open risks

## Review Checklist

- [ ] Threat model
- [ ] Risk table
- [ ] Mitigations
- [ ] Open risks

## Prompt

```text
Use `.sa/security/threat-modeling.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/security/threat-modeling.md`.

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

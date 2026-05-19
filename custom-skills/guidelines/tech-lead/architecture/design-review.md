# architecture/design-review.md — Tech Lead Design Review Standard

## Objective

Review design before implementation for feasibility, boundaries, risks, and production behavior.

## When To Use

- Reviewing HLD/LLD
- Before implementation
- Approving technical proposal

## Scope

- Requirements
- Boundaries
- Data
- API
- Integration
- NFR
- Security
- Operations
- Risks

## Tech Lead Rules

1. Review against requirements.
2. Check service/module boundaries.
3. Check data ownership and consistency.
4. Check failure modes.
5. Check observability and rollout.
6. Ask for ADR when decision is significant.

## Security / Production Rules

1. Flag missing auth/audit/idempotency for sensitive flows.
2. Check data protection.

## Anti-patterns

- Only reviewing diagram look.
- No failure scenario review.
- No NFR/security review.

## Expected Output

1. Design review findings
2. Required changes
3. Approval status

## Review Checklist

- [ ] Design review findings
- [ ] Required changes
- [ ] Approval status

## Prompt

```text
Use `.techlead/architecture/design-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/architecture/design-review.md`.

Task:
<describe the planning/review/leadership task>

Context:
- Feature/change:
- Existing architecture:
- Team constraints:
- Risk level:
- Deadline:
- Production impact:

Output:
- Assumptions
- Findings or plan
- Risks
- Action items
- Definition of Done
```

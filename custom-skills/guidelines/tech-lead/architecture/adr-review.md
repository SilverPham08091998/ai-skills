# architecture/adr-review.md — ADR Review Standard

## Objective

Review architecture decision records for quality and completeness.

## When To Use

- Reviewing ADR
- Approving technology choice
- Documenting important decision

## Scope

- Context
- Options
- Decision
- Consequences
- Risks
- Owner
- Review date

## Tech Lead Rules

1. ADR must have clear context.
2. Alternatives must be real.
3. Decision criteria must be explicit.
4. Consequences must be honest.
5. Status and review date must be present.

## Security / Production Rules

1. Security/compliance impact must be included when relevant.

## Anti-patterns

- ADR with only conclusion.
- No rejected alternatives.
- No consequences.
- No owner.

## Expected Output

1. ADR review comments
2. Missing sections
3. Approval decision

## Review Checklist

- [ ] ADR review comments
- [ ] Missing sections
- [ ] Approval decision

## Prompt

```text
Use `.techlead/architecture/adr-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/architecture/adr-review.md`.

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

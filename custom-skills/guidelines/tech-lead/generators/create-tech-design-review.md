# generators/create-tech-design-review.md — Generator — Create Tech Design Review

## Objective

Generate Tech Lead review for design doc.

## When To Use

- Reviewing HLD/LLD
- Before implementation
- Design approval

## Scope

- Summary
- Gaps
- Risks
- Questions
- Required changes
- Approval

## Tech Lead Rules

1. Review requirements alignment.
2. Check boundaries, data, API, integration, NFR.
3. Classify findings.
4. Ask concrete questions.
5. Give approval status.

## Security / Production Rules

1. Flag security/data/financial risks as blockers when critical.

## Anti-patterns

- Generic review.
- No approval status.
- No severity.
- No action items.

## Expected Output

1. Design review report
2. Findings by severity
3. Approval decision

## Review Checklist

- [ ] Design review report
- [ ] Findings by severity
- [ ] Approval decision

## Prompt

```text
Use `.techlead/generators/create-tech-design-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/generators/create-tech-design-review.md`.

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

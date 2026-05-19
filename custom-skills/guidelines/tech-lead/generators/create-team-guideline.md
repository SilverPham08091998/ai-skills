# generators/create-team-guideline.md — Generator — Create Team Guideline

## Objective

Generate team engineering guideline from repeated issue or desired standard.

## When To Use

- Creating team rule
- After repeated review comments
- Standardizing workflow

## Scope

- Problem
- Rule
- Examples
- Do/Don't
- Checklist
- Adoption

## Tech Lead Rules

1. Explain why guideline exists.
2. Give concrete examples.
3. Make it enforceable in review.
4. Keep guideline short enough to use.
5. Add checklist.

## Security / Production Rules

1. Include security examples if relevant.

## Anti-patterns

- Abstract guideline.
- No examples.
- Too long to apply.
- No checklist.

## Expected Output

1. Team guideline
2. Examples
3. Review checklist

## Review Checklist

- [ ] Team guideline
- [ ] Examples
- [ ] Review checklist

## Prompt

```text
Use `.techlead/generators/create-team-guideline.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/generators/create-team-guideline.md`.

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

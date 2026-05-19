# generators/create-pr-review.md — Generator — Create PR Review

## Objective

Generate structured PR review comments.

## When To Use

- Reviewing PR diff
- Reviewing generated code
- Mentoring engineer

## Scope

- Summary
- Blocking issues
- Suggestions
- Tests
- Security
- Approval

## Tech Lead Rules

1. Separate blockers from suggestions.
2. Be specific and actionable.
3. Include why it matters.
4. Recommend concrete fix.
5. Mention good parts when useful.

## Security / Production Rules

1. Block critical security/data issues.
2. Flag sensitive logging or auth bypass.

## Anti-patterns

- Vague comment.
- Only style nits.
- No severity.
- No fix suggestion.

## Expected Output

1. PR review report
2. Inline-style comments
3. Merge decision

## Review Checklist

- [ ] PR review report
- [ ] Inline-style comments
- [ ] Merge decision

## Prompt

```text
Use `.techlead/generators/create-pr-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/generators/create-pr-review.md`.

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

# review/pr-review.md — Pull Request Review Standard

## Objective

Define PR review process and checklist.

## When To Use

- Reviewing GitHub/GitLab PR
- Creating PR template
- Preparing merge gate

## Scope

- Description
- Scope
- Diff size
- Tests
- Risk
- Docs
- Migration
- Rollback

## Tech Lead Rules

1. PR must explain what and why.
2. Diff should be reviewable.
3. Tests must be shown.
4. Risk and rollback must be documented for production changes.
5. Large PR should be split when possible.

## Security / Production Rules

1. Check secrets in diff.
2. Check auth/audit changes carefully.
3. Check migration and data changes.

## Anti-patterns

- No PR description.
- Huge PR.
- No tests.
- No rollback note.
- Unrelated changes.

## Expected Output

1. PR checklist
2. Review comments
3. Merge decision

## Review Checklist

- [ ] PR checklist
- [ ] Review comments
- [ ] Merge decision

## Prompt

```text
Use `.techlead/review/pr-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/review/pr-review.md`.

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

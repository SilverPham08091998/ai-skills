# standards/naming-convention.md — Naming Convention Standard

## Objective

Define naming rules for files, classes, functions, variables, branches, and commits.

## When To Use

- Creating project guideline
- Reviewing code
- Standardizing generated output

## Scope

- Classes
- Methods
- Variables
- Packages
- Branches
- Commits
- PR titles

## Tech Lead Rules

1. Names must reveal intent.
2. Use project/domain language consistently.
3. Avoid abbreviations unless common.
4. Keep naming aligned with existing codebase.
5. Use consistent suffixes for DTO/Command/Model/Entity if architecture uses them.

## Security / Production Rules

1. Avoid leaking sensitive data in branch or commit names.

## Anti-patterns

- Random abbreviations.
- Different names for same concept.
- Misleading class names.
- Generated names like Manager/Helper everywhere.

## Expected Output

1. Naming rules
2. Examples
3. Review checklist

## Review Checklist

- [ ] Naming rules
- [ ] Examples
- [ ] Review checklist

## Prompt

```text
Use `.techlead/standards/naming-convention.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/standards/naming-convention.md`.

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

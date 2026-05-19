# planning/task-breakdown.md — Task Breakdown Standard

## Objective

Break feature into implementable tasks with clear ownership and dependencies.

## When To Use

- Creating Jira tickets
- Preparing implementation plan
- Splitting big feature

## Scope

- Epic
- Stories
- Subtasks
- Dependencies
- Acceptance criteria
- Risks
- Estimate

## Tech Lead Rules

1. Break by deliverable, not only layer.
2. Keep tasks reviewable.
3. Identify dependencies early.
4. Each task must have testable acceptance criteria.
5. Separate refactor from feature when possible.

## Security / Production Rules

1. Add security/observability/testing tasks explicitly.
2. Do not hide risky migration under generic task.

## Anti-patterns

- One huge task.
- No acceptance criteria.
- No dependency mapping.
- No testing task.

## Expected Output

1. Task list
2. Dependency order
3. Acceptance criteria
4. Risk notes

## Review Checklist

- [ ] Task list
- [ ] Dependency order
- [ ] Acceptance criteria
- [ ] Risk notes

## Prompt

```text
Use `.techlead/planning/task-breakdown.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/planning/task-breakdown.md`.

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

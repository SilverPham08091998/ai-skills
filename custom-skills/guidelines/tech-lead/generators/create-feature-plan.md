# generators/create-feature-plan.md — Generator — Create Feature Implementation Plan

## Objective

Generate implementation plan from requirement.

## When To Use

- User asks to plan feature
- Before Codex implementation
- Creating Jira tasks

## Scope

- Requirement
- Assumptions
- Architecture impact
- Tasks
- Tests
- Risks
- DoD

## Tech Lead Rules

1. Clarify requirement.
2. Map architecture impact.
3. Break down into tasks.
4. Include testing and observability.
5. Define risks and assumptions.
6. Produce implementation-ready prompt if needed.

## Security / Production Rules

1. Include auth/audit/idempotency for sensitive features.

## Anti-patterns

- Only coding steps.
- No tests.
- No risk.
- No acceptance criteria.

## Expected Output

1. Feature plan
2. Task breakdown
3. Test plan
4. Codex prompt

## Review Checklist

- [ ] Feature plan
- [ ] Task breakdown
- [ ] Test plan
- [ ] Codex prompt

## Prompt

```text
Use `.techlead/generators/create-feature-plan.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/generators/create-feature-plan.md`.

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

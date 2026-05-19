# delivery/definition-of-ready.md — Definition of Ready Standard

## Objective

Define when a task is ready for engineering implementation.

## When To Use

- Sprint planning
- Before Codex prompt
- Before assigning task

## Scope

- Requirement
- Acceptance criteria
- Design
- Dependencies
- Data
- API
- Test expectation

## Tech Lead Rules

1. Task must have clear goal.
2. Acceptance criteria must be testable.
3. Dependencies must be known.
4. Design decision must be resolved for high-impact tasks.
5. Unknowns must be listed.

## Security / Production Rules

1. Security-sensitive tasks must include security acceptance criteria.

## Anti-patterns

- Vague story.
- No acceptance criteria.
- Hidden dependency.
- No design for complex change.

## Expected Output

1. DoR checklist
2. Missing info
3. Questions

## Review Checklist

- [ ] DoR checklist
- [ ] Missing info
- [ ] Questions

## Prompt

```text
Use `.techlead/delivery/definition-of-ready.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/delivery/definition-of-ready.md`.

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

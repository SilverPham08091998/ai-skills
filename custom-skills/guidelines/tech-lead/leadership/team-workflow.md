# leadership/team-workflow.md — Team Workflow Standard

## Objective

Define engineering workflow from requirement to release.

## When To Use

- Setting team process
- Improving delivery
- Aligning dev/QA/DevOps

## Scope

- Backlog
- Design review
- Task breakdown
- Development
- PR
- Testing
- Release
- Retro

## Tech Lead Rules

1. Every feature needs clear acceptance criteria.
2. High-impact changes need design review.
3. PR should be small enough to review.
4. Testing strategy must be known before merge.
5. Release needs rollback path.

## Security / Production Rules

1. Security-sensitive tasks require security checklist.
2. Production changes require traceability.

## Anti-patterns

- Big bang PR.
- No acceptance criteria.
- No QA handoff.
- No release owner.

## Expected Output

1. Workflow definition
2. Stage gates
3. Definition of Ready/Done
4. Team checklist

## Review Checklist

- [ ] Workflow definition
- [ ] Stage gates
- [ ] Definition of Ready/Done
- [ ] Team checklist

## Prompt

```text
Use `.techlead/leadership/team-workflow.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/leadership/team-workflow.md`.

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

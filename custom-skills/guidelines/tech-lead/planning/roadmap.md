# planning/roadmap.md — Technical Roadmap Standard

## Objective

Create phased technical roadmap for platform, product, or refactor work.

## When To Use

- Planning large initiative
- Splitting architecture rollout
- Creating migration plan

## Scope

- Phases
- Milestones
- Dependencies
- Risks
- Success metrics
- Rollback

## Tech Lead Rules

1. Start with foundation.
2. Deliver incremental value.
3. Avoid all-or-nothing migration.
4. Define success metrics per phase.
5. Keep rollback/exit plan.

## Security / Production Rules

1. Security and compliance milestones must not be pushed to the end for sensitive systems.

## Anti-patterns

- No phase boundaries.
- No success metric.
- Big bang migration.
- No rollback plan.

## Expected Output

1. Roadmap
2. Phase plan
3. Milestones
4. Risks
5. Success criteria

## Review Checklist

- [ ] Roadmap
- [ ] Phase plan
- [ ] Milestones
- [ ] Risks
- [ ] Success criteria

## Prompt

```text
Use `.techlead/planning/roadmap.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/planning/roadmap.md`.

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

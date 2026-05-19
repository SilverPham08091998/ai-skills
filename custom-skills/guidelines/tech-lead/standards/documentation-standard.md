# standards/documentation-standard.md — Engineering Documentation Standard

## Objective

Define documentation expectations for design, code, operations, and handoff.

## When To Use

- Writing docs
- Reviewing PR docs
- Creating handoff

## Scope

- README
- Architecture notes
- ADR
- API docs
- Runbook
- Operational notes

## Tech Lead Rules

1. Document why, not only what.
2. Keep docs close to code when practical.
3. Update docs with behavior changes.
4. Use diagrams for complex flows.
5. Docs must be useful to new engineer.

## Security / Production Rules

1. Do not include secrets.
2. Sanitize production examples.
3. Document security assumptions.

## Anti-patterns

- Outdated docs.
- No README.
- Diagram without explanation.
- Docs copied but not adapted.

## Expected Output

1. Documentation checklist
2. Required docs
3. Review comments

## Review Checklist

- [ ] Documentation checklist
- [ ] Required docs
- [ ] Review comments

## Prompt

```text
Use `.techlead/standards/documentation-standard.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/standards/documentation-standard.md`.

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

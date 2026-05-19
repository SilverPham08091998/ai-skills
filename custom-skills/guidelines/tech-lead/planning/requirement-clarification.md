# planning/requirement-clarification.md — Requirement Clarification Standard

## Objective

Clarify requirements before implementation to avoid wrong technical output.

## When To Use

- Starting new feature
- Writing Codex prompt
- Reviewing vague task

## Scope

- Business goal
- Actors
- Inputs
- Outputs
- Rules
- Edge cases
- NFR
- Out of scope

## Tech Lead Rules

1. Clarify business goal first.
2. Identify actor and trigger.
3. Define happy path and edge cases.
4. Capture validation and error scenarios.
5. Write assumptions explicitly if details are missing.

## Security / Production Rules

1. Clarify authorization, audit, and sensitive data requirements.
2. Identify financial/identity/security impact.

## Anti-patterns

- Coding from vague requirement.
- Ignoring edge cases.
- No acceptance criteria.
- No out-of-scope.

## Expected Output

1. Clarified requirement
2. Assumptions
3. Open questions
4. Acceptance criteria

## Review Checklist

- [ ] Clarified requirement
- [ ] Assumptions
- [ ] Open questions
- [ ] Acceptance criteria

## Prompt

```text
Use `.techlead/planning/requirement-clarification.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/planning/requirement-clarification.md`.

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

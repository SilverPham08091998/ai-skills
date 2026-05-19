# generators/create-codex-prompt.md — Generator — Create Codex Implementation Prompt

## Objective

Generate a precise prompt for Codex/Claude to implement feature in existing codebase.

## When To Use

- User wants AI coding prompt
- Existing source implementation
- Avoiding random folders

## Scope

- Context
- Files to inspect
- Architecture rules
- Task
- Constraints
- Output
- Tests

## Tech Lead Rules

1. Tell Codex to inspect existing patterns first.
2. Provide exact feature scope.
3. Enforce architecture boundaries.
4. Require TODO plan before edit if workflow needs approval.
5. Require tests and validation commands.
6. Forbid creating random new project/folder.

## Security / Production Rules

1. Mention security/secret/logging/idempotency constraints.

## Anti-patterns

- Prompt too vague.
- No files to inspect.
- No architecture constraints.
- No tests required.

## Expected Output

1. Codex prompt
2. Inspection checklist
3. Implementation constraints

## Review Checklist

- [ ] Codex prompt
- [ ] Inspection checklist
- [ ] Implementation constraints

## Prompt

```text
Use `.techlead/generators/create-codex-prompt.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/generators/create-codex-prompt.md`.

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

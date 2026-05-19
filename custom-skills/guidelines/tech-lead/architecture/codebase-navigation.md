# architecture/codebase-navigation.md — Codebase Navigation Standard

## Objective

Guide AI agents to inspect existing source before editing.

## When To Use

- Using Codex/Claude on existing repo
- Avoiding random implementation
- Preparing edit prompt

## Scope

- Entry points
- Existing patterns
- Module structure
- Naming
- Tests
- Config
- Build

## Tech Lead Rules

1. Read existing structure before adding code.
2. Find similar feature and follow pattern.
3. Identify layer responsibilities.
4. Check tests and build config.
5. Do not invent architecture if project already has one.

## Security / Production Rules

1. Look for existing security/auth patterns.
2. Do not create duplicate secret/config handling.

## Anti-patterns

- Creating new parallel architecture.
- Ignoring existing mapper/test conventions.
- Duplicate config.

## Expected Output

1. Navigation checklist
2. Files to inspect
3. Implementation constraints

## Review Checklist

- [ ] Navigation checklist
- [ ] Files to inspect
- [ ] Implementation constraints

## Prompt

```text
Use `.techlead/architecture/codebase-navigation.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/architecture/codebase-navigation.md`.

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

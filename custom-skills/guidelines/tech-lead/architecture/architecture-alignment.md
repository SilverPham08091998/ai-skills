# architecture/architecture-alignment.md — Architecture Alignment Standard

## Objective

Ensure implementation follows existing architecture and boundaries.

## When To Use

- Reviewing implementation plan
- Before generating code
- Refactoring existing source

## Scope

- Layers
- Boundaries
- Dependencies
- Contracts
- Ownership
- Existing patterns

## Tech Lead Rules

1. Understand existing architecture before changing it.
2. Follow project conventions.
3. Do not create random folders/modules.
4. Respect Clean Architecture/Hexagonal boundaries when present.
5. Keep dependency direction valid.

## Security / Production Rules

1. Check security boundaries and data ownership.
2. Do not bypass authorization/audit layers.

## Anti-patterns

- New folder outside convention.
- Controller calls repository directly.
- Domain depends on framework.
- Shared DB ownership violation.

## Expected Output

1. Architecture impact review
2. Boundary checklist
3. Required changes

## Review Checklist

- [ ] Architecture impact review
- [ ] Boundary checklist
- [ ] Required changes

## Prompt

```text
Use `.techlead/architecture/architecture-alignment.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/architecture/architecture-alignment.md`.

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

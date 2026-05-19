# delivery/definition-of-done.md — Definition of Done Standard

## Objective

Define completion criteria for engineering tasks.

## When To Use

- Completing feature
- Reviewing PR
- Before merge/release

## Scope

- Code
- Tests
- Docs
- Review
- Observability
- Security
- Release notes

## Tech Lead Rules

1. Code implemented according to architecture.
2. Tests pass and cover important cases.
3. Docs updated when behavior changes.
4. Review comments resolved.
5. Observability added where needed.
6. No known critical risk.

## Security / Production Rules

1. Security review done for sensitive changes.
2. Secrets not exposed.
3. Audit/logging checked.

## Anti-patterns

- Code works locally only.
- No tests.
- No docs for contract change.
- No observability.
- Known critical issue ignored.

## Expected Output

1. DoD checklist
2. Release readiness
3. Remaining risks

## Review Checklist

- [ ] DoD checklist
- [ ] Release readiness
- [ ] Remaining risks

## Prompt

```text
Use `.techlead/delivery/definition-of-done.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/delivery/definition-of-done.md`.

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

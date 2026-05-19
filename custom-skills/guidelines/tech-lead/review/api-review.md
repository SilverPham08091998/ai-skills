# review/api-review.md — API Review Standard

## Objective

Review API contract consistency, security, compatibility, and consumer experience.

## When To Use

- Reviewing endpoint design
- Before API implementation
- PR review for API

## Scope

- URL
- Method
- Status
- Request
- Response
- Validation
- Errors
- Versioning
- Idempotency

## Tech Lead Rules

1. Use consistent resource naming.
2. Use correct HTTP semantics.
3. Define error contract.
4. Avoid breaking compatibility.
5. Validate input.
6. Add idempotency for retryable commands.

## Security / Production Rules

1. Authorize every non-public endpoint.
2. Do not expose internal/sensitive fields.

## Anti-patterns

- Action URLs everywhere.
- No error schema.
- Breaking mobile contract.
- No idempotency for payment command.

## Expected Output

1. API review comments
2. Contract fixes
3. Compatibility notes

## Review Checklist

- [ ] API review comments
- [ ] Contract fixes
- [ ] Compatibility notes

## Prompt

```text
Use `.techlead/review/api-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/review/api-review.md`.

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

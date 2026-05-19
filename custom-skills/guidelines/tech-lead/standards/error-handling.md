# standards/error-handling.md — Error Handling Standard

## Objective

Define consistent error handling and propagation.

## When To Use

- Reviewing API/service code
- Designing error contract
- Fixing exception handling

## Scope

- Exception type
- Error code
- HTTP status
- User message
- Logging
- Retryability
- Recovery

## Tech Lead Rules

1. Use domain-specific error codes.
2. Do not swallow exceptions silently.
3. Separate technical message from user-safe message.
4. Preserve cause for debugging.
5. Classify retryable vs non-retryable.

## Security / Production Rules

1. Do not expose stack trace or sensitive data.
2. Log with traceId/correlationId.

## Anti-patterns

- catch Exception and ignore.
- Raw stack trace in API.
- HTTP 500 for validation errors.
- No error code.

## Expected Output

1. Error handling checklist
2. Error mapping
3. Review comments

## Review Checklist

- [ ] Error handling checklist
- [ ] Error mapping
- [ ] Review comments

## Prompt

```text
Use `.techlead/standards/error-handling.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/standards/error-handling.md`.

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

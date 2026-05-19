# standards/logging-standard.md — Logging Standard for Tech Lead Review

## Objective

Define logging expectations for application code review.

## When To Use

- Reviewing logs in code
- Setting team logging standard
- Production readiness

## Scope

- Level
- Message
- Context
- traceId
- requestId
- Sensitive data
- Business event

## Tech Lead Rules

1. Log important state transitions.
2. Use structured logs when platform supports it.
3. Include correlation identifiers.
4. Use correct log level.
5. Avoid noisy logs in loops/hot paths.

## Security / Production Rules

1. Never log OTP/PIN/token/password/CVV/private keys.
2. Mask PII.
3. Avoid full request/response logs for sensitive flows.

## Anti-patterns

- System.out.println.
- Logging entire request.
- No context.
- Error logs without cause.
- Too many info logs.

## Expected Output

1. Logging checklist
2. Sensitive data review
3. Recommended comments

## Review Checklist

- [ ] Logging checklist
- [ ] Sensitive data review
- [ ] Recommended comments

## Prompt

```text
Use `.techlead/standards/logging-standard.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/standards/logging-standard.md`.

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

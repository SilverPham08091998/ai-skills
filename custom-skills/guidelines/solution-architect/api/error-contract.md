# api/error-contract.md — API Error Contract Standard

## Objective

Define standard error responses, codes, and troubleshooting fields.

## When To Use

- Designing API errors
- Reviewing API consistency
- Implementing error handling

## Scope

- Error code
- Message
- Details
- Trace ID
- Field errors
- HTTP status
- Localization

## Architecture Rules

1. Use stable machine-readable error codes.
2. Do not expose internal stack traces.
3. Include trace/request ID.
4. Use field errors for validation.
5. Keep messages consumer-safe.

## Security / Compliance Rules

1. Do not leak sensitive data or internal implementation.
2. Avoid revealing security details in auth errors.

## Anti-patterns

- Raw exception response.
- Different error shapes per endpoint.
- No trace ID.
- HTTP 200 with error body for failure.

## Expected Output

1. Error schema
2. Code convention
3. Examples
4. Mapping table

## Review Checklist

- [ ] Error schema
- [ ] Code convention
- [ ] Examples
- [ ] Mapping table

## Prompt

```text
Use `.sa/api/error-contract.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/api/error-contract.md`.

Task:
<describe the architecture task>

Context:
- Domain:
- Actors:
- Existing systems:
- Constraints:
- NFR:
- Security/compliance concerns:

Output:
- Assumptions
- Architecture/design
- Diagrams if useful
- Trade-offs
- Risks
- Implementation handoff
```

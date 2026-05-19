# api/api-design.md — API Design Standard

## Objective

Design REST/HTTP APIs that are consistent, secure, versionable, and easy to consume.

## When To Use

- Creating API contract
- Reviewing endpoint design
- Preparing LLD

## Scope

- Resource naming
- HTTP methods
- Versioning
- Request/response
- Pagination
- Filtering
- Errors
- Idempotency

## Architecture Rules

1. Design for consumers, not server convenience.
2. Use resource-oriented URLs.
3. Use correct HTTP methods and status codes.
4. Version APIs intentionally.
5. Standardize response and error shape.
6. Define idempotency for retryable commands.

## Security / Compliance Rules

1. Authenticate and authorize every non-public endpoint.
2. Do not expose internal fields.
3. Mask sensitive data.
4. Validate input.

## Anti-patterns

- Action-only URLs everywhere.
- Inconsistent response shape.
- No error contract.
- No idempotency for payment commands.

## Expected Output

1. API contract
2. Request/response examples
3. Error contract
4. Validation rules

## Review Checklist

- [ ] API contract
- [ ] Request/response examples
- [ ] Error contract
- [ ] Validation rules

## Prompt

```text
Use `.sa/api/api-design.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/api/api-design.md`.

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

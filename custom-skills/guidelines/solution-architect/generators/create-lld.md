# generators/create-lld.md — Generator — Create LLD

## Objective

Generate low-level design document for implementation.

## When To Use

- User asks for LLD
- Preparing Codex/Claude implementation
- Breaking feature into modules

## Scope

- Modules
- APIs
- Sequence
- Database
- State machine
- Errors
- Transactions
- Events
- Tests

## Architecture Rules

1. Load LLD, API, data, transaction, integration, security skills.
2. Make implementation boundaries explicit.
3. Define contracts and error codes.
4. Include validation and transaction rules.

## Security / Compliance Rules

1. Include authorization/audit points.
2. Avoid entity leakage.
3. Protect sensitive fields.

## Anti-patterns

- No API contract.
- No DB model.
- No sequence diagram.
- No error handling.
- No transaction boundary.

## Expected Output

1. Full LLD markdown
2. Mermaid sequence
3. API schema
4. DB model
5. Implementation checklist

## Review Checklist

- [ ] Full LLD markdown
- [ ] Mermaid sequence
- [ ] API schema
- [ ] DB model
- [ ] Implementation checklist

## Prompt

```text
Use `.sa/generators/create-lld.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/generators/create-lld.md`.

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

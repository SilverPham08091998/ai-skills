# architecture/lld.md — Low-Level Design Standard

## Objective

Create LLD that engineering can implement with modules, APIs, contracts, state, database, and error handling.

## When To Use

- Preparing implementation
- Breaking down service internals
- Creating module design for Codex/Claude

## Scope

- Modules
- Classes/components
- API contracts
- Database schema
- State machine
- Error handling
- Transactions
- Events

## Architecture Rules

1. LLD must be implementable.
2. Define interfaces and responsibilities.
3. Define request/response contracts.
4. Define persistence model.
5. Define transaction boundary.
6. Define error codes and retries.

## Security / Compliance Rules

1. Include validation and authorization points.
2. Define audit logs.
3. Avoid exposing internal entities directly.

## Anti-patterns

- LLD missing API contracts.
- No transaction boundary.
- No error handling.
- No state model.

## Expected Output

1. Module structure
2. API specs
3. Data model
4. Sequence diagram
5. Error contract
6. Implementation checklist

## Review Checklist

- [ ] Module structure
- [ ] API specs
- [ ] Data model
- [ ] Sequence diagram
- [ ] Error contract
- [ ] Implementation checklist

## Prompt

```text
Use `.sa/architecture/lld.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/architecture/lld.md`.

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

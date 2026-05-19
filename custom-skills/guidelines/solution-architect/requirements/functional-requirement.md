# requirements/functional-requirement.md — Functional Requirement Standard

## Objective

Define functional requirements in a way that engineering can implement and test.

## When To Use

- Writing feature requirements
- Creating API/module design
- Preparing LLD from business scope

## Scope

- User actions
- System behavior
- Inputs
- Outputs
- Validation
- Error cases
- State transitions

## Architecture Rules

1. Use clear shall-style statements.
2. Include happy path and alternative flows.
3. Define validation rules.
4. Define state transitions.
5. Make requirements testable.

## Security / Compliance Rules

1. Identify authorization checks for every function.
2. Define audit requirements for sensitive actions.
3. Avoid leaking sensitive data in response.

## Anti-patterns

- Vague requirement like system should be fast.
- No error cases.
- No validation rules.
- No state model.

## Expected Output

1. Functional requirement table
2. Flow description
3. Validation matrix
4. Error cases
5. Testable acceptance criteria

## Review Checklist

- [ ] Functional requirement table
- [ ] Flow description
- [ ] Validation matrix
- [ ] Error cases
- [ ] Testable acceptance criteria

## Prompt

```text
Use `.sa/requirements/functional-requirement.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/requirements/functional-requirement.md`.

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

# review/design-smell.md — Architecture Design Smell Standard

## Objective

Detect common architecture problems and propose improvements.

## When To Use

- Reviewing design quality
- Refactoring architecture
- Coaching engineering

## Scope

- Coupling
- Cohesion
- Shared database
- Chatty calls
- God service
- Distributed monolith
- Overengineering

## Architecture Rules

1. Identify symptoms and root cause.
2. Recommend pragmatic fix.
3. Avoid rewriting everything without priority.
4. Map smell to risk.

## Security / Compliance Rules

1. Flag security smells separately.
2. Identify data ownership and authorization smells.

## Anti-patterns

- Microservices sharing DB.
- Service owns everything.
- Kafka used for all calls.
- No clear boundaries.
- Too many sync calls.

## Expected Output

1. Design smell list
2. Risk impact
3. Fix recommendation
4. Priority

## Review Checklist

- [ ] Design smell list
- [ ] Risk impact
- [ ] Fix recommendation
- [ ] Priority

## Prompt

```text
Use `.sa/review/design-smell.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/review/design-smell.md`.

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

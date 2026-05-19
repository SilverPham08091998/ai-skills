# requirements/domain-discovery.md — Domain Discovery Standard

## Objective

Discover business domains, subdomains, bounded contexts, and ownership boundaries.

## When To Use

- Before microservice decomposition
- Designing DDD architecture
- Splitting modules/services

## Scope

- Domain
- Subdomain
- Bounded context
- Aggregate
- Domain event
- Ownership
- Ubiquitous language

## Architecture Rules

1. Start with business capabilities.
2. Separate core/supporting/generic subdomains.
3. Define bounded contexts before services.
4. Avoid data ownership ambiguity.
5. Use domain events for cross-context communication when appropriate.

## Security / Compliance Rules

1. Identify sensitive domains like identity, payment, wallet, compliance.
2. Protect money movement and audit domains with stronger rules.

## Anti-patterns

- Microservices by database table.
- Shared database across contexts.
- No clear owner.
- Anemic service split.

## Expected Output

1. Domain map
2. Bounded context list
3. Ownership matrix
4. Candidate services
5. Domain events

## Review Checklist

- [ ] Domain map
- [ ] Bounded context list
- [ ] Ownership matrix
- [ ] Candidate services
- [ ] Domain events

## Prompt

```text
Use `.sa/requirements/domain-discovery.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/requirements/domain-discovery.md`.

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

# data/database-selection.md — Database Selection Standard

## Objective

Choose database technology based on data model, consistency, query, and operational needs.

## When To Use

- Choosing DB
- Comparing PostgreSQL/Redis/Kafka/NoSQL/TigerBeetle
- Design review

## Scope

- Relational
- Document
- Key-value
- Ledger
- Search
- Time-series
- Object storage

## Architecture Rules

1. Choose database by workload, not trend.
2. PostgreSQL fits transactional relational data.
3. Redis fits cache/lock/short-lived state.
4. Kafka fits event stream, not database.
5. Ledger systems fit accounting-like immutable transfers.
6. Search engines fit search, not source of truth.

## Security / Compliance Rules

1. Consider compliance, backup, encryption, access, audit.
2. Avoid storing sensitive data in unsupported stores.

## Anti-patterns

- Using Redis as permanent DB.
- Using Kafka as query database.
- Choosing NoSQL to avoid modeling.
- No backup/restore consideration.

## Expected Output

1. Database comparison
2. Recommendation
3. Trade-offs
4. Operational impact

## Review Checklist

- [ ] Database comparison
- [ ] Recommendation
- [ ] Trade-offs
- [ ] Operational impact

## Prompt

```text
Use `.sa/data/database-selection.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/data/database-selection.md`.

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

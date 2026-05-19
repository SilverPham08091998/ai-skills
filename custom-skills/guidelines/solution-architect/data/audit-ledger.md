# data/audit-ledger.md — Audit and Ledger Standard

## Objective

Design audit trails and ledger-like records for fintech/banking systems.

## When To Use

- Wallet/payment design
- Compliance audit
- Money movement architecture

## Scope

- Immutable audit
- Ledger entry
- Journal
- Double-entry
- Traceability
- Reconciliation
- Correction

## Architecture Rules

1. Money movement needs immutable traceability.
2. Never update historical financial entries destructively.
3. Use reversal/correction entries.
4. Separate operational state from accounting record.
5. Support reconciliation and audit queries.

## Security / Compliance Rules

1. Protect ledger access.
2. Audit who performed actions.
3. Mask sensitive customer data while preserving traceability.

## Anti-patterns

- Updating balances without journal.
- Deleting audit records.
- No correlation between transaction and ledger.
- No reconciliation reference.

## Expected Output

1. Audit model
2. Ledger flow
3. Reversal strategy
4. Reconciliation fields

## Review Checklist

- [ ] Audit model
- [ ] Ledger flow
- [ ] Reversal strategy
- [ ] Reconciliation fields

## Prompt

```text
Use `.sa/data/audit-ledger.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/data/audit-ledger.md`.

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

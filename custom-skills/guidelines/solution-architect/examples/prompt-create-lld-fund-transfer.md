# Example Prompt — Create LLD for Fund Transfer

Use these skills:
- `.sa/SA.md`
- `.sa/generators/create-lld.md`
- `.sa/architecture/lld.md`
- `.sa/api/api-design.md`
- `.sa/api/idempotency.md`
- `.sa/data/transaction-consistency.md`
- `.sa/data/audit-ledger.md`
- `.sa/integration/saga.md`
- `.sa/integration/external-partner.md`

Task:
Create LLD for wallet-to-bank fund transfer.

Context:
- Endpoint: POST /api/v1/fund-transfer/bank
- Rule: call bank API first, get result, then update wallet
- Need idempotency, audit, reconciliation, compensation handling
- Backend: Spring Boot Clean Architecture

Output:
- Module structure
- API contract
- Sequence diagram
- State machine
- Transaction boundary
- Error contract
- Idempotency design
- Reconciliation plan
- Implementation checklist for Codex

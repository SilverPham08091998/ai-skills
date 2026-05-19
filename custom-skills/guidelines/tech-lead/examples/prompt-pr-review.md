# Example Prompt — PR Review

Use these skills:
- `.techlead/TECH_LEAD.md`
- `.techlead/generators/create-pr-review.md`
- `.techlead/review/pr-review.md`
- `.techlead/review/code-review.md`
- `.techlead/review/security-review.md`
- `.techlead/review/production-readiness-review.md`

Task:
Review this PR diff as a Tech Lead.

Context:
- Service: payment-service
- Domain: money movement
- Risk: high
- Architecture: Clean Architecture / Hexagonal
- Need: security, idempotency, audit, tests, observability

Output:
- Summary
- Blocking issues
- Non-blocking suggestions
- Missing tests
- Security findings
- Production readiness findings
- Merge decision

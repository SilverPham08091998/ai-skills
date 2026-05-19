# Example Prompt — Create Codex Prompt for Existing Source

Use these skills:
- `.techlead/TECH_LEAD.md`
- `.techlead/generators/create-codex-prompt.md`
- `.techlead/architecture/codebase-navigation.md`
- `.techlead/architecture/architecture-alignment.md`
- `.techlead/planning/requirement-clarification.md`
- `.techlead/standards/testing-standard.md`

Task:
Create a Codex prompt to implement wallet-to-bank fund transfer in existing Spring Boot Clean Architecture source.

Context:
- Endpoint: POST /api/v1/fund-transfer/bank
- Rule: call bank API first, get result, then update wallet
- Must follow existing package/layer structure
- Must not create random new project/folder
- Must include idempotency, audit, tests, and validation
- Codex must present TODO list before editing if hooks require approval

Output:
- Codex prompt
- Files to inspect first
- Implementation rules
- Required tests
- Definition of Done

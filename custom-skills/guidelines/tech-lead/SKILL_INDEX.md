# SKILL_INDEX.md — Tech Lead Skill Index

## Objective

Map Tech Lead tasks to the correct `.techlead` skill files.

## Recommended Workflow

```text
Step 1: Clarify requirement and business goal
Step 2: Check existing architecture and codebase conventions
Step 3: Break work into tasks and risks
Step 4: Prepare implementation prompt or task tickets
Step 5: Review design before implementation if high impact
Step 6: Review PR/code before merge
Step 7: Check production readiness before release
Step 8: Capture lessons and improve team standards
```

## Task Routing

| Task | Recommended Skills |
|---|---|
| Plan new feature | `.techlead/generators/create-feature-plan.md`, `.techlead/planning/requirement-clarification.md`, `.techlead/planning/task-breakdown.md` |
| Create Codex prompt | `.techlead/generators/create-codex-prompt.md`, `.techlead/architecture/codebase-navigation.md`, `.techlead/architecture/architecture-alignment.md` |
| Review PR | `.techlead/generators/create-pr-review.md`, `.techlead/review/pr-review.md`, `.techlead/review/code-review.md` |
| Review security-sensitive code | `.techlead/review/security-review.md`, `.techlead/standards/logging-standard.md`, `.techlead/production/config-management.md` |
| Review API | `.techlead/review/api-review.md`, `.techlead/standards/error-handling.md`, `.techlead/standards/testing-standard.md` |
| Review design | `.techlead/generators/create-tech-design-review.md`, `.techlead/architecture/design-review.md`, `.techlead/architecture/adr-review.md` |
| Prepare release | `.techlead/generators/create-release-checklist.md`, `.techlead/delivery/release-readiness.md`, `.techlead/delivery/rollback-plan.md` |
| Production readiness | `.techlead/review/production-readiness-review.md`, `.techlead/production/observability-check.md`, `.techlead/production/runbook-review.md` |
| Improve team standard | `.techlead/generators/create-team-guideline.md`, `.techlead/standards/coding-standard.md`, `.techlead/leadership/mentoring.md` |
| Manage tech debt | `.techlead/quality/technical-debt.md`, `.techlead/architecture/refactoring-strategy.md`, `.techlead/quality/maintainability.md` |

## Full File Map

| File | Purpose | Use When |
|---|---|---|
| `.techlead/README.md` | Tech Lead Skill Pack Overview | Onboarding AI agent, Explaining folder structure |
| `.techlead/TECH_LEAD.md` | Tech Lead Master Skill | Starting a new feature or project, Reviewing code, architecture, PRs, or production readiness |
| `.techlead/architecture/adr-review.md` | ADR Review Standard | Reviewing ADR, Approving technology choice |
| `.techlead/architecture/architecture-alignment.md` | Architecture Alignment Standard | Reviewing implementation plan, Before generating code |
| `.techlead/architecture/codebase-navigation.md` | Codebase Navigation Standard | Using Codex/Claude on existing repo, Avoiding random implementation |
| `.techlead/architecture/design-review.md` | Tech Lead Design Review Standard | Reviewing HLD/LLD, Before implementation |
| `.techlead/architecture/refactoring-strategy.md` | Refactoring Strategy Standard | Cleaning code, Migrating architecture |
| `.techlead/delivery/definition-of-done.md` | Definition of Done Standard | Completing feature, Reviewing PR |
| `.techlead/delivery/definition-of-ready.md` | Definition of Ready Standard | Sprint planning, Before Codex prompt |
| `.techlead/delivery/incident-followup.md` | Incident Follow-up Standard | After incident, Postmortem |
| `.techlead/delivery/release-readiness.md` | Release Readiness Standard | Before staging/prod release, Release planning |
| `.techlead/delivery/rollback-plan.md` | Rollback Plan Standard | Before production release, Incident mitigation |
| `.techlead/generators/create-codex-prompt.md` | Generator — Create Codex Implementation Prompt | User wants AI coding prompt, Existing source implementation |
| `.techlead/generators/create-feature-plan.md` | Generator — Create Feature Implementation Plan | User asks to plan feature, Before Codex implementation |
| `.techlead/generators/create-pr-review.md` | Generator — Create PR Review | Reviewing PR diff, Reviewing generated code |
| `.techlead/generators/create-release-checklist.md` | Generator — Create Release Checklist | Before release, Go-live preparation |
| `.techlead/generators/create-team-guideline.md` | Generator — Create Team Guideline | Creating team rule, After repeated review comments |
| `.techlead/generators/create-tech-design-review.md` | Generator — Create Tech Design Review | Reviewing HLD/LLD, Before implementation |
| `.techlead/leadership/communication.md` | Engineering Communication Standard | Writing update, Explaining risk |
| `.techlead/leadership/decision-making.md` | Technical Decision Making Standard | Choosing library/framework, Resolving design disagreement |
| `.techlead/leadership/mentoring.md` | Mentoring Standard | Coaching junior/mid engineer, Reviewing repeated mistakes |
| `.techlead/leadership/role.md` | Tech Lead Role Standard | Clarifying Tech Lead scope, Setting team expectations |
| `.techlead/leadership/team-workflow.md` | Team Workflow Standard | Setting team process, Improving delivery |
| `.techlead/planning/estimation.md` | Engineering Estimation Standard | Sprint planning, Sizing feature |
| `.techlead/planning/requirement-clarification.md` | Requirement Clarification Standard | Starting new feature, Writing Codex prompt |
| `.techlead/planning/risk-management.md` | Engineering Risk Management Standard | Before implementation, Before release |
| `.techlead/planning/roadmap.md` | Technical Roadmap Standard | Planning large initiative, Splitting architecture rollout |
| `.techlead/planning/task-breakdown.md` | Task Breakdown Standard | Creating Jira tickets, Preparing implementation plan |
| `.techlead/production/config-management.md` | Configuration Management Standard | Reviewing config, Preparing deployment |
| `.techlead/production/feature-flag.md` | Feature Flag Standard | Risky release, Canary rollout |
| `.techlead/production/migration-review.md` | Migration Review Standard | DB migration PR, Data migration |
| `.techlead/production/observability-check.md` | Observability Check Standard | Before release, PR review |
| `.techlead/production/runbook-review.md` | Runbook Review Standard | Before release, On-call readiness |
| `.techlead/quality/clean-code.md` | Clean Code Review Standard | Code review, Refactoring |
| `.techlead/quality/code-smell.md` | Code Smell Standard | Code review, Refactor planning |
| `.techlead/quality/maintainability.md` | Maintainability Standard | Architecture review, Code review |
| `.techlead/quality/technical-debt.md` | Technical Debt Management Standard | Reviewing debt, Planning refactor |
| `.techlead/quality/test-strategy.md` | Test Strategy Standard | Planning tests, Reviewing feature quality |
| `.techlead/review/api-review.md` | API Review Standard | Reviewing endpoint design, Before API implementation |
| `.techlead/review/code-review.md` | Code Review Standard | Reviewing PR, Reviewing generated code |
| `.techlead/review/performance-review.md` | Performance Review Standard | Reviewing hot path, High traffic API |
| `.techlead/review/pr-review.md` | Pull Request Review Standard | Reviewing GitHub/GitLab PR, Creating PR template |
| `.techlead/review/production-readiness-review.md` | Production Readiness Review Standard | Before release, Go-live checklist |
| `.techlead/review/security-review.md` | Security Review Standard | Sensitive feature review, Before merge |
| `.techlead/standards/coding-standard.md` | Coding Standard | Creating team standard, Reviewing code quality |
| `.techlead/standards/documentation-standard.md` | Engineering Documentation Standard | Writing docs, Reviewing PR docs |
| `.techlead/standards/error-handling.md` | Error Handling Standard | Reviewing API/service code, Designing error contract |
| `.techlead/standards/logging-standard.md` | Logging Standard for Tech Lead Review | Reviewing logs in code, Setting team logging standard |
| `.techlead/standards/naming-convention.md` | Naming Convention Standard | Creating project guideline, Reviewing code |
| `.techlead/standards/testing-standard.md` | Testing Standard | Reviewing PR tests, Planning feature tests |

## Prompt Pattern

```text
Use these skills:
- .techlead/TECH_LEAD.md
- .techlead/SKILL_INDEX.md
- <specific skill files>

Task:
<what you want>

Context:
- Feature/change:
- Existing codebase:
- Architecture style:
- Risk:
- Deadline:
- Production impact:

Output:
- Assumptions
- Plan/review
- Risks
- Concrete action items
- Definition of Done
```

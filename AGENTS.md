# Repository Instructions

This repository keeps AI engineering skills and guidelines for multiple assistants. Codex behavior must be isolated from Claude Code plugin behavior.

## Codex Load Requirement

Before doing any code generation, code review, refactor, file edit, or repository analysis in this repository, Codex must load these files in order:

1. `.codex/AGENTS.md`
2. `.codex/CODEX.md`
3. `.codex/SKILL.md`
4. The most relevant `.codex/skills/<skill-name>/SKILL.md`

Use `.codex/skills/<skill-name>/SKILL.md` as the primary Codex skill source when the task matches a specific backend, mobile, Java, Spring Boot, Clean Architecture, testing, code-review, React Native, or state-management skill.

## Separation Rule

- Codex-specific skills live under `.codex/skills/<skill-name>/SKILL.md`.
- Claude Code plugin skills live under `plugins/ai-skills/skills/<skill-name>/SKILL.md`.
- Do not edit or depend on the Claude plugin copy when updating Codex behavior.
- Do not edit or depend on the Codex copy when updating Claude plugin behavior.

## Default Codex Behavior

- Prefer the most specific `.codex/skills` file before loading broader guideline files.
- Load `.codex/guidelines/**/*.md` only when deeper source rules are needed beyond the selected Codex skill.
- Preserve fintech production-safety rules, including security, validation, observability, idempotency, and sensitive-data masking.

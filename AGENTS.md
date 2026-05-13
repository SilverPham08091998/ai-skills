# Repository Instructions

This repository centralizes AI engineering skills, workflows, and rules for multiple assistants.
It is also intended to be used as a global Codex rule source from any project folder.

Claude Code plugin behavior and Codex behavior must stay isolated at the file level, but their
high-level delivery rules should stay aligned.

## Codex Load Requirement

Before doing any code generation, code review, refactor, file edit, or repository analysis using this rule set, Codex must load these files in order from the ai-skills rule root:

1. `.codex/AGENTS.md`
2. `.codex/CODEX.md`
3. `.codex/SKILL.md`
4. `.codex/COMMANDS.md`
5. `.codex/workflow/*.md` when implementation or file edits are requested
6. The most relevant `.codex/skills/<skill-name>/SKILL.md`

Use `.codex/skills/<skill-name>/SKILL.md` as the primary Codex skill source when the task matches a specific backend, mobile, Java, Spring Boot, Clean Architecture, testing, code-review, React Native, or state-management skill.

## Global Path Rule

- When Codex is running inside this repository, the ai-skills rule root is the current repository root.
- When Codex is running in another project, locate this rule root through `AI_SKILLS_HOME`, `CODEX_AI_SKILLS_HOME`, or the known fallback `/home/tinhpn2/Documents/ai-skills`.
- Read rules from the ai-skills rule root, but apply code edits, tests, and version guides to the user's current target project.
- Do not copy `.codex/` into the target project unless the user explicitly asks to install local rules there.

## Separation Rule

- Codex-specific skills live under `.codex/skills/<skill-name>/SKILL.md`.
- Codex-specific workflow rules live under `.codex/workflow/*.md`.
- Codex command entrypoints live under `.codex/COMMANDS.md`.
- Claude Code plugin skills live under `plugins/ai-skills/skills/<skill-name>/SKILL.md`.
- Claude Code plugin workflow rules live under `plugins/ai-skills/workflow/*.md`.
- Do not edit or depend on the Claude plugin copy when updating Codex behavior.
- Do not edit or depend on the Codex copy when updating Claude plugin behavior.

## Cross-Agent Alignment Rule

- Keep global behavior aligned across assistants: TODO-first approval gate, explicit file scope, architecture check, structure check, implementation, tests, coverage, and version guide.
- Mirror rule intent, not file paths: Claude rules stay in `plugins/ai-skills/`; Codex rules stay in `.codex/`.
- When changing shared policy, update both assistant-specific copies or document why one side intentionally differs.

## Default Codex Behavior

- Prefer the most specific `.codex/skills` file before loading broader guideline files.
- Load `.codex/guidelines/**/*.md` only when deeper source rules are needed beyond the selected Codex skill.
- Preserve fintech production-safety rules, including security, validation, observability, idempotency, and sensitive-data masking.
- For implementation work, follow the Codex workflow files and keep the edited-file scope explicit.

# Codex Generator Instructions

This folder contains the generation rules for Codex use in the centralized `ai-skills` repository.
These rules are designed to be loaded globally from any target project folder.

Codex rules must align with Claude plugin behavior at the workflow level while remaining isolated
under `.codex/`.

## Load Order

When generating or reviewing code in any folder, use these files from the ai-skills rule root in order:

1. `CODEX.md` for global engineering and production-safety rules.
2. `SKILL.md` to understand available Codex skill groups and routing.
3. `COMMANDS.md` to select the Codex execution entrypoint.
4. `workflow/router.md` to classify the request intent, then the matching workflow file(s).
5. `skills/<skill-name>/SKILL.md` for the specific backend, mobile, review, testing, Java, Spring Boot, Clean Architecture, React Native, or state-management skill that matches the task.
6. `generator-pipeline.md` for end-to-end service/module/API/Kafka generation.
7. `templates/*.md` for concrete generation tasks.
8. `guidelines/**/*.md` only when deeper source rules are needed beyond the selected Codex skill.

## Rule Root Resolution

Codex must separate the **rule root** from the **target project root**:

- Rule root: the `ai-skills` repository that contains this `.codex/` directory.
- Target project root: the user's current project/folder where code is inspected, edited, tested, or documented.

Resolve the rule root in this order:

1. `AI_SKILLS_HOME`
2. `CODEX_AI_SKILLS_HOME`
3. `/home/tinhpn2/Documents/ai-skills`
4. Current repository root, only when it contains `.codex/CODEX.md`

Use absolute paths from the rule root when reading rules from another project. Keep all edits in the target project unless the user explicitly asks to update ai-skills itself.

## Codex Execution Model

Claude plugin can enforce workflow through hooks. Codex does not use Claude plugin hooks.
Codex enforcement is instruction-driven:

- Before edits, Codex must explicitly read the matching command in `COMMANDS.md`.
- Codex must read `.codex/workflow/router.md` before selecting an intent-specific workflow.
- For ask/explanation work, Codex must read `.codex/workflow/ask.md` and research local context before falling back to outside knowledge.
- For implementation work, Codex must read `.codex/workflow/implement/00-context-alignment.md` through `.codex/workflow/implement/08-pre-commit.md` before the first file edit.
- Codex must present the TODO/file-scope gate from `CODEX.md` and wait for approval unless the user already approved that exact scope.
- Codex must run validation commands directly with available tools and report commands that could not run.
- When the target project is not ai-skills, Codex must still read commands/workflows/skills from the ai-skills rule root before editing the target project.

## Codex Skills

- Codex-specific skills live under `.codex/skills/<skill-name>/SKILL.md`.
- Codex command entrypoints live under `.codex/COMMANDS.md`.
- Codex workflow rules live under `.codex/workflow/*.md`.
- Claude Code plugin skills live separately under `plugins/ai-skills/skills/<skill-name>/SKILL.md`.
- Claude Code plugin workflow rules live separately under `plugins/ai-skills/workflow/*.md`.
- Do not edit or depend on the Claude plugin copy when updating Codex behavior; keep Codex changes isolated under `.codex/`.
- Prefer the most specific Codex skill before loading broader registry or guideline files.

## Default Behavior

- Before implementation, present a TODO/file-scope plan and wait for explicit user confirmation.
- Files already listed in the approved TODO/file scope may proceed without asking again.
- If a needed edit falls outside the approved file scope, stop and ask before touching that file.
- For Ask requests, research target-project or rule context first, answer with local examples as the primary source, and do not edit files.
- Follow `.codex/workflow/implement/00-context-alignment.md` through `.codex/workflow/implement/08-pre-commit.md` for feature implementation.
- Follow Clean Architecture: Controller -> Application -> Domain -> Infrastructure.
- Keep domain code framework-free.
- Use MapStruct for mapping boundaries.
- Use `BigDecimal` for money and explicit rounding rules.
- Require idempotency for payment and financial write APIs.
- Add validation, exception handling, observability, focused tests, coverage verification, and version-guide documentation for generated code.

## Repository Scope

These instructions apply to code generated, reviewed, or modified in any target project that chooses this ai-skills rule set, unless a more specific user or project instruction overrides them.

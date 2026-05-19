# Cursor Generator Instructions

This folder contains the generation rules for Cursor use in the centralized `ai-skills` repository.
These rules are designed to be loaded globally from any target project folder.

Cursor rules must align with Claude plugin behavior at the workflow level while remaining isolated
under `cursor/`.

## Load Order

When generating or reviewing code in any folder, use these files from the ai-skills rule root in order:

1. `CURSOR.md` for global engineering and production-safety rules.
2. `SKILL.md` to understand available Cursor skill groups and routing.
3. `COMMANDS.md` to select the Cursor execution entrypoint.
4. `workflow/router.md` to classify the request intent, then the matching workflow file(s).
5. `skills/<skill-name>/SKILL.md` for the specific backend, mobile, review, testing, Java, Spring Boot, Clean Architecture, React Native, or state-management skill that matches the task.
6. `generator-pipeline.md` for end-to-end service/module/API/Kafka generation.
7. `templates/*.md` for concrete generation tasks.
8. `guidelines/**/*.md` only when deeper source rules are needed beyond the selected Cursor skill.

## Rule Root Resolution

Cursor must separate the **rule root** from the **target project root**:

- Rule root: the `ai-skills` repository that contains this `cursor/` directory.
- Target project root: the user's current project/folder where code is inspected, edited, tested, or documented.

Resolve the rule root in this order:

1. `AI_SKILLS_HOME`
2. `CURSOR_AI_SKILLS_HOME`
3. `/home/tinhpn2/Documents/ai-skills`
4. Current repository root, only when it contains `cursor/CURSOR.md`

Use absolute paths from the rule root when reading rules from another project. Keep all edits in the target project unless the user explicitly asks to update ai-skills itself.

## Cursor Execution Model

Claude plugin can enforce workflow through hooks. Cursor does not use Claude plugin hooks.
Cursor enforcement is instruction-driven:

- Before edits, Cursor must explicitly read the matching command in `COMMANDS.md`.
- Cursor must read `cursor/workflow/router.md` before selecting an intent-specific workflow.
- For ask/explanation work, Cursor must read `cursor/workflow/ask.md` and research local context before falling back to outside knowledge.
- For implementation work, Cursor must read `cursor/workflow/implement/00-context-alignment.md` through `cursor/workflow/implement/08-pre-commit.md` before the first file edit.
- Cursor must present the TODO/file-scope gate from `CURSOR.md` and wait for approval unless the user already approved that exact scope.
- Cursor must run validation commands directly with available tools and report commands that could not run.
- When the target project is not ai-skills, Cursor must still read commands/workflows/skills from the ai-skills rule root before editing the target project.

## Cursor Skills

- Cursor-specific skills live under `cursor/skills/<skill-name>/SKILL.md`.
- Cursor command entrypoints live under `cursor/COMMANDS.md`.
- Cursor workflow rules live under `cursor/workflow/*.md`.
- Claude Code plugin skills live separately under `plugins/ai-skills/skills/<skill-name>/SKILL.md`.
- Claude Code plugin workflow rules live separately under `plugins/ai-skills/workflow/*.md`.
- Do not edit or depend on the Claude plugin copy when updating Cursor behavior; keep Cursor changes isolated under `cursor/`.
- Prefer the most specific Cursor skill before loading broader registry or guideline files.

## Default Behavior

- Before implementation, present a TODO/file-scope plan and wait for explicit user confirmation.
- Files already listed in the approved TODO/file scope may proceed without asking again.
- If a needed edit falls outside the approved file scope, stop and ask before touching that file.
- For Ask requests, research target-project or rule context first, answer with local examples as the primary source, and do not edit files.
- Follow `cursor/workflow/implement/00-context-alignment.md` through `cursor/workflow/implement/08-pre-commit.md` for feature implementation.
- Follow Clean Architecture: Controller -> Application -> Domain -> Infrastructure.
- Keep domain code framework-free.
- Use MapStruct for mapping boundaries.
- Use `BigDecimal` for money and explicit rounding rules.
- Require idempotency for payment and financial write APIs.
- Add validation, exception handling, observability, focused tests, coverage verification, and version-guide documentation for generated code.

## Repository Scope

These instructions apply to code generated, reviewed, or modified in any target project that chooses this ai-skills rule set, unless a more specific user or project instruction overrides them.

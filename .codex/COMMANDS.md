# Codex Commands

This file translates centralized AI workflow rules into Codex-executable entrypoints.

Claude Code uses plugin hooks. Codex does not execute Claude hooks, so Codex must use these command
entrypoints as the practical enforcement layer before editing files.

## Rule Root And Target Project

These commands are portable. Codex may run from any target project folder.

Resolve the ai-skills rule root in this order:

1. `AI_SKILLS_HOME`
2. `CODEX_AI_SKILLS_HOME`
3. `/home/tinhpn2/Documents/ai-skills`
4. Current repository root, only if it contains `.codex/CODEX.md`

Read commands, workflows, templates, and skills from the rule root. Inspect, edit, test, and document the target project in the current working folder unless the user explicitly asks to update ai-skills itself.

## `codex-implement`

Use for code generation, feature implementation, refactor, or meaningful file edits.

Before editing:

1. Resolve the ai-skills rule root.
2. Read `<rule-root>/.codex/CODEX.md`.
3. Read `<rule-root>/.codex/SKILL.md`.
4. Read all workflow files from `<rule-root>/.codex/workflow/`.
5. Read the most relevant `<rule-root>/.codex/skills/<skill-name>/SKILL.md`.
6. Present TODO list and target-project file scope.
7. Wait for explicit approval unless the current user message already approves that exact scope.
8. Edit only approved files in the target project.
9. If another file is needed, stop and ask with the out-of-scope format from `<rule-root>/.codex/CODEX.md`.
10. Run relevant tests/build/coverage commands in the target project.
11. Create/update version guide in the target project when the workflow requires it.

## `codex-sync-claude-rules`

Use when the user says Claude rules or skills are already updated and Codex should copy or align with them.

Before editing:

1. Resolve the ai-skills rule root.
2. Read `<rule-root>/plugins/ai-skills/CLAUDE.md`.
3. Read `<rule-root>/plugins/ai-skills/workflow/*.md`.
4. Read `<rule-root>/.codex/AGENTS.md`, `<rule-root>/.codex/CODEX.md`, `<rule-root>/.codex/SKILL.md`, and this file.
5. Copy workflow files from `<rule-root>/plugins/ai-skills/workflow/` to `<rule-root>/.codex/workflow/` when the user asks to mirror Claude.
6. Compare `<rule-root>/plugins/ai-skills/skills/` and `<rule-root>/.codex/skills/`; copy missing skill folders into `<rule-root>/.codex/skills/` when the user asks to mirror Claude skills.
7. Update Codex rule and index files so Codex can execute the same intent without claiming Claude hook support.
8. Verify copied workflow files with `diff -q`.
9. Verify skill counts and missing skill list with `find`/`comm`.

Do not edit `plugins/ai-skills/` unless the user explicitly asks to change Claude plugin behavior.

## `codex-update-skill`

Use when updating a specific Codex skill.

Before editing:

1. Resolve the ai-skills rule root.
2. Read `<rule-root>/.codex/CODEX.md`.
3. Read `<rule-root>/.codex/SKILL.md`.
4. Read this file.
5. Read the target `<rule-root>/.codex/skills/<skill-name>/SKILL.md`.
6. Read deeper `<rule-root>/.codex/guidelines/**/*.md` only if the skill lacks enough detail.
7. Keep the skill concise and action-oriented.
8. Do not modify the Claude plugin copy unless explicitly requested.

## `codex-review`

Use for code review.

Before reviewing:

1. Resolve the ai-skills rule root.
2. Read `<rule-root>/.codex/CODEX.md`.
3. Read `<rule-root>/.codex/SKILL.md`.
4. Read the most relevant code-review skill under `<rule-root>/.codex/skills/`.
5. Review the target project for bugs, security, data correctness, reliability, test gaps, and production readiness.
6. Lead with findings ordered by severity.

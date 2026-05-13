---
name: ai-skills-global
description: Global ai-skills bootstrap. Use before any code generation, code review, refactor, file edit, repository analysis, backend work, mobile work, Java, Spring Boot, Clean Architecture, React Native, testing, DevOps, security, observability, frontend, cloud, or workflow task in any project.
---

# AI Skills Global Bootstrap

Use `/home/tinhpn2/Documents/ai-skills` as the global ai-skills rule root unless the user provides another path.

Before code generation, code review, refactor, file edit, or repository analysis:

1. Read `/home/tinhpn2/Documents/ai-skills/.codex/AGENTS.md`.
2. Read `/home/tinhpn2/Documents/ai-skills/.codex/CODEX.md`.
3. Read `/home/tinhpn2/Documents/ai-skills/.codex/SKILL.md`.
4. Read `/home/tinhpn2/Documents/ai-skills/.codex/COMMANDS.md`.
5. Read `/home/tinhpn2/Documents/ai-skills/.codex/workflow/router.md`.
6. Select the relevant command entrypoint from `COMMANDS.md`.
7. For ask/explanation work, read `/home/tinhpn2/Documents/ai-skills/.codex/workflow/ask.md`.
8. For implementation or file edits, read the implementation workflow files under `/home/tinhpn2/Documents/ai-skills/.codex/workflow/implement/`, starting with `00-context-alignment.md` and including `08-pre-commit.md` before any user-requested commit.
9. Read the most relevant skill under `/home/tinhpn2/.codex/skills/<skill-name>/SKILL.md` or `/home/tinhpn2/Documents/ai-skills/.codex/skills/<skill-name>/SKILL.md`.

Keep rule root and target project separate:

- Read rules, commands, workflows, templates, and skills from ai-skills.
- Inspect, edit, test, and document the current target project.
- Do not copy ai-skills rules into the target project unless explicitly requested.

For implementation work, present TODO and target file scope, then wait for explicit approval before editing unless the user already approved that exact scope.

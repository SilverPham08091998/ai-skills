# Global Codex AI Skills Bootstrap

Use `/home/tinhpn2/Documents/ai-skills` as the global ai-skills rule root for every project unless the user provides another rule root.

Before code generation, code review, refactor, file edit, or repository analysis:

1. Read `/home/tinhpn2/Documents/ai-skills/.codex/AGENTS.md`.
2. Read `/home/tinhpn2/Documents/ai-skills/.codex/CODEX.md`.
3. Read `/home/tinhpn2/Documents/ai-skills/.codex/SKILL.md`.
4. Read `/home/tinhpn2/Documents/ai-skills/.codex/COMMANDS.md`.
5. Read `/home/tinhpn2/Documents/ai-skills/.codex/workflow/router.md`.
6. Select the relevant command entrypoint from `COMMANDS.md`.
7. For ask/explanation work, read `/home/tinhpn2/Documents/ai-skills/.codex/workflow/ask.md`.
8. For implementation or file edits, read the implementation workflow files under `/home/tinhpn2/Documents/ai-skills/.codex/workflow/implement/`, starting with `00-context-alignment.md` and including `08-pre-commit.md` before any user-requested commit.
9. Read the most relevant skill under `/home/tinhpn2/Documents/ai-skills/.codex/skills/<skill-name>/SKILL.md`.

Keep the ai-skills rule root separate from the target project:

- Read rules, commands, workflows, templates, and skills from `/home/tinhpn2/Documents/ai-skills`.
- Inspect, edit, test, and document files in the user's current target project.
- Do not copy ai-skills rules into the target project unless the user explicitly asks.

For implementation work, Codex must present TODO + target file scope and wait for explicit approval before editing, unless the user already approved that exact scope.

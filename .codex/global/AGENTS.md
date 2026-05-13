# Global Codex AI Skills Bootstrap

Use `/home/tinhpn2/Documents/ai-skills` as the global ai-skills rule root for every project unless the user provides another rule root.

Before code generation, code review, refactor, file edit, or repository analysis:

1. Read `/home/tinhpn2/Documents/ai-skills/.codex/AGENTS.md`.
2. Read `/home/tinhpn2/Documents/ai-skills/.codex/CODEX.md`.
3. Read `/home/tinhpn2/Documents/ai-skills/.codex/SKILL.md`.
4. Read `/home/tinhpn2/Documents/ai-skills/.codex/COMMANDS.md`.
5. Select the relevant command entrypoint from `COMMANDS.md`.
6. For implementation or file edits, read all workflow files under `/home/tinhpn2/Documents/ai-skills/.codex/workflow/`.
7. Read the most relevant skill under `/home/tinhpn2/Documents/ai-skills/.codex/skills/<skill-name>/SKILL.md`.

Keep the ai-skills rule root separate from the target project:

- Read rules, commands, workflows, templates, and skills from `/home/tinhpn2/Documents/ai-skills`.
- Inspect, edit, test, and document files in the user's current target project.
- Do not copy ai-skills rules into the target project unless the user explicitly asks.

For implementation work, Codex must present TODO + target file scope and wait for explicit approval before editing, unless the user already approved that exact scope.

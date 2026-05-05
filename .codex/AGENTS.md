# Codex Generator Instructions

This folder contains the local generation rules for Codex use.

## Load Order

When generating or reviewing backend or mobile code for this repository, use these files in order:

1. `CODEX.md` for global engineering and production-safety rules.
2. `skills/<skill-name>/SKILL.md` for the specific backend, mobile, review, testing, Java, Spring Boot, Clean Architecture, React Native, or state-management skill that matches the task.
3. `SKILL.md` to route to the relevant guideline files when no specific skill is enough.
4. `generator-pipeline.md` for end-to-end service/module/API/Kafka generation.
5. `templates/*.md` for concrete generation tasks.
6. `guidelines/**/*.md` only when deeper source rules are needed beyond the selected Codex skill.

## Codex Skills

- Codex-specific skills live under `.codex/skills/<skill-name>/SKILL.md`.
- Claude Code plugin skills live separately under `plugins/ai-skills/skills/<skill-name>/SKILL.md`.
- Do not edit or depend on the Claude plugin copy when updating Codex behavior; keep Codex changes isolated under `.codex/`.
- Prefer the most specific Codex skill before loading broader registry or guideline files.

## Default Behavior

- Follow Clean Architecture: Controller -> Application -> Domain -> Infrastructure.
- Keep domain code framework-free.
- Use MapStruct for mapping boundaries.
- Use `BigDecimal` for money and explicit rounding rules.
- Require idempotency for payment and financial write APIs.
- Add validation, exception handling, observability, and focused tests for generated code.

## Repository Scope

These instructions apply to code generated or modified in this repository unless a more specific user instruction overrides them.

# Workflow Router

## Purpose

Use this router to select the correct workflow intent for the user's request.

Do not treat every request as implementation work.

## Routing Rule

If the user's intent is clear, route directly. If the intent is ambiguous, ask the user to choose the workflow before continuing.

```text
User request
  -> classify intent
  -> if clear: load matching workflow
  -> if ambiguous: ask user to choose
```

## Supported Intents

| Intent | Use When | Workflow |
|---|---|---|
| `ask` | The user asks a question, wants explanation, context, comparison, or pre-implementation discovery | `workflow/ask.md` |
| `implement` | The user asks to add a feature, generate code, make a meaningful edit, or implement a planned change | `workflow/implement/*.md` |
| `fix-bug` | The user asks to diagnose and fix a defect, failing behavior, failing test, runtime error, or regression | `workflow/fix-bug/` |
| `review` | The user asks for code review, PR review, risk assessment, or findings | `workflow/review/` |
| `refactor` | The user asks to restructure code while preserving behavior, or reorganize layers per Clean Architecture | `workflow/refactor/` |

## Defaults

- If the user is trying to understand before deciding what to build, default to `ask`.
- If the user uses action verbs like "add", "implement", "create", "generate", or "build", default to `implement`.
- If the user says "fix", "bug", "lỗi", "error", "failing", "broken", or provides a failing test/log/stacktrace, default to `fix-bug`.
- If the user says "review", default to `review`.
- If the user says "refactor", "clean up", "restructure", "clean architecture", "sai layer", "wrong layer", or "apply clean arch", default to `refactor`.

## Ambiguous Requests

When intent is ambiguous, ask a short clarification question:

```text
Bạn muốn mình xử lý theo workflow nào?

- ask: nghiên cứu context và giải thích bức tranh lớn, không sửa file
- implement: thêm chức năng mới hoặc tạo code
- fix-bug: tìm nguyên nhân và sửa lỗi
- review: review code/PR và chỉ ra findings
- refactor: cải tổ code nhưng giữ nguyên behavior
```

Do not ask when the intent is already clear from the user's wording.

## Workflow Boundaries

- `ask` must not edit files.
- `implement` must use the step-by-step workflow under `workflow/implement/`.
- `refactor` must use `workflow/refactor/` — never fall back to `implement` for refactor/restructure requests.
- Switching from `ask` to an edit workflow requires explicit user intent to proceed.

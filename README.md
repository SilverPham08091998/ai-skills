# AI Skills

Repository này centralize **AI engineering skills, rules, workflow** cho nhiều assistant.

- Claude Code plugin nằm trong `plugins/ai-skills/`.
- Codex rules và skills nằm trong `.codex/`.
- Hai bên tách file để không conflict, nhưng phải giữ cùng intent về workflow và production safety.
- Claude plugin và Codex hiện cùng có **173 skills**.

Trọng tâm repo: fintech/banking backend, Java/Spring Boot, Clean Architecture, React Native mobile, testing, review, observability, security, idempotency, và sensitive-data masking.

---

## Cài Đặt Trên Máy Mới

### Bước 1 — Thêm marketplace vào `~/.claude/settings.json`

Mở file `~/.claude/settings.json` và thêm vào:

```json
{
  "extraKnownMarketplaces": {
    "ai-skills": {
      "source": {
        "source": "github",
        "repo": "SilverPham08091998/ai-skills"
      }
    }
  },
  "enabledPlugins": {
    "ai-skills@ai-skills": true
  }
}
```

Nếu `settings.json` đã có `extraKnownMarketplaces` và `enabledPlugins`, chỉ cần **merge thêm** 2 key trên vào, không xoá các entry cũ.

**Ví dụ khi đã có plugins khác:**

```json
{
  "extraKnownMarketplaces": {
    "claude-code-workflows": {
      "source": {
        "source": "github",
        "repo": "wshobson/agents"
      }
    },
    "ai-skills": {
      "source": {
        "source": "github",
        "repo": "SilverPham08091998/ai-skills"
      }
    }
  },
  "enabledPlugins": {
    "backend-development@claude-code-workflows": true,
    "ai-skills@ai-skills": true
  }
}
```

### Bước 2 — Restart Claude Code

Đóng và mở lại Claude Code. Plugin sẽ tự động được tải từ GitHub.

### Bước 3 — Kiểm tra

Trong Claude Code session, hỏi:

```
what instructions are you following?
```

Hoặc yêu cầu Claude dùng skill cụ thể:

```
Using java-core skill, review this code: ...
```

---

## Dùng Cục Bộ (Local)

Nếu muốn dùng bản local thay vì GitHub:

```json
{
  "extraKnownMarketplaces": {
    "ai-skills": {
      "source": {
        "source": "directory",
        "path": "/đường/dẫn/đến/ai-skills"
      }
    }
  },
  "enabledPlugins": {
    "ai-skills@ai-skills": true
  }
}
```

---

## Assistant Layout

```text
ai-skills/
├── AGENTS.md                         # repo-level rules for Codex
├── .codex/
│   ├── AGENTS.md                     # Codex load order and separation rules
│   ├── CODEX.md                      # Codex global contract
│   ├── SKILL.md                      # Codex skill index
│   ├── workflow/                     # Codex implementation workflow
│   ├── skills/                       # Codex-ready skills, mirrored from Claude catalog
│   └── templates/                    # Codex generation templates
├── plugins/ai-skills/
│   ├── CLAUDE.md                     # Claude global workflow
│   ├── .claude-plugin/plugin.json    # Claude plugin metadata
│   ├── workflow/                     # Claude implementation workflow
│   ├── hooks/                        # Claude hook definitions
│   ├── scripts/                      # Claude automation scripts
│   └── skills/                       # Claude plugin skills
└── claude/guidelines/                # raw source guidelines
```

## Cross-Agent Rules

- Update `.codex/*` for Codex behavior.
- Update `plugins/ai-skills/*` for Claude plugin behavior.
- Do not make one assistant depend on the other's runtime files.
- When changing shared policy, mirror the intent in both assistant-specific locations.
- When adding Claude plugin skills that should be available to Codex, copy the skill folder into `.codex/skills/` and update `.codex/SKILL.md`.
- Keep fintech production rules mandatory: security, validation, observability, idempotency, rollback, and sensitive-data masking.

## Shared Implementation Workflow

Both assistant tracks should follow the same intent:

1. Planning/file-scope gate.
2. Architecture design when the change crosses layers, services, async flows, or contracts.
3. Source structure check before edits.
4. Implementation with clean code, security, and separation rules.
5. Behavior-focused tests.
6. Test/build/coverage validation, target coverage >= 90% where tooling supports it.
7. Version guide for meaningful implementation work.

# AI Skills — Claude Code Plugin

Repository này là một **Claude Code Plugin** chứa engineering guidelines cho backend (Java/Spring Boot/Clean Architecture) và mobile (React Native) dành cho fintech/banking apps.

Plugin tự động inject đúng guidelines vào context khi Claude Code làm việc, giúp AI generate code nhất quán và production-ready.

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

## Danh Sách Skills (57 skills)

### Backend — Clean Architecture (7)

| Skill | Mô tả |
|-------|-------|
| `clean-architecture-layers` | Layer overview, dependency rules, ports & adapters |
| `clean-architecture-common` | Shared rules across all layers |
| `clean-architecture-controller` | Controller layer rules — thin, validation only |
| `clean-architecture-application` | Application/UseCase layer rules |
| `clean-architecture-domain` | Domain layer rules — rich model, invariants |
| `clean-architecture-infrastructure` | Infrastructure layer — adapters, clients |
| `clean-architecture-mapper` | Mapping rules between layers (MapStruct) |

### Backend — Code Review (4)

| Skill | Mô tả |
|-------|-------|
| `code-review-backend` | Backend PR review checklist |
| `code-review-performance` | Performance review guidelines |
| `code-review-pr-checklist` | PR merge checklist |
| `code-review-production-readiness` | Production readiness checklist |

### Backend — Engineering (4)

| Skill | Mô tả |
|-------|-------|
| `engineering-clean-code` | Clean code principles |
| `engineering-coding-principles` | Core coding philosophy (SOLID, SRP, etc.) |
| `engineering-design-patterns` | Standard design patterns usage |
| `engineering-naming-convention` | Naming rules for classes, methods, variables |

### Backend — Infrastructure (1)

| Skill | Mô tả |
|-------|-------|
| `infrastructure-datasource` | HikariCP datasource configuration rules |

### Backend — Java (5)

| Skill | Mô tả |
|-------|-------|
| `java-core` | Java core best practices (types, null, exceptions, streams) |
| `java-collections` | Collection usage rules |
| `java-concurrency` | Thread safety, executor usage |
| `java-performance` | JVM optimization, GC awareness |
| `java-lombok-mapstruct` | Lombok annotations + MapStruct mapping rules |

### Backend — Microservice Patterns (2)

| Skill | Mô tả |
|-------|-------|
| `microservice-outbox` | Transactional Outbox pattern |
| `microservice-master-slave` | Master-Slave / Leader-Follower pattern |

### Backend — Spring Boot (8)

| Skill | Mô tả |
|-------|-------|
| `springboot-project-structure` | Domain-first package structure |
| `springboot-rest-api` | REST API design standards |
| `springboot-validation` | Bean Validation, input validation rules |
| `springboot-exception-handler` | Global exception handling |
| `springboot-security` | Authentication, authorization, JWT |
| `springboot-testing` | Spring Boot testing strategy |
| `springboot-logging` | Structured logging with SLF4J/Logback/MDC |
| `springboot-tracing` | Distributed tracing (OpenTelemetry / Micrometer) |

### Backend — Testing (4)

| Skill | Mô tả |
|-------|-------|
| `testing-unit` | Unit testing rules (JUnit 5, Mockito, AssertJ) |
| `testing-api` | API/Controller testing (MockMvc, @WebMvcTest) |
| `testing-e2e` | End-to-end testing strategy |
| `testing-performance` | Performance testing (k6, Gatling) |

### Mobile — Architecture (5)

| Skill | Mô tả |
|-------|-------|
| `mobile-architecture` | Global layer architecture (application/domain/infra/component/presentation) |
| `mobile-feature-module` | Feature module structure rules |
| `mobile-layer-rule` | Layer responsibility rules |
| `mobile-dependency-rule` | Dependency direction rules |
| `mobile-navigation-rule` | Navigation architecture rules |

### Mobile — Foundation (5)

| Skill | Mô tả |
|-------|-------|
| `mobile-engineer-role` | Mobile engineer role, mindset, responsibilities |
| `mobile-clean-code` | Clean code for mobile |
| `mobile-coding-principles` | Core mobile coding principles |
| `mobile-design-patterns` | Design patterns for mobile |
| `mobile-naming-convention` | Naming rules for mobile code |

### Mobile — React Native (5)

| Skill | Mô tả |
|-------|-------|
| `react-native-project-structure` | Global layer project structure |
| `react-native-component-rule` | Reusable component rules |
| `react-native-hook-rule` | Custom hook rules |
| `react-native-screen-rule` | Screen/view rules |
| `react-native-native-module` | Native module bridge rules |

### Mobile — State Management (8)

| Skill | Mô tả |
|-------|-------|
| `state-redux-toolkit` | Redux Toolkit — slice, selector, store |
| `state-redux-saga` | Redux Saga — async side effects |
| `state-redux-observable` | Redux Observable — RxJS epics |
| `state-redux-persist` | Redux Persist — state persistence |
| `state-storage-mmkv` | MMKV high-performance storage |
| `state-token-management` | Token storage — Keychain/Keystore |
| `state-async-flow` | Async flow patterns |
| `state-offline` | Offline state handling |

---

## Cấu Trúc Repo

```
ai-skills/
├── .claude-plugin/
│   └── marketplace.json          ← marketplace registry
├── plugins/
│   └── ai-skills/
│       ├── .claude-plugin/
│       │   └── plugin.json       ← plugin metadata
│       └── skills/
│           ├── java-core/
│           │   └── SKILL.md
│           ├── springboot-rest-api/
│           │   └── SKILL.md
│           └── ...               ← 57 skills total
├── claude/
│   └── guidelines/               ← source guideline files (raw)
├── .codex/                       ← Codex-specific guidelines
└── codex-generate-skills-prompt.md  ← prompt để regenerate skills
```

---

## Cập Nhật / Thêm Skill Mới

1. Thêm guideline vào `claude/guidelines/<category>/<skill-name>.md`
2. Tạo `plugins/ai-skills/skills/<skill-name>/SKILL.md` theo format:

```markdown
---
name: <skill-name>
description: <one sentence — what this skill covers and when to use it>
---

# Title

## When to Use This Skill

- ...

## Content

...

## Mandatory For AI Code Generation

- ...
```

3. Commit và push lên GitHub
4. Restart Claude Code trên mọi máy để pull version mới

---

## Tái Tạo Toàn Bộ Skills

Nếu muốn gen lại 57 skills từ source guidelines, dùng file prompt:

```
codex-generate-skills-prompt.md
```

Đưa file này + toàn bộ thư mục `claude/guidelines/` cho AI (Codex/Claude) để generate.

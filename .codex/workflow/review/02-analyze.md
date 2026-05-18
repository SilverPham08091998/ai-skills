# Review Step 02 — Analysis

## Mục đích

Phân tích code theo các tiêu chí đã xác định ở Step 00, áp dụng đầy đủ skills về code quality, design patterns, và clean architecture.

Không được đưa ra finding nếu không có evidence cụ thể (file + line).

## Skills áp dụng bắt buộc

### Clean Architecture
- `@skills/clean-architecture-layers` — kiểm tra layer boundaries, dependency rule
- `@skills/clean-architecture-domain` — domain không import framework
- `@skills/clean-architecture-application` — use case chỉ orchestrate, không chứa infra detail
- `@skills/clean-architecture-infrastructure` — adapter không chứa business logic
- `@skills/clean-architecture-controller` — controller chỉ validate + delegate
- `@skills/clean-architecture-mapper` — mapper không chứa logic
- `@skills/clean-architecture-common` — shared rules áp dụng toàn bộ layers

### Code Quality
- `@skills/engineering-clean-code` — naming, single responsibility, no magic values
- `@skills/engineering-coding-principles` — SOLID, DRY, YAGNI, KISS
- `@skills/engineering-naming-convention` — naming nhất quán với codebase

### Design Patterns
- `@skills/engineering-design-patterns` — pattern đúng chỗ, không over-engineer
- `@skills/architecture-patterns` — macro-level architecture patterns

### Code Review Specific
- `@skills/code-review-backend` — backend-specific review checklist
- `@skills/code-review-performance` — N+1, blocking, memory, caching issues
- `@skills/code-review-production-readiness` — logging, error handling, observability
- `@skills/code-review-pr-checklist` — PR-level completeness check

## Quy trình phân tích

### 1. Clean Architecture Analysis

Kiểm tra từng file theo layer:

```text
Layer Boundary Check:
- Controller: chỉ validate + delegate? [pass/fail + evidence]
- Use Case: chỉ orchestrate? Không có infra detail? [pass/fail + evidence]
- Domain: framework-free? [pass/fail + evidence]
- Infrastructure: không chứa business logic? [pass/fail + evidence]
- Mapper: không chứa logic? [pass/fail + evidence]

Dependency Rule:
- Inner layer không import outer layer? [pass/fail + evidence]
- DTO tách biệt khỏi domain? [pass/fail + evidence]
```

### 2. Code Quality Analysis

```text
Naming:
- Class/method/variable names tự giải thích? [pass/fail + evidence]
- Naming nhất quán với codebase? [pass/fail + evidence]

Single Responsibility:
- Mỗi class/method chỉ làm 1 việc? [pass/fail + evidence]

Code Smells:
- Magic numbers/strings? [pass/fail + evidence]
- Deep nesting thay vì early return? [pass/fail + evidence]
- Long methods / God class? [pass/fail + evidence]
- Duplicated logic? [pass/fail + evidence]
- Dead code? [pass/fail + evidence]
```

### 3. Design Pattern Analysis

```text
Pattern Usage:
- Pattern được dùng có giải quyết vấn đề thật? [pass/fail + evidence]
- Có pattern nào dùng sai mục đích? [pass/fail + evidence]
- Có abstraction không cần thiết (YAGNI)? [pass/fail + evidence]
- Có cơ hội dùng pattern phù hợp hơn? [suggestion + evidence]
```

### 4. Production Readiness Analysis

```text
Error Handling:
- Exception đúng chỗ, đúng loại? [pass/fail + evidence]
- Không expose stack trace ra API? [pass/fail + evidence]

Security:
- Không hardcode secret? [pass/fail + evidence]
- Input validation ở boundary? [pass/fail + evidence]
- Không log sensitive data? [pass/fail + evidence]

Observability:
- Logging đủ và đúng level? [pass/fail + evidence]
- Có metrics/tracing nếu cần? [pass/fail + evidence]

Performance:
- N+1 query? [pass/fail + evidence]
- Blocking call trong async context? [pass/fail + evidence]
- Missing cache cho data read nhiều? [pass/fail + evidence]
```

### 5. Test Quality Analysis

```text
Coverage:
- Happy path được test? [pass/fail]
- Error cases được test? [pass/fail]
- Edge cases được test? [pass/fail]

Test Quality:
- Test test behavior, không test implementation? [pass/fail + evidence]
- Mock đúng, không mock chính class đang test? [pass/fail + evidence]
- Naming convention: should_X_when_Y? [pass/fail + evidence]
```

## Severity Classification

Mỗi finding phải được phân loại:

| Severity | Định nghĩa |
|----------|-----------|
| `critical` | Bug tiềm ẩn, security vulnerability, vi phạm layer boundary nghiêm trọng |
| `major` | Vi phạm clean architecture, dirty code ảnh hưởng maintainability |
| `minor` | Naming không nhất quán, missing logging, code smell nhỏ |
| `suggestion` | Cải tiện optional, không ảnh hưởng correctness |

## Checklist trước khi qua Step 03

- [ ] Đã áp dụng Clean Architecture skills cho toàn bộ file
- [ ] Đã áp dụng Code Quality skills
- [ ] Đã áp dụng Design Pattern skills
- [ ] Đã kiểm tra Production Readiness
- [ ] Đã kiểm tra Test Quality
- [ ] Mỗi finding có evidence (file + line)
- [ ] Mỗi finding có severity
- [ ] Không có finding nào thiếu evidence

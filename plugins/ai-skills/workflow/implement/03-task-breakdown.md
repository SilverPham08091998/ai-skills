# Step 03 — Task Breakdown

## Mục đích

Sau khi đã có context, architecture, file scope, và Applied Skill Contract, Claude phải break work thành task list chi tiết trước khi code.

Không được bắt đầu coding nếu task list còn mơ hồ, thiếu thứ tự phụ thuộc, thiếu acceptance criteria, hoặc chưa map task với file/skill/test.

## Input bắt buộc từ Step 02

Task breakdown phải dựa trên:

- Context và alignment từ Step 00
- Architecture/API/data/event contract từ Step 01
- File scope từ Step 02
- Applied Skill Contract từ Step 02
- Per-file quality constraints từ Step 02

## Format task list bắt buộc

Mỗi task phải rõ ràng và có output kiểm chứng được:

| ID | Task | File(s) | Layer | Depends On | Applied Skills | Acceptance Criteria | Tests |
|----|------|---------|-------|------------|----------------|---------------------|-------|
| T1 | Define domain value object | `Money.java` | domain | none | java-core, clean-architecture-domain | immutable, BigDecimal, explicit rounding | unit test invalid amount |
| T2 | Add use case orchestration | `CreatePaymentUseCase.java` | application | T1 | clean-architecture-application, engineering-clean-code | orchestration only, no SDK details | unit test success/failure |

## Breakdown rules

- Break tasks small enough to review independently.
- Order tasks by dependency, preferably inside-out:

```text
Domain -> Application -> Infrastructure -> Presentation -> Tests -> Docs
```

- Every created/modified file from Step 02 must appear in at least one task.
- Every task must include acceptance criteria.
- Every task must map to Applied Skills or explain why no extra skill applies.
- Every risky behavior must have a test task or an explicit reason why it cannot be tested.
- Include config/migration/docs tasks when applicable.
- Separate test tasks from implementation tasks when the test needs different files.

## Required task categories

Use only categories that apply to the request:

- Domain/model tasks
- Application/use-case tasks
- Infrastructure/adapter tasks
- Presentation/API/screen tasks
- Mapper/DTO tasks
- Validation/error handling tasks
- Security/permission tasks
- Observability/logging/tracing tasks
- Database migration/data impact tasks
- Kafka/event/outbox/retry/DLQ tasks
- Unit/integration/API test tasks
- Documentation/version-guide tasks

## Prompt gap coverage

If Step 00 identified prompt gaps, each gap must be handled by one of:

```text
- Task added
- Explicit assumption recorded
- User confirmation required before coding
- Out of scope with reason
```

## Status tracking

After the user approves the TODO/file scope, Claude should proceed continuously through approved tasks without asking repeated yes/no questions.

During implementation, Claude should update task status as work progresses:

```text
[pending] T1 ...
[in_progress] T2 ...
[done] T3 ...
[blocked] T4 ... reason
```

Do not mark a task done until its acceptance criteria and relevant skill constraints are satisfied.

## Out-of-scope task handling

If a task requires a file that was not approved in Step 02/03, do not edit it. Stop and report:

```text
Cần sửa thêm file ngoài scope đã approve:
- File: `path/to/file`
- Việc cần làm: ...
- Vì sao cần sửa: ...
- Nếu thêm thay đổi này thì làm được gì: ...
- Hướng giải quyết: ...
- Rủi ro nếu không sửa: ...

Bạn có đồng ý thêm file này vào scope không?
```

Only continue after approval. Once approved, add the file/task to the task list and proceed without asking again for that approved item.

## Checklist trước khi qua Step 04

- [ ] Task list bao phủ toàn bộ file scope từ Step 02
- [ ] Task order rõ dependency
- [ ] Mỗi task có acceptance criteria
- [ ] Mỗi task có Applied Skills hoặc lý do không cần thêm skill
- [ ] Test tasks đã được xác định cho behavior/risk chính
- [ ] Prompt gaps từ Step 00 đã được xử lý
- [ ] Không còn task mơ hồ kiểu "implement logic" hoặc "update service" mà thiếu output cụ thể
- [ ] Approved task/file scope có thể chạy liền mạch mà không cần hỏi lại

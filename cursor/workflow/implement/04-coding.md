# Step 04 — Implementation (Coding)

## Nguyên tắc cốt lõi

### Clean Code
- Tên biến/method/class phải tự giải thích — không cần comment mô tả WHAT
- Chỉ comment khi WHY không hiển nhiên (workaround, constraint ẩn, invariant)
- Function chỉ làm 1 việc (Single Responsibility)
- Không thêm feature/abstraction không được yêu cầu (YAGNI)

### Error Handling
- Validate ở boundary (input từ user, external API) — không validate internal code
- Dùng custom exception có ý nghĩa, không dùng generic Exception
- Fail fast — throw sớm, không để lỗi lan sâu

### Security
- Không hardcode secret/credential
- Sanitize input từ user trước khi xử lý
- Không expose stack trace ra response API
- Không log sensitive data (password, token, PII)

## Quy trình implement

### 0. Bắt buộc áp dụng skill trước khi code

Trước khi sửa file đầu tiên, Cursor phải có Applied Skill Contract từ Step 02 và task breakdown từ Step 03.

Contract phải gồm:

- Các skill đã đọc
- Rule cụ thể được áp dụng từ từng skill
- Quality constraints cho từng file
- Pattern decision cho task này

Không được bắt đầu code nếu chỉ mới "đọc skill" nhưng chưa chuyển skill thành constraints cụ thể.

### 1. Implement theo thứ tự layer (Inside-Out)
```
Domain → Application → Infrastructure → Presentation
```
Bắt đầu từ domain logic (không dependency ngoài), ra ngoài dần.

### 2. Pattern decision bắt buộc

Trước khi thêm Factory, Strategy, Adapter, Facade, Decorator, Builder, hoặc abstraction mới, phải trả lời:

```text
Pattern decision:
- Problem:
- Chosen pattern:
- Why needed:
- Why simpler code is not enough:
- Skill source:
```

Nếu không cần pattern:

```text
Pattern decision: none
Reason: direct implementation is simpler and meets current requirements.
```

Không được dùng pattern chỉ để làm code "trông enterprise".

### 3. Dirty code blockers

Không được để các lỗi sau trong code mới:

- Class hoặc method tên mơ hồ như `Manager`, `Helper`, `Util`, `process`, `handle`, `doWork` nếu không có ý nghĩa domain rõ ràng
- Method dài, nhiều trách nhiệm, hoặc trộn high-level flow với low-level details
- Deep nesting thay vì guard clauses / early return
- Magic number/string trong business logic
- Business logic trong controller, repository, mapper, config, hoặc external adapter
- Domain import Spring, JPA, Kafka, HTTP client, hoặc framework ngoài
- DTO/entity/domain model bị trộn responsibility
- Generic `Exception` cho lỗi business có thể đặt tên rõ
- `TODO`, `FIXME`, `@SuppressWarnings` không có lý do và kế hoạch xử lý
- Pattern hoặc abstraction không giải quyết vấn đề thật

### 4. Mỗi file sau khi viết xong phải tự review:
- [ ] Logic đúng với yêu cầu
- [ ] Không có code smell (magic number, duplicated logic, long method)
- [ ] Exception được handle đúng chỗ
- [ ] Không có security vulnerability (SQL injection, XSS, command injection)
- [ ] Import chỉ từ đúng layer được phép
- [ ] Applied Skill Contract đã được áp dụng cho file này
- [ ] Không vi phạm dirty code blockers

Review phải ghi rõ theo format:

```text
Skill Compliance Review — <file>
- <skill-name>: <rule applied / pass-fail note>
- <skill-name>: <rule applied / pass-fail note>
- Pattern decision: <pattern or none + reason>
```

### 5. Approved scope execution

Khi user đã approve TODO/file scope từ Step 02/03:

- Cứ implement liền mạch trên các file đã approved.
- Không hỏi lại yes/no cho từng file hoặc từng task đã nằm trong scope.
- Chỉ dừng nếu gặp blocker thật, validation/test failure cần xử lý, hoặc cần sửa file ngoài scope.
- Cập nhật task status thay vì hỏi lại.

Nếu cần sửa file ngoài scope, dừng trước khi edit và report:

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

### 6. Không được làm
- ❌ Không thêm feature ngoài scope được yêu cầu
- ❌ Không refactor code xung quanh khi không được yêu cầu
- ❌ Không dùng `@SuppressWarnings` hay `// TODO` và bỏ đó
- ❌ Không commit trong workflow implement
- ❌ Không hỏi lại approval cho file/task đã nằm trong approved scope

## Checklist trước khi qua Step 05
- [ ] Tất cả file trong danh sách Step 02 đã được implement
- [ ] Tất cả task implementation từ Step 03 đã hoàn thành hoặc được report nếu blocked/out of scope
- [ ] Applied Skill Contract đã được áp dụng
- [ ] Mỗi file đã có Skill Compliance Review
- [ ] Pattern decision đã rõ ràng cho abstraction/pattern mới hoặc đã ghi `none`
- [ ] Không có dirty code blockers
- [ ] Code compile/parse không lỗi
- [ ] Không có hardcoded value nên là config
- [ ] Không có security issue rõ ràng
- [ ] Code đã được self-review theo checklist trên

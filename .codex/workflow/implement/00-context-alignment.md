# Step 00 — Context Discovery & Solution Alignment

## Mục đích

Trước khi vẽ architecture hoặc implement, Codex phải lấy đủ context từ project/rules/user request và xác nhận lại cách hiểu với user.

Không được nhảy thẳng vào Step 01 nếu chưa hiểu hiện trạng, chưa rõ mục tiêu, hoặc đang dựa trên giả định rủi ro.

## Nguyên tắc cốt lõi

```text
Research context
  -> Restate understanding
  -> Identify prompt gaps
  -> Propose solution direction
  -> Align with user
  -> Only then move to architecture
```

## 1. Research context trước

Codex phải đọc đủ context liên quan trong target project trước khi đề xuất architecture:

- Existing source flow liên quan đến yêu cầu
- Current module/package structure
- Existing API/DB/Kafka/cache/security patterns
- Existing naming, exception, logging, validation, testing conventions
- Existing skill/rule context trong ai-skills
- Similar feature/module đã có để reuse pattern

Ưu tiên search có phạm vi:

```bash
rg -n "<domain>|<feature>|<api>|<event>|<entity>|<keyword>"
```

Không scan toàn bộ repo nếu search theo module/keyword đã đủ.

## 2. Restate understanding

Trước Step 01, Codex phải giải thích lại:

```text
Mình hiểu yêu cầu là:
- ...

Context hiện tại trong project:
- ...

Flow/pattern hiện có:
- ...

Mục tiêu thay đổi:
- ...
```

Phần này phải dựa trên file/source/rule đã đọc, không chỉ dựa vào kiến thức chung.

## 3. Identify prompt gaps

Nếu prompt của user thiếu case quan trọng, Codex phải bổ sung vào phân tích trước khi architecture.

Các gap thường phải kiểm tra:

- Edge cases
- Failure cases
- Permission/security
- Validation
- Idempotency
- Concurrency/race conditions
- Transaction boundary
- Backward compatibility
- Data migration/data impact
- Kafka retry/DLQ/outbox nếu có event flow
- Observability/logging/tracing/metrics
- Rollback
- Test scope
- Mobile offline/retry/navigation impact nếu là mobile flow

Output mẫu:

```text
Prompt còn thiếu các case cần xác nhận:
- ...

Mình đề xuất xử lý thêm:
- ...
```

## 4. Solution alignment

Codex phải nêu hướng giải quyết dự kiến và kiểm tra xem có khớp với ý user không:

```text
Hướng giải quyết dự kiến:
- ...

Assumptions:
- ...

Trade-offs:
- ...

Nếu hướng này đúng, mình sẽ chuyển sang Step 01 Architecture.
```

Nếu user đã approve rõ cùng scope và hướng xử lý trong cùng lượt, có thể đi tiếp. Nếu chưa rõ, phải hỏi.

## 5. Missing context report

Nếu không đủ context để vẽ architecture hoặc implement an toàn, phải dừng và report ngay:

```text
Mình chưa đủ context để vẽ architecture/implement:
- Thiếu: ...
- Vì sao quan trọng: ...
- Cần bạn xác nhận/cung cấp: ...
```

Không được lấp khoảng trống bằng giả định âm thầm.

## 6. Checklist trước khi qua Step 01

- [ ] Đã research source/rule context liên quan
- [ ] Đã tóm tắt lại yêu cầu theo cách hiểu của Codex
- [ ] Đã tóm tắt hiện trạng project/flow/pattern liên quan
- [ ] Đã nêu prompt gaps hoặc xác nhận không có gap đáng kể
- [ ] Đã nêu hướng giải quyết dự kiến
- [ ] Assumptions/trade-offs đã rõ
- [ ] Missing context đã được report nếu có
- [ ] User đã align với hướng giải quyết hoặc prompt đã đủ rõ để đi tiếp

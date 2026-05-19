# Fix-Bug Step 02 — Root Cause Analysis

## Mục đích

Tìm nguyên nhân gốc rễ của bug — không được fix symptom mà bỏ qua root cause thật sự.

## Nguyên tắc

- Fix đúng chỗ, không fix vòng quanh
- Root cause phải rõ ràng trước khi viết 1 dòng fix
- Nếu có nhiều nguyên nhân có thể → liệt kê và loại trừ từng cái

## Quy trình

### 1. Trace code path từ điểm reproduce

Bắt đầu từ entry point (API endpoint, event handler, screen action) và trace xuống:

```text
Entry point → Layer 1 → Layer 2 → ... → Điểm lỗi
```

Đọc code theo luồng thực tế, không đoán.

### 2. Xác định loại bug

| Loại | Dấu hiệu |
|------|----------|
| Logic error | Sai điều kiện, sai tính toán, sai flow |
| Null / undefined | NPE, missing null check |
| Race condition | Lỗi không consistent, liên quan timing |
| Data integrity | Dữ liệu sai, missing migration, constraint violation |
| Integration error | External service, API contract mismatch |
| Config / env | Sai config, missing env var |
| Concurrency | Deadlock, lost update, dirty read |

### 3. Confirm root cause

Sau khi trace, phải giải thích được:

```text
Root cause:
- File: `path/to/file.java` line X
- Vấn đề: ...
- Tại sao gây ra bug: ...
- Tại sao chỉ xảy ra trong điều kiện X: ...
```

Nếu không giải thích được tại sao → chưa tìm đúng root cause.

### 4. Loại trừ các nguyên nhân khác

Nếu có nhiều hypothesis:

```text
Hypothesis 1: ... → Loại trừ vì ...
Hypothesis 2: ... → Loại trừ vì ...
Hypothesis 3: ... → Confirmed vì ...
```

## Checklist trước khi qua Step 03

- [ ] Đã trace code path từ entry point đến điểm lỗi
- [ ] Root cause đã được xác định với file + line cụ thể
- [ ] Có thể giải thích tại sao root cause gây ra bug
- [ ] Các hypothesis khác đã được loại trừ
- [ ] Root cause consistent với điều kiện reproduce ở Step 01

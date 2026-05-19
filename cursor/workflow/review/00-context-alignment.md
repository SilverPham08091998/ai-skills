# Review Step 00 — Context Alignment

## Mục đích

Trước khi review bất cứ thứ gì, Cursor và user phải align rõ về scope, mục tiêu, và loại review cần thực hiện.

Không được bắt đầu đọc code khi chưa biết review cái gì và tại sao.

## Nguyên tắc cốt lõi

```text
Xác định scope
  -> Xác định loại review
  -> Xác định tiêu chí đánh giá
  -> Align với user
  -> Chuyển sang Step 01
```

## 1. Xác định scope review

Cursor phải hỏi hoặc tự xác định:

- **Target:** PR / branch / file cụ thể / feature / module / toàn bộ service
- **Context:** Feature mới / refactor / bug fix / migration / release
- **Ticket/PR link** nếu có

```text
Scope review:
- Target: ...
- Context: ...
- PR/Ticket: ...
```

## 2. Xác định loại review

| Loại | Mô tả |
|------|-------|
| `full` | Toàn diện: clean code, architecture, security, performance, tests |
| `quick` | Chỉ check critical issues và blocking problems |
| `architecture` | Tập trung layer boundaries, dependency rule, design patterns |
| `security` | Tập trung auth, input validation, data exposure, secrets |
| `performance` | Tập trung N+1, blocking calls, memory, caching |
| `test-coverage` | Tập trung test quality, missing cases, coverage |

Nếu user không chỉ định → mặc định `full`.

## 3. Xác định tiêu chí

Dựa vào loại review, xác định skills sẽ áp dụng ở Step 02:

```text
Review criteria:
- Loại: full / quick / architecture / ...
- Skills sẽ áp dụng: ...
- Không áp dụng: ... (lý do)
```

## 4. Align với user

```text
Mình sẽ review:
- Target: ...
- Loại: ...
- Tiêu chí: ...

Nếu đúng, mình sẽ chuyển sang Step 01 thu thập code.
```

## Checklist trước khi qua Step 01

- [ ] Đã xác định rõ target review
- [ ] Đã xác định loại review
- [ ] Đã xác định skills sẽ áp dụng
- [ ] User đã align với scope và tiêu chí

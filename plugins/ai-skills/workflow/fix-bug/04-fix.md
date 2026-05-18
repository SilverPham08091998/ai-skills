# Fix-Bug Step 04 — Fix Implementation

## Mục đích

Implement fix đúng root cause, đúng scope — không refactor, không cleanup, không thêm feature.

## Nguyên tắc cốt lõi

- Fix **chỉ** root cause đã xác định ở Step 02
- Scope fix **không được vượt quá** danh sách file ở Step 03
- Không refactor code xung quanh khi không được yêu cầu
- Không thêm abstraction mới nếu không cần thiết cho fix

## Quy trình

### 1. Implement fix

Dựa trên root cause từ Step 02 và scope từ Step 03, implement fix:

- Fix tại đúng file + line đã xác định
- Minimal change — chỉ sửa đủ để fix bug
- Không sửa style, formatting, naming ngoài vùng fix

### 2. Dirty code blockers (vẫn áp dụng cho fix)

Dù là fix bug, vẫn không được để lại:

- Magic number / string trong business logic
- Generic `Exception` thay vì exception có tên rõ
- Null check tạm bợ che giấu root cause thật
- TODO / FIXME không có kế hoạch xử lý
- Security vulnerability mới

### 3. Self-review sau khi fix

Sau khi viết xong fix, tự review:

```text
Fix Review — <file>
- Root cause addressed: yes/no
- Minimal change: yes/no
- No side effects: yes/no
- No new code smell: yes/no
- Fix matches Step 02 root cause: yes/no
```

### 4. Out-of-scope blocker

Nếu fix cần chạm vào file ngoài scope Step 03, phải dừng và report:

```text
Cần sửa thêm file ngoài scope đã approve:
- File: `path/to/file`
- Việc cần làm: ...
- Vì sao cần sửa: ...
- Rủi ro nếu không sửa: ...

Bạn có đồng ý thêm file này vào scope không?
```

## Checklist trước khi qua Step 05

- [ ] Fix đúng root cause đã xác định ở Step 02
- [ ] Chỉ thay đổi file trong scope Step 03
- [ ] Không có refactor / cleanup ngoài fix
- [ ] Không có dirty code mới
- [ ] Self-review đã pass
- [ ] Code compile / parse không lỗi

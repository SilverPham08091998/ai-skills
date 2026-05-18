# Fix-Bug Step 01 — Reproduce

## Mục đích

Xác nhận bug có thể reproduce được trước khi tìm root cause. Không fix bug khi chưa reproduce được.

## Nguyên tắc

- Reproduce trước, fix sau — không được đoán root cause từ mô tả
- Nếu không reproduce được → report ngay, không tiếp tục
- Reproduce phải rõ điều kiện: input, state, sequence

## Quy trình

### 1. Xác định điều kiện reproduce

Từ context ở Step 00, liệt kê rõ:

```text
Điều kiện reproduce:
- Môi trường: ...
- Input / data: ...
- Sequence of actions: ...
- Pre-conditions (state cần có trước): ...
```

### 2. Tìm code path liên quan

Search code liên quan đến bug trước khi chạy:

```bash
rg -n "<keyword>|<api>|<function>|<error-message>"
```

Xác định file, function, layer nào có khả năng liên quan.

### 3. Reproduce

Thực hiện reproduce theo điều kiện đã xác định:

- Chạy test case nếu có
- Gọi API với input trigger bug
- Trace log để confirm bug xảy ra

### 4. Kết quả reproduce

#### Nếu reproduce được

```text
✅ Reproduce thành công
- Điều kiện: ...
- Output thực tế: ...
- Log / stacktrace: ...
→ Chuyển sang Step 02 Root Cause
```

#### Nếu không reproduce được

```text
❌ Không reproduce được
- Đã thử: ...
- Kết quả: ...
- Có thể do: ...
→ Cần thêm thông tin từ user trước khi tiếp tục
```

Không được tiếp tục Step 02 nếu chưa reproduce được.

## Checklist trước khi qua Step 02

- [ ] Đã xác định rõ điều kiện reproduce
- [ ] Đã search code path liên quan
- [ ] Bug đã reproduce được với output/log rõ ràng
- [ ] Điều kiện reproduce đã được ghi lại để dùng cho Step 05 Verify

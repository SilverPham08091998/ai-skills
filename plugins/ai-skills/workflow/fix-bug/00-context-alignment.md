# Fix-Bug Step 00 — Context Alignment

## Mục đích

Trước khi reproduce hoặc fix bất cứ điều gì, Claude và user phải align đầy đủ về bug: điều kiện, môi trường, impact, và kỳ vọng.

Không được nhảy thẳng vào code khi chưa hiểu rõ bug là gì.

## Nguyên tắc cốt lõi

```text
Thu thập thông tin
  -> Restate lại hiểu biết về bug
  -> Xác định missing context
  -> Align với user trước khi reproduce
```

## 1. Thu thập thông tin bug

Claude phải hỏi hoặc tự tìm đủ các thông tin sau:

### Mô tả bug
- Bug xảy ra ở đâu? (module, feature, API endpoint, screen)
- Expected behavior là gì?
- Actual behavior là gì?
- Điều kiện trigger? (input, state, sequence of actions)

### Môi trường
- Môi trường xảy ra: `dev` / `uat` / `stg` / `prod`
- Xảy ra lần đầu khi nào?
- Tần suất: luôn luôn / thỉnh thoảng / chỉ 1 lần
- Có thể reproduce on demand không?

### Evidence
- Log / stacktrace / error message có không?
- Screenshot / recording có không?
- Request/response payload có không?
- Ticket / issue link có không?

### Impact
- Bao nhiêu user bị ảnh hưởng?
- Có workaround tạm không?
- Severity: blocker / critical / major / minor

## 2. Restate lại hiểu biết

Trước khi reproduce, Claude phải tóm tắt lại:

```text
Mình hiểu bug là:
- Xảy ra tại: ...
- Điều kiện trigger: ...
- Expected: ...
- Actual: ...
- Môi trường: ...
- Evidence: ...
- Impact: ...
```

Phần này phải dựa trên thông tin user cung cấp hoặc đã tìm được, không được đoán.

## 3. Identify missing context

Nếu thiếu thông tin quan trọng để reproduce hoặc root cause:

```text
Mình cần thêm thông tin để tiếp tục:
- Thiếu: ...
- Vì sao cần: ...
- Bạn có thể cung cấp: ...
```

Không được assume và tiến tiếp khi thiếu context quan trọng.

## 4. Align trước khi reproduce

Claude phải xác nhận với user trước khi qua Step 01:

```text
Mình sẽ tiến hành theo hướng:
- Reproduce bằng cách: ...
- Tìm root cause tại: ...
- Scope fix dự kiến: ...

Nếu đúng, mình sẽ chuyển sang Step 01 Reproduce.
```

## Checklist trước khi qua Step 01

- [ ] Đã thu thập đủ thông tin mô tả bug
- [ ] Đã xác định môi trường và điều kiện trigger
- [ ] Có ít nhất 1 evidence (log / stacktrace / mô tả rõ)
- [ ] Đã restate lại bug theo cách hiểu của Claude
- [ ] Missing context đã được report nếu có
- [ ] User đã align với hướng tiếp cận

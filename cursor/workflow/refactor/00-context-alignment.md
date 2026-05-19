# Refactor Step 00 — Context Alignment

## Mục đích

Trước khi phân tích hoặc thay đổi bất cứ điều gì, Cursor và user phải align rõ về target refactor, lý do, sub-type, và scope.

Không được nhảy thẳng vào analysis khi chưa hiểu rõ tại sao refactor và cái gì cần thay đổi.

## Nguyên tắc cốt lõi

```text
Thu thập thông tin
  -> Xác định sub-type refactor
  -> Restate lại hiểu biết
  -> Xác định scope và constraints
  -> Align với user trước khi analysis
```

## 1. Xác định sub-type refactor

Cursor phải xác định sub-type từ yêu cầu user:

| Sub-type | Mô tả | Dấu hiệu nhận biết |
|----------|-------|-------------------|
| `code` | Cải thiện chất lượng code trong cùng structure | "clean up", "remove smell", "quá dài", "magic number", "naming" |
| `restructure` | Di chuyển code đúng layer theo Clean Architecture | "sai layer", "domain import Spring", "business logic trong controller", "clean arch" |
| `both` | Vừa code vừa structure | Cả hai dấu hiệu trên, hoặc user nói rõ |

Nếu không rõ, hỏi user:

```text
Bạn muốn refactor theo hướng nào?
- code: cải thiện chất lượng code (naming, smell, pattern) — không di chuyển file
- restructure: tổ chức lại theo Clean Architecture — có thể di chuyển file giữa các layer
- both: cả hai
```

## 2. Thu thập thông tin

### Target
- Module / feature / file / package cụ thể nào?
- Là backend (Java/Spring), mobile (React Native), hay service khác?

### Lý do refactor
- Tại sao cần refactor bây giờ? (tech debt, onboarding, release prep, violation được phát hiện)
- Có ticket/issue link không?

### Constraints
- Có được thay đổi public API / interface không?
- Có migration data cần thực hiện kèm không?
- Có deadline hay freeze branch không?
- Đang ở branch nào? (không được refactor trực tiếp trên protected branch)

### Current state
- Test hiện tại có đang pass không?
- Coverage hiện tại khoảng bao nhiêu?

## 3. Restate lại hiểu biết

```text
Mình hiểu yêu cầu là:
- Sub-type: code / restructure / both
- Target: ...
- Lý do: ...
- Scope: ...
- Constraints: ...
- Branch hiện tại: ...
```

## 4. Missing context report

Nếu thiếu thông tin quan trọng:

```text
Mình cần thêm thông tin để tiếp tục:
- Thiếu: ...
- Vì sao cần: ...
- Bạn có thể cung cấp: ...
```

Không được assume và tiến tiếp khi thiếu context quan trọng.

## 5. Align trước khi analysis

```text
Mình sẽ tiến hành:
- Sub-type: ...
- Target: ...
- Skills sẽ áp dụng: ...
- Scope dự kiến: ...

Nếu đúng, mình sẽ chuyển sang Step 01 Behavior Baseline.
```

## Checklist trước khi qua Step 01

- [ ] Đã xác định sub-type: code / restructure / both
- [ ] Đã xác định target rõ ràng (module/file/package)
- [ ] Đã xác định lý do và constraints
- [ ] Đã kiểm tra branch — không phải protected branch
- [ ] Đã restate lại theo cách hiểu của Claude
- [ ] Missing context đã được report nếu có
- [ ] User đã align với scope và sub-type

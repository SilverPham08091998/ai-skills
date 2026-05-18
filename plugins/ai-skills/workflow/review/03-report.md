# Review Step 03 — Report

## Mục đích

Tổng hợp toàn bộ findings từ Step 02 thành report rõ ràng, có thứ tự ưu tiên, dễ action.

Report chỉ mô tả vấn đề — không sửa file. Fix suggestions nằm ở Step 04 (optional).

## Format report bắt buộc

```markdown
# Code Review Report
**Target:** <file / PR / branch>
**Date:** YYYY-MM-DD
**Review type:** full / quick / architecture / ...
**Reviewer:** Claude

---

## Summary

| Severity | Count |
|----------|-------|
| 🔴 Critical | X |
| 🟠 Major | X |
| 🟡 Minor | X |
| 💡 Suggestion | X |
| **Total** | **X** |

**Overall assessment:** Pass / Pass with conditions / Needs rework

---

## Findings

### 🔴 Critical

#### [C1] <Tiêu đề ngắn>
- **File:** `path/to/file.java:line`
- **Vấn đề:** Mô tả cụ thể vấn đề là gì
- **Tại sao critical:** Giải thích impact
- **Skill vi phạm:** `engineering-clean-code` / `clean-architecture-layers` / ...

---

### 🟠 Major

#### [M1] <Tiêu đề ngắn>
- **File:** `path/to/file.java:line`
- **Vấn đề:** ...
- **Tại sao major:** ...
- **Skill vi phạm:** ...

---

### 🟡 Minor

#### [m1] <Tiêu đề ngắn>
- **File:** `path/to/file.java:line`
- **Vấn đề:** ...

---

### 💡 Suggestions

#### [S1] <Tiêu đề ngắn>
- **File:** `path/to/file.java:line`
- **Đề xuất:** ...
- **Lợi ích:** ...

---

## Checklist kết quả

- [ ] Security: pass / fail
- [ ] Clean Architecture: pass / fail
- [ ] Code Quality: pass / fail
- [ ] Design Patterns: pass / fail
- [ ] Production Readiness: pass / fail
- [ ] Test Quality: pass / fail
```

## Quy tắc viết report

- Mỗi finding phải có **file + line** cụ thể — không được viết chung chung
- Không đưa ra finding không có evidence từ Step 02
- Sắp xếp theo severity: Critical → Major → Minor → Suggestion
- Đánh ID cho từng finding (C1, M1, m1, S1...) để dễ reference khi fix
- Overall assessment phải rõ ràng: **Pass** (có thể merge) / **Pass with conditions** (fix minor trước) / **Needs rework** (có critical/major)

## Escalation sau report

Sau khi user đọc report:

- Nếu user muốn **xem fix suggestions** → chuyển sang Step 04
- Nếu user muốn **tự fix** → dừng ở đây, route sang `fix-bug` hoặc `implement` khi cần
- Nếu user muốn **discuss finding** → route sang `ask` workflow

## Checklist hoàn thành Step 03

- [ ] Report có đầy đủ summary table
- [ ] Mọi finding có ID, file, line, vấn đề, lý do
- [ ] Findings sắp xếp đúng thứ tự severity
- [ ] Overall assessment rõ ràng
- [ ] Checklist kết quả đã điền
- [ ] Không có finding nào thiếu evidence

# AI Skills — Global Workflow Rules

## 1. Workflow Router (Phân loại intent trước)

Trước khi làm bất cứ điều gì, phân loại intent của user. Không được nhảy thẳng vào implement.

@workflow/router.md

---

## 2. Ask Workflow

Nếu intent là `ask` — dừng ở đây, không tạo TODO, không sửa file.

@workflow/ask.md

---

## 3. Planning Gate (Chỉ áp dụng cho implement intent)

**CRITICAL: Trước khi viết, edit, hoặc tạo bất kỳ code/file nào, PHẢI:**

1. Present **TODO list** theo format:
   ```
   ## TODO
   - [ ] Step 1 — mô tả ngắn
   - [ ] Step 2 — mô tả ngắn
   - [ ] Step 3 — mô tả ngắn
   ```

2. **STOP và chờ** user confirm trước khi proceed.

3. Chỉ bắt đầu implement sau khi user confirm (e.g., "ok", "làm đi", "proceed", "go ahead", "done", "yes").

4. Nếu user hỏi hoặc explore (không yêu cầu code), respond bình thường, không cần TODO.

**Rule này áp dụng cho:**
- Viết file mới
- Edit file đã có
- Chạy script thay đổi file
- Bất kỳ implementation task nào

**Rule này KHÔNG áp dụng cho:**
- Read-only operations (đọc file, search, giải thích code)
- Simple one-liner fix đã được approve inline
- Task mà user đã nói "just do it" hoặc tương tự từ đầu
- Files đã có trong approved TODO list — proceed trực tiếp, không hỏi lại

---

## 4. TODO Approval Gate

Sau khi present TODO list và user confirm (ok / yes / confirm / go ahead / proceed / làm đi):

1. Chạy ngay lệnh này qua Bash trước khi edit bất kỳ file nào:
   ```bash
   touch ~/.claude/todo-approved
   ```
2. Sau đó mới bắt đầu implement.

Approval có hiệu lực trong 2 giờ. Nếu hook block với lý do "hết hạn", present TODO lại và chờ user confirm rồi touch lại file.

Sau khi implement xong toàn bộ TODO list:
1. Chạy lệnh này để reset approval:
   ```bash
   rm ~/.claude/todo-approved
   ```
2. Lần implement tiếp theo bắt buộc phải present TODO mới + chờ user confirm lại.

---

## 5. Out-of-Scope File Changes

Nếu cần sửa file **KHÔNG có** trong TODO list đã approve:

**PHẢI dừng và hỏi user TRƯỚC**, theo format:
```
Cần sửa thêm file ngoài scope đã liệt kê:
- File: `path/to/file.ts`
- Làm gì: mô tả thay đổi cụ thể
- Tại sao: lý do kỹ thuật bắt buộc phải sửa file này
Bạn có đồng ý không?
```

Chỉ proceed sau khi user approve rõ ràng.

---

## 6. Implementation Steps (Implement Workflow)

Thực hiện tuần tự các bước sau:

@workflow/implement/00-context-alignment.md
@workflow/implement/01-architecture.md
@workflow/implement/02-structure-check.md
@workflow/implement/03-task-breakdown.md
@workflow/implement/04-coding.md
@workflow/implement/05-unit-tests.md
@workflow/implement/06-coverage.md
@workflow/implement/07-version-guide.md
@workflow/implement/08-pre-commit.md

---

## 6b. Fix-Bug Steps (Fix-Bug Workflow)

Nếu intent là `fix-bug`, thực hiện tuần tự các bước sau:

@workflow/fix-bug/00-context-alignment.md
@workflow/fix-bug/01-reproduce.md
@workflow/fix-bug/02-root-cause.md
@workflow/fix-bug/03-impact-analysis.md
@workflow/fix-bug/04-fix.md
@workflow/fix-bug/05-verify.md
@workflow/fix-bug/06-pre-commit.md

---

## 6c. Review Steps (Review Workflow)

Nếu intent là `review`, thực hiện tuần tự các bước sau:

@workflow/review/00-context-alignment.md
@workflow/review/01-collect.md
@workflow/review/02-analyze.md
@workflow/review/03-report.md
@workflow/review/04-fix-suggestions.md

---

## 6d. Refactor Steps (Refactor Workflow)

Nếu intent là `refactor` hoặc `restructure`, thực hiện tuần tự các bước sau:

@workflow/refactor/00-context-alignment.md
@workflow/refactor/01-behavior-baseline.md
@workflow/refactor/02-analysis.md
@workflow/refactor/03-refactor-plan.md
@workflow/refactor/04-coding.md
@workflow/refactor/05-verify.md
@workflow/refactor/06-pre-commit.md

---

## 7. Progress Tracking

Sau mỗi bước hoàn thành, **reprint lại toàn bộ Progress list** ngay bên dưới response — item đã xong gạch ngang + ✅, đang làm ⏳, chưa làm ○:

```
## Progress
- ~~Step 1 — mô tả~~ ✅
- ⏳ Step 2 — mô tả
- ○ Step 3 — mô tả
```

Không cần user scroll lên để xem trạng thái — luôn thấy ở cuối message mới nhất.

---

## 8. Ghi chú chung

- Mỗi bước phải hoàn thành trước khi qua bước tiếp theo
- Nếu bước nào fail (test, build, coverage) → dừng, báo lỗi, fix trước khi tiếp tục
- Version guide (bước 07) là bắt buộc, không được bỏ qua
- Pre-commit (bước 08) chỉ chạy khi user yêu cầu commit

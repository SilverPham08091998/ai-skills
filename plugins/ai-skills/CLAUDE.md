# AI Skills — Global Workflow Rules

## 1. Planning Gate (Bắt buộc trước khi implement)

Trước khi viết bất kỳ code nào, PHẢI:
1. Present **TODO list** với đầy đủ các bước
2. **Chờ user confirm** (ok / confirm / làm đi / yes / proceed)
3. Sau đó mới bắt đầu implement theo thứ tự workflow

## 2. Feature Implementation Workflow

Khi implement một chức năng, thực hiện tuần tự các bước sau:

@workflow/01-architecture.md
@workflow/02-structure-check.md
@workflow/03-coding.md
@workflow/04-unit-tests.md
@workflow/05-coverage.md
@workflow/06-version-guide.md

## 3. Ghi chú chung

- Mỗi bước phải hoàn thành trước khi qua bước tiếp theo
- Nếu bước nào fail (test, build, coverage) → dừng, báo lỗi, fix trước khi tiếp tục
- Version guide (bước 6) là bắt buộc, không được bỏ qua

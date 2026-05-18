# Fix-Bug Step 06 — Pre-Commit Verification

## Mục đích

Trước khi commit fix, verify lại test/build, kiểm tra branch an toàn, và chuẩn bị commit message đúng format bug fix.

Step này chỉ áp dụng khi user yêu cầu commit. Nếu chưa yêu cầu, không tự commit.

## 1. Run tests one more time

Chạy lại toàn bộ test liên quan trước khi commit:

```text
Pre-commit verification:
- Test command: ...
- Build command: ...
- Result: PASS / FAIL
- New bug test: PASS
- Regression: clean
```

Không commit nếu có test fail.

## 2. Protected branch rule

Không commit hoặc push trực tiếp trên:

```text
dev / uat / stg / main / master
dev/** / uat/** / stg/** / main/** / master/**
```

Kiểm tra branch hiện tại trước:

```bash
git branch --show-current
```

Nếu đang ở protected branch → checkout sang branch fix trước.

## 3. Branch naming rule

```text
bug/<env>/<short-name>
```

Ví dụ:

```text
bug/dev/fix-null-user-binding
bug/uat/fix-payment-amount-calc
bug/dev/fix-login-race-condition
```

Nếu thiếu env hoặc short-name, hỏi user trước khi tạo branch.

## 4. Commit message format

```text
[ENV][BUG][TICKET] summary
```

Ví dụ:

```text
[DEV][BUG][VSP-1234] fix null pointer in user binding flow
[UAT][BUG][VSP-5678] fix payment amount rounding error
```

## 5. Commit body

```markdown
Root Cause:
- File: `path/to/file` line X
- Cause: ...

Fix:
- ...

Verify:
- Reproduce condition: PASS
- New test: PASS
- Regression: clean

File Changes:
| File | Action | Lý do |
|------|--------|-------|
| ... | MODIFY | ... |

Tickets:
- VSP-XXXX
```

## Checklist hoàn thành Step 06

- [ ] User explicitly requested commit
- [ ] Current branch checked — không ở protected branch
- [ ] Branch theo format `bug/<env>/<short-name>`
- [ ] Test/build pass lần cuối
- [ ] Commit subject theo format `[ENV][BUG][TICKET]`
- [ ] Commit body có root cause, fix, verify, file changes, ticket
- [ ] Không push lên protected branch

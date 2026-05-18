# Refactor Step 06 — Pre-Commit

## Mục đích

Trước khi commit, verify lần cuối và chuẩn bị commit message đúng format cho refactor/restructure.

Step này chỉ áp dụng khi user yêu cầu commit. Không tự commit.

## 1. Run tests one more time

```text
Pre-commit verification:
- Test command: ...
- Build command: ...
- Coverage: ...%
- Result: PASS / FAIL
```

Không commit nếu test fail hoặc coverage < 90%, trừ khi user explicitly override.

## 2. Protected branch rule

Không commit hoặc push trực tiếp trên:
```
dev / uat / stg / main / master
dev/** / uat/** / stg/** / main/** / master/**
```

```bash
git branch --show-current
```

Nếu đang ở protected branch → checkout sang branch làm việc trước.

## 3. Branch naming rule

```text
refactor/<env>/<short-name>
chore/<env>/<short-name>
```

Ví dụ:
```text
refactor/dev/clean-user-domain
refactor/dev/restructure-order-service
chore/dev/apply-clean-architecture-payment
```

Nếu thiếu env hoặc short-name → hỏi user trước khi tạo branch.

## 4. Commit message format

```text
[ENV][REFACTOR][TICKET] summary
[ENV][RESTRUCTURE][TICKET] summary
```

Ví dụ:
```text
[DEV][REFACTOR][VSP-1234] clean up user domain and remove smells
[DEV][RESTRUCTURE][VSP-1234] apply clean architecture to order service
[DEV][REFACTOR][VSP-1234] restructure payment module to clean architecture layers
```

Rules:
- `ENV` uppercase: `DEV`, `UAT`, `STG`
- `TYPE`: `REFACTOR` cho code-level, `RESTRUCTURE` cho structural, `REFACTOR` cho cả hai
- Summary phải nói rõ scope, không chỉ "refactor code"

Nếu thiếu ticket → hỏi user trước commit.

## 5. Commit body

```markdown
Type: refactor / restructure / both

Sub-type changes:
- Code: [số lượng files, smells fixed]
- Structural: [số lượng files moved/split, violations fixed]

Behavior: UNCHANGED
- Test baseline: X tests passed (pre-refactor)
- Test post-refactor: X tests passed
- Coverage: Y% → Z%

Architecture constraints verified:
- [ ] Domain: no framework imports
- [ ] Application: no infrastructure direct imports
- [ ] Controller: no business logic
- [ ] Public interfaces: unchanged

File Changes:
| File | Action | Lý do |
|------|--------|-------|
| `old/path/File.java` | MOVE → `new/path/File.java` | Wrong layer |
| `File.java` | MODIFY | Extract method, remove smell |
| `NewFile.java` | CREATE | Split use case from service |
| `OldFile.java` | DELETE | Replaced by adapter + use case |

Tickets:
- VSP-1234
```

## 6. Reconcile với git status

```bash
git status --short
```

- Mọi file thay đổi phải xuất hiện trong commit body
- Mọi file MOVE/DELETE phải được ghi rõ
- Không có file ngoài scope lọt vào commit

## Checklist hoàn thành Step 06

- [ ] User explicitly requested commit
- [ ] Branch checked — không phải protected branch
- [ ] Branch name đúng format refactor/<env>/<name>
- [ ] Test/build/coverage chạy lại — PASS
- [ ] Coverage ≥ 90%
- [ ] Commit subject đúng format [ENV][REFACTOR/RESTRUCTURE][TICKET]
- [ ] Commit body có: sub-type, behavior unchanged, coverage delta, architecture checklist, file changes
- [ ] git status reconciled — không có file lạ
- [ ] Không push lên protected branch

# Step 08 — Pre-Commit Verification

## Mục đích

Trước khi commit code, Cursor phải verify lại test/build/coverage, kiểm tra branch an toàn, và chuẩn bị commit message/body đúng format.

Step này chỉ áp dụng khi user yêu cầu commit. Nếu user chưa yêu cầu commit, không tự commit.

## 1. Run tests one more time

Trước commit phải chạy lại test/build/coverage phù hợp với project.

Use commands from Step 06 when available. If project tooling differs, use the closest project-native commands.

Required output:

```text
Pre-commit verification:
- Test command: ...
- Build command: ...
- Coverage command/report: ...
- Result: PASS/FAIL
- Unit test coverage: ...%
```

Không commit nếu test/build fail hoặc coverage requirement không đạt, trừ khi user explicitly override sau khi đã thấy report.

## 2. Protected branch rule

Không được commit hoặc push trực tiếp trên protected environment branches:

```text
dev
uat
stg
main
master
dev/**
uat/**
stg/**
main/**
master/**
```

Trước commit phải check current branch:

```bash
git branch --show-current
```

Nếu đang ở protected branch, phải checkout sang branch làm việc mới trước khi commit.

## 3. Branch naming rule

Branch mới phải theo format:

```text
feature/<env>/<short-name>
bug/<env>/<short-name>
<noun>/<env>/<short-name>
```

Examples:

```text
feature/dev/ai-workflow
bug/dev/ai-workflow
chore/dev/ai-workflow
docs/dev/ai-workflow
```

`<env>` thường là `dev`, `uat`, hoặc `stg` theo ticket/context.

Nếu thiếu env hoặc short-name, hỏi user trước khi tạo branch.

## 4. Commit message format

Commit subject format:

```text
[ENV][TYPE][TICKET] summary
```

Examples:

```text
[DEV][BUG][VSP-9876] fix bug AI-workflow
[DEV][FEATURE][VSP-9876] add AI-workflow routing
[UAT][CHORE][VSP-9876] update workflow rules
```

Rules:

- `ENV` uppercase: `DEV`, `UAT`, `STG`, etc.
- `TYPE` uppercase: `BUG`, `FEATURE`, `CHORE`, `DOCS`, `REFACTOR`, etc.
- `TICKET` must use the ticket id/link context provided by user.
- Summary must be concise and action-based.

If ticket id is missing, ask user before commit.

## 5. Commit body / description

Commit body must include:

```markdown
Coverage:
- Unit test coverage: > 90% / actual percentage
- Test command: ...
- Coverage report: ...

TODO Completed:
- [x] T1 ...
- [x] T2 ...

File Changes Report:
| File | Layer | Action | Applied Skills | Quality Constraints | Lý do |
|------|-------|--------|----------------|---------------------|-------|
| ...  | ...   | CREATE/MODIFY/DELETE/MOVE | ... | ... | ... |

Tickets:
- VSP-9876
- https://...
```

## 6. File Changes Report source

File Changes Report is the final version of the Step 02 file scope table.

Before commit, reconcile it with actual git changes:

```bash
git status --short
```

Requirements:

- Every changed file must appear in the final Step 02/File Changes Report table.
- Every report row must match the actual action: `CREATE`, `MODIFY`, `DELETE`, or `MOVE`.
- Approved out-of-scope files added during implementation must be included.
- Unexpected files must be reported before commit.

Do not invent a separate file report format. Reuse the Step 02 table columns:

```text
File | Layer | Action | Applied Skills | Quality Constraints | Lý do
```

## 7. Push safety

Do not push directly to protected branches or protected branch prefixes.

Push only the working branch created/confirmed for this change.

If push target is unclear, ask user before pushing.

## Checklist hoàn thành Step 08

- [ ] User explicitly requested commit
- [ ] Current branch checked
- [ ] Not committing on protected branch/prefix
- [ ] Working branch follows naming rule
- [ ] Tests/build/coverage run again before commit
- [ ] Unit test coverage is reported and satisfies requirement or user approved exception
- [ ] File Changes Report reconciled with `git status --short`
- [ ] Commit subject follows `[ENV][TYPE][TICKET] summary`
- [ ] Commit body includes coverage, TODO completed, File Changes Report, and ticket links
- [ ] No push to protected branch/prefix

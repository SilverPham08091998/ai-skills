# Refactor Step 05 — Verify

## Mục đích

Sau khi refactor xong, phải verify 3 điều:
1. Test vẫn pass (behavior unchanged)
2. Coverage vẫn ≥ 90%
3. Architecture constraints được thỏa mãn (không còn violation)

## 1. Chạy lại test và so sánh với baseline

Chạy lại toàn bộ test như Step 01, sau đó so sánh với baseline snapshot:

```text
Baseline (trước refactor):   X tests passed, coverage Y%
Sau refactor:                X tests passed, coverage Z%

Delta:
- Tests: [thêm / bớt / giữ nguyên]
- Coverage: [tăng / giảm / giữ nguyên]
```

### Kết quả chấp nhận được

| Trạng thái | Kết quả | Hành động |
|-----------|---------|-----------|
| Test pass, coverage ≥ 90% | ✅ | Tiếp tục |
| Test pass, coverage tăng | ✅ | Tiếp tục (refactor làm code testable hơn) |
| Test fail | ❌ | DỪNG — tìm regression |
| Coverage giảm | ❌ | DỪNG — tìm lý do |

### Nếu test fail sau refactor

```text
❌ Regression detected sau refactor

Failing tests:
- [test name]: [error message]

Phân tích:
- Test fail vì behavior bị thay đổi? → Refactor sai, phải revert thay đổi đó
- Test fail vì test depend vào implementation detail? → Update test, không phải revert refactor

Hành động:
- Nếu behavior bị thay đổi → revert + re-plan
- Nếu test quá brittle → update test để test behavior, không test implementation
```

## 2. Verify Architecture Constraints (sub-type: restructure / both)

Dùng `clean-architecture-layers` để verify sau restructure:

### Dependency Rule Check

```bash
# Tìm domain import framework
grep -rn "import org.springframework\|import javax.persistence\|import org.apache.kafka" src/main/java/<package>/domain/

# Tìm use case import infrastructure
grep -rn "import.*infrastructure\|import.*repository" src/main/java/<package>/application/

# Tìm controller chứa business logic
grep -rn "if.*&&\|businessRule\|validate.*Rule" src/main/java/<package>/presentation/
```

### Checklist Architecture

- [ ] Domain không import Spring/JPA/Kafka/HTTP
- [ ] Application layer không import infrastructure class trực tiếp (chỉ qua port interface)
- [ ] Controller chỉ chứa validation request + delegation, không có business logic
- [ ] Repository/Adapter không chứa business rule
- [ ] DTO và Domain entity đã tách hoàn toàn
- [ ] Mapper tồn tại ở đúng layer (infrastructure hoặc presentation)
- [ ] Không còn circular dependency

### Output mẫu

```text
Architecture Verification:
✅ Domain: 0 framework imports
✅ Application: 0 infrastructure direct imports
✅ Controller: no business logic detected
✅ Mapper: exists at correct layer
✅ No circular dependency
```

## 3. Verify Public Interfaces Unchanged

So sánh với baseline snapshot từ Step 01:

```text
Public Interface Verification:
- API endpoints: [list] → unchanged ✅ / changed ❌
- Public method signatures: unchanged ✅ / changed ❌
- Events published: unchanged ✅ / changed ❌
- DB schema: unchanged ✅ / changed ❌
```

Nếu có thay đổi public interface → dừng và báo user — đây có thể là breaking change.

## 4. Final Coverage Report

```text
Coverage Report — Post Refactor:
- Test command: ...
- Tests: X passed / Y total
- Coverage: Z% (baseline: W%)
- Delta: +/- X%

Status: ✅ PASS / ❌ FAIL
```

## Checklist trước khi qua Step 06

- [ ] Tất cả test vẫn PASS (0 new failures)
- [ ] Coverage ≥ 90% sau refactor
- [ ] Coverage không giảm so với baseline
- [ ] Architecture constraints đã được verify (nếu restructure)
- [ ] Public interfaces không thay đổi
- [ ] Không còn dirty code blockers
- [ ] Không có breaking change không được approve

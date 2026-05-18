# Refactor Step 01 — Behavior Baseline

## Mục đích

Trước khi thay đổi bất kỳ dòng code nào, phải đảm bảo behavior hiện tại đã được capture đầy đủ bởi test.

Refactor không thêm hoặc bớt behavior — nếu behavior chưa được test, không có cách nào biết refactor có phá vỡ gì không.

## Nguyên tắc cốt lõi

```text
Chạy test hiện tại
  -> Kiểm tra coverage
  -> Nếu không đủ → viết test trước
  -> Chỉ tiếp tục khi baseline đã vững
```

## 1. Chạy test hiện tại

Chạy toàn bộ test của module/service target:

### Java — Maven
```bash
mvn test -pl <module>
mvn jacoco:report -pl <module>
awk -F',' 'NR>1{ covered += $4; missed += $3 } END { printf "Coverage: %.1f%%\n", covered/(covered+missed)*100 }' target/site/jacoco/jacoco.csv
```

### Java — Gradle
```bash
./gradlew :<module>:test :<module>:jacocoTestReport
```

### TypeScript / React Native
```bash
yarn test --coverage --watchAll=false
```

### Go
```bash
go test ./... -coverprofile=coverage.out
go tool cover -func=coverage.out | grep total
```

## 2. Đánh giá kết quả baseline

### Nếu test PASS và coverage ≥ 90%

```text
✅ Behavior baseline đạt yêu cầu
- Test: X passed, 0 failed
- Coverage: Y% (≥ 90%)
→ Tiếp tục Step 02
```

### Nếu test FAIL

```text
❌ Test đang fail trước khi refactor
→ DỪNG — không được refactor khi test đang đỏ
→ Phải fix test fail trước, hoặc xác nhận với user đây là known failure
```

Không được tiếp tục refactor khi test đang fail — không thể phân biệt regression do refactor hay lỗi cũ.

### Nếu coverage < 90% — BLOCK

```text
❌ Coverage: X% — chưa đủ để refactor an toàn

Các behavior chưa được cover:
- [liệt kê class/method/case còn thiếu]

Bắt buộc phải viết thêm test trước khi refactor.
Lý do: refactor không thêm behavior mới — nếu behavior chưa có test,
không thể verify refactor không phá vỡ gì.

Bạn có muốn mình viết test bổ sung trước không?
```

Chỉ tiếp tục sau khi:
- User đồng ý viết test bổ sung → viết test → chạy lại Step 01
- Hoặc user explicitly accept rủi ro với lý do rõ ràng (ví dụ: legacy code không thể test được, sẽ refactor theo từng bước nhỏ)

## 3. Ghi lại baseline snapshot

Trước khi refactor, ghi lại trạng thái hiện tại:

```text
Behavior Baseline Snapshot:
- Test command: ...
- Tests: X passed / Y total
- Coverage: Z%
- Timestamp: YYYY-MM-DD HH:mm

Public interfaces / contracts đang tồn tại:
- API endpoints: ...
- Public method signatures: ...
- Events published: ...
- DB schema: ...
```

Snapshot này sẽ được dùng ở Step 05 để verify behavior unchanged.

## Checklist trước khi qua Step 02

- [ ] Test đang PASS (0 failures)
- [ ] Coverage ≥ 90% hoặc user đã explicitly accept rủi ro với lý do
- [ ] Baseline snapshot đã được ghi lại
- [ ] Public interfaces đã được liệt kê
- [ ] Không có known test skip che giấu failure thật

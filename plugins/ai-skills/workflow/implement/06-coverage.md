# Step 06 — Run Tests & Coverage Check

## Yêu cầu bắt buộc
- Tất cả test phải **PASS**
- Coverage của code mới phải **≥ 90%**
- Nếu không đạt → **DỪNG**, phân tích thiếu case nào, viết thêm test, chạy lại

## Lệnh chạy theo language

### Java — Maven + JaCoCo
```bash
mvn test
mvn jacoco:report
# Report: target/site/jacoco/index.html
# Check coverage CLI:
awk -F',' '{ covered += $4; missed += $3 } END { printf "Coverage: %.1f%%\n", covered/(covered+missed)*100 }' target/site/jacoco/jacoco.csv
```

### Java — Gradle + JaCoCo
```bash
./gradlew test jacocoTestReport
# Report: build/reports/jacoco/test/html/index.html
./gradlew jacocoTestCoverageVerification
```

### TypeScript / JavaScript — Jest
```bash
npm test -- --coverage --coverageThreshold='{"global":{"lines":90}}'
# Hoặc config trong jest.config.js:
# coverageThreshold: { global: { lines: 90, branches: 90 } }
```

### React Native — Jest
```bash
yarn test --coverage --watchAll=false
```

### Go
```bash
go test ./... -coverprofile=coverage.out
go tool cover -func=coverage.out | grep total
# Phải ≥ 90%
```

### Rust
```bash
cargo tarpaulin --out Stdout --fail-under 90
```

### Kotlin — JUnit 5 + Kover
```bash
./gradlew koverReport
./gradlew koverVerify
```

## Đọc kết quả và xử lý

### Nếu PASS ≥ 90%
```
✅ All tests passed
✅ Coverage: 93.5% (≥ 90% required)
→ Tiếp tục Step 07
```

### Nếu FAIL hoặc Coverage < 90%
```
❌ Coverage: 78% — chưa đạt yêu cầu
→ Phân tích các dòng chưa được cover:
   - UserService.java line 45-52: edge case khi list rỗng
   - UserMapper.java line 23: null handling
→ Viết thêm test cases cho các case trên
→ Chạy lại từ đầu Step 06
```

## Checklist trước khi qua Step 07
- [ ] Tất cả test PASS (0 failures, 0 errors)
- [ ] Coverage ≥ 90% cho code mới
- [ ] Không có test bị skip/disabled để đạt coverage
- [ ] Build thành công sau khi test pass

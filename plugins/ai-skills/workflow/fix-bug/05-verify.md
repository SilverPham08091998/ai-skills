# Fix-Bug Step 05 — Verify & Regression Check

## Mục đích

Xác nhận bug đã được fix và không có regression sau khi apply fix.

## Quy trình

### 1. Verify fix với điều kiện reproduce từ Step 01

Chạy lại đúng điều kiện đã reproduce được bug ở Step 01:

```text
Verify:
- Điều kiện reproduce (từ Step 01): ...
- Kết quả trước fix: <bug output>
- Kết quả sau fix: <expected output>
- Kết quả: ✅ Fixed / ❌ Chưa fix
```

Nếu bug vẫn còn → quay lại Step 02 Root Cause.

### 2. Viết test case cho bug này

Bắt buộc viết ít nhất 1 test case reproduce được bug:

```java
@Test
void should_<expected>_when_<bug_condition>() {
    // Arrange — điều kiện trigger bug
    // Act
    // Assert — confirm expected behavior sau fix
}
```

Test này phải:
- FAIL trước khi apply fix
- PASS sau khi apply fix

### 3. Chạy test suite liên quan

Chạy test của module / feature bị ảnh hưởng:

```bash
# Java
mvn test -pl <module>

# TypeScript / React Native
yarn test --testPathPattern=<feature>

# Go
go test ./...
```

Tất cả test phải PASS.

### 4. Regression check

Kiểm tra các feature đã nhận diện ở Step 03 có bị ảnh hưởng không:

```text
Regression check:
- Feature A: ✅ Không bị ảnh hưởng
- Feature B: ✅ Test pass
- Feature C: ⚠️ Cần kiểm tra thêm → ...
```

### 5. Kết quả verify

```text
✅ Bug fixed — verify thành công
- Reproduce condition: pass
- New test: pass
- Regression: không phát hiện vấn đề
→ Chuyển sang Step 06 Pre-commit

HOẶC

❌ Verify failed
- Vấn đề: ...
→ Quay lại Step 02 / Step 04
```

## Checklist trước khi qua Step 06

- [ ] Bug đã được verify fix với điều kiện reproduce từ Step 01
- [ ] Đã viết test case mới reproduce được bug
- [ ] Test case mới PASS sau fix
- [ ] Toàn bộ test suite liên quan PASS
- [ ] Regression check đã được thực hiện
- [ ] Không có regression mới phát hiện (hoặc đã xử lý)

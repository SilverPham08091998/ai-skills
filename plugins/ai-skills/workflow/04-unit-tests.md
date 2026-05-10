# Step 04 — Unit Tests

## Nguyên tắc

- Test **behavior**, không test implementation detail
- Mỗi test case chỉ test **1 điều** — tên test phải nói rõ điều đó
- Test phải **độc lập** — không phụ thuộc thứ tự chạy, không share state
- **Mock** tất cả external dependency (DB, API, file system, time)
- Không test framework/library — chỉ test logic của mình

## Cấu trúc test (AAA Pattern)

```java
@Test
void should_returnUser_when_validIdProvided() {
    // Arrange — chuẩn bị data, mock
    var userId = UserId.of("123");
    when(userRepository.findById(userId)).thenReturn(Optional.of(mockUser));

    // Act — thực thi hành động cần test
    var result = getUserUseCase.execute(userId);

    // Assert — kiểm tra kết quả
    assertThat(result.getId()).isEqualTo("123");
    assertThat(result.getName()).isEqualTo("John");
}
```

## Naming convention cho test

```
should_<expected>_when_<condition>()
```

Ví dụ:
- `should_throwNotFoundException_when_userNotFound()`
- `should_returnEmptyList_when_noUsersExist()`
- `should_saveUser_when_validDataProvided()`

## Các case bắt buộc phải cover

### Happy Path
- [ ] Input hợp lệ → output đúng
- [ ] Edge cases (empty list, zero, null optional)

### Error Cases
- [ ] Input không hợp lệ → đúng exception
- [ ] External service fail → đúng exception/fallback
- [ ] Không tìm thấy resource → NotFoundException

### Boundary Cases
- [ ] Giá trị min/max
- [ ] String rỗng vs null
- [ ] List rỗng vs null

## Framework theo language

| Language | Test Framework | Mock | Assert |
|----------|---------------|------|--------|
| Java | JUnit 5 | Mockito | AssertJ |
| Kotlin | JUnit 5 / Kotest | MockK | AssertJ |
| TypeScript | Jest | Jest mock | Jest expect |
| Go | testing + testify | gomock | testify/assert |
| Rust | built-in `#[test]` | mockall | assert! |

## Checklist trước khi qua Step 05
- [ ] Tất cả public method của class mới đều có test
- [ ] Happy path đã được cover
- [ ] Error cases đã được cover
- [ ] Tất cả test đều pass (không có skip/ignore)
- [ ] Không có test phụ thuộc nhau
- [ ] Mock đúng — không mock chính class đang test

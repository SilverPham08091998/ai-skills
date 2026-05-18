# Refactor Step 02 — Analysis

## Mục đích

Đọc code target và phân tích các vấn đề cần refactor dựa trên sub-type đã xác định ở Step 00.

Không phán đoán từ tên file — phải đọc code thực tế trước khi kết luận.

## Skills bắt buộc phải đọc

Trước khi phân tích, Claude phải load và áp dụng các skills sau:

### Code sub-type
- `engineering-clean-code`
- `engineering-design-patterns`
- `engineering-naming-convention`

### Restructure sub-type
- `clean-architecture-layers`
- `clean-architecture-domain`
- `clean-architecture-application`
- `clean-architecture-infrastructure`
- `clean-architecture-controller`
- `clean-architecture-mapper`
- `clean-architecture-common`

### Both → load tất cả skills trên

## 1. Phân tích Code (sub-type: code / both)

Dùng `engineering-clean-code` và `engineering-design-patterns` để phát hiện:

### Code Smells
| Smell | Mô tả | Vị trí |
|-------|-------|--------|
| Long Method | Method > 20 dòng, nhiều trách nhiệm | `ClassA.java:45` |
| Magic Number/String | Literal không có tên rõ nghĩa | `ServiceB.java:78` |
| Deep Nesting | if/for lồng > 3 cấp | `UseCaseC.java:120` |
| Duplicated Logic | Đoạn code giống nhau ở nhiều nơi | `RepoA.java`, `RepoB.java` |
| Vague Naming | Tên `Manager`, `Helper`, `Util`, `process`, `handle` không rõ domain | `DataManager.java` |
| God Class | Class quá nhiều trách nhiệm | `UserService.java` |
| Feature Envy | Method dùng data của class khác nhiều hơn class mình | `OrderService.java:55` |
| Primitive Obsession | Dùng String/int thay vì Value Object | `PaymentService.java` |

### Pattern Violations
| Violation | Mô tả | Vị trí |
|-----------|-------|--------|
| Pattern không cần thiết | Factory/Strategy/Builder dùng cho 1 case cứng | `...` |
| Missing pattern | Nhiều if-else cho behavior variation — nên dùng Strategy | `...` |

## 2. Phân tích Structure (sub-type: restructure / both)

Dùng `clean-architecture-layers` và các clean-arch skills để phát hiện:

### Architecture Violations
| Violation | Rule vi phạm | Vị trí |
|-----------|-------------|--------|
| Domain import framework | Domain không được import Spring/JPA/Kafka/HTTP | `domain/User.java` |
| Business logic trong Controller | Controller chỉ được validate + delegate | `UserController.java:89` |
| Business logic trong Repository | Repository chỉ là persistence adapter | `UserRepository.java:34` |
| Use case import infrastructure | Application layer không được phụ thuộc infrastructure | `CreateOrderUseCase.java` |
| DTO/Entity trộn lẫn | Domain entity bị expose ra ngoài / DTO chứa logic | `UserDTO.java` |
| Missing mapper | Convert trực tiếp domain ↔ DTO không qua mapper | `UserController.java:56` |
| Circular dependency | Layer A → Layer B → Layer A | `...` |

### File Structure Violations
| File hiện tại | Vấn đề | Nên đặt ở |
|--------------|--------|-----------|
| `service/UserService.java` | Chứa cả business logic + DB call | Split: `application/` + `infrastructure/` |
| `controller/OrderController.java` | Chứa validation business rule | Move rule → `application/` |

## 3. Applied Skill Contract

Sau khi đọc skills, trích rule cụ thể sẽ enforce trong refactor này:

```text
Applied skills:
- [danh sách skill đã đọc]

Rules enforced:
- [rule cụ thể 1]
- [rule cụ thể 2]
- ...

Rules không áp dụng lần này:
- [rule X]: [lý do — ví dụ: không có event flow, không có mobile layer]
```

## 4. Tổng hợp findings

```text
## Analysis Report

### Code Issues (N findings)
1. [Smell] — [File:Line] — [Mô tả ngắn]
2. ...

### Structure Issues (N findings)
1. [Violation] — [File] — [Rule vi phạm]
2. ...

### Priority
- Critical (phải fix): ...
- Major (nên fix): ...
- Minor (có thể bỏ qua lần này): ...
```

## Checklist trước khi qua Step 03

- [ ] Đã đọc tất cả skills theo sub-type
- [ ] Đã lập Applied Skill Contract với rule cụ thể
- [ ] Đã đọc code thực tế, không phán đoán từ tên file
- [ ] Đã liệt kê tất cả code smells với vị trí cụ thể (nếu sub-type là code/both)
- [ ] Đã liệt kê tất cả architecture violations với vị trí cụ thể (nếu sub-type là restructure/both)
- [ ] Đã phân loại priority: critical / major / minor
- [ ] Analysis report đã được share với user

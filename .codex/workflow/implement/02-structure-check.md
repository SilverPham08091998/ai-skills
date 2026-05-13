# Step 02 — Source Structure Check

## Mục đích
Trước khi viết code, kiểm tra xem các file sẽ tạo có đúng với quy định cấu trúc dự án không.

## Quy trình kiểm tra

### 1. Đọc cấu trúc hiện tại của project
Scan toàn bộ cấu trúc thư mục để hiểu conventions đang dùng:
```
src/
├── main/java/com/example/
│   ├── domain/          ← entities, value objects
│   ├── application/     ← use cases, ports
│   ├── infrastructure/  ← adapters, repositories
│   └── presentation/    ← controllers, DTOs
```

### 2. Lập danh sách file sẽ tạo/sửa
Liệt kê rõ ràng từng file theo format, bao gồm skill và quality constraints sẽ áp dụng:

| File | Layer | Action | Applied Skills | Quality Constraints | Lý do |
|------|-------|--------|----------------|---------------------|-------|
| `UserController.java` | presentation | CREATE | springboot-rest-api, clean-architecture-controller | thin adapter, validation + delegation only, no business logic | REST endpoint mới |
| `CreateUserUseCase.java` | application | CREATE | clean-architecture-application, engineering-clean-code | orchestration only, short single-purpose methods, no framework leakage | Business flow |
| `UserRepository.java` | infrastructure | MODIFY | clean-architecture-infrastructure, infrastructure-datasource | persistence adapter only, no business rules, explicit query behavior | Thêm query method |

### 2.1 Applied Skill Contract

Trước khi qua Step 03, Codex phải trích rule cụ thể từ các skill đã đọc thành contract áp dụng cho task này.

Contract không được chỉ liệt kê tên skill. Phải nêu rõ rule cụ thể sẽ được enforce.

Ví dụ:

```text
Applied skills:
- engineering-clean-code
- engineering-design-patterns
- java-core
- springboot-rest-api
- clean-architecture-application

Rules applied:
- Controller is validation + delegation only.
- Application use case orchestrates flow and does not contain provider SDK details.
- Domain remains framework-free.
- Methods stay single-purpose and avoid deep nesting.
- No Manager/Helper/Util names unless matching an existing project convention.
- No magic numbers or magic strings in business logic.
- Use BigDecimal for money.
- Pattern decision must be explicit: Adapter/Strategy/Factory/etc. only when solving a real variation or integration problem.
```

Nếu một design pattern không cần thiết, phải ghi rõ:

```text
Pattern decision: none
Reason: direct implementation is simpler and no behavior/creation variation exists.
```

### 3. Kiểm tra từng file theo checklist

#### Backend (Java/Spring Boot)
- [ ] Package name đúng layer (`domain`, `application`, `infrastructure`, `presentation`)
- [ ] Class name đúng convention (`UseCase`, `Repository`, `Controller`, `Service`, `Port`)
- [ ] File nằm đúng thư mục theo Clean Architecture
- [ ] Không vi phạm dependency rule (inner layer không import outer layer)
- [ ] DTO tách biệt khỏi domain entity

#### Mobile (React Native)
- [ ] Feature module đặt trong `src/features/<feature-name>/`
- [ ] Cấu trúc: `components/`, `screens/`, `hooks/`, `store/`, `services/`
- [ ] Không import trực tiếp từ feature khác (phải qua index)
- [ ] Type definitions trong `types.ts` riêng

#### Chung
- [ ] Naming convention nhất quán với codebase hiện tại
- [ ] Không tạo file trùng chức năng với file đã có
- [ ] Test file đặt cùng vị trí hoặc trong `test/` mirror cấu trúc src
- [ ] Mỗi file có Applied Skills và Quality Constraints cụ thể
- [ ] Applied Skill Contract đã map skill rules thành constraints thực thi được
- [ ] Pattern decision đã được nêu rõ nếu task có creation/behavior/integration variation

### 4. Báo cáo kết quả trước khi code
Trình bày rõ:
```
✅ Cấu trúc hợp lệ — sẵn sàng implement
HOẶC
⚠️  Cần điều chỉnh:
  - File X nên đặt ở Y thay vì Z
  - Rename A → B để đúng convention
```

## Checklist trước khi qua Step 03
- [ ] Đã scan và hiểu cấu trúc project hiện tại
- [ ] Đã list toàn bộ file sẽ tạo/sửa
- [ ] Đã lập Applied Skill Contract từ các skill đã đọc
- [ ] File scope có Applied Skills và Quality Constraints
- [ ] Tất cả file đều đúng layer và naming convention
- [ ] Không có circular dependency trong plan
- [ ] User đã xem và approve danh sách file

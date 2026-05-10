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
Liệt kê rõ ràng từng file theo format:

| File | Layer | Action | Lý do |
|------|-------|--------|-------|
| `UserController.java` | presentation | CREATE | REST endpoint mới |
| `CreateUserUseCase.java` | application | CREATE | Business logic |
| `UserRepository.java` | infrastructure | MODIFY | Thêm query method |

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
- [ ] Tất cả file đều đúng layer và naming convention
- [ ] Không có circular dependency trong plan
- [ ] User đã xem và approve danh sách file

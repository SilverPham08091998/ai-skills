# Refactor Step 03 — Refactor Plan

## Mục đích

Dựa trên findings từ Step 02, lập kế hoạch thay đổi chi tiết trước khi động vào code.

Refactor plan phải tách rõ 2 loại thay đổi và đảm bảo không có behavior mới được thêm vào.

## Nguyên tắc cốt lõi

```text
Findings từ Step 02
  -> Tách code changes vs structural changes
  -> Xác định thứ tự an toàn
  -> Xác nhận scope với user
  -> Chỉ implement sau khi plan được approve
```

## 1. Code Changes (sub-type: code / both)

Liệt kê thay đổi code-level:

| ID | File | Vấn đề | Thay đổi | Behavior thay đổi? |
|----|------|--------|----------|--------------------|
| C1 | `UserService.java:45` | Long method | Extract → `validateUser()` + `buildResponse()` | Không |
| C2 | `OrderService.java:78` | Magic number `30` | Extract → `MAX_PENDING_DAYS = 30` | Không |
| C3 | `PaymentService.java` | Primitive obsession `String accountId` | Extract Value Object `AccountId` | Không |

**Cột "Behavior thay đổi?" phải là "Không" cho mọi dòng.**

Nếu một thay đổi làm thay đổi behavior → đó không phải refactor, phải tách ra thành separate task implement.

## 2. Structural Changes (sub-type: restructure / both)

Liệt kê thay đổi structure/file:

| ID | File hiện tại | Vấn đề | Hành động | Đích đến |
|----|--------------|--------|-----------|----------|
| S1 | `service/UserService.java` | Business logic + DB call | Split | `application/CreateUserUseCase.java` + `infrastructure/UserRepositoryAdapter.java` |
| S2 | `controller/OrderController.java:89` | Business validation rule | Extract + Move | `application/ValidateOrderUseCase.java` |
| S3 | `domain/User.java` | Import `@Entity` (JPA) | Remove JPA annotation → pure domain | `domain/User.java` (sửa tại chỗ) |

### File Move Map

```text
Trước refactor:
src/
├── service/
│   └── UserService.java       ← chứa cả business + DB
└── controller/
    └── UserController.java    ← chứa validation

Sau refactor:
src/
├── application/
│   ├── usecase/
│   │   └── CreateUserUseCase.java   ← business only
│   └── port/
│       └── UserPort.java            ← interface
├── infrastructure/
│   └── persistence/
│       └── UserRepositoryAdapter.java  ← DB only
└── presentation/
    └── UserController.java          ← delegate only
```

## 3. Thứ tự thực hiện

Thứ tự an toàn cho structural changes: inside-out

```text
1. Domain changes (remove framework imports, extract Value Objects)
2. Application layer (extract use cases, define ports)
3. Infrastructure layer (create adapters implementing ports)
4. Presentation layer (update controllers to delegate)
5. Code-level changes (naming, extract method, remove smells)
6. Delete/move files cũ
```

Không được move file trước khi layer mới đã sẵn sàng — tránh broken compile state.

## 4. Scope confirmation

Trước khi code, Codex phải xác nhận scope với user:

```text
Mình sẽ thực hiện các thay đổi sau:

Code changes (X items):
- C1: ...
- C2: ...

Structural changes (Y items):
- S1: ...
- S2: ...

Thứ tự: Domain → Application → Infrastructure → Presentation → Code cleanup

Không thay đổi:
- Public API endpoints (method + path giữ nguyên)
- Request/Response schema
- DB schema
- Event contracts

Nếu bạn đồng ý, mình sẽ chuyển sang Step 04.
```

## 5. Out-of-scope handling

Nếu trong quá trình lập plan phát hiện cần thêm thay đổi ngoài analysis:

```text
Phát hiện thêm vấn đề ngoài scope analysis:
- File: ...
- Vấn đề: ...
- Nếu không sửa: ...
- Đề xuất: thêm vào plan / để lại ticket riêng

Bạn có muốn thêm vào scope lần này không?
```

## Checklist trước khi qua Step 04

- [ ] Tất cả findings từ Step 02 đã được map vào plan
- [ ] Code changes và structural changes đã tách rõ
- [ ] File move map đã vẽ (nếu có structural changes)
- [ ] Tất cả thay đổi đều xác nhận "Behavior thay đổi? Không"
- [ ] Thứ tự thực hiện đã được xác định
- [ ] Scope đã được confirm với user
- [ ] Public interfaces không bị thay đổi đã được ghi nhận rõ

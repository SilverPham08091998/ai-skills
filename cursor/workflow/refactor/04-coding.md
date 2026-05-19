# Refactor Step 04 — Coding

## Nguyên tắc cốt lõi

### Refactor chỉ thay đổi structure/readability — không thêm behavior

Mỗi thay đổi phải trả lời được câu hỏi:
> "Nếu xóa thay đổi này, test vẫn pass với cùng kết quả không?"
> Nếu không → đó là behavior change, không phải refactor.

### Thứ tự bắt buộc: Inside-Out

```text
Domain → Application → Infrastructure → Presentation → Code cleanup
```

Không được bắt đầu từ ngoài vào — outer layer phụ thuộc inner layer, inner layer phải sẵn sàng trước.

## 1. Áp dụng Applied Skill Contract từ Step 02

Trước khi sửa file đầu tiên, Cursor phải có Applied Skill Contract từ Step 02 và refactor plan từ Step 03.

Contract phải gồm:
- Skills đã đọc
- Rule cụ thể được áp dụng
- Danh sách thay đổi đã approve

Không được bắt đầu code nếu chỉ mới "đọc skill" nhưng chưa chuyển thành constraints cụ thể.

## 2. Thực hiện Code Changes

### Extract Method
```java
// Trước
public void processOrder(Order order) {
    if (order.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
        throw new InvalidOrderException("Amount must be positive");
    }
    if (order.getItems().isEmpty()) {
        throw new InvalidOrderException("Order must have items");
    }
    // ... 30 dòng logic nữa
}

// Sau
public void processOrder(Order order) {
    validateOrder(order);
    // ... logic còn lại
}

private void validateOrder(Order order) {
    if (order.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
        throw new InvalidOrderException("Amount must be positive");
    }
    if (order.getItems().isEmpty()) {
        throw new InvalidOrderException("Order must have items");
    }
}
```

### Extract Value Object
```java
// Trước
public class Payment {
    private String accountId;  // primitive obsession
}

// Sau
public class Payment {
    private AccountId accountId;  // value object
}

public final class AccountId {
    private final String value;
    public AccountId(String value) {
        if (value == null || value.isBlank()) throw new InvalidAccountIdException();
        this.value = value;
    }
}
```

### Remove Magic Number
```java
// Trước
if (pendingDays > 30) { expire(); }

// Sau
private static final int MAX_PENDING_DAYS = 30;
if (pendingDays > MAX_PENDING_DAYS) { expire(); }
```

## 3. Thực hiện Structural Changes

### Bước 1 — Domain: Gỡ framework dependency

```java
// Trước (domain import JPA)
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class User {
    @Id
    private Long id;
}

// Sau (pure domain)
public class User {
    private UserId id;
}
```

### Bước 2 — Application: Extract use case

```java
// Trước (business logic trong Service)
@Service
public class UserService {
    public User createUser(String name, String email) {
        if (userRepository.existsByEmail(email)) {
            throw new DuplicateEmailException();
        }
        User user = new User(name, email);
        return userRepository.save(user);
    }
}

// Sau (use case orchestration only)
public class CreateUserUseCase {
    private final UserPort userPort;  // interface, không phải impl

    public User execute(CreateUserCommand command) {
        if (userPort.existsByEmail(command.email())) {
            throw new DuplicateEmailException();
        }
        return userPort.save(new User(command.name(), command.email()));
    }
}
```

### Bước 3 — Infrastructure: Create adapter

```java
// Adapter implement port
@Repository
public class UserRepositoryAdapter implements UserPort {
    private final JpaUserRepository jpa;

    @Override
    public boolean existsByEmail(String email) {
        return jpa.existsByEmail(email);
    }

    @Override
    public User save(User user) {
        return userMapper.toDomain(jpa.save(userMapper.toEntity(user)));
    }
}
```

### Bước 4 — Presentation: Thin controller

```java
// Sau (delegate only)
@RestController
public class UserController {
    private final CreateUserUseCase createUserUseCase;

    @PostMapping("/users")
    public ResponseEntity<UserResponse> create(@Valid @RequestBody CreateUserRequest request) {
        User user = createUserUseCase.execute(new CreateUserCommand(request.name(), request.email()));
        return ResponseEntity.ok(userMapper.toResponse(user));
    }
}
```

## 4. Dirty Code Blockers — Không được để lại sau refactor

- Business logic còn trong Controller, Repository, Mapper, Config
- Domain vẫn import Spring/JPA/Kafka/HTTP sau restructure
- Method mới extract vẫn dài và nhiều trách nhiệm
- Magic number/string còn tồn tại sau khi đã có trong plan
- DTO/Entity/Domain model vẫn bị trộn lẫn
- Circular dependency sau khi di chuyển layer

## 5. Self-review sau mỗi file

```text
Skill Compliance Review — <file>
- <skill-name>: <rule applied / pass-fail>
- Pattern decision: <pattern or none + reason>
- Behavior changed: No / [mô tả nếu có — dừng ngay]
```

## 6. Approved scope execution

Khi đã có plan từ Step 03:
- Implement liên tục trên các thay đổi đã approve
- Không hỏi lại yes/no cho từng file trong plan
- Chỉ dừng nếu phát hiện cần thay đổi ngoài scope đã approve

Nếu cần thay đổi ngoài scope:

```text
Cần thay đổi thêm ngoài scope đã approve:
- File: ...
- Vấn đề phát hiện: ...
- Nếu không sửa: ...
- Đề xuất: ...

Bạn có đồng ý thêm vào scope không?
```

## Checklist trước khi qua Step 05

- [ ] Applied Skill Contract đã được áp dụng cho tất cả thay đổi
- [ ] Thứ tự inside-out đã được tuân thủ
- [ ] Tất cả code changes trong plan đã hoàn thành
- [ ] Tất cả structural changes trong plan đã hoàn thành
- [ ] Mỗi file đã có Skill Compliance Review
- [ ] Không còn dirty code blockers
- [ ] Behavior changed = No cho tất cả thay đổi
- [ ] Code compile không lỗi
- [ ] Không có thay đổi ngoài scope chưa được approve

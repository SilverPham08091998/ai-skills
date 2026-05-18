# Review Step 04 — Fix Suggestions (Optional)

## Mục đích

Đề xuất fix cụ thể cho từng finding trong report — step này chỉ chạy khi user yêu cầu.

Step này **không sửa file** — chỉ cung cấp hướng dẫn fix để user hoặc Claude thực hiện sau.

## Khi nào chạy Step 04

Chỉ chạy khi user explicitly yêu cầu sau khi xem report ở Step 03:
- "Fix giúp tôi"
- "Đề xuất cách fix"
- "Sửa finding C1"

Nếu user không yêu cầu → dừng ở Step 03.

## Format fix suggestion bắt buộc

Mỗi finding từ report cần có:

```markdown
### Fix [C1] — <Tiêu đề finding>

**Skill áp dụng:** `clean-architecture-layers`, `engineering-clean-code`

**Vấn đề:**
<Trích lại code hiện tại có vấn đề>

```java
// ❌ Current — vấn đề ở đây
public class UserController {
    @Autowired
    private UserRepository userRepository; // vi phạm: controller import infrastructure
}
```

**Fix đề xuất:**

```java
// ✅ Fixed
public class UserController {
    private final CreateUserUseCase createUserUseCase; // chỉ depend vào use case

    public UserController(CreateUserUseCase createUserUseCase) {
        this.createUserUseCase = createUserUseCase;
    }
}
```

**Giải thích:** Controller chỉ được depend vào application layer (use case), không được import infrastructure trực tiếp — theo `clean-architecture-layers`.

**Effort:** Low / Medium / High
**Risk:** Low / Medium / High
```

## Nhóm findings theo effort

Sau khi đề xuất hết, tóm tắt:

```markdown
## Fix Priority

### Quick wins (Low effort, High impact)
- [C1] ...
- [M2] ...

### Medium effort
- [M1] ...

### High effort / Consider later
- [S1] ...
```

## Escalation sau Step 04

Nếu user muốn **thực sự implement fix**:

- Bug fix → route sang `fix-bug` workflow
- Feature / refactor → route sang `implement` workflow
- Review workflow kết thúc tại Step 04

## Checklist hoàn thành Step 04

- [ ] Mọi critical và major finding có fix suggestion
- [ ] Mỗi suggestion có code example (before/after)
- [ ] Mỗi suggestion có skill reference
- [ ] Effort và risk đã được đánh giá
- [ ] Fix priority summary đã được tổng hợp
- [ ] Không tự ý sửa file trong step này

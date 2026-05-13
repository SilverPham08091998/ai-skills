# Step 03 — Implementation (Coding)

## Nguyên tắc cốt lõi

### Clean Code
- Tên biến/method/class phải tự giải thích — không cần comment mô tả WHAT
- Chỉ comment khi WHY không hiển nhiên (workaround, constraint ẩn, invariant)
- Function chỉ làm 1 việc (Single Responsibility)
- Không thêm feature/abstraction không được yêu cầu (YAGNI)

### Error Handling
- Validate ở boundary (input từ user, external API) — không validate internal code
- Dùng custom exception có ý nghĩa, không dùng generic Exception
- Fail fast — throw sớm, không để lỗi lan sâu

### Security
- Không hardcode secret/credential
- Sanitize input từ user trước khi xử lý
- Không expose stack trace ra response API
- Không log sensitive data (password, token, PII)

## Quy trình implement

### 1. Implement theo thứ tự layer (Inside-Out)
```
Domain → Application → Infrastructure → Presentation
```
Bắt đầu từ domain logic (không dependency ngoài), ra ngoài dần.

### 2. Mỗi file sau khi viết xong phải tự review:
- [ ] Logic đúng với yêu cầu
- [ ] Không có code smell (magic number, duplicated logic, long method)
- [ ] Exception được handle đúng chỗ
- [ ] Không có security vulnerability (SQL injection, XSS, command injection)
- [ ] Import chỉ từ đúng layer được phép

### 3. Commit nhỏ, rõ nghĩa
Sau mỗi layer hoặc component hoàn chỉnh:
```
feat(user): add CreateUserUseCase with validation
feat(user): add UserRepository with findByEmail query
feat(user): add POST /users endpoint
```

### 4. Không được làm
- ❌ Không thêm feature ngoài scope được yêu cầu
- ❌ Không refactor code xung quanh khi không được yêu cầu
- ❌ Không dùng `@SuppressWarnings` hay `// TODO` và bỏ đó
- ❌ Không commit file config chứa secret

## Checklist trước khi qua Step 04
- [ ] Tất cả file trong danh sách Step 02 đã được implement
- [ ] Code compile/parse không lỗi
- [ ] Không có hardcoded value nên là config
- [ ] Không có security issue rõ ràng
- [ ] Code đã được self-review theo checklist trên

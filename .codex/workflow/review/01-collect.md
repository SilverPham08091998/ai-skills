# Review Step 01 — Collect & Read Code

## Mục đích

Thu thập đầy đủ code cần review và đọc context liên quan trước khi phân tích.

Không được analyze khi chưa đọc đủ code — findings từ đọc thiếu sẽ sai hoặc thiếu sót.

## Quy trình

### 1. Thu thập code target

Tùy theo scope từ Step 00:

**Nếu là PR / branch:**
```bash
git diff main...<branch> --name-only
git diff main...<branch>
```

**Nếu là file / module cụ thể:**
```bash
# Đọc file target
# Search các file liên quan
rg -n "<class>|<function>|<api>" --type java
```

**Nếu là feature / service:**
```bash
# List toàn bộ file trong module
ls -R src/<module>/
```

### 2. Đọc context liên quan

Không chỉ đọc file thay đổi — phải hiểu context xung quanh:

- Interface / contract mà code này implement
- Caller của các method / API đang review
- Test file liên quan
- Config, migration, schema liên quan (nếu có)
- Existing patterns trong cùng layer / module

### 3. Map file theo layer

Phân loại file thu thập được theo layer để chuẩn bị analyze:

| File | Layer | Loại thay đổi |
|------|-------|--------------|
| `UserController.java` | presentation | CREATE |
| `CreateUserUseCase.java` | application | MODIFY |
| `UserRepository.java` | infrastructure | MODIFY |

### 4. Ghi nhận missing context

Nếu thiếu file quan trọng để review đầy đủ:

```text
Missing context:
- File X không có trong diff nhưng liên quan vì ...
- Test file chưa được cung cấp
- Schema migration chưa thấy
```

## Checklist trước khi qua Step 02

- [ ] Đã thu thập toàn bộ file trong scope
- [ ] Đã đọc context caller / interface / contract
- [ ] Đã map file theo layer
- [ ] Missing context đã được ghi nhận
- [ ] Không có file quan trọng bị bỏ sót

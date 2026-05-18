# Fix-Bug Step 03 — Impact Analysis

## Mục đích

Trước khi fix, xác định rõ phạm vi ảnh hưởng của bug và của fix — để không bỏ sót case và không gây regression.

## Quy trình

### 1. Phạm vi ảnh hưởng của bug

Xác định những gì đang bị ảnh hưởng:

```text
Bug impact:
- Layers bị ảnh hưởng: ...
- Services / modules: ...
- API endpoints / screens: ...
- Data bị ảnh hưởng (nếu có): ...
- Users bị ảnh hưởng: tất cả / một số / điều kiện cụ thể
- Môi trường: dev / uat / prod
```

### 2. Phạm vi fix dự kiến

Xác định fix sẽ chạm vào đâu:

| File | Layer | Thay đổi dự kiến | Rủi ro |
|------|-------|-----------------|--------|
| `UserService.java` | application | Thêm null check | Thấp |
| `UserRepository.java` | infrastructure | Fix query | Trung bình |

### 3. Regression risk

Kiểm tra những gì có thể bị ảnh hưởng sau khi fix:

- Các feature dùng chung code path bị fix
- Các test hiện có có thể bị break
- Data migration cần thiết không
- API contract thay đổi không (breaking change)

```text
Regression risks:
- Feature X dùng chung method Y → cần verify
- Test Z có thể fail → cần update
- Không có data migration cần thiết
```

### 4. Fix scope decision

Xác nhận rõ scope fix — không được mở rộng:

```text
Fix scope:
- Chỉ sửa: ...
- Không sửa: ... (lý do: ngoài scope bug này)
- Known limitations sau fix: ...
```

## Checklist trước khi qua Step 04

- [ ] Đã xác định đầy đủ bug impact
- [ ] Đã lập danh sách file sẽ thay đổi
- [ ] Regression risks đã được nhận diện
- [ ] Fix scope đã rõ ràng và không mở rộng ngoài bug
- [ ] User đã align với scope fix

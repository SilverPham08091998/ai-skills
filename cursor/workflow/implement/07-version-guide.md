# Step 07 — Version Guide (Markdown Documentation)

## Mục đích
Ghi lại toàn bộ những gì đã làm trong lần implement này — để team có thể review, onboard, hoặc rollback khi cần.

## File output
Tạo file: `docs/version-guide/<YYYY-MM-DD>-<feature-name>.md`

Nếu không có thư mục `docs/`, tạo ở root project.

## Template bắt buộc

```markdown
# [Feature Name] — Version Guide
**Date:** YYYY-MM-DD
**Author:** Cursor + <user>
**Version:** vX.Y.Z / branch name / pending commit

---

## 1. Tổng quan
> Mô tả ngắn gọn chức năng đã implement và lý do.

## 2. Architecture
> Copy diagram từ Step 01 vào đây (nếu có)

### Component Diagram
\`\`\`mermaid
...
\`\`\`

### Sequence Diagram
\`\`\`mermaid
...
\`\`\`

### API Contract (nếu có)
| Method | Endpoint | Request | Response |
|--------|----------|---------|----------|
| POST | /api/v1/feature | {...} | {...} |

## 3. Files Changed

### Created
| File | Layer | Mô tả |
|------|-------|-------|
| `src/.../FeatureUseCase.java` | application | Use case chính |

### Modified
| File | Thay đổi |
|------|---------|
| `src/.../UserRepository.java` | Thêm method `findByEmail` |

## 4. Các quyết định kỹ thuật
> Ghi lại những lựa chọn quan trọng và lý do.

- **Tại sao dùng X thay Y:** ...
- **Trade-off đã chấp nhận:** ...
- **Known limitations:** ...

## 5. Test Coverage
| Class/Module | Coverage |
|---|---|
| FeatureUseCase | 95% |
| FeatureRepository | 92% |
| **Overall** | **93.5%** |

## 6. Hướng dẫn deploy
\`\`\`bash
# Các bước cần thực hiện khi deploy
mvn clean package -DskipTests
# Migration DB (nếu có):
flyway migrate
\`\`\`

## 7. Rollback plan
> Hướng dẫn rollback nếu có vấn đề.
- Revert changed files or revert the future commit/PR that contains this change
- Rollback DB migration (nếu có): `flyway undo`

## 8. Checklist deploy
- [ ] Unit tests pass
- [ ] Coverage ≥ 90%
- [ ] Code review approved
- [ ] DB migration script reviewed
- [ ] Environment variables updated
- [ ] Staging tested
```

## Checklist hoàn thành workflow
- [ ] Version guide đã được tạo với đầy đủ sections
- [ ] Diagrams từ Step 01 đã được copy vào
- [ ] Danh sách file changed đầy đủ và chính xác
- [ ] Coverage report đã được ghi vào
- [ ] Rollback plan đã được mô tả

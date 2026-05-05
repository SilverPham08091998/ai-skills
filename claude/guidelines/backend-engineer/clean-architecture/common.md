# .claude/guidelines/clean-architecture/common.md

# Clean Architecture Common Package Rules

---

# STEP 1 — OBJECTIVE

`common` package is a shared internal package containing reusable technical components used across layers.

Purpose:

* Reduce duplication
* Centralize constants
* Provide safe reusable utilities
* Standardize shared models
* Keep business modules clean

Rule:
`common package supports layers, but must not become a dumping ground.`

---

# STEP 2 — WHAT BELONGS IN common/

Allowed sub-packages:

```text
common/
 ├── constant/
 ├── util/
 ├── enums/
 ├── exception/
 ├── response/
 ├── config/ (light shared config)
 ├── validation/
 └── helper/
```

---

# STEP 3 — constant/

Use for application-wide constants.

Examples:

* Header names
* Error codes
* Regex patterns
* Date formats
* Role names
* Cache keys prefix

Example:

```java
public final class HeaderConstant {
    public static final String TRACE_ID = "X-Trace-Id";
}
```

---

# STEP 4 — util/

Use for stateless helper utilities.

Examples:

* JsonUtil
* DateTimeUtil
* MaskingUtil
* SignatureUtil
* AmountUtil

Rule:

* Pure functions preferred
* No business logic
* No hidden side effects

---

# STEP 5 — exception/

Shared base exceptions.

Examples:

* BaseException
* ValidationException
* UnauthorizedException
* InternalException

Feature-specific business exceptions should stay in domain package.

---

# STEP 6 — response/

Shared API response models.

Examples:

* ApiResponse<T>
* ErrorResponse
* PagingResponse<T>

---

# STEP 7 — validation/

Reusable validators / annotations.

Examples:

* @ValidCurrency
* @ValidPhoneNumber
* @ValidAccountNo

---

# STEP 8 — STRICTLY FORBIDDEN

Do NOT place in common:

* Feature business logic
* Wallet transfer rules
* Payment orchestration
* Repository implementations
* Giant Utils with 500 methods
* Random unrelated classes

Bad:

```text
common/EverythingService.java
```

---

# STEP 9 — DEPENDENCY RULES

All layers may use common package only when generic.

```text
controller -> common
application -> common
domain -> common (carefully)
infrastructure -> common
```

Prefer domain to depend only on pure/common primitives, not framework config.

---

# STEP 10 — CLEAN EXAMPLE STRUCTURE

```text
common/
 ├── constant/ErrorCode.java
 ├── util/JsonUtil.java
 ├── util/MaskingUtil.java
 ├── response/ApiResponse.java
 ├── exception/BaseException.java
 └── validation/ValidCurrency.java
```

---

# STEP 11 — FINTECH EXAMPLES

Useful shared components:

* Currency constants
* Transaction status enum
* Money formatting util
* Mask account number util
* Signature verify util
* Error codes catalog
* Idempotency header constants

---

# STEP 12 — ANTI PATTERNS

Avoid:

* common as trash folder
* Static util for everything
* Business logic hidden in util
* Circular dependencies via common
* Shared mutable state

---

# STEP 13 — GENERATOR RULES FOR AI

When generating common package:

1. Only generic reusable components
2. Separate constant/util/exception clearly
3. Keep utilities stateless
4. No feature-specific logic
5. Use clear naming
6. Keep package lightweight

---

# FINAL CHECKLIST

* [ ] Constants centralized
* [ ] Utilities reusable
* [ ] No business logic in common
* [ ] Response wrappers standardized
* [ ] Exceptions organized
* [ ] No dumping-ground smell

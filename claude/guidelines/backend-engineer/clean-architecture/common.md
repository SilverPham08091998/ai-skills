# .claude/guidelines/clean-architecture/common.md

# Clean Architecture Common Package Rules

---

# STEP 1 — OBJECTIVE

`shared` package (also seen as `common` in some projects) is a cross-cutting package containing reusable technical components used across all layers.

Purpose:

* Reduce duplication
* Centralize constants
* Provide safe reusable utilities
* Standardize shared response models
* Keep business modules clean

Rule:
`shared package supports layers, but must not become a dumping ground.`

---

# STEP 2 — WHAT BELONGS IN shared/

Allowed sub-packages:

```text
shared/
 ├── constants/      ← application-wide constants (header names, error codes, regex, cache key prefixes)
 ├── utils/          ← stateless helper utilities (JsonUtil, DateTimeUtil, MaskingUtil)
 ├── exceptions/     ← shared base exceptions (BaseException, UnauthorizedException)
 ├── dtos/           ← shared response wrappers (BaseResponse<T>, PageResponse<T>, ErrorResponse)
 ├── filter/         ← shared servlet filters (tracing filter, request logging filter)
 └── validation/     ← reusable validation annotations (@ValidCurrency, @ValidAccountNo)
```

---

# STEP 3 — constants/

Use for application-wide constants.

Examples:

* Header names (`CasaHttpHeaders.IDEMPOTENCY_KEY`)
* Error codes
* Regex patterns
* Date formats
* Role names
* Cache key prefixes

Example:

```java
public final class CasaHttpHeaders {
    public static final String IDEMPOTENCY_KEY = "Idempotency-Key";
    public static final String TRACE_ID = "X-Trace-Id";

    private CasaHttpHeaders() {}
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

# STEP 5 — exceptions/

Shared base exceptions.

Examples:

* `BaseException`
* `ValidationException`
* `UnauthorizedException`
* `InternalException`

Feature-specific business exceptions (e.g., `InsufficientBalanceException`, `AccountNotFoundException`) stay in `domain/` — not here.

---

# STEP 6 — dtos/

Shared response wrapper DTOs used across all controllers.

Examples:

```java
// shared/dtos/BaseResponse.java
public class BaseResponse<T> {
    private String code;
    private String message;
    private T data;

    public static <T> BaseResponse<T> ok(T data) {
        return new BaseResponse<>("00", "SUCCESS", data);
    }
}
```

Examples:
* `BaseResponse<T>` — standard API envelope
* `ErrorResponse` — error details
* `PageResponse<T>` — paginated result wrapper

---

# STEP 6b — filter/

Shared servlet filters applied across the application.

Examples:

* Request tracing filter (inject/propagate `X-Trace-Id`)
* Request/response logging filter
* MDC context filter

```java
@Component
@Order(1)
public class TraceIdFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {
        String traceId = Optional.ofNullable(request.getHeader(CasaHttpHeaders.TRACE_ID))
                .orElse(UUID.randomUUID().toString());
        MDC.put("traceId", traceId);
        chain.doFilter(request, response);
    }
}
```

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

All layers may use `shared` package, but only for generic cross-cutting concerns.

```text
controllers/    → shared (constants, dtos, exceptions, filter)
application/    → shared (constants, exceptions)
domain/         → shared (carefully — only pure primitives, no framework config)
infrastructure/ → shared (constants, utils)
```

Domain must not depend on `shared/dtos/` (response wrappers) or `shared/filter/` — those are HTTP concerns.

---

# STEP 10 — CLEAN EXAMPLE STRUCTURE

```text
shared/
 ├── constants/
 │   └── CasaHttpHeaders.java
 ├── utils/
 │   ├── JsonUtil.java
 │   └── MaskingUtil.java
 ├── exceptions/
 │   └── BaseException.java
 ├── dtos/
 │   └── BaseResponse.java
 ├── filter/
 │   └── TraceIdFilter.java
 └── validation/
     └── ValidCurrency.java
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

When generating shared package:

1. Use `shared/` as the package name (not `common/`)
2. Sub-packages: `constants/`, `utils/`, `exceptions/`, `dtos/`, `filter/`, `validation/`
3. Only generic, reusable, cross-cutting components — no feature logic
4. `dtos/` for shared response wrappers (`BaseResponse<T>`) — controllers use this
5. `filter/` for shared servlet filters (tracing, logging)
6. Keep utilities stateless — pure functions only
7. Domain may use `shared/` carefully — never `dtos/` or `filter/`
8. Keep package lightweight — no God utility classes

---

# FINAL CHECKLIST

* [ ] Package named `shared/` with correct sub-packages
* [ ] `constants/` — HTTP headers, error codes, cache keys
* [ ] `dtos/` — `BaseResponse<T>` and other shared response wrappers
* [ ] `filter/` — tracing, logging, MDC filters
* [ ] `exceptions/` — base exceptions only, feature exceptions stay in domain
* [ ] `utils/` — stateless, pure, no side effects
* [ ] No business logic anywhere in shared
* [ ] Domain does not depend on `dtos/` or `filter/`
* [ ] No feature-specific class in shared

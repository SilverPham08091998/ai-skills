# .claude/guidelines/clean-architecture/controller-rule.md

# Clean Architecture Controller Rules

---

# STEP 1 — OBJECTIVE

Controller layer is the entry point of the system.

Its job is only to:

* Receive requests
* Validate input
* Transform request DTO to command/query
* Call application use case
* Return standardized response

Rule:
`Controller must be thin. No business logic allowed.`

---

# STEP 2 — RESPONSIBILITIES

Controller is allowed to handle:

* REST endpoints
* HTTP status codes
* Headers
* Path variables
* Query params
* Request body parsing
* Bean validation
* Authentication context reading
* Response formatting

---

# STEP 3 — STRICTLY FORBIDDEN

Controller must NOT contain:

* Business calculations
* Pricing logic
* Wallet balance checks
* Transfer rules
* Retry logic
* SQL queries
* Repository calls
* Transaction handling
* Complex if/else business flow
* Mapping to database entities

Bad Example:

```java
if(balance<amount){throw new

Exception(); }
        repo.

save(...);
```

---

# STEP 4 — STANDARD FLOW

```text
HTTP Request
-> Controller
-> Validate DTO
-> Map to Command
-> Call UseCase
-> Map Result to Response
-> Return HTTP Response
```

---

# STEP 5 — REQUEST / RESPONSE RULES

Use dedicated DTOs:

Examples:

* TransferRequest
* TransferResponse
* PaymentRequest
* PaymentResponse

Never expose:

* Domain model directly
* JPA entity directly
* Internal exceptions directly

---

# STEP 6 — VALIDATION RULES

Use Bean Validation:

```java
@NotBlank
@NotNull
@Positive
@Size(max = 50)
```

Example:

```java
public record TransferRequest(
        @NotBlank String fromWallet,
        @NotBlank String toWallet,
        @Positive BigDecimal amount
) {
}
```

Validation belongs to controller boundary.

---

# STEP 7 — MAPPING RULES

Use MapStruct preferred.

Mappings:

* Request -> Command
* Result -> Response

Example:

```java
TransferCommand toCommand(TransferRequest req);

TransferResponse toResponse(TransferResult result);
```

No manual repetitive mapping if avoidable.

---

# STEP 8 — RESPONSE STANDARD

Use consistent envelope if project standard requires:

```json
{
  "code": "00",
  "message": "SUCCESS",
  "data": {}
}
```

HTTP status examples:

* 200 success query
* 201 created
* 204 no content
* 400 validation error
* 401 unauthorized
* 403 forbidden
* 404 not found
* 409 conflict
* 500 internal error

---

# STEP 9 — EXCEPTION HANDLING

Use GlobalExceptionHandler.

Controller should NOT try/catch every endpoint.

Bad:

```java
try{...}catch(Exception e){...}
```

Good:

* Throw business exception
* Global handler maps response

---

# STEP 10 — SECURITY RULES

Controller may:

* Read authenticated user id
* Read roles/scopes
* Apply @PreAuthorize

Example:

```java
@PreAuthorize("hasRole('ADMIN')")
```

Controller should NOT verify JWT manually.

---

# STEP 11 — CLEAN EXAMPLE

```java

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/transfers")
public class TransferController {

    private final TransferUseCase useCase;
    private final TransferMapper mapper;

    @PostMapping
    public ResponseEntity<TransferResponse> transfer(
            @Valid @RequestBody TransferRequest request) {

        var result = useCase.execute(mapper.toCommand(request));
        return ResponseEntity.ok(mapper.toResponse(result));
    }
}
```

---

# STEP 12 — TESTING RULES

Controller tests must cover:

* Success case
* Validation failure
* Unauthorized
* Forbidden
* Not found
* Response schema

Use:

```java
@WebMvcTest
MockMvc
```

---

# STEP 13 — FINTECH EXAMPLES

Transfer endpoint:

* POST /transfers

Bill payment:

* POST /bill-payments

OTP verify:

* POST /otp/verify

Refund:

* POST /payments/{id}/refund

Controllers only orchestrate HTTP boundary.

---

# STEP 14 — ANTI PATTERNS

Avoid:

* Fat controller with 300 lines logic
* Calling repository directly
* Returning entity object
* try/catch every method
* Building SQL in controller
* Multiple nested if business rules
* Duplicated mapping code everywhere

---

# STEP 15 — GENERATOR RULES FOR AI

When generating controller:

1. Use REST conventions
2. Keep methods thin
3. Use Request/Response DTO
4. Validate with annotations
5. Call UseCase only
6. Use mapper
7. Return proper status code
8. No business logic
9. Generate controller tests

---

# FINAL CHECKLIST

* [ ] Thin controller
* [ ] DTO separated
* [ ] Validation present
* [ ] UseCase invoked
* [ ] No repository call
* [ ] No business logic
* [ ] Standard response
* [ ] Tested with MockMvc

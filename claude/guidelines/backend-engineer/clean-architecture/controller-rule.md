# .claude/guidelines/clean-architecture/controller-rule.md

# Clean Architecture Controller Rules

---

# STEP 1 — OBJECTIVE

Controller layer is the **entry point** of the system. It contains two types of input adapters — both live in the `controllers/` top-level package and both call application use cases.

| Type | Package | Trigger |
|------|---------|---------|
| HTTP Controllers | `controllers/` | REST HTTP request |
| Event Consumers | `controllers/events/consumers/` | Kafka / messaging event |

Package structure:

```text
controllers/
├── <Domain>Controller.java    ← HTTP input adapter
├── request/                   ← HTTP request DTOs
├── response/                  ← HTTP response DTOs
├── mapper/                    ← MapStruct: Request→Command, Domain→Response
└── events/
    └── consumers/             ← Kafka @KafkaListener → call use cases
```

Rule:
`Controller must be thin. No business logic allowed. Both HTTP and event consumers follow the same rule.`

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

## HTTP Flow

```text
HTTP Request
-> Controller
-> Validate DTO (@Valid, @NotBlank, ...)
-> Map to Command (MapStruct mapper)
-> Call UseCase
-> Map Result to Response (MapStruct mapper)
-> Return ResponseEntity
```

## Messaging Flow

```text
Kafka Event
-> @KafkaListener (controllers/events/consumers/)
-> Deserialize payload (from application/events/ schema)
-> Map to Command if needed (MapStruct mapper)
-> Call UseCase
-> (no response — async)
```

Both flows: **call use case only, no business logic, no DB access.**

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

## HTTP Controller

```java
@RestController
@RequestMapping("/api/v1/payment-accounts")
@RequiredArgsConstructor
public class PaymentAccountController {

    private final OpenPaymentAccountUseCase openPaymentAccountUseCase;
    private final PaymentAccountControllerMapper mapper;

    @PostMapping
    public ResponseEntity<BaseResponse<PaymentAccountOperationResponse>> open(
            @RequestBody @Valid OpenPaymentAccountRequest request) {
        return ResponseEntity.ok(BaseResponse.ok(
                mapper.toResponse(openPaymentAccountUseCase.execute(
                        mapper.toCommand(request)))));
    }
}
```

## Event Consumer (controllers/events/consumers/)

```java
@Component
@RequiredArgsConstructor
public class CoreBankingEventConsumer {

    private final SyncPaymentAccountUseCase syncPaymentAccountUseCase;
    private final CoreBankingEventMapper mapper;

    @KafkaListener(topics = "${kafka.topics.corebanking-events}")
    public void consume(CoreBankingEventMessage message) {
        syncPaymentAccountUseCase.execute(
                mapper.toCommand(message.getPayload()));
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

When generating controller layer:

1. Place HTTP controllers in `controllers/` (top-level package)
2. Place Kafka consumers in `controllers/events/consumers/`
3. Sub-packages: `request/`, `response/`, `mapper/` under `controllers/`
4. Keep methods thin — validate + map + delegate only
5. Use MapStruct mapper in `controllers/mapper/` for all Request→Command and Domain→Response conversions
6. Call UseCase only — never call repository or infrastructure directly
7. HTTP: return proper status code with `ResponseEntity`
8. Kafka consumer: `@KafkaListener`, deserialize payload, call use case, no return
9. No business logic in either type
10. Generate tests: `@WebMvcTest` + MockMvc for HTTP, unit test with mock use case for consumer

---

# FINAL CHECKLIST

* [ ] HTTP controllers in `controllers/` with `request/`, `response/`, `mapper/`
* [ ] Kafka consumers in `controllers/events/consumers/`
* [ ] Controller is thin — validate + map + delegate only
* [ ] MapStruct mapper used — no manual field copy, no `new A(a,b,c,d)`
* [ ] UseCase invoked — no repository or infrastructure call
* [ ] No business logic in either HTTP or event consumer
* [ ] Standard response envelope (`BaseResponse`) for HTTP
* [ ] HTTP: tested with `@WebMvcTest` + MockMvc
* [ ] Event consumer: tested with mocked use case

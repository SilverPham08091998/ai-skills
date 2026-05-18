# .claude/guidelines/clean-architecture/mapper-rule.md

# Clean Architecture Mapper Rules (MapStruct Standard)

---

# STEP 1 — OBJECTIVE

Mapper layer converts objects between architecture boundaries.

Goals:

* Remove repetitive boilerplate mapping
* Keep layers isolated
* Standardize object conversion
* Improve readability
* Reduce manual bugs

## Core Rule

```
Cross-layer mapping → MUST use MapStruct.
Within same layer  → MapStruct or Builder, depending on the case.
```

### Why no `new A(a, b, c, d)`

Constructor mapping breaks every time a field is added or removed:

```java
// BAD — breaks silently when fields change
return new OpenPaymentAccountCommand(
        request.getUserId(),
        request.getAccountType(),
        request.getCurrency(),
        idempotencyKey
);

// GOOD — MapStruct handles field evolution safely
@Mapper(componentModel = "spring")
public interface PaymentAccountControllerMapper {
    @Mapping(target = "idempotencyKey", source = "idempotencyKey")
    OpenPaymentAccountCommand toCommand(OpenPaymentAccountRequest request, String idempotencyKey);
}
```

When a new field is added to the command, MapStruct generates a compile-time warning. With `new A(...)`, the compiler stays silent and the field is silently dropped.

Rule:
`Every layer communicates through explicit models, not shared objects.`

---

# STEP 2 — WHERE MAPPERS ARE USED AND WHICH TOOL TO USE

| Boundary | Mapping | Tool | Package |
|----------|---------|------|---------|
| Cross-layer: Controller → Application | Request → Command | **MapStruct** (mandatory) | `controllers/mapper/` |
| Cross-layer: Application → Controller | Domain/Result → Response | **MapStruct** (mandatory) | `controllers/mapper/` |
| Cross-layer: Infrastructure → Application | Entity → Domain | **MapStruct** (mandatory) | `adapters/persistence/mappers/` |
| Cross-layer: Application → Infrastructure | Domain → Entity | **MapStruct** (mandatory) | `adapters/persistence/mappers/` |
| Cross-layer: Infrastructure client | Command/Domain → External DTO | **MapStruct** (mandatory) | `client/<service>/mapper/` |
| Cross-layer: Infrastructure client | External DTO → Domain/Result | **MapStruct** (mandatory) | `client/<service>/mapper/` |
| Within same layer | Object construction inside one layer | MapStruct **or Builder** | same package |

**Cross-layer = always MapStruct. No exceptions. No `new A(a,b,c,d)`.**

Within the same layer (e.g., building a command object inside a use case from multiple inputs), use Builder when the object has many optional fields, or MapStruct when converting between two explicit models.

---

# STEP 3 — STRICTLY FORBIDDEN

Do NOT use mapper for:

* Business decisions
* Calculations
* Validation rules
* Database queries
* Calling external APIs
* Side effects

Bad Example:

```java
if(request.amount() >1000)fee =...
```

Mapper only transforms data.

---

# STEP 4 — MAPSTRUCT STANDARD

Use MapStruct preferred.

Example:

```java

@Mapper(componentModel = "spring")
public interface TransferMapper {

    TransferCommand toCommand(TransferRequest request);

    TransferResponse toResponse(TransferResult result);
}
```

Benefits:

* Compile-time generation
* Fast performance
* Clear contracts

---

# STEP 5 — CONTROLLER MAPPER RULES

Convert:

* Request -> Command
* QueryParam DTO -> Query object
* Result -> Response

Example:

```java
CreatePaymentRequest ->CreatePaymentCommand
PaymentResult ->PaymentResponse
```

Controller should not manually copy fields repeatedly.

---

# STEP 6 — INFRASTRUCTURE MAPPER RULES

Convert:

* JPA Entity -> Domain
* Domain -> JPA Entity
* Gateway Response -> Domain
* Kafka Message -> Event Model

Example:

```java
WalletEntity<->Wallet
```

Never return entity directly to controller.

---

# STEP 7 — FIELD MAPPING RULES

Use explicit mapping when names differ.

Example:

```java
@Mapping(target = "walletId", source = "id")
```

Ignore internal fields when needed:

```java
@Mapping(target = "password", ignore = true)
```

---

# STEP 8 — NESTED OBJECT RULES

Map nested models with dedicated mappers.

Example:

```java
uses ={MoneyMapper .class}
```

Keep mapper modular.

---

# STEP 9 — UPDATE MAPPING RULES

Use @MappingTarget for partial updates.

Example:

```java
void update(@MappingTarget WalletEntity entity, Wallet wallet);
```

Useful for JPA update flows.

---

# STEP 10 — NULL HANDLING RULES

Define strategy clearly.

Examples:

* Ignore null fields on patch update
* Map null explicitly on replace update

Use:

```java
nullValuePropertyMappingStrategy =IGNORE
```

---

# STEP 11 — CLEAN EXAMPLE

```java

@Mapper(componentModel = "spring")
public interface WalletEntityMapper {

    Wallet toDomain(WalletEntity entity);

    WalletEntity toEntity(Wallet domain);
}
```

---

# STEP 12 — PACKAGE STRUCTURE

```text
controllers/
└── mapper/                              ← HTTP Request→Command, Domain→Response

application/
└── mappers/                             ← application-level mappers (if needed)

infrastructure/
├── adapters/
│   └── persistence/
│       └── mappers/                     ← Entity ↔ Domain
└── client/
    └── <service-name>/
        └── mapper/                      ← Command/Domain ↔ External request/response DTOs
```

One mapper per boundary. Never share a mapper across layers.

---

# STEP 13 — TESTING RULES

Test mapper when:

* Custom expressions used
* Complex nested mapping
* Critical finance fields
* Date/time conversion
* Currency conversion formatting

Simple generated mapping may rely on compile-time checks.

---

# STEP 14 — FINTECH RULES

Critical fields must map correctly:

* amount
* currency
* transactionId
* accountNo
* walletId
* feeAmount
* promotionAmount
* createdAt
* status

Never silently drop money fields.

---

# STEP 15 — ANTI PATTERNS

Avoid:

* Massive mapper with 200 methods
* Business logic in @AfterMapping
* Controller manual mapping everywhere
* Reusing entity as response DTO
* Reflection mappers with poor performance by default
* Hidden field loss

## CRITICAL: No constructor mapping across layers

Never use `new A(a, b, c, d)` for cross-layer conversions.

Bad — breaks silently when fields are added/removed:

```java
// In UseCase or Controller
return new PaymentResponse(
        payment.getId(),
        payment.getAmount(),
        payment.getStatus()
);
```

Good — compile-time safe, field evolution handled:

```java
@Mapper(componentModel = "spring")
public interface PaymentControllerMapper {
    PaymentResponse toResponse(Payment payment);
}
```

## Within same layer — MapStruct or Builder

Builder is acceptable when constructing objects within the same layer with many optional fields:

```java
// OK — within application layer, building a complex command from multiple inputs
StatementJobCommand command = StatementJobCommand.builder()
        .accountNo(accountNo)
        .fromDate(fromDate)
        .toDate(toDate)
        .requestedBy(userId)
        .build();
```

MapStruct is preferred when there are two explicit models to convert between, even within the same layer.

Rule: **Cross-layer = MapStruct always. Within-layer = MapStruct or Builder, choose based on the case.**

---

# STEP 16 — GENERATOR RULES FOR AI

When generating source code:

1. Cross-layer mapping → always MapStruct, never `new A(a,b,c,d)` constructor
2. Within same layer → MapStruct or Builder depending on case
3. Place mappers in the correct package per boundary (see STEP 12)
4. Use `@Mapper(componentModel = "spring")`
5. Add explicit `@Mapping` when field names differ
6. Keep mapper side-effect free — no business logic, no API calls
7. Use `@MappingTarget` for partial update (JPA patch flow)
8. Preserve financial precision fields: `amount`, `feeAmount`, `currency` — never lose or truncate
9. Generate tests for mappers with custom expressions or critical financial fields

---

# FINAL CHECKLIST

* [ ] Cross-layer mapping uses MapStruct — no `new A(a,b,c,d)` constructor
* [ ] Within-layer: MapStruct or Builder chosen based on case
* [ ] Mapper placed in correct package (see STEP 12)
* [ ] DTO ≠ Domain ≠ Entity — each layer has its own model
* [ ] No business logic in mapper
* [ ] Explicit `@Mapping` for renamed fields
* [ ] Financial fields (`amount`, `currency`, `feeAmount`) verified — never silently dropped
* [ ] Null strategy defined for patch update flows
* [ ] Nested mapping uses `uses = {...}` for modular mappers
* [ ] Compile-time generated via MapStruct

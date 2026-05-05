# .codex/guidelines/clean-architecture/mapper-rule.md

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

Rule:
`Every layer communicates through explicit models, not shared objects.`

---

# STEP 2 — WHERE MAPPERS ARE USED

Typical mappings:

```text
Controller Layer:
Request DTO <-> Command / Query
Result <-> Response DTO

Infrastructure Layer:
Entity <-> Domain Model
External DTO <-> Domain Model
Kafka Event <-> Domain Event
```

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
controller/mapper
application (usually no mapper unless needed)
infrastructure/persistence/mapper
infrastructure/client/mapper
```

Recommended separate by boundary.

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

## CRITICAL: No Manual Mapper Methods

Never implement manual `build()` / `toResult()` / `toDto()` methods inline.

Bad:

```java
// In UseCase or Service
private PaymentResponse buildResponse(Payment payment) {
    return PaymentResponse.builder()
        .id(payment.getId())
        .amount(payment.getAmount())
        .build();
}
```

Good:

```java
@Mapper(componentModel = "spring")
public interface PaymentMapper {
    PaymentResponse toResponse(Payment payment);
}
```

Rule: All object conversion between layers MUST use a dedicated `*Mapper` interface with MapStruct.

---

# STEP 16 — GENERATOR RULES FOR AI

When generating source code:

1. Create mapper for every boundary
2. Use MapStruct with componentModel=spring
3. Add explicit @Mapping when names differ
4. Keep mapper side-effect free
5. Generate update mapper when needed
6. Preserve financial precision fields
7. Generate tests for complex mapper logic

---

# FINAL CHECKLIST

* [ ] DTO != Domain != Entity
* [ ] Mapper per boundary exists
* [ ] No business logic in mapper
* [ ] Explicit renamed fields mapped
* [ ] Money fields verified
* [ ] Null strategy defined
* [ ] Nested mapping clean
* [ ] Compile-time generated

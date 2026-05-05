---
name: java-lombok-mapstruct
description: Lombok and MapStruct standards for Java services. Use when generating boilerplate, DTOs, mappers, and compile-time mapping code.
---

# Java Lombok Mapstruct Guidelines

This Codex skill adapts `backend-engineer/java/lombok-mapstruct.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Lombok & MapStruct Guidelines

## Purpose

Define standards for using Lombok and MapStruct in Java projects.

Goals:

- reduce boilerplate
- improve readability
- keep mappings consistent
- speed up development
- preserve maintainability
- support clean architecture boundaries

Applies to:

- Spring Boot services
- DTO mapping
- entity conversion
- clean architecture layers

---

# 1. Core Principles

Use Lombok and MapStruct as productivity tools, not as excuses for poor design.

Rules:

- explicit architecture boundaries still required
- models must remain meaningful
- mapping logic must stay maintainable
- generated code should be predictable

---

# 2. Lombok Allowed Usage

Preferred annotations:

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@RequiredArgsConstructor
@ToString
@EqualsAndHashCode
@Slf4j
@Value

Use only what is necessary.

---

# 3. Lombok Preferred by Type

## DTO / Request / Response

Use:

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor

## Immutable Value Object

Use:

@Value
@Builder

## Spring Service

Use:

@RequiredArgsConstructor
@Slf4j

Example:

@Service
@RequiredArgsConstructor
public class PaymentService {
private final PaymentRepository repository;
}

---

# 4. Avoid @Data by Default

Do NOT use @Data blindly.

Why:

- generates setter for everything
- broad equals/hashCode
- hidden behavior

Prefer explicit annotations.

Bad:

@Data
class Customer {}

Good:

@Getter
@Setter

---

# 5. Builder Usage

Use @Builder when:

- many fields
- optional fields
- test object creation
- immutable construction readability

Good:

PaymentRequest request =
PaymentRequest.builder()
.customerId("123")
.amount(amount)
.build();

Avoid builder for tiny 2-field objects unless helpful.

---

# 6. Equals and HashCode

Use carefully.

Recommended:

@EqualsAndHashCode(of = "id")

For entities.

Avoid all-fields equality for mutable JPA entities.

---

# 7. toString Safety

Never expose secrets.

Exclude:

password
token
secretKey
pin
cardNumber

Example:

@ToString(exclude = {"password", "token"})

---

# 8. Constructor Injection

Use Lombok for dependency injection.

Good:

@RequiredArgsConstructor

@Service
public class RefundService {
private final PaymentGateway gateway;
}

Avoid field injection.

Bad:

@Autowired
private PaymentGateway gateway;

---

# 9. Lombok on JPA Entities

Use cautiously.

Recommended:

@Getter
@Setter
@NoArgsConstructor

Avoid:

@Builder on complex JPA entities unless well understood.

Avoid @Data on JPA entities.

---

# 10. Records vs Lombok DTO

Prefer Java record when suitable.

Good:

public record PaymentRequest(
String customerId,
BigDecimal amount
) {}

Use Lombok when:

- mutable DTO required
- framework constraints
- builder desired

---

# MAPSTRUCT SECTION

# 11. Why MapStruct

Use MapStruct for compile-time mapping.

Benefits:

- fast
- type safe
- no reflection
- maintainable
- clear boundaries

Preferred over manual repetitive mapping.

---

# 12. Where to Use MapStruct

Use between layers:

Controller:
Request <-> Command

Application:
Result <-> Response

Infrastructure:
Entity <-> Domain

External API:
ProviderResponse <-> Domain

---

# 13. Mapper Naming

Use clear names.

Examples:

PaymentMapper
CustomerEntityMapper
RefundResponseMapper
PaymentRequestMapper

Avoid:

ConvertUtil
CommonMapper

---

# 14. Mapper Location

Place near related module.

Example:

payment/controller/mapper/
payment/infrastructure/mapper/

Avoid giant global mapper package.

---

# 15. Basic Mapper Example

@Mapper(componentModel = "spring")
public interface PaymentMapper {

PaymentCommand toCommand(CreatePaymentRequest request);

PaymentResponse toResponse(PaymentResult result);
}

Use Spring component model.

---

# 16. Clean Architecture Rule

Each layer communicates via mapper.

Example:

Controller:
Request -> Command

UseCase:
Domain -> Result

Controller:
Result -> Response

No leaking entity directly to API.

---

# 17. Explicit Field Mapping

Use @Mapping when names differ.

Example:

@Mapping(target = "customerId", source = "id")

Do not rely blindly when semantics differ.

---

# 18. Ignore Sensitive/Internal Fields

Use:

@Mapping(target = "secretKey", ignore = true)

Prevent accidental exposure.

---

# 19. Nested Mapping

Use dedicated mapper dependencies.

Example:

@Mapper(
componentModel = "spring",
uses = AddressMapper.class
)

Avoid giant monolithic mappers.

---

# 20. Update Existing Objects

Use @MappingTarget for update flows.

Example:

void updateEntity(UpdateRequest request,
@MappingTarget CustomerEntity entity);

Useful for patch/update.

---

# 21. Null Handling

Configure null strategy intentionally.

Avoid overwriting valid fields with null accidentally.

Review:
NullValuePropertyMappingStrategy

---

# 22. Collections Mapping

MapStruct handles:

List<A> -> List<B>

Use when layer returns lists.

Keep element mapper defined.

---

# 23. Enum Mapping

MapStruct can map enums.

When names differ, configure explicitly.

Avoid unsafe String status conversions.

---

# 24. Expressions and Custom Logic

Use expressions sparingly.

Bad:
Huge business logic inside mapper.

Good:
Simple derived field only.

Business rules belong in service/domain.

---

# 25. AfterMapping / BeforeMapping

Use for minor enrichment.

Example:
set calculated displayName

Do not place complex workflows there.

---

# 26. Forbidden Mapper Usage

Never:

- database queries inside mapper
- API calls inside mapper
- business validation inside mapper
- transaction logic inside mapper

Mapper = transformation only.

---

# 27. Testing Mappers

Add tests for:

- critical field mappings
- null handling
- nested objects
- enum conversions
- ignored fields

Especially for payment / fintech models.

---

# 28. Performance Notes

MapStruct generated code is fast.

Prefer over reflection mappers in hot paths.

Still avoid unnecessary repeated mapping loops.

---

# 29. Fintech Examples

## Payment API

CreatePaymentRequest
-> PaymentCommand
-> PaymentResult
-> PaymentResponse

## Ledger

LedgerEntity
-> LedgerEntryDomain

## Provider Callback

ProviderWebhookRequest
-> CallbackCommand

---

# 30. Common Mistakes

Avoid:

- @Data everywhere
- entity returned directly to controller
- manual copy-paste mapping everywhere
- giant universal mapper
- business logic inside mapper
- exposing internal fields

## CRITICAL RULE: No Manual Mapper Functions

Never write manual conversion methods inline in services or use cases.

Bad:

```java
private PaymentDto toDto(Payment payment) {
    return new PaymentDto(payment.getId(), payment.getAmount());
}
```

Good:

```java
@Mapper(componentModel = "spring")
public interface PaymentMapper {
    PaymentDto toDto(Payment payment);
}
```

All mapping MUST go through a dedicated `*Mapper` interface with MapStruct annotation. No exceptions.

---

# 31. Review Checklist

Before merge ask:

- Is Lombok annotation minimal and intentional?
- Any @Data misuse?
- Secrets excluded from toString?
- Constructor injection used?
- MapStruct mapper named clearly?
    - Layer boundaries mapped cleanly?
- Any business logic in mapper?
- Tests for critical mapping?

---

# 32. Mandatory For AI Code Generation

When generating Java code:

- Prefer @RequiredArgsConstructor for services
- Avoid @Data by default
- Use @Builder for complex DTO creation
- Use MapStruct for layer mapping
- Use @Mapper(componentModel = "spring")
- Keep mapper pure transformation only
- Respect clean architecture boundaries
- Never expose entity directly to API

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

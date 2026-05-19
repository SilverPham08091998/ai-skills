# .claude/guidelines/clean-architecture/layers.md

# Clean Architecture Layers Standards

---

# STEP 1 — OBJECTIVE

Clean Architecture separates business logic from frameworks and infrastructure.

Goals:

* High maintainability
* Easy testing
* Replaceable frameworks
* Scalable codebase
* Clear responsibilities
* Lower coupling
* Faster onboarding

Rule:
`Business logic must not depend on frameworks.`

---

# STEP 2 — LAYER OVERVIEW

Standard layers:

```text
Controller / Entry Point
Application / UseCase
Domain / Core Business
Infrastructure / External World
```

Dependency direction:

```text
Outer layers depend on inner layers
Inner layers never depend on outer layers
```

---

# STEP 3 — CONTROLLER LAYER (Entry Point)

The controller layer is the **entry point** of the service. It contains two types of input adapters — both live in the `controllers/` top-level package and both call application use cases. Neither contains business logic.

## 3.1 — HTTP Controllers

Package: `controllers/`

Responsibilities:

* Receive HTTP requests
* Validate input (Bean Validation)
* Convert Request → Command via mapper
* Call UseCase
* Convert Domain → Response via mapper
* Return ResponseEntity

Sub-packages:

```text
controllers/
├── request/     ← HTTP request DTOs (@Valid, @NotBlank, etc.)
├── response/    ← HTTP response DTOs
└── mapper/      ← Request→Command, Domain→Response (MapStruct)
```

Allowed:

* Request / Response DTOs
* Bean Validation annotations
* Mapper
* Spring MVC annotations (`@RestController`, `@RequestMapping`, etc.)

Forbidden:

* Business logic
* Repository access
* Direct infrastructure dependency
* Transaction management

Example:

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

## 3.2 — Event Consumers (Messaging Input Adapter)

Package: `controllers/events/consumers/`

Responsibilities:

* Receive Kafka / messaging events
* Deserialize and validate message payload
* Convert Event payload → Command via mapper (if needed)
* Call UseCase
* Do NOT publish events — that is infrastructure's responsibility

Sub-packages:

```text
controllers/
└── events/
    └── consumers/   ← @KafkaListener classes → call use cases
```

Allowed:

* Kafka listener annotations (`@KafkaListener`)
* Event payload classes from `application/events/`
* UseCase calls
* Mapper (payload → command)

Forbidden:

* Business logic
* Direct DB access
* Publishing Kafka events (use messaging port via use case)
* Error suppression without dead-letter handling

Example:

```java
@Component
@RequiredArgsConstructor
public class CoreBankingEventConsumer {

    private final SyncPaymentAccountUseCase syncPaymentAccountUseCase;

    @KafkaListener(topics = "${kafka.topics.corebanking-events}")
    public void consume(CoreBankingEventMessage message) {
        syncPaymentAccountUseCase.execute(
                mapper.toCommand(message.getPayload()));
    }
}
```

## 3.3 — Full Controller Layer Structure

```text
controllers/
├── <Domain>Controller.java    ← HTTP entry point
├── request/                   ← HTTP request DTOs
├── response/                  ← HTTP response DTOs
├── mapper/                    ← HTTP mapper (Request→Command, Domain→Response)
└── events/
    └── consumers/             ← Kafka/messaging consumers → call use cases
```

---

# STEP 4 — APPLICATION LAYER

Responsibilities:

* Orchestrate business flow
* Execute use cases
* Manage transactions
* Call ports/interfaces
* Apply policies

Allowed:

* Commands
* UseCases
* Ports
* Application services

Forbidden:

* Framework annotations except minimal service/tx if needed
* Entity persistence details
* HTTP logic

Example:

```java
public PaymentResult execute(PaymentCommand cmd)
```

---

# STEP 5 — DOMAIN LAYER

Responsibilities:

* Core business rules
* Entities
* Value objects
* Domain services
* Invariants

Allowed:

* Pure Java code
* Business exceptions
* Calculations

Forbidden:

* Spring dependency
* JPA annotations (preferred avoid)
* REST client
* Kafka client
* DB access

Example:

```java
wallet.debit(amount)
wallet.

credit(amount)
```

---

# STEP 6 — INFRASTRUCTURE LAYER

The infrastructure layer contains all **output adapters** — implementations that connect the application to the external world (DB, external services, messaging, scheduling, observability).

Responsibilities:

* Database adapters (JPA repositories)
* External service clients (Feign)
* Kafka producers (outbound messaging)
* Scheduler adapters
* Observability adapters (metrics, tracing)

Allowed:

* Spring Data JPA, `@Repository`
* Feign / WebClient
* `KafkaTemplate`
* `RedisTemplate`
* `@Scheduled`, Micrometer

Forbidden:

* Business logic
* Cross-use-case orchestration
* Direct use-case calls (only implement ports)

## 6.1 — Adapters Sub-packages

```text
infrastructure/adapters/
├── persistence/           ← JPA adapter (implements persistence ports)
│   ├── repositories/      ← Spring Data JPA interfaces
│   ├── entities/          ← JPA @Entity classes
│   └── mappers/           ← Entity ↔ Domain mappers (MapStruct)
├── messaging/             ← Kafka OUTPUT adapter (producer, publish events)
│   └── events/            ← Outbound Kafka event classes
├── scheduler/             ← Scheduled job adapters (@Scheduled)
└── observability/         ← Metrics / tracing adapters (Micrometer, etc.)
```

> **Note:** Kafka **consumers** (input) live in `controllers/events/consumers/`.
> Kafka **producers** (output) live in `infrastructure/adapters/messaging/`.

## 6.2 — Client Sub-packages

Each external service gets its own sub-package under `infrastructure/client/`:

```text
infrastructure/client/
└── <service-name>/                    ← one package per external service
    ├── <ServiceName>Adapter.java      ← implements application port (e.g. MfaServicePort)
    ├── client/                        ← Feign interface + config + interceptor + properties
    │   ├── <Service>FeignClient.java
    │   ├── <Service>FeignConfig.java
    │   ├── <Service>Interceptor.java
    │   └── <Service>Properties.java
    ├── request/                       ← request DTOs sent to external service
    ├── response/                      ← response DTOs received from external service
    └── mapper/                        ← maps between domain/command and external DTOs
```

Example — `MfaServiceAdapter` implements `MfaServicePort`:

```java
@Component
@RequiredArgsConstructor
public class MfaServiceAdapter implements MfaServicePort {

    private final MfaServiceFeignClient feignClient;
    private final MfaServiceMapper mapper;

    @Override
    public MfaInitResult initiate(String transactionId, String productCode, String userId) {
        return mapper.toInitResult(feignClient.initiate(
                mapper.toInitRequest(transactionId, productCode, userId)));
    }
}
```

```java
@FeignClient(
        name = "mfa-service",
        url = "${clients.mfa-service.url}",
        configuration = MfaServiceFeignConfig.class
)
public interface MfaServiceFeignClient {
    @PostMapping("/internal/mfa/initiate")
    MfaInitResponse initiate(@RequestBody MfaInitRequest request);
}
```

## 6.3 — Full Infrastructure Structure

```text
infrastructure/
├── adapters/
│   ├── persistence/
│   │   ├── repositories/
│   │   ├── entities/
│   │   └── mappers/
│   ├── messaging/
│   │   └── events/
│   ├── scheduler/
│   └── observability/
├── client/
│   └── <service-name>/
│       ├── <ServiceName>Adapter.java
│       ├── client/
│       ├── request/
│       ├── response/
│       └── mapper/
├── config/
└── web/
```

---

# STEP 7 — DEPENDENCY RULE

Correct:

```text
Controller -> Application -> Domain
Infrastructure -> Application Port
```

Wrong:

```text
Domain -> RepositoryImpl
Domain -> Controller
UseCase -> ResponseEntity
```

---

# STEP 8 — PORTS & ADAPTERS

Ports are interfaces defined in the **application layer** that the use cases depend on. Infrastructure adapters implement these ports — the application never depends on the implementation directly.

## Input Ports (driven by entry points)

* UseCase interfaces — called by `controllers/` and `controllers/events/consumers/`

## Output Ports (implemented by infrastructure)

Ports are categorized into 4 groups under `application/ports/`:

```text
application/ports/
├── clients/        ← external service ports (FeeServicePort, MfaServicePort, CoreBankingPort)
├── persistence/    ← repository ports (PaymentAccountRepositoryPort, UserRepositoryPort)
├── messaging/      ← outbound messaging ports (StatementJobPublisherPort)
└── observability/  ← metrics ports (OperationalMetricsPort)
```

| Port category | Interface lives in | Implemented by |
|---|---|---|
| `clients/` | `application/ports/clients/` | `infrastructure/client/<service>/<ServiceAdapter>.java` |
| `persistence/` | `application/ports/persistence/` | `infrastructure/adapters/persistence/` |
| `messaging/` | `application/ports/messaging/` | `infrastructure/adapters/messaging/` |
| `observability/` | `application/ports/observability/` | `infrastructure/adapters/observability/` |

Example:

```java
// Port — defined in application layer
public interface MfaServicePort {
    MfaInitResult initiate(String transactionId, String productCode, String userId);
    MfaVerifyResult verify(String challengeId, String userId, String mfaCode);
}

// Adapter — implemented in infrastructure/client/mfa/
@Component
public class MfaServiceAdapter implements MfaServicePort { ... }
```

```java
// Port — persistence
public interface PaymentAccountRepositoryPort {
    Optional<PaymentAccount> findByAccountNo(String accountNo);
    PaymentAccount save(PaymentAccount account);
}

// Adapter — implemented in infrastructure/adapters/persistence/
@Repository
public class PaymentAccountRepositoryAdapter implements PaymentAccountRepositoryPort { ... }
```

---

# STEP 9 — PACKAGE STRUCTURE

Full structure based on casa-service clean architecture:

```text
com.company.<service>
│
├── controllers/                          ← ENTRY POINT LAYER
│   ├── <Domain>Controller.java           ← HTTP input adapter
│   ├── request/                          ← HTTP request DTOs
│   ├── response/                         ← HTTP response DTOs
│   ├── mapper/                           ← Request→Command, Domain→Response
│   └── events/
│       └── consumers/                    ← Kafka input adapters → call use cases
│
├── application/                          ← APPLICATION LAYER
│   ├── usecases/                         ← use case interfaces grouped by domain
│   │   └── <domain>/
│   │       └── impl/                     ← use case implementations
│   ├── services/                         ← application services (cross-usecase helpers)
│   ├── events/                           ← event schema / message models (Kafka payload types)
│   ├── dtos/                             ← application-level DTOs (commands, queries, results)
│   ├── mappers/                          ← application-level mappers
│   └── ports/                            ← output port interfaces
│       ├── clients/                      ← external service port interfaces
│       ├── persistence/                  ← repository port interfaces
│       ├── messaging/                    ← outbound messaging port interfaces
│       └── observability/                ← metrics port interfaces
│
├── domain/                               ← DOMAIN LAYER (pure Java, no framework)
│   ├── models/                           ← entities, value objects, aggregates
│   └── enums/                            ← domain enumerations
│
├── infrastructure/                       ← INFRASTRUCTURE LAYER (output adapters)
│   ├── adapters/
│   │   ├── persistence/                  ← JPA adapter (implements persistence ports)
│   │   │   ├── repositories/             ← Spring Data JPA interfaces
│   │   │   ├── entities/                 ← @Entity classes
│   │   │   └── mappers/                  ← Entity ↔ Domain mappers
│   │   ├── messaging/                    ← Kafka PRODUCER adapters (implements messaging ports)
│   │   │   └── events/                   ← outbound Kafka event classes
│   │   ├── scheduler/                    ← @Scheduled job adapters
│   │   └── observability/                ← Micrometer / tracing adapters
│   ├── client/                           ← external service Feign clients
│   │   └── <service-name>/               ← one sub-package per external service
│   │       ├── <Service>Adapter.java     ← implements clients port interface
│   │       ├── client/                   ← FeignClient + FeignConfig + Interceptor + Properties
│   │       ├── request/                  ← request DTOs for external service
│   │       ├── response/                 ← response DTOs from external service
│   │       └── mapper/                   ← maps domain/command ↔ external DTOs
│   ├── config/                           ← Spring @Configuration classes
│   └── web/                              ← web filters, interceptors, CORS config
│
└── shared/                               ← CROSS-CUTTING (no business logic)
    ├── constants/                        ← shared constants
    ├── dtos/                             ← shared DTOs (BaseResponse, PageResponse)
    ├── exceptions/                       ← shared exception classes
    ├── filter/                           ← shared filters
    └── utils/                            ← utility classes
```

## Dependency direction

```text
controllers/          → application/usecases   (HTTP + messaging entry points call use cases)
application/usecases  → application/ports      (use cases depend on port interfaces)
application/ports     ← infrastructure/        (infrastructure implements the ports)
domain/               ← application/           (application orchestrates domain)
domain/               has NO outward dependency
```

---

# STEP 10 — MAPPER RULES

Use MapStruct between layers:

* Request -> Command
* Domain -> Response
* Entity -> Domain
* Domain -> Entity

Never expose JPA entity directly to controller.

---

# STEP 11 — TESTING PER LAYER

Controller:

* MockMvc
* Mock UseCase

Application:

* Unit test with mocked ports

Domain:

* Pure unit test

Infrastructure:

* Integration tests

---

# STEP 12 — FINTECH EXAMPLE FLOW

```text
POST /transfer
Controller receives request
-> TransferUseCase.execute(cmd)
-> WalletRepository.load()
-> wallet.debit()
-> LedgerPort.post()
-> Save transaction
-> Return response
```

---

# STEP 13 — ANTI PATTERNS

Avoid:

* Fat controller
* God service
* Domain using Spring annotations everywhere
* Repository returning ResponseDTO
* Controller calling DB directly
* Business logic inside mapper

---

# STEP 14 — GENERATOR RULES FOR AI

When generating source code:

1. Create all 4 layers
2. Separate DTO / Command / Domain / Entity
3. Use ports for outbound dependency
4. Use MapStruct for conversions
5. Keep business logic in domain/application only
6. Generate tests per layer

---

# FINAL CHECKLIST

* [ ] Layers separated
* [ ] Dependency direction correct
* [ ] No business logic in controller
* [ ] Domain framework independent
* [ ] Ports defined
* [ ] Adapters implemented
* [ ] DTO separated from entity
* [ ] Tests per layer

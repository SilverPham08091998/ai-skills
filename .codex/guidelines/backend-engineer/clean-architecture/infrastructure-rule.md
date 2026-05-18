# .codex/guidelines/clean-architecture/infrastructure-rule.md

# Clean Architecture Infrastructure Layer Rules

---

# STEP 1 — OBJECTIVE

Infrastructure layer handles all technical details and external systems.

It contains only **output adapters** — it implements ports defined by the application layer.

> **Important distinction:**
> - Kafka **producers** (outbound) → `infrastructure/adapters/messaging/`
> - Kafka **consumers** (inbound) → `controllers/events/consumers/` (entry point layer)

Package structure:

```text
infrastructure/
├── adapters/
│   ├── persistence/           ← JPA adapter (implements persistence ports)
│   │   ├── repositories/      ← Spring Data JPA interfaces
│   │   ├── entities/          ← @Entity classes
│   │   └── mappers/           ← Entity ↔ Domain (MapStruct)
│   ├── messaging/             ← Kafka PRODUCER adapters (implements messaging ports)
│   │   └── events/            ← outbound Kafka event classes
│   ├── scheduler/             ← @Scheduled job adapters
│   └── observability/         ← Micrometer / tracing adapters
├── client/                    ← external service Feign clients
│   └── <service-name>/        ← one sub-package per external service
│       ├── <Service>Adapter.java   ← implements clients port
│       ├── client/            ← FeignClient + Config + Interceptor + Properties
│       ├── request/           ← request DTOs for external service
│       ├── response/          ← response DTOs from external service
│       └── mapper/            ← MapStruct: domain/command ↔ external DTOs
├── config/                    ← Spring @Configuration
└── web/                       ← filters, interceptors, CORS
```

Rule:
`Infrastructure serves the business. Business must not depend on infrastructure.`

---

# STEP 2 — RESPONSIBILITIES

Infrastructure layer may contain:

* Repository implementations
* JPA entities
* Spring Data repositories
* REST clients
* Feign clients
* WebClient adapters
* Kafka producer / consumer
* Redis adapters
* S3/File storage adapters
* Security providers
* Scheduler jobs
* Entities

---

# STEP 3 — STRICTLY FORBIDDEN

Infrastructure must NOT contain:

* Core business rules
* Pricing policy logic
* Wallet balance decisions
* Transfer approval rules
* Controller request validation logic
* UseCase orchestration across many features

Bad Example:

```java
if(amount >1000000)

approveAutomatically();
```

---

# STEP 4 — DEPENDENCY RULE

Correct direction:

```text
Infrastructure -> Application Port / Domain Model
```

Wrong:

```text
Application -> JpaRepositoryImpl
Domain -> KafkaProducer
```

Infrastructure implements interfaces from inner layers.

---

# STEP 5 — PERSISTENCE RULES

Package: `infrastructure/adapters/persistence/`

```text
adapters/persistence/
├── repositories/      ← Spring Data JPA interfaces (JpaRepository)
├── entities/          ← @Entity classes (DB schema representation)
└── mappers/           ← MapStruct Entity ↔ Domain mappers
```

Adapter implements persistence port:

```java
@Component
@RequiredArgsConstructor
public class PaymentAccountRepositoryAdapter implements PaymentAccountRepositoryPort {

    private final PaymentAccountJpaRepository jpaRepository;
    private final PaymentAccountEntityMapper mapper;

    @Override
    public Optional<PaymentAccount> findByAccountNo(String accountNo) {
        return jpaRepository.findByAccountNo(accountNo)
                .map(mapper::toDomain);
    }

    @Override
    public PaymentAccount save(PaymentAccount account) {
        return mapper.toDomain(jpaRepository.save(mapper.toEntity(account)));
    }
}
```

Rules:
* Convert Entity ↔ Domain using MapStruct mapper in `mappers/`
* Never expose `@Entity` class to application or controller layer
* Never put business logic inside adapter methods

---

# STEP 6 — EXTERNAL CLIENT RULES

Package: `infrastructure/client/<service-name>/`

Each external service gets its own sub-package:

```text
client/
└── mfa/
    ├── MfaServiceAdapter.java          ← implements MfaServicePort (from application/ports/clients/)
    ├── client/
    │   ├── MfaServiceFeignClient.java  ← @FeignClient interface
    │   ├── MfaServiceFeignConfig.java  ← Feign config (encoder, decoder, etc.)
    │   ├── MfaServiceInterceptor.java  ← request interceptor (add headers, auth)
    │   └── MfaServiceProperties.java  ← @ConfigurationProperties (url, timeout, etc.)
    ├── request/                        ← DTOs sent to external service
    ├── response/                       ← DTOs received from external service
    └── mapper/                         ← MapStruct: command/domain ↔ request/response DTOs
```

`<Service>Adapter.java` is placed at the root of the service package (not inside `client/`):

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

Rules:
* Adapter implements the `ports/clients/` interface — application never imports Feign directly
* Use MapStruct mapper in `mapper/` — no `new RequestDto(a, b, c, d)`
* Handle timeout, retry, circuit breaker at Feign config level
* Map external exceptions to domain exceptions in the adapter

---

# STEP 7 — MESSAGING RULES

Package: `infrastructure/adapters/messaging/`

> **This package contains PRODUCERS only.**
> Kafka consumers (input) live in `controllers/events/consumers/`.

```text
adapters/messaging/
├── KafkaStatementJobPublisherAdapter.java   ← implements StatementJobPublisherPort
├── KafkaStatementNotificationAdapter.java
└── events/                                  ← outbound Kafka event payload classes
    └── AccountBlockRequestedEvent.java
```

Producer responsibilities:
* Implement messaging port from `application/ports/messaging/`
* Serialize domain events to Kafka messages
* Add required headers (trace-id, timestamp, etc.)
* Publish reliably — use outbox pattern for critical flows

```java
@Component
@RequiredArgsConstructor
public class KafkaStatementJobPublisherAdapter implements StatementJobPublisherPort {

    private final KafkaTemplate<String, Object> kafkaTemplate;

    @Override
    public void publish(StatementJobRequestedEvent event) {
        kafkaTemplate.send(STATEMENT_JOB_TOPIC, event.getAccountNo(), event);
    }
}
```

No business logic inside producer. Serialize and publish only.

---

# STEP 8 — CACHE RULES

Use Redis adapters for:

* OTP temp storage
* Idempotency keys
* Session data
* Read cache

Cache policy belongs in application/domain decision, not Redis class itself.

---

# STEP 9 — SECURITY RULES

Infrastructure may implement:

* JWT decoder
* OAuth2 resource server config
* Secret manager client
* Encryption utilities

Never store secrets in source code.

---

# STEP 10 — CLEAN EXAMPLE

```java

@Component
@RequiredArgsConstructor
public class PaymentGatewayAdapter implements PaymentGatewayPort {

    private final WebClient client;

    public PaymentGatewayResult charge(PaymentRequest request) {
        return client.post()
                .uri("/charge")
                .retrieve()
                .bodyToMono(PaymentGatewayResult.class)
                .block();
    }
}
```

---

# STEP 11 — TESTING RULES

Infrastructure requires integration tests.

Examples:

* Repository with Testcontainers
* Kafka producer/consumer tests
* WireMock for external API
* Redis integration tests

Validate:

* Mapping correctness
* Connectivity
* Retry behavior
* Error translation

---

# STEP 12 — FINTECH EXAMPLES

Infrastructure adapters:

* Core banking connector
* Wallet ledger DB adapter
* QR provider client
* Payment gateway adapter
* Reconciliation file exporter
* OTP Redis adapter
* Fraud scoring client

---

# STEP 13 — ANTI PATTERNS

Avoid:

* Business logic in repository impl
* Returning entity to controller
* Static util everywhere
* Hardcoded URLs/secrets
* No timeout on API calls
* Huge god adapter handling many systems
* Consumer doing all business rules directly

---

# STEP 14 — GENERATOR RULES FOR AI

When generating infrastructure layer:

1. `adapters/persistence/` — `{repositories/, entities/, mappers/}` — use MapStruct for entity↔domain
2. `adapters/messaging/` — producers only, implement messaging port, no business logic
3. `adapters/scheduler/` — `@Scheduled` adapters, call use cases
4. `adapters/observability/` — Micrometer metrics, implement observability port
5. `client/<service>/` — `{<Service>Adapter.java, client/, request/, response/, mapper/}` per external service
6. Adapter always implements a port from `application/ports/`
7. Use MapStruct mapper in `mapper/` for all cross-layer conversions — no `new Dto(a,b,c,d)`
8. Handle timeout/retry/circuit breaker at Feign config level
9. Map external exceptions → domain exceptions inside adapter
10. Generate integration tests (Testcontainers for DB, WireMock for external APIs)

---

# FINAL CHECKLIST

* [ ] `adapters/persistence/` has `{repositories/, entities/, mappers/}`
* [ ] `adapters/messaging/` contains producers only — no consumers
* [ ] `adapters/scheduler/` and `adapters/observability/` exist if needed
* [ ] Each external service has its own `client/<service>/` sub-package
* [ ] `<Service>Adapter.java` at root of service package, implements `ports/clients/` interface
* [ ] MapStruct mapper in `client/<service>/mapper/` — no `new Dto(a,b,c,d)`
* [ ] No business logic in any adapter
* [ ] `@Entity` never exposed to application or controller layer
* [ ] Secrets externalized — no hardcoded URLs or credentials
* [ ] Integration tested (Testcontainers, WireMock)

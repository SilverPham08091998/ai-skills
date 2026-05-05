# .codex/guidelines/clean-architecture/infrastructure-rule.md

# Clean Architecture Infrastructure Layer Rules

---

# STEP 1 — OBJECTIVE

Infrastructure layer handles all technical details and external systems.

It implements ports defined by inner layers.

Goals:

* Connect database
* Call third-party services
* Publish / consume messages
* Cache data
* Handle file storage
* Provide technical integrations

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

Use persistence adapters.

Example:

```java

@RequiredArgsConstructor
public class WalletRepositoryAdapter implements WalletRepositoryPort {

    private final WalletJpaRepository repo;
    private final WalletEntityMapper mapper;
}
```

Responsibilities:

* Convert Entity <-> Domain
* Execute DB operations
* Hide ORM details

Never expose JPA entity upward.

---

# STEP 6 — EXTERNAL CLIENT RULES

Examples:

* Payment gateway client
* Bank API client
* Fraud engine client
* Notification provider

Use:

* Feign
* WebClient
* RestTemplate (legacy)

Handle:

* Timeout
* Retry
* Circuit breaker
* Error mapping

---

# STEP 7 — MESSAGING RULES

Kafka / RabbitMQ adapters:

Producer responsibilities:

* Serialize events
* Add headers
* Publish reliably

Consumer responsibilities:

* Deserialize
* Validate schema
* Call UseCase
* Handle retry / DLQ

No business logic inside consumer listener.

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

1. Implement ports only
2. Keep technical concerns isolated
3. Add entity/domain mappers
4. Configure timeout/retry
5. Handle exceptions cleanly
6. No business rules
7. Generate integration tests

---

# FINAL CHECKLIST

* [ ] Ports implemented
* [ ] No business logic
* [ ] Entity hidden from upper layers
* [ ] Clients have timeout/retry
* [ ] Messaging isolated
* [ ] Secrets externalized
* [ ] Integration tested
* [ ] Replaceable adapters

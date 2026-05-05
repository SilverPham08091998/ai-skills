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

# STEP 3 — CONTROLLER LAYER

Responsibilities:

* Receive HTTP / Kafka / gRPC requests
* Validate input
* Convert DTO to Command
* Call UseCase
* Return response

Allowed:

* Request DTO
* Response DTO
* Bean Validation
* Mapper

Forbidden:

* Business logic
* Repository access
* SQL
* Transaction rules

Example:

```java

@PostMapping("/transfer")
public ResponseEntity<?> transfer(@RequestBody @Valid TransferRequest req) {
    return ok(mapper.toResponse(useCase.execute(mapper.toCommand(req))));
}
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

Responsibilities:

* Database adapters
* REST clients
* Kafka producer/consumer
* Redis adapters
* File storage
* Security provider

Allowed:

* Spring Data JPA
* Feign/WebClient
* KafkaTemplate
* RedisTemplate

Forbidden:

* Core business rules
* Cross-usecase orchestration

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

Input Port:

* UseCase interfaces

Output Port:

* Repository interfaces
* External gateway interfaces

Adapters:

* REST controller
* JPA repository adapter
* Kafka adapter

Example:

```java
public interface WalletRepository {
    Optional<Wallet> findById(String id);
}
```

---

# STEP 9 — PACKAGE STRUCTURE

```text
com.company.payment
 ├── controller
 ├── application
 │   ├── usecase
 │   ├── command
 │   └── port
 ├── domain
 │   ├── model
 │   ├── service
 │   └── exception
 └── infrastructure
     ├── persistence
     ├── client
     └── messaging
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

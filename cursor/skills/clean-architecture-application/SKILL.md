---
name: clean-architecture-application
description: Application-layer and use case rules for Clean Architecture backend services. Use when orchestrating business flows, ports, and transactions.
---

# Clean Architecture Application Guidelines

This Cursor skill adapts `backend-engineer/clean-architecture/application-rule.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# cursor/guidelines/clean-architecture/application-rule.md

# Clean Architecture Application Layer Rules

---

# STEP 1 — OBJECTIVE

Application layer orchestrates use cases and business flows.

It sits between Controller and Domain/Infrastructure.

Goals:

* Execute user/business use cases
* Coordinate domain objects
* Manage transactions
* Call ports/adapters
* Enforce application policies
* Keep controller thin

Package structure:

```text
application/
├── usecases/                  ← use case interfaces grouped by domain
│   └── <domain>/
│       └── impl/              ← use case implementations
├── services/                  ← application services (cross-usecase helpers)
├── events/                    ← event schema / message models (Kafka payload types, NOT consumers)
├── dtos/                      ← commands, queries, result objects
├── mappers/                   ← application-level mappers (if needed)
└── ports/                     ← output port interfaces (implemented by infrastructure)
    ├── clients/               ← external service ports (FeeServicePort, MfaServicePort)
    ├── persistence/           ← repository ports (PaymentAccountRepositoryPort)
    ├── messaging/             ← outbound messaging ports (StatementJobPublisherPort)
    └── observability/         ← metrics ports (OperationalMetricsPort)
```

Rule:
`Application layer controls the flow, not the business essence.`

---

# STEP 2 — RESPONSIBILITIES

Application layer is allowed to:

* Receive Command / Query objects
* Execute UseCases
* Coordinate multiple domain models
* Start / commit transactions
* Call repositories through ports
* Publish domain/integration events
* Apply idempotency flow
* Authorization checks at use-case level if needed
* Return Result DTOs

---

# STEP 3 — STRICTLY FORBIDDEN

Application layer must NOT contain:

* HTTP request/response handling
* Controller annotations logic
* Raw SQL queries
* JPA entity leakage to upper layers
* Framework-heavy code everywhere
* UI formatting logic
* Low-level infra client details

Bad Example:

```java
return ResponseEntity.ok(...)
```

---

# STEP 4 — STANDARD FLOW

```text
Controller
-> Command
-> UseCase.execute(command)
-> Load domain objects via ports
-> Execute business rules
-> Persist changes via ports
-> Publish events
-> Return Result
```

---

# STEP 5 — COMMAND / QUERY RULES

Use dedicated models:

Examples:

* CreatePaymentCommand
* TransferMoneyCommand
* GetWalletQuery
* RefundPaymentCommand

Command contains input required by use case only.

---

# STEP 6 — USECASE RULES

Use one class per use case. Group by domain under `usecases/<domain>/impl/`.

```text
usecases/
├── payment/
│   ├── OpenPaymentAccountUseCase.java        ← interface
│   ├── LockPaymentAccountUseCase.java
│   └── impl/
│       ├── OpenPaymentAccountUseCaseImpl.java ← implementation
│       └── LockPaymentAccountUseCaseImpl.java
├── savings/
│   └── impl/
├── statement/
│   └── impl/
└── operations/
    └── impl/
```

Prefer single public method:

```java
PaymentResult execute(CreatePaymentCommand cmd)
```

Use case interface is what the controller depends on. Implementation is in `impl/` and wired by Spring.

---

# STEP 7 — TRANSACTION RULES

Transaction boundary usually belongs here.

Example:

```java

@Transactional
public TransferResult execute(...) {
}
```

Use transaction for:

* Update multiple aggregates carefully
* Save + outbox pattern
* Idempotent write flow

Avoid giant transaction with remote API calls.

---

# STEP 8 — PORTS RULES

Depend on port interfaces only — never import infrastructure implementation directly.

Ports are categorized into 4 groups under `application/ports/`:

| Category | Package | Examples |
|----------|---------|---------|
| External clients | `ports/clients/` | `FeeServicePort`, `MfaServicePort`, `CoreBankingPort` |
| Persistence | `ports/persistence/` | `PaymentAccountRepositoryPort`, `UserRepositoryPort` |
| Outbound messaging | `ports/messaging/` | `StatementJobPublisherPort` |
| Observability | `ports/observability/` | `OperationalMetricsPort` |

```java
// ports/clients/MfaServicePort.java
public interface MfaServicePort {
    MfaInitResult initiate(String transactionId, String productCode, String userId);
    MfaVerifyResult verify(String challengeId, String userId, String mfaCode);
}

// ports/persistence/PaymentAccountRepositoryPort.java
public interface PaymentAccountRepositoryPort {
    Optional<PaymentAccount> findByAccountNo(String accountNo);
    PaymentAccount save(PaymentAccount account);
}
```

Application uses ports, infrastructure implements them.

---

# STEP 9 — RESULT OBJECT RULES

Return dedicated result objects.

Examples:

* TransferResult
* PaymentResult
* RefundResult

Do not return entity directly.

---

# STEP 10 — CLEAN EXAMPLE

```java

@RequiredArgsConstructor
public class TransferUseCase {

    private final WalletRepositoryPort walletRepo;
    private final LedgerPort ledgerPort;

    @Transactional
    public TransferResult execute(TransferCommand cmd) {
        Wallet from = walletRepo.load(cmd.fromWalletId());
        Wallet to = walletRepo.load(cmd.toWalletId());

        from.debit(cmd.amount());
        to.credit(cmd.amount());

        walletRepo.save(from);
        walletRepo.save(to);
        ledgerPort.postTransfer(cmd);

        return new TransferResult("SUCCESS");
    }
}
```

---

# STEP 11 — FINTECH RULES

Application layer handles:

* Idempotency key validation
* Duplicate request prevention
* Saga / compensation orchestration
* Outbox event publishing
* Retry policy trigger
* Reconciliation kickoff

Examples:

* Transfer flow
* Bill payment flow
* QR payment flow
* Refund flow

---

# STEP 12 — ERROR HANDLING RULES

Throw meaningful exceptions:

* WalletNotFoundException
* InsufficientBalanceException
* DuplicateRequestException
* PaymentTimeoutException

Do not return null.

---

# STEP 13 — TESTING RULES

Use unit tests with mocked ports.

Test:

* Success flow
* Validation/business failures
* Duplicate request
* Dependency failure
* Event published

Example:

```java

@Mock
WalletRepositoryPort repo;
@InjectMocks
TransferUseCase useCase;
```

---

# STEP 14 — ANTI PATTERNS

Avoid:

* God service with 2000 lines
* One service handling all use cases
* Returning ResponseEntity
* Direct SQL in use case
* Calling external APIs inside long DB transaction
* Putting all business logic in application layer and empty domain

---

# STEP 15 — GENERATOR RULES FOR AI

When generating application layer:

1. Group use cases by domain: `usecases/<domain>/` with interface + `impl/`
2. Input = Command / Query (in `dtos/`)
3. Output = Result object (in `dtos/`)
4. Depend on port interfaces only — never import infrastructure class
5. Categorize ports: `ports/clients/`, `ports/persistence/`, `ports/messaging/`, `ports/observability/`
6. Place event schema/payload classes in `application/events/` — NOT consumers (consumers go in `controllers/events/consumers/`)
7. Add `@Transactional` where needed
8. Keep orchestration readable
9. Throw domain/business exceptions — never return null
10. Generate unit tests with mocked ports

---

# FINAL CHECKLIST

* [ ] Use cases grouped by domain in `usecases/<domain>/impl/`
* [ ] Input = Command/Query, Output = Result (all in `dtos/`)
* [ ] Ports categorized: `clients/`, `persistence/`, `messaging/`, `observability/`
* [ ] Event schema/models in `application/events/` — NOT consumers
* [ ] Depends on port interfaces only — no infrastructure import
* [ ] Transaction boundary correct
* [ ] No HTTP logic, no `ResponseEntity`
* [ ] Throws named business exceptions, never returns null
* [ ] Tested with mocked ports


## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.

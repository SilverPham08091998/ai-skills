# Design Patterns Guidelines

## Purpose

Design patterns are reusable solutions to common software design problems.

Use patterns to improve:

- maintainability
- extensibility
- readability
- scalability
- testability

Do NOT use patterns for decoration or unnecessary complexity.

Rule:
Use the simplest pattern that solves a real problem.

---

# 1. General Principles

Before applying a pattern ask:

- What problem am I solving?
- Is pattern necessary?
- Will this reduce coupling?
- Will future engineers understand it?
- Is simpler code enough?

Avoid pattern obsession.

---

# 2. Prefer Composition Over Inheritance

Use object collaboration instead of deep inheritance.

Good:

PaymentService uses Validator + Gateway + Repository

Bad:

BaseService -> PaymentBaseService -> WalletPaymentBaseService

Use inheritance only when strong "is-a" relationship exists.

---

# 3. SOLID Friendly Patterns

Preferred patterns should support:

- Single responsibility
- Open/closed
- Dependency inversion
- Testability

---

# CREATIONAL PATTERNS

# 4. Builder Pattern

## Use When

- many constructor parameters
- optional fields
- immutable object creation
- readable object setup

Good:

PaymentRequest.builder()
.customerId(id)
.amount(amount)
.currency("VND")
.build()

Use for:

- DTO
- Command objects
- Config objects

Avoid builder for tiny 2-field objects.

---

# 5. Factory Pattern

## Use When

Creation logic varies by type.

Example:

PaymentGatewayFactory.create(provider)

Returns:

- MomoGateway
- ZaloPayGateway
- BankGateway

Use when object creation contains logic.

---

# 6. Abstract Factory

Use for families of related objects.

Example:

RegionalPaymentFactory:

- createGateway()
- createFeePolicy()
- createFraudRule()

Use rarely unless clear need.

---

# 7. Singleton Pattern

Use for stateless shared objects managed safely by framework.

Examples:

- Spring Beans
- Config providers

Avoid manual singleton with global state.

Bad:

public static Singleton INSTANCE;

---

# STRUCTURAL PATTERNS

# 8. Adapter Pattern

Use to integrate incompatible interfaces.

Example:

LegacyBankApi -> BankTransferGateway

Wrap provider SDK into internal standard interface.

Very useful in fintech integrations.

---

# 9. Facade Pattern

Provide simple interface over complex subsystem.

Example:

PaymentFacade.process()

Internally:

- validate
- reserve balance
- call provider
- persist
- publish event

Good for orchestration entrypoints.

---

# 10. Decorator Pattern

Add behavior without changing original class.

Example:

Gateway with:

- LoggingDecorator
- RetryDecorator
- MetricsDecorator

Useful for cross-cutting concerns.

---

# 11. Proxy Pattern

Control access to real object.

Examples:

- lazy loading
- remote proxy
- security checks
- caching wrapper

---

# 12. Composite Pattern

Tree structures.

Examples:

- menu hierarchy
- organization tree
- rule groups

Use when part-whole hierarchy exists.

---

# BEHAVIORAL PATTERNS

# 13. Strategy Pattern

Use when multiple interchangeable algorithms exist.

Example:

FeeCalculationStrategy:

- FlatFeeStrategy
- PercentageFeeStrategy
- TieredFeeStrategy

Very recommended.

---

# 14. Template Method

Base flow fixed, steps customizable.

Example:

AbstractPaymentProcessor:

process():

- validate()
- execute()
- notify()

Subclass overrides execute().

Use sparingly.
Prefer Strategy when possible.

---

# 15. Chain of Responsibility

Pass request through handlers.

Example:

FraudCheckChain:

- VelocityCheck
- BlacklistCheck
- LimitCheck

Good for validations and filters.

---

# 16. Observer Pattern

One event triggers many subscribers.

Example:

PaymentCompleted:

- send notification
- analytics update
- reward points
- audit log

Modern version:
event-driven / Kafka / Spring events

---

# 17. Command Pattern

Wrap action into object.

Example:

CreatePaymentCommand
RefundPaymentCommand

Useful in clean architecture use cases.

---

# 18. State Pattern

Behavior changes by internal state.

Example:

TransactionStatus:

- Pending
- Approved
- Failed
- Reversed

Use when many state-specific rules exist.

---

# 19. Specification Pattern

Encapsulate business rules.

Example:

EligibleForLoanSpecification

Combine:

isActive AND hasIncome AND noFraudFlag

Great for domain rules.

---

# ENTERPRISE / MODERN PATTERNS

# 20. Repository Pattern

Abstract persistence access.

Good:

CustomerRepository.findById()

Avoid leaking SQL everywhere.

---

# 21. Service Layer Pattern

Business operations grouped in services.

Examples:

PaymentService
WalletService
SettlementService

---

# 22. Dependency Injection

Use framework-managed injection.

Benefits:

- testability
- loose coupling
- cleaner composition

Prefer constructor injection.

---

# 23. Unit of Work

Group changes into transaction.

Common with Spring @Transactional.

Use when multiple updates must succeed together.

---

# 24. CQRS

Separate read and write models.

Use when:

- read complexity high
- write rules complex
- scaling differs

Avoid for simple CRUD.

---

# 25. Event Driven Pattern

Use domain events / Kafka.

Example:

PaymentCompleted -> reward service consumes.

Use for loose coupling.

---

# CLEAN ARCHITECTURE FRIENDLY PATTERNS

# 26. Port and Adapter

Use interfaces in application/domain.

Example:

PaymentGatewayPort
NotificationPort

Adapters implement infrastructure details.

Highly recommended.

---

# 27. Use Case Pattern

One business action = one use case.

Examples:

CreatePaymentUseCase
RefundPaymentUseCase
TransferMoneyUseCase

---

# WHEN NOT TO USE PATTERNS

# 28. Anti-Patterns

Do NOT use patterns when:

- simple if/else is enough
- only one implementation exists forever
- adds more files than value
- team cannot understand it
- pattern used just for interview style

---

# 29. Common Misuses

Bad:

PaymentManagerFactoryBuilderAdapterUtil

Bad:

10 interfaces for tiny CRUD service

Bad:

AbstractBaseSuperService hierarchy

---

# 30. Pattern Selection Guide

If problem is...

Multiple algorithms:
-> Strategy

Complex object creation:
-> Builder / Factory

External provider integration:
-> Adapter

Cross-cutting behaviors:
-> Decorator

Many subscribers:
-> Observer / Event

Business rule chain:
-> Chain of Responsibility

Persistence abstraction:
-> Repository

Layer boundary:
-> Port and Adapter

---

# 31. Fintech Examples

## Payment Provider Integration

Use:

- Adapter
- Strategy
- Factory

## Fraud Engine

Use:

- Chain
- Specification
- Strategy

## Ledger Posting

Use:

- Command
- Template
- Event Driven

---

# 32. Testing Considerations

Prefer patterns that improve testability.

Good:
inject interfaces, mock dependencies.

Bad:
static singleton global state.

---

# 33. Naming Rules

Use explicit names:

PaymentGatewayFactory
FeeCalculationStrategy
BankApiAdapter
FraudRuleChain

Avoid vague names:
Helper
Manager
ProcessorX

---

# 34. Review Checklist

Before merge ask:

- What problem does this pattern solve?
- Simpler alternative available?
- Easier to test?
- Reduces coupling?
- Naming clear?
- Team can maintain it?
- Too many abstractions?

---

# 35. Mandatory For AI Code Generation

When generating code:

- Use patterns only for real need
- Prefer Strategy, Builder, Adapter, Repository
- Prefer composition over inheritance
- Keep naming explicit
- Avoid overengineering
- Optimize for maintainability
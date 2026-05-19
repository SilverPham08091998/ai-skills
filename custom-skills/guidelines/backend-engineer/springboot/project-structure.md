# Spring Boot Project Structure Guidelines

## Purpose

Define a scalable, maintainable, enterprise-grade project structure for Spring Boot applications.

Goals:

- clear ownership
- modular design
- clean architecture support
- easier onboarding
- testability
- long-term maintainability

Applies to:

- monoliths
- microservices
- fintech services
- internal APIs
- event-driven services

---

# 1. Core Principle

Organize by business domain first, technical layer second.

Prefer:

payment/
customer/
wallet/
fraud/

Avoid:

controller/
service/
repository/
util/

Reason:
Business-oriented structure scales better.

---

# 2. Recommended High-Level Structure

src/main/java/com/company/service/

- common/
- config/
- shared/
- payment/
- customer/
- wallet/
- fraud/
- integration/

Example:

com.company.paymentservice
├── config
├── common
├── payment
├── customer
└── wallet

---

# 3. Domain Module Structure

Each business module should contain its own layers.

Example:

payment/
├── controller/
├── application/
├── domain/
├── infrastructure/
├── mapper/
└── model/

---

# 4. Clean Architecture Preferred Structure

payment/

controller/

- PaymentController
- request/
- response/

application/

- usecase/
- command/
- result/

domain/

- model/
- service/
- repository/

infrastructure/

- persistence/
- client/
- messaging/

mapper/

- PaymentMapper

---

# 5. Example Full Structure

payment/
├── controller/
│ ├── PaymentController.java
│ ├── request/
│ └── response/
│
├── application/
│ ├── CreatePaymentUseCase.java
│ ├── command/
│ └── result/
│
├── domain/
│ ├── Payment.java
│ ├── PaymentRepository.java
│ └── PaymentDomainService.java
│
├── infrastructure/
│ ├── persistence/
│ ├── client/
│ └── kafka/
│
└── mapper/

---

# 6. Package Responsibilities

## controller

Handles:

- REST endpoints
- request validation
- response mapping
- HTTP concerns only

Must NOT contain:

- business logic
- DB logic

## application

Handles:

- use cases
- orchestration
- transactions
- calling domain ports

## domain

Contains:

- core business rules
- entities
- value objects
- domain services
- repository interfaces

## infrastructure

Contains:

- JPA repositories
- external API clients
- Kafka adapters
- Redis
- file storage

---

# 7. Common Shared Modules

Use carefully.

common/

- exceptions
- constants
- base response

config/

- Spring config
- security config
- bean config

shared/

- reusable utilities with clear ownership

Avoid giant dumping ground folders.

---

# 8. Naming Conventions

Use singular business module names.

Good:

payment
customer
wallet

Avoid:

paymentsModule
customerStuff

Classes:

PaymentController
CreatePaymentUseCase
PaymentRepository

---

# 9. Request / Response Separation

Keep API models isolated.

Good:

controller/request/CreatePaymentRequest
controller/response/CreatePaymentResponse

Avoid exposing domain/entity directly.

---

# 10. DTO / Command / Result Flow

Controller:

Request -> Command

Application:

Command -> Domain -> Result

Controller:

Result -> Response

Keeps layers clean.

---

# 11. Configuration Structure

config/

Examples:

SecurityConfig
JacksonConfig
OpenApiConfig
KafkaConfig
DatasourceConfig

Keep config classes focused.

---

# 12. Exception Structure

common/exception/

Examples:

BusinessException
ValidationException
NotFoundException
GlobalExceptionHandler

Do not scatter exceptions randomly.

---

# 13. Constants Structure

Use constants only when meaningful.

Examples:

ErrorCodes
ApiPaths
KafkaTopics

Avoid giant Constants.java dumping file.

---

# 14. Utilities Rule

Avoid generic util package.

Bad:

utils/
StringUtil
CommonUtil
DateUtilEverything

Prefer domain-owned helpers.

---

# 15. Integration Structure

For external systems:

integration/
├── bank/
├── wallet/
├── provider/
└── notification/

Each contains:

- client
- request
- response
- mapper

---

# 16. Persistence Structure

infrastructure/persistence/

Examples:

entity/
repository/
specification/

Good:

PaymentEntity
JpaPaymentRepository

---

# 17. Messaging Structure

infrastructure/messaging/

Examples:

producer/
consumer/
event/

Good:

PaymentCreatedProducer
RefundCompletedConsumer

---

# 18. Test Structure Mirrors Source

src/test/java same package layout.

Example:

payment/controller/PaymentControllerTest
payment/application/CreatePaymentUseCaseTest

---

# 19. Monolith Modularization

Even in monoliths, separate bounded contexts.

Example:

customer/
payment/
ledger/
notification/

Avoid giant service package.

---

# 20. Microservice Structure

Per microservice keep same internal structure.

payment-service
wallet-service
customer-service

Consistency across services matters.

---

# 21. Fintech Recommended Modules

payment/
wallet/
ledger/
settlement/
fraud/
customer/
otp/
notification/

---

# 22. Security Structure

security/

Examples:

JwtFilter
AuthService
PermissionEvaluator

Or under config/security.

Keep auth logic organized.

---

# 23. API Versioning Structure

controller/v1/
controller/v2/

Use only when needed.

Avoid premature versions.

---

# 24. Generated Code Placement

generated/

or target/build generated sources.

Do not mix generated files manually with business code.

---

# 25. Resource Structure

src/main/resources/

application.yml
application-dev.yml
application-uat.yml
db/migration/
templates/

---

# 26. Migration Structure

Use Flyway/Liquibase.

db/migration/

V1__init.sql
V2__create_payment_table.sql

Consistent naming mandatory.

---

# 27. Anti-Patterns

Avoid:

service/
controller/
repo/
util/
model/

single flat package with 300 files.

Avoid:

PaymentService doing controller + DB + provider + kafka.

---

# 28. Refactor Triggers

Restructure when:

- package has > 30 mixed classes
- ownership unclear
- circular dependencies appear
- onboarding confusion
- feature work touches many unrelated folders

---

# 29. Example Enterprise Layout

com.company.paymentservice
├── config
├── common
├── payment
├── wallet
├── ledger
├── fraud
└── integration

---

# 30. Review Checklist

Before merge ask:

- Organized by domain?
- Layer boundaries clear?
- Controller thin?
- Domain isolated?
- Infra separated?
- Requests/responses isolated?
- Test package mirrors source?
- Any util dumping ground?
- Easy for new engineer to navigate?

---

# 31. Mandatory For AI Code Generation

When generating Spring Boot code:

- Use domain-first package structure
- Use clean architecture inside modules
- Keep controller thin
- Separate request/response models
- Separate infrastructure adapters
- Mirror test structure
- Avoid generic util/common dumping grounds
- Optimize for long-term maintainability
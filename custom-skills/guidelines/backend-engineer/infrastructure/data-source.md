# Data Source Guidelines

## Objective

Define standards for implementing data sources in the Infrastructure layer for databases, caches, message brokers, files, and external systems within Clean Architecture.

---

## Role of Data Source

A Data Source is a technical component responsible for reading/writing data from a specific storage or provider.

Examples:

* MySQL / PostgreSQL
* Redis
* Kafka
* S3 / MinIO
* REST partner API
* gRPC service
* File system

It belongs to Infrastructure layer.

---

## Clean Architecture Position

### Dependency Direction

Domain <- Application <- Infrastructure

Infrastructure implements ports defined by Application.

### Good Flow

UseCase -> Port -> Repository Adapter -> Data Source

### Bad Flow

Controller -> Data Source directly

Domain -> JPA Repository directly

---

## Responsibilities

### Must Handle

* Read/write technical data
* Query execution
* Serialization / deserialization
* Retry / timeout integration config
* Connection usage
* Error translation to infra exceptions
* Mapping raw result to persistence model

### Must NOT Handle

* Business rules
* Use case orchestration
* HTTP response logic
* Domain decision making

---

## Package Structure Example

```text
infrastructure/
 └── datasource/
      ├── mysql/
      ├── redis/
      ├── kafka/
      ├── partner/
      └── s3/
```

---

## Naming Standard

### Good

* WalletJpaDataSource
* TransactionRedisDataSource
* PaymentPartnerDataSource
* LedgerKafkaDataSource
* ReceiptS3DataSource

### Bad

* CommonUtil
* DataManager
* HelperService
* TempRepo

---

## Database Data Source

### Example Responsibility

* execute query
* save entity
* pagination
* batch update
* transaction participation

### Good Example

```java
public interface WalletJpaDataSource {
    Optional<WalletEntity> findById(String id);
    WalletEntity save(WalletEntity entity);
}
```

---

## Cache Data Source

### Use Cases

* OTP cache
* session/token cache
* idempotency key cache
* hot reference data

### Rules

* TTL mandatory when applicable
* key naming standard
* serialization stable
* avoid unlimited growth

### Example Keys

* otp:user:123
* idempotency:transfer:abc123

---

## Messaging Data Source

### Kafka / Queue

Responsibilities:

* publish message
* consume raw message
* ack/nack mechanics
* serializer config

### Rules

* schema versioning
* retry strategy
* DLQ support
* trace id propagation

---

## External API Data Source

### Responsibilities

* call partner API
* auth header generation
* request signing
* timeout
* retry/backoff
* response parsing

### Must Include

* connection timeout
* read timeout
* circuit breaker if critical
* sanitized logging

---

## File / Object Storage Data Source

### Examples

* upload receipt PDF
* download statement file
* archive reports

### Rules

* validate content type
* size limits
* encryption if sensitive
* pre-signed URL if needed

---

## Mapping Rules

### Separate Models

Use:

* Domain Model
* Persistence Entity
* External DTO
* Event Payload

Do not leak JPA entity into Domain.

### Preferred

Use MapStruct mapper adapters.

---

## Error Handling

### Convert Technical Errors

Examples:

* SQL timeout -> DataAccessException
* 504 partner timeout -> ExternalSystemTimeoutException
* serialization fail -> InfrastructureException

Do not expose vendor-specific exceptions upward.

---

## Transactions

### Rules

* Transaction boundary usually in Application layer
* Data source participates only
* Avoid starting hidden nested transactions

---

## Performance Standards

### Database

* indexes reviewed
* avoid N+1 queries
* use pagination
* batch writes when possible

### Cache

* compact payload
* TTL sensible

### HTTP Client

* connection pooling enabled

---

## Security Standards

* Never hardcode credentials
* Use secret manager/env vars
* Mask sensitive logs
* Encrypt sensitive data at rest if needed
* TLS enabled for external calls

---

## Observability

### Must Emit

* latency metrics
* success/failure count
* timeout count
* retry count
* trace/span ids

### Logs Should Include

* request id
* partner name
* operation
* duration

---

## Testing Strategy

### Unit Test

* mapper logic
* retry wrapper logic
* exception translation

### Integration Test

* DB queries
* Redis behavior
* Kafka publish/consume
* HTTP stub interactions

Use Testcontainers where possible.

---

## Fintech / Banking Rules

### Must Ensure

* idempotent writes for transfers/payments
* no duplicate ledger posting
* audit references stored
* reconciliation fields available
* exact decimal precision preserved

---

## Anti Patterns

* Business logic inside repository/data source
* Returning JPA entity to controller
* Hardcoded SQL everywhere without structure
* No timeout on partner calls
* Logging account numbers unmasked
* Massive god repository class

---

## Example Flow

TransferMoneyUseCase
-> WalletRepositoryPort
-> WalletRepositoryAdapter
-> WalletJpaDataSource
-> MySQL

---

## Review Checklist

* [ ] Single responsibility clear
* [ ] No business logic leakage
* [ ] Proper timeout/retry config
* [ ] Errors translated cleanly
* [ ] Models separated correctly
* [ ] Metrics/logging present
* [ ] Secure credential handling
* [ ] Tested properly

---

## Golden Rule

A data source should solve technical persistence/integration concerns only, never business decisions.

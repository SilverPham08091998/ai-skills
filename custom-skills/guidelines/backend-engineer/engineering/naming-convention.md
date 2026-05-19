# Naming Convention Guidelines

## Purpose

Consistent naming improves readability, maintainability, onboarding speed, and code quality.

Good names reduce bugs because engineers understand intent faster.

Rules apply to:

- Classes
- Interfaces
- Methods
- Variables
- Packages
- Database objects
- APIs
- Events
- Tests

---

# 1. General Principles

Names must be:

- Clear
- Specific
- Intentional
- Consistent
- Searchable
- Domain meaningful

Avoid names that are:

- vague
- generic
- abbreviated without standard meaning
- misleading
- overloaded

---

# 2. Golden Rule

Prefer explicit names over short names.

Bad:
x
tmp
data
obj
manager
handler

Good:
customerId
retryCount
paymentRequest
transactionStatus
paymentProcessor

---

# 3. Class Naming

Use PascalCase.

Use nouns.

Examples:

PaymentService
OrderRepository
CustomerValidator
FraudDecisionEngine
WalletBalanceCalculator

Avoid:

DoEverything
CommonUtil
Manager
ProcessorHelper

---

# 4. Interface Naming

Use capability-based names.

Good:

PaymentGateway
NotificationSender
CustomerRepository

Optional:

PaymentGatewayPort
OrderRepositoryPort

Avoid:

IPaymentService
IHandler

---

# 5. Abstract Class Naming

Use clear intent.

Examples:

AbstractPaymentProcessor
BaseRetryableConsumer

Use sparingly.

Avoid unnecessary inheritance.

---

# 6. Method Naming

Use camelCase.

Use verbs.

Examples:

createPayment()
validateRequest()
findCustomer()
calculateFee()
publishEvent()
markAsFailed()

Boolean methods:

isActive()
hasBalance()
canRetry()
shouldEscalate()

Avoid:

doStuff()
handle()
run()
process()   // unless context is obvious

---

# 7. Variable Naming

Use camelCase.

Be specific.

Good:

customerId
totalAmount
retryAttempt
paymentStatus
requestTimestamp

Bad:

x
tmp
flag
value
data

---

# 8. Collection Naming

Use plural nouns.

Good:

customers
transactions
failedPayments
activeSessions

Bad:

customerListData
arr

---

# 9. Boolean Naming

Use readable prefixes:

is
has
can
should
was

Good:

isVerified
hasPermission
canRetry
shouldNotify

Bad:

verifiedFlag
permissionValue
retryIndicator

---

# 10. Constant Naming

Use UPPER_SNAKE_CASE.

Examples:

MAX_RETRY_COUNT
DEFAULT_TIMEOUT_MS
MANUAL_REVIEW_THRESHOLD
KAFKA_TOPIC_PAYMENT_CREATED

Avoid:

MaxRetry
timeoutValue

---

# 11. Enum Naming

Enum type = singular noun.

Enum values = uppercase.

Good:

PaymentStatus

- PENDING
- SUCCESS
- FAILED

TransferType

- INTERNAL
- EXTERNAL

---

# 12. Package Naming

Use lowercase.

Use business domain first.

Good:

com.company.payment.application
com.company.payment.domain
com.company.payment.infrastructure

Avoid:

com.company.utils
com.company.misc
com.company.commonstuff

---

# 13. DTO Naming

Use suffixes consistently.

Request:
CreatePaymentRequest

Response:
CreatePaymentResponse

Internal transfer object:
PaymentDto

Command:
CreatePaymentCommand

Query:
GetPaymentQuery

Avoid mixed naming:
PaymentReq
PaymentRes
PaymentDataBean

---

# 14. Entity Naming

Use business nouns.

Good:

Customer
PaymentTransaction
WalletAccount
LedgerEntry

Avoid:

CustomerEntityModelData

If JPA entity, keep clean:
CustomerEntity (optional if needed to separate domain)

---

# 15. Repository Naming

Good:

CustomerRepository
PaymentTransactionRepository

Avoid:

CustomerDaoManager
PaymentStorageService

---

# 16. Service Naming

Use clear responsibility.

Good:

PaymentService
RefundService
SettlementService
FraudCheckService

Avoid:

GeneralService
MainService
HelperService

---

# 17. Validator Naming

Good:

PaymentValidator
CustomerEligibilityValidator

Method examples:

validate()
validateForTransfer()

---

# 18. Mapper Naming

Good:

PaymentMapper
CustomerEntityMapper
TransactionResponseMapper

Avoid:

ConvertUtil

---

# 19. Event Naming

Use past tense for completed events.

Good:

PaymentCreated
PaymentCompleted
RefundApproved
CustomerRegistered

Kafka topic examples:

payment.created
payment.completed
refund.approved

Avoid:

createPaymentEvent
payment.do

---

# 20. REST API Naming

Use plural resources.

Good:

GET /payments/{id}
POST /payments
GET /customers/{id}/accounts

Avoid:

/getPayment
/createCustomer
/doTransferNow

---

# 21. Database Naming

## Tables

snake_case singular or plural (choose one standard)

payments
customers
ledger_entries

## Columns

customer_id
created_at
updated_at
total_amount

Avoid:

custId
Amt
dtCreated

---

# 22. Test Naming

Use behavior-based naming.

Good:

shouldCreatePaymentSuccessfully()
shouldRejectExpiredOtp()
shouldReturnEmptyWhenCustomerNotFound()

Avoid:

test1()
runCase()

---

# 23. Temporary Variables

Avoid temp names.

Bad:

tmp
temp2
abc

Good:

calculatedFee
normalizedPhoneNumber
encryptedPayload

---

# 24. Time Variables

Always include unit.

Good:

timeoutMs
durationSeconds
retryAfterMinutes

Bad:

timeout
delay

---

# 25. Money Variables

Always include meaning.

Good:

amount
feeAmount
taxAmount
netAmount
promotionAmount

Avoid:

money
cash
value

---

# 26. IDs

Always suffix with Id.

Good:

customerId
transactionId
walletId
requestId

Avoid:

customer
txn

---

# 27. Abbreviations

Use only common industry abbreviations.

Allowed:
id
url
api
otp
jwt
sms
ttl
db

Avoid unclear abbreviations:

cfg
mgr
prc
txnAmtTmpVal

---

# 28. Forbidden Names

Never use:

misc
helper
util
thing
stuff
manager
common
testData123

Unless responsibility is truly specific.

---

# 29. Rename Triggers

Rename code when:

- meaning unclear
- responsibility changed
- reused incorrectly
- duplicate names in context
- causes confusion in review

---

# 30. Naming Checklist

Before merge ask:

- Is intent obvious?
- Can new engineer understand it?
- Is it specific enough?
- Matches project pattern?
- Any vague names?
- Any misleading names?
- Correct singular/plural?
- Units included where needed?

---

# 31. Mandatory For AI Code Generation

When generating names:

- Prefer explicit over short
- Use domain language
- Avoid generic words
- Respect existing conventions
- Keep names consistent across layers
- Use verbs for methods
- Use nouns for classes
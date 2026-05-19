# Clean Code Guidelines

## Purpose

Write code that is easy to read, easy to change, easy to test, and safe to maintain over time.

Clean code minimizes confusion, reduces bugs, and speeds up delivery.

---

# 1. Code Is Read More Than Written

Always optimize for the next engineer reading the code.

Ask:

- Can someone understand this in 30 seconds?
- Is the intention obvious?
- Would I understand this after 6 months?

---

# 2. Use Meaningful Names

Names must explain intent.

## Classes

Use nouns.

Good:

- PaymentService
- UserRepository
- FraudChecker

Bad:

- Manager
- Helper
- UtilThing

## Methods

Use verbs.

Good:

- createPayment()
- validateRequest()
- loadCustomer()

Bad:

- process()
- doWork()
- handle()

## Variables

Good:
customerId
retryCount
totalAmount

Bad:
x
tmp
val
data

---

# 3. Keep Functions Small

Functions should do one thing.

Preferred:

- 5 to 20 lines
- single purpose
- easy to scan

Bad:

createOrder() {
validate();
save();
sendEmail();
publishKafka();
updateAnalytics();
}

Good:

createOrder() {
validateOrder();
persistOrder();
triggerPostActions();
}

---

# 4. One Level of Abstraction Per Function

Do not mix high-level flow with low-level details.

Bad:

processPayment() {
validate();
if (token == null) throw ...
connection.setTimeout(3000);
}

Good:

processPayment() {
validateRequest();
configureGateway();
}

---

# 5. Avoid Deep Nesting

Use early return.

Bad:

if (user != null) {
if (user.isActive()) {
if (user.hasBalance()) {
...
}
}
}

Good:

if (user == null) return;
if (!user.isActive()) return;
if (!user.hasBalance()) return;

process();

---

# 6. Avoid Boolean Complexity

Bad:

if (isVip && isActive && !isExpired && hasBalance)

Good:

if (eligibleForFastTransfer(customer))

---

# 7. Prefer Intention-Revealing Methods

Bad:

if (a > 3)

Good:

if (exceededRetryLimit(retryCount))

---

# 8. Remove Duplication

Duplicate logic creates defects.

Extract shared behavior when duplication is meaningful.

Bad:

fee = amount * 0.03;
tax = amount * 0.05;

Repeated in 8 files.

Good:

FeeCalculator.calculate(amount)

---

# 9. Avoid Magic Numbers

Bad:

if (retry > 3)

Good:

if (retry > MAX_RETRY_COUNT)

---

# 10. Use Constants for Business Rules

Bad:

if (amount > 50000000)

Good:

if (amount > MANUAL_REVIEW_THRESHOLD)

---

# 11. Comments Are Last Resort

Prefer self-explanatory code.

Bad:

// add 1 to retry
retry++;

Good:

retryCount++;

Use comments only for:

- Why something exists
- Non-obvious constraints
- External provider behavior
- Regulatory rules

---

# 12. Do Not Leave Dead Code

Remove:

- commented old code
- unused methods
- abandoned classes
- temporary hacks after completion

Bad:

// old version kept for later

---

# 13. Keep Classes Focused

Each class should have one reason to change.

Bad:

PaymentService:

- validate
- save
- email
- analytics
- retry scheduler
- PDF export

Good:

PaymentService
PaymentValidator
PaymentNotifier
PaymentReportService

---

# 14. Prefer Composition Over Giant Inheritance

Avoid deep inheritance trees.

Prefer:

PaymentProcessor uses Validator + Gateway + Logger

Instead of:

BaseProcessor -> PaymentBase -> WalletPaymentBase -> QRPaymentBase

---

# 15. Hide Implementation Details

Expose intent, not internals.

Bad:

getInternalMutableList()

Good:

getTransactions()

---

# 16. Error Messages Must Be Useful

Bad:

Invalid request

Good:

Customer account is locked

Bad:

Error 500

Good:

Payment provider timeout after 3 seconds

---

# 17. Fail Fast

Validate early.

Bad:

Process 10 steps then fail on missing customerId.

Good:

Validate required fields first.

---

# 18. Keep Side Effects Obvious

Bad:

calculateTotal() // also writes DB

Good:

calculateTotal()
saveTotal()

---

# 19. Null Handling

Avoid surprise nulls.

Prefer:

- Optional
- empty collections
- validation

Bad:

return null;

Good:

return Optional.empty();

---

# 20. Formatting Matters

Use consistent formatting.

Rules:

- aligned indentation
- blank lines between logical blocks
- readable method spacing
- no giant files

---

# 21. Organize by Domain Meaning

Prefer:

payment/
wallet/
fraud/
customer/

Instead of:

utils/
common/
misc/
helper/

---

# 22. Testable Code

Write code that can be tested easily.

Prefer:

- injected dependencies
- deterministic outputs
- no hidden globals

Bad:

new HttpClient() inside method

Good:

constructor injected client

---

# 23. Clean Logging

Log events with context.

Good:

Payment failed customerId=123 txnId=abc reason=timeout

Bad:

failed

Never log:

- passwords
- tokens
- secrets
- card full numbers

---

# 24. Refactor Continuously

When touching code:

- improve names
- remove duplication
- split large methods
- improve tests

Leave code cleaner than found.

---

# 25. Red Flags

Immediate cleanup candidates:

- method > 50 lines
- class > 500 lines
- nested if depth > 3
- repeated copy/paste logic
- vague names
- too many constructor params
- utility class with 100 methods

---

# 26. Clean Code Checklist

Before merge ask:

- Is purpose obvious?
- Good names?
- Small methods?
- Minimal nesting?
- Duplicate logic removed?
- Errors clear?
- Tests added?
- Logs useful?
- Easy to modify later?

---

# 27. Mandatory For AI Code Generation

When generating code:

- Use explicit names
- Small focused methods
- No giant utility classes
- No vague abstractions
- Clear errors
- Testable structure
- Follow project style
- Clean before clever
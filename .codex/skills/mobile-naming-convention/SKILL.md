---
name: mobile-naming-convention
description: Mobile naming conventions for React Native and TypeScript code. Use when naming files, folders, components, hooks, state, and APIs.
---

# Mobile Naming Convention Guidelines

This Codex skill adapts `mobile-engineer/foundation/naming-convention.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🏷️ NAMING CONVENTION (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define consistent naming rules for Mobile Engineer to ensure:

* Readability
* Consistency
* Predictability
* Easy collaboration

Applied for:

* React Native (TypeScript)
* iOS (Swift)
* Android (Kotlin / Java)

---

# ========================

# 🔥 GENERAL RULES

# ========================

## 1. USE DESCRIPTIVE NAMES

Names must clearly describe purpose.

### ❌ BAD

```ts
const data = res.data;
```

### ✅ GOOD

```ts
const transactionList = response.data.transactions;
```

---

## 2. AVOID ABBREVIATION

### ❌ BAD

```ts
const usr = getUsr();
```

### ✅ GOOD

```ts
const user = getUser();
```

---

## 3. BE CONSISTENT

Same meaning → same name across project.

Example:

* userId (NOT uid, user_id, idUser)
* transactionId (NOT txnId, txId)

---

## 4. BOOLEAN MUST BE CLEAR

### ❌ BAD

```ts
const status = true;
```

### ✅ GOOD

```ts
const isLoading = true;
const hasError = false;
const isAuthenticated = true;
```

---

## 5. FUNCTION NAME = ACTION

### ❌ BAD

```ts
const data = () => {};
```

### ✅ GOOD

```ts
const fetchUserProfile = () => {};
const submitTransfer = () => {};
```

---

## 6. CONSTANT = UPPER_CASE

```ts
const MAX_RETRY = 3;
const TRANSACTION_SUCCESS = 'SUCCESS';
```

---

# ========================

# ⚙️ REACT NATIVE NAMING

# ========================

## 1. COMPONENT

Format: PascalCase

```tsx
TransferScreen
TransactionItem
UserProfileCard
```

---

## 2. HOOK

Format: use + Feature

```ts
useTransfer
useLogin
useTransactionHistory
```

---

## 3. FILE NAME

```txt
transfer.screen.tsx
transfer.hook.ts
transfer.service.ts
```

---

## 4. EVENT HANDLER

```ts
handleSubmit
handleLogin
handleAmountChange
```

---

## 5. STATE VARIABLE

```ts
const [isLoading, setIsLoading]
const [transactionList, setTransactionList]
```

---

# ========================

# 🍏 SWIFT NAMING

# ========================

## 1. CLASS / STRUCT

```swift
TransferViewController
TransactionViewModel
UserService
```

---

## 2. VARIABLE

```swift
var isLoading: Bool
var transactionList: [Transaction]
```

---

## 3. FUNCTION

```swift
func fetchUserProfile()
func submitTransfer()
```

---

## 4. ENUM

```swift
enum TransactionStatus {
    case pending
    case success
    case failed
}
```

---

# ========================

# 🤖 ANDROID NAMING

# ========================

## 1. CLASS

```kotlin
TransferActivity
TransactionViewModel
UserRepository
```

---

## 2. VARIABLE

```kotlin
val isLoading = true
val transactionList = listOf<Transaction>()
```

---

## 3. FUNCTION

```kotlin
fun fetchUserProfile()
fun submitTransfer()
```

---

## 4. STATE

```kotlin
sealed class UiState {
    object Loading : UiState()
    data class Success(val data: Any) : UiState()
    data class Error(val message: String) : UiState()
}
```

---

# ========================

# 🔐 FINTECH NAMING RULE

# ========================

## 1. USE DOMAIN LANGUAGE

Always use business terms:

* transaction
* transfer
* payment
* wallet
* balance

---

## 2. REQUEST / RESPONSE

```ts
TransferRequest
TransferResponse
ConfirmTransactionRequest
```

---

## 3. ID NAMING

```ts
transactionId
requestId
userId
```

---

## 4. STATUS NAMING

```ts
transactionStatus
paymentStatus

// values
PENDING
SUCCESS
FAILED
```

---

# ========================

# 🧪 AI RULE

# ========================

AI MUST:

* Use clear and meaningful names
* Follow naming convention strictly
* Use domain-based naming
* Keep naming consistent across layers

---

AI MUST NOT:

* Use random short names
* Mix naming styles
* Use unclear abbreviations

---

# ========================

# 📌 SUMMARY

# ========================

Good naming =

* Easy to read
* Easy to understand
* Consistent

Bad naming =

* Confusing
* Inconsistent
* Hard to maintain

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

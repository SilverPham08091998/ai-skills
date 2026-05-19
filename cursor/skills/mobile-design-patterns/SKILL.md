---
name: mobile-design-patterns
description: Mobile design pattern guidance for React Native apps. Use when selecting patterns for screens, hooks, services, state, and feature modules.
---

# Mobile Design Patterns Guidelines

This Cursor skill adapts `mobile-engineer/foundation/design-patterns.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🧩 DESIGN PATTERNS (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define common design patterns for Mobile Engineer to build:

* Scalable architecture
* Maintainable code
* Reusable modules

Applied for:

* React Native
* iOS (Swift)
* Android (Kotlin / Java)

---

# ========================

# 🔥 CORE PATTERNS

# ========================

## 1. CONTAINER / PRESENTATIONAL PATTERN

Separate logic and UI.

### Structure:

```
Container (logic) → Presentational (UI)
```

### ✅ GOOD

```tsx
// Container
const TransferScreen = () => {
  const { amount, submitTransfer } = useTransfer();

  return (
    <TransferView
      amount={amount}
      onSubmit={submitTransfer}
    />
  );
};

// Presentational
const TransferView = ({ amount, onSubmit }) => {
  return <Button onPress={onSubmit} />;
};
```

---

## 2. CUSTOM HOOK PATTERN (REACT NATIVE)

Encapsulate business logic inside hook.

### ✅ GOOD

```ts
export const useTransfer = () => {
  const [isLoading, setIsLoading] = useState(false);

  const submitTransfer = async () => {
    setIsLoading(true);
    try {
      await transferService.submit();
    } finally {
      setIsLoading(false);
    }
  };

  return { isLoading, submitTransfer };
};
```

---

## 3. SERVICE PATTERN

All API calls must go through service layer.

### ✅ GOOD

```ts
class TransferService {
  submitTransfer(payload) {
    return api.post('/transfer', payload);
  }
}

export const transferService = new TransferService();
```

---

## 4. REPOSITORY PATTERN

Abstract data source.

### Structure:

```
View → Hook/ViewModel → Repository → API / Local
```

---

## 5. MVVM PATTERN

### Used in:

* Swift
* Android

### Structure:

```
View → ViewModel → Model / Service
```

---

## 6. STATE PATTERN

Represent UI state clearly.

### React Native

```ts
type UiState =
  | { type: 'loading' }
  | { type: 'success'; data: any }
  | { type: 'error'; message: string };
```

### Android

```kotlin
sealed class UiState {
    object Loading : UiState()
    data class Success(val data: Any) : UiState()
    data class Error(val message: String) : UiState()
}
```

---

## 7. FACTORY PATTERN

Used to create object dynamically.

### Example

```ts
const createPaymentMethod = (type: string) => {
  switch (type) {
    case 'QR': return new QrPayment();
    case 'CARD': return new CardPayment();
    default: throw new Error('Invalid type');
  }
};
```

---

## 8. SINGLETON PATTERN

Used for global instance.

### Example

```ts
class ApiClient {
  static instance = new ApiClient();
}

export const apiClient = ApiClient.instance;
```

---

## 9. OBSERVER PATTERN

Used for event / state update.

### Example

* Redux
* RxJS / Redux-Observable

---

## 10. ADAPTER PATTERN

Used to map API response to domain model.

### Example

```ts
const mapTransaction = (response) => ({
  id: response.txn_id,
  amount: response.total_amount,
});
```

---

# ========================

# 🔐 FINTECH PATTERNS

# ========================

## 1. IDEMPOTENCY PATTERN

Prevent duplicate transaction.

```ts
if (isSubmitting) return;
```

---

## 2. RETRY PATTERN

Retry failed API safely.

---

## 3. STATE MACHINE PATTERN

Transaction flow:

```
INIT → PENDING → PROCESSING → SUCCESS / FAILED
```

---

## 4. VALIDATION PIPELINE

```
Validate → Execute → Confirm
```

---

# ========================

# 🧪 AI RULE

# ========================

AI MUST:

* Use appropriate pattern
* Separate UI / logic / data
* Avoid anti-pattern

---

AI MUST NOT:

* Put all logic in one place
* Ignore architecture

---

# ========================

# 📌 SUMMARY

# ========================

Patterns help:

* Scale system
* Reduce bugs
* Improve readability

No pattern = spaghetti code

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

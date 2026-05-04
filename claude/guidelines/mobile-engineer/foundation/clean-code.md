# ========================

# ✨ CLEAN CODE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define clean code standards for Mobile Engineer to ensure:

* Readability
* Maintainability
* Predictability
* Low bug rate

Applied for:

* React Native (TypeScript)
* iOS (Swift)
* Android (Kotlin / Java)

---

# ========================

# 🔥 CORE RULES

# ========================

## 1. CODE MUST BE SELF-EXPLANATORY

You should NOT need comments to understand the code.

### ❌ BAD

```ts
// calculate total
const t = a + b;
```

### ✅ GOOD

```ts
const totalAmount = amount + fee;
```

---

## 2. USE MEANINGFUL NAMES

Names must clearly describe intent.

### ❌ BAD

```ts
const d = userData;
const x = get();
```

### ✅ GOOD

```ts
const userProfile = userData;
const fetchTransactionHistory = getTransactionHistory;
```

---

## 3. FUNCTION MUST DO ONE THING

### ❌ BAD

```ts
const processTransaction = async () => {
  validate();
  callApi();
  mapResponse();
  updateUI();
};
```

### ✅ GOOD

```ts
const validateTransaction = () => {};
const submitTransaction = async () => {};
const mapTransactionResponse = () => {};
```

---

## 4. KEEP FUNCTION SMALL

* Ideal: < 20 lines
* Avoid deep nesting (> 2 levels)

---

## 5. AVOID NESTED LOGIC

### ❌ BAD

```ts
if (user) {
  if (user.account) {
    if (user.account.balance > 0) {
      // ...
    }
  }
}
```

### ✅ GOOD

```ts
if (!user?.account?.balance) return;

// continue logic
```

---

## 6. REMOVE DUPLICATION (DRY)

### ❌ BAD

```ts
formatCurrency(amount);
formatCurrency(fee);
formatCurrency(total);
```

### ✅ GOOD

```ts
const formatMoney = (value: number) => formatCurrency(value);
```

---

## 7. USE EARLY RETURN

### ❌ BAD

```ts
if (isValid) {
  // long logic
}
```

### ✅ GOOD

```ts
if (!isValid) return;

// logic here
```

---

## 8. AVOID SIDE EFFECTS

Function should not unexpectedly modify external state.

---

## 9. CONSISTENT STYLE

* Same naming convention
* Same folder structure
* Same architecture pattern

---

## 10. WRITE CODE FOR HUMAN FIRST

> Code is read more than written.

---

# ========================

# ⚙️ REACT NATIVE CLEAN CODE

# ========================

## 1. COMPONENT = UI ONLY

### ❌ BAD

```tsx
const Screen = () => {
  const handle = async () => {
    await api.call();
  };
};
```

### ✅ GOOD

```tsx
const Screen = () => {
  const { handleAction } = useFeature();

  return <Button onPress={handleAction} />;
};
```

---

## 2. SPLIT COMPONENT

* Container (logic)
* View (UI)

---

## 3. AVOID PROPS DRILLING

Use:

* Context
* State management (Redux / Zustand)

---

## 4. REUSABLE COMPONENT

* Button
* Input
* Modal
* List Item

---

# ========================

# 🍏 SWIFT CLEAN CODE

# ========================

## 1. SMALL VIEWCONTROLLER

* Move logic to ViewModel

---

## 2. USE EXTENSION

```swift
extension String {
    func isValidPhone() -> Bool {
        // logic
    }
}
```

---

## 3. USE ENUM INSTEAD OF STRING

```swift
enum TransactionStatus {
    case pending
    case success
    case failed
}
```

---

## 4. AVOID FORCE UNWRAP

### ❌ BAD

```swift
user!.name
```

### ✅ GOOD

```swift
guard let user = user else { return }
```

---

# ========================

# 🤖 ANDROID CLEAN CODE

# ========================

## 1. USE DATA CLASS

```kotlin
data class User(
    val id: String,
    val name: String
)
```

---

## 2. USE SEALED CLASS FOR STATE

```kotlin
sealed class UiState {
    object Loading : UiState()
    data class Success(val data: User) : UiState()
    data class Error(val message: String) : UiState()
}
```

---

## 3. AVOID GOD CLASS

* Do not put everything in ViewModel

---

# ========================

# 🔐 FINTECH CLEAN CODE

# ========================

## 1. EXPLICIT TRANSACTION FLOW

### ❌ BAD

```ts
handleTransfer();
```

### ✅ GOOD

```ts
validateTransfer();
createRequestId();
submitTransfer();
confirmTransfer();
```

---

## 2. LOGIC MUST BE TRACEABLE

Every step must be clear for debugging:

* request
* processing
* response

---

## 3. NO HIDDEN LOGIC

Avoid magic behavior.

---

# ========================

# 🧪 AI RULE

# ========================

AI MUST:

* Write readable code
* Use clear naming
* Split logic into small functions
* Avoid duplication
* Follow architecture

---

AI MUST NOT:

* Write long functions
* Use unclear variable names
* Mix multiple responsibilities
* Write nested complex logic

---

# ========================

# 📌 SUMMARY

# ========================

Clean code =

* Easy to read
* Easy to change
* Easy to debug

Bad code =

* Hard to understand
* Easy to break
* Difficult to maintain

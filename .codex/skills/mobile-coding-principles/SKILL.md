---
name: mobile-coding-principles
description: Mobile coding principles for React Native fintech apps. Use when applying SOLID, DRY, KISS, separation of concerns, and safe implementation practices.
---

# Mobile Coding Principles Guidelines

This Codex skill adapts `mobile-engineer/foundation/coding-principles.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🧠 MOBILE CODING PRINCIPLES

# ========================

## 🎯 OBJECTIVE

Define coding principles for Mobile Engineer to ensure:

* Clean code
* Maintainability
* Scalability
* Production readiness

Applied for:

* React Native
* iOS (Swift)
* Android (Kotlin / Java)

---

# ========================

# 🔥 CORE PRINCIPLES

# ========================

## 1. CLEAN CODE

Code must be:

* Readable
* Predictable
* Easy to maintain

### ✅ GOOD

```ts
const calculateTotalAmount = (amount: number, fee: number) => {
  return amount + fee;
};
```

### ❌ BAD

```ts
const a = (x, y) => x + y;
```

---

## 2. SINGLE RESPONSIBILITY

Each function / class must have ONE responsibility.

### ✅ GOOD

```ts
// API
const fetchUser = () => api.get('/user');

// Logic
const useUser = () => {
  const [user, setUser] = useState();

  useEffect(() => {
    fetchUser().then(setUser);
  }, []);
};
```

### ❌ BAD

```ts
const UserScreen = () => {
  useEffect(() => {
    api.get('/user').then(res => {
      // logic + mapping + UI state all here ❌
    });
  }, []);
};
```

---

## 3. SEPARATION OF CONCERNS

Must separate:

* UI (component)
* Logic (hook / viewmodel)
* API (service)

### ✅ STANDARD STRUCTURE

```txt
screen → hook → service → api
```

---

## 4. NO SIDE EFFECT IN UI

UI must be pure.

### ❌ BAD

```tsx
const Screen = () => {
  const handleClick = async () => {
    await api.transferMoney(); // ❌
  };
};
```

### ✅ GOOD

```tsx
const Screen = () => {
  const { submitTransfer } = useTransfer();

  return <Button onPress={submitTransfer} />;
};
```

---

## 5. EXPLICIT NAMING

Names must clearly describe intent.

### ❌ BAD

```ts
const data = res.data;
```

### ✅ GOOD

```ts
const transactionList = response.data.transactions;
```

---

## 6. AVOID MAGIC VALUES

### ❌ BAD

```ts
if (status === 1) {}
```

### ✅ GOOD

```ts
const TRANSACTION_SUCCESS = 1;

if (status === TRANSACTION_SUCCESS) {}
```

---

## 7. IMMUTABILITY

Do not mutate state directly.

### ❌ BAD

```ts
state.user.name = 'new';
```

### ✅ GOOD

```ts
setUser(prev => ({
  ...prev,
  name: 'new'
}));
```

---

## 8. ERROR HANDLING IS MANDATORY

Every API call MUST handle error.

### ❌ BAD

```ts
await api.transfer();
```

### ✅ GOOD

```ts
try {
  await api.transfer();
} catch (error) {
  showError(error);
}
```

---

## 9. NO HARDCODE SENSITIVE DATA

### ❌ BAD

```ts
const token = "123456";
```

### ✅ GOOD

```ts
const token = getSecureToken();
```

---

## 10. DEFENSIVE PROGRAMMING

Always assume:

* API may fail
* Data may be null
* User may spam action

### ✅ GOOD

```ts
if (!response?.data) {
  throw new Error("Invalid response");
}
```

---

# ========================

# ⚙️ REACT NATIVE SPECIFIC

# ========================

## 1. COMPONENT MUST BE DUMB

* Only render UI
* No business logic
* Receive data and callbacks from hook / container

---

## 2. USE HOOK FOR LOGIC

Use custom hooks to isolate screen logic.

Examples:

* `useTransfer`
* `useLogin`
* `useUserProfile`
* `useTransactionHistory`

### ✅ GOOD

```tsx
const TransferScreen = () => {
  const {
    amount,
    setAmount,
    isSubmitting,
    submitTransfer,
  } = useTransfer();

  return (
    <TransferView
      amount={amount}
      onAmountChange={setAmount}
      isSubmitting={isSubmitting}
      onSubmit={submitTransfer}
    />
  );
};
```

---

## 3. AVOID INLINE FUNCTION IN HEAVY COMPONENTS

### ❌ BAD

```tsx
<Button onPress={() => handleClick()} />
```

### ✅ GOOD

```tsx
<Button onPress={handleClick} />
```

---

## 4. FLATLIST OPTIMIZATION

Must:

* Use `keyExtractor`
* Use `React.memo` for list item
* Avoid inline `renderItem`
* Use `getItemLayout` when item height is fixed
* Avoid heavy calculation inside `renderItem`

### ✅ GOOD

```tsx
const renderTransactionItem = ({ item }: { item: Transaction }) => {
  return <TransactionItem transaction={item} />;
};

<FlatList
  data={transactions}
  keyExtractor={item => item.id}
  renderItem={renderTransactionItem}
/>
```

---

# ========================

# 🍏 SWIFT / iOS PRINCIPLES

# ========================

## 1. USE MVVM

Structure:

```txt
View / ViewController → ViewModel → Service / Repository
```

Rules:

* View only renders UI
* ViewModel handles state and logic
* Service handles API / SDK / native integration

---

## 2. AVOID MASSIVE VIEWCONTROLLER

### ❌ BAD

* ViewController contains UI, API call, mapping, validation, navigation, and state
* 1000+ lines ViewController

### ✅ GOOD

* Move business logic to ViewModel
* Move API logic to Service
* Move reusable UI to custom View

---

## 3. USE PROTOCOL FOR ABSTRACTION

### ✅ GOOD

```swift
protocol UserService {
    func fetchUser() async throws -> User
}

final class DefaultUserService: UserService {
    func fetchUser() async throws -> User {
        // API call here
    }
}
```

---

## 4. HANDLE OPTIONAL SAFELY

### ❌ BAD

```swift
user!.name
```

### ✅ GOOD

```swift
guard let user = user else { return }
let name = user.name
```

---

## 5. MAIN THREAD RULE

UI updates must happen on main thread.

### ✅ GOOD

```swift
await MainActor.run {
    self.isLoading = false
}
```

---

# ========================

# 🤖 ANDROID PRINCIPLES

# ========================

## 1. USE MVVM + CLEAN STRUCTURE

Structure:

```txt
Activity / Fragment / Compose Screen → ViewModel → UseCase / Repository → Data Source
```

Rules:

* UI observes state
* ViewModel exposes state
* Repository handles data access
* Data Source handles API / database / SDK

---

## 2. USE COROUTINES SAFELY

### ✅ GOOD

```kotlin
viewModelScope.launch {
    try {
        val user = repository.getUser()
        _state.value = UserState.Success(user)
    } catch (ex: Exception) {
        _state.value = UserState.Error(ex.message.orEmpty())
    }
}
```

---

## 3. AVOID CONTEXT LEAK

### ❌ BAD

```kotlin
object AppHolder {
    var context: Context? = null
}
```

### ✅ GOOD

* Use application context only when required
* Do not store Activity context in singleton
* Clear references when lifecycle ends

---

## 4. HANDLE LIFECYCLE CORRECTLY

Must:

* Cancel jobs when lifecycle ends
* Avoid observing forever without cleanup
* Avoid memory leak from listeners / callbacks

---

# ========================

# 🔐 SECURITY CODING RULE

# ========================

## 1. NEVER STORE SENSITIVE DATA IN PLAIN TEXT

Sensitive data includes:

* Access token
* Refresh token
* PIN
* OTP
* Soft OTP secret key
* Private key
* User identity data

Use:

* iOS Keychain
* Android Keystore
* Encrypted storage

---

## 2. MASK SENSITIVE DATA IN LOG

### ❌ BAD

```ts
console.log('token', token);
```

### ✅ GOOD

```ts
logger.info('Login success');
```

---

## 3. DO NOT TRUST CLIENT-SIDE VALIDATION ONLY

Client validation is for UX.

Backend validation is mandatory for security and money flow.

---

# ========================

# 🔥 FINTECH CODING RULE

# ========================

## 1. PREVENT DUPLICATE ACTION

### ❌ BAD

User can click Transfer multiple times.

### ✅ GOOD

```ts
if (isSubmitting) return;

setSubmitting(true);
try {
  await submitTransfer();
} finally {
  setSubmitting(false);
}
```

---

## 2. USE REQUEST ID / IDEMPOTENCY KEY

Every money-related action should have a unique request id.

Examples:

* transfer money
* bill payment
* top up
* cash out
* confirm transaction

### ✅ GOOD

```ts
const requestId = generateRequestId();

await transferService.submitTransfer({
  requestId,
  amount,
  receiverAccount,
});
```

---

## 3. HANDLE TRANSACTION STATE EXPLICITLY

Must track:

* initialized
* pending
* processing
* success
* failed
* expired
* cancelled

### ✅ GOOD

```ts
type TransactionStatus =
  | 'initialized'
  | 'pending'
  | 'processing'
  | 'success'
  | 'failed'
  | 'expired'
  | 'cancelled';
```

---

## 4. NEVER ASSUME PAYMENT SUCCESS FROM CLIENT ONLY

Client must display success only when backend confirms final state.

### ❌ BAD

```ts
showSuccessScreen(); // immediately after button click
```

### ✅ GOOD

```ts
const result = await confirmTransaction(transactionId);

if (result.status === 'success') {
  showSuccessScreen();
}
```

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

When generating mobile code, AI MUST:

* Follow separation of layers
* Use meaningful naming
* Handle loading / success / error states
* Handle network failure
* Avoid duplicate submission
* Avoid hardcoded sensitive data
* Avoid business logic in UI
* Prefer reusable components
* Prefer typed models
* Add comments only when logic is complex

---

AI MUST NOT:

* Write spaghetti code
* Mix UI + API + business logic in one file
* Ignore error handling
* Ignore security
* Ignore lifecycle
* Create duplicated functions
* Create unnecessary abstraction
* Hardcode token, secret key, endpoint, or credentials

---

# ========================

# 📌 SUMMARY

# ========================

Good mobile code is:

* Clean
* Safe
* Predictable
* Maintainable
* Performant
* Secure for fintech / banking

Bad mobile code is:

* Hard to read
* Easy to break
* Difficult to scale
* Unsafe for money flow

This rule is mandatory for all mobile code generation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

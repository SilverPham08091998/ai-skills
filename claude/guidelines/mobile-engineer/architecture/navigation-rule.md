# ========================

# 🧭 NAVIGATION RULE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define navigation standards for mobile projects to ensure:

* Predictable screen flow
* Safe fintech transaction flow
* Clean separation between navigation and business logic
* Maintainable route structure

Applied for:

* React Native
* iOS Swift
* Android Kotlin / Java

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

Navigation is UI flow control.

Navigation MUST NOT become business logic.

Rule:

```txt
Business decides result.
Application decides next action.
Presentation performs navigation.
```

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/
  navigation/
    app-navigation.tsx
    root-navigator.tsx
    auth-navigator.tsx
    main-navigator.tsx
    route-name.ts
    navigation-type.ts
    navigation-service.ts
```

Meaning:

```txt
app-navigation.tsx     → root navigation container
root-navigator.tsx     → switch between auth/main/maintenance flow
auth-navigator.tsx     → login/register/otp flow
main-navigator.tsx     → home/main app flow
route-name.ts          → central route constants
navigation-type.ts     → typed route params
navigation-service.ts  → global navigation helper when needed
```

---

# ========================

# 🏷️ ROUTE NAMING RULE

# ========================

Use clear and domain-based route names.

### ✅ GOOD

```ts
export const RouteName = {
  Login: 'Login',
  Home: 'Home',
  TransferInput: 'TransferInput',
  TransferConfirm: 'TransferConfirm',
  TransferResult: 'TransferResult',
  TransactionDetail: 'TransactionDetail',
} as const;
```

### ❌ BAD

```ts
export const RouteName = {
  Page1: 'Page1',
  ScreenA: 'ScreenA',
  Result: 'Result',
};
```

---

# ========================

# 🧾 ROUTE PARAM RULE

# ========================

All route params MUST be typed.

### ✅ GOOD

```ts
export type RootStackParamList = {
  Login: undefined;
  Home: undefined;
  TransferInput: undefined;
  TransferConfirm: {
    requestId: string;
    amount: number;
    receiverAccountNo: string;
  };
  TransferResult: {
    transactionId: string;
    status: TransactionStatus;
  };
  TransactionDetail: {
    transactionId: string;
  };
};
```

### ❌ BAD

```ts
navigation.navigate('TransferConfirm', data);
```

Rule:

```txt
Do not pass raw API response through navigation params.
```

---

# ========================

# 🔁 STANDARD NAVIGATION FLOW

# ========================

Screen flow example:

```txt
TransferInput
  → TransferConfirm
  → OTP / SoftOTP
  → TransferProcessing
  → TransferResult
```

Rule:

```txt
Each screen represents one clear step.
```

---

# ========================

# 💸 FINTECH TRANSACTION NAVIGATION RULE

# ========================

Money-related navigation MUST be state-aware.

## Required states

```txt
input
confirm
authentication
processing
success
failed
pending
expired
```

## MUST

* Disable back when transaction is processing if needed
* Prevent duplicate navigation
* Navigate result only after backend confirms final state
* Support pending state screen
* Support retry safely with requestId / transactionId

## MUST NOT

* Navigate success immediately after button click
* Allow user to submit same transaction twice by back/forward navigation
* Store OTP/PIN in route params
* Pass access token / refresh token through route params
* Pass full sensitive user object through route params

---

# ========================

# 🔐 SENSITIVE PARAM RULE

# ========================

Never pass sensitive data via navigation params.

Forbidden:

```txt
accessToken
refreshToken
PIN
OTP
Soft OTP secret
privateKey
password
full card number
CVV
raw identity document image
```

Allowed:

```txt
requestId
transactionId
maskedAccountNo
maskedPhoneNumber
status
screenMode
```

---

# ========================

# 🧩 PRESENTATION RESPONSIBILITY

# ========================

Presentation layer can:

* Read route params
* Trigger navigation
* Display screen by route state

Presentation layer MUST NOT:

* Decide business success
* Create transaction result by itself
* Store sensitive route params
* Call API just because screen focused without application control

---

# ========================

# 🧠 APPLICATION RESPONSIBILITY

# ========================

Application layer can:

* Decide next action after use case result
* Return navigation intent to presentation
* Validate whether user can continue flow

Example:

```ts
type TransferNavigationIntent =
  | { type: 'goToConfirm'; requestId: string }
  | { type: 'goToProcessing'; transactionId: string }
  | { type: 'goToResult'; transactionId: string; status: TransactionStatus }
  | { type: 'showError'; message: string };
```

Rule:

```txt
Application returns intent. Presentation performs navigation.
```

---

# ========================

# ⚙️ REACT NATIVE RULE

# ========================

## 1. Use typed navigation

```ts
type TransferConfirmRouteProp = RouteProp<
  RootStackParamList,
  'TransferConfirm'
>;
```

---

## 2. Avoid magic route string

### ❌ BAD

```ts
navigation.navigate('abc');
```

### ✅ GOOD

```ts
navigation.navigate(RouteName.TransferConfirm, {
  requestId,
  amount,
  receiverAccountNo,
});
```

---

## 3. Use reset for auth/session change

After login/logout, avoid going back into previous stack.

```ts
navigation.reset({
  index: 0,
  routes: [{ name: RouteName.Home }],
});
```

---

## 4. Use replace for one-way flow

Example:

```ts
navigation.replace(RouteName.TransferResult, {
  transactionId,
  status,
});
```

---

# ========================

# 🍏 iOS SWIFT RULE

# ========================

## Preferred patterns

```txt
Coordinator Pattern
ViewController → Coordinator → Next Screen
```

Rules:

* ViewController should not know entire app flow
* Coordinator owns navigation flow
* ViewModel should not push screen directly
* ViewModel may emit navigation intent

Example:

```swift
enum TransferNavigationIntent {
    case confirm(requestId: String)
    case processing(transactionId: String)
    case result(transactionId: String, status: TransactionStatus)
}
```

---

# ========================

# 🤖 ANDROID RULE

# ========================

## Preferred patterns

```txt
Activity / Fragment / Compose Screen
  → observe ViewModel state / event
  → NavController performs navigation
```

Rules:

* ViewModel must not hold Activity reference
* ViewModel emits navigation event
* UI layer performs actual navigation
* Do not pass sensitive data in Bundle / Intent extras

Example:

```kotlin
sealed class TransferNavigationEvent {
    data class GoToConfirm(val requestId: String) : TransferNavigationEvent()
    data class GoToResult(
        val transactionId: String,
        val status: TransactionStatus
    ) : TransferNavigationEvent()
}
```

---

# ========================

# 🚫 BACK NAVIGATION RULE

# ========================

For transaction flow:

## MUST CONTROL BACK BEHAVIOR

Examples:

```txt
Input screen       → back allowed
Confirm screen     → back allowed if not submitted
Processing screen  → back disabled or confirmed dialog
Result screen      → back should go Home / TransactionDetail, not Processing
```

MUST NOT:

* Allow back from processing to confirm and resubmit
* Allow duplicate transaction by navigating backward
* Keep OTP screen accessible after transaction completed

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Create route constants
* Create typed route params
* Avoid magic route strings
* Keep navigation in presentation layer
* Let application emit navigation intent when business flow is involved
* Prevent sensitive data in params
* Handle transaction back behavior safely

AI MUST NOT:

* Put business decision inside navigator
* Pass raw API response as route params
* Pass token / OTP / PIN as route params
* Navigate success before backend final confirmation
* Create duplicate route names randomly

---

# ========================

# 📌 SUMMARY

# ========================

Navigation rule summary:

```txt
Route name must be centralized.
Route params must be typed.
Sensitive data must not be passed through navigation.
Application emits intent.
Presentation performs navigation.
Transaction flow must prevent duplicate submit.
```

This rule is mandatory for all mobile code generation.

---
name: react-native-screen-rule
description: React Native screen rules. Use when implementing screen containers, navigation integration, UI state, and presentation boundaries.
---

# React Native Screen Rule Guidelines

This Cursor skill adapts `mobile-engineer/react-native/screen-rule.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 📱 SCREEN RULE (REACT NATIVE)

# ========================

## 🎯 OBJECTIVE

Define strict rules for React Native screens to ensure:

* Clean presentation layer
* No business logic leakage
* Predictable navigation
* Safe fintech transaction flow
* Easy testing and maintenance

Path:

```txt
src/presentation/
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
Screen = Page Container
```

A screen should:

* Connect UI with application hook / view model
* Read route params
* Trigger navigation
* Pass state and callbacks to view/component

A screen should NOT:

* Call API directly
* Access repository directly
* Access storage directly
* Contain business rules
* Contain complex mapping logic

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
presentation/
  transfer/
    transfer-input.screen.tsx
    transfer-input.view.tsx
    transfer-confirm.screen.tsx
    transfer-confirm.view.tsx
    transfer-result.screen.tsx
    transfer-result.view.tsx
    transfer.style.ts
```

Rule:

```txt
screen.tsx = container
view.tsx = UI rendering
style.ts = styles
```

---

# ========================

# 🔁 STANDARD SCREEN FLOW

# ========================

```txt
Screen
  → useApplicationHook
  → receive state/actions
  → render View
  → trigger navigation based on result/intent
```

Example:

```tsx
export const TransferInputScreen = ({ navigation }: Props) => {
  const {
    state,
    submitTransfer,
  } = useTransfer();

  const handleSubmit = async () => {
    const intent = await submitTransfer();

    if (intent.type === 'goToConfirm') {
      navigation.navigate(RouteName.TransferConfirm, {
        requestId: intent.requestId,
      });
    }
  };

  return (
    <TransferInputView
      state={state}
      onSubmit={handleSubmit}
    />
  );
};
```

---

# ========================

# ✅ SCREEN RESPONSIBILITIES

# ========================

Screen can:

* Use application hook
* Read typed route params
* Trigger navigation
* Pass props to view
* Handle screen lifecycle when needed
* Handle back behavior when needed

Screen must delegate:

```txt
business flow     → application
business rules    → domain
API/storage/native → infrastructure
reusable UI       → component
```

---

# ========================

# ❌ SCREEN MUST NOT DO

# ========================

## 1. Do not call API directly

### ❌ BAD

```tsx
const TransferScreen = () => {
  const submit = async () => {
    await apiClient.post('/transfer');
  };
};
```

### ✅ GOOD

```tsx
const TransferScreen = () => {
  const { submitTransfer } = useTransfer();
};
```

---

## 2. Do not access storage directly

### ❌ BAD

```tsx
const token = await AsyncStorage.getItem('token');
```

### ✅ GOOD

```tsx
const { user } = useAuthSession();
```

---

## 3. Do not put business rules in screen

### ❌ BAD

```tsx
if (amount > dailyLimit) {
  showError('Daily limit exceeded');
}
```

### ✅ GOOD

```ts
validateTransferAmount(amount);
```

Business validation belongs to:

```txt
domain
```

---

## 4. Do not pass raw API response to view

### ❌ BAD

```tsx
<TransferView data={response.data} />
```

### ✅ GOOD

```tsx
<TransferView transaction={transactionModel} />
```

---

# ========================

# 🧾 ROUTE PARAM RULE

# ========================

Screen MUST use typed route params.

### ✅ GOOD

```ts
type Props = NativeStackScreenProps<
  RootStackParamList,
  'TransferConfirm'
>;

export const TransferConfirmScreen = ({ route }: Props) => {
  const { requestId } = route.params;
};
```

### ❌ BAD

```ts
const requestId = route.params.requestId as any;
```

---

# ========================

# 🔐 SENSITIVE DATA RULE

# ========================

Screen MUST NOT receive sensitive data from route params.

Forbidden route params:

```txt
accessToken
refreshToken
PIN
OTP
password
Soft OTP secret
privateKey
CVV
full card number
raw identity document image
```

Allowed route params:

```txt
requestId
transactionId
maskedPhoneNumber
maskedAccountNo
status
screenMode
```

---

# ========================

# 💸 FINTECH SCREEN RULE

# ========================

Money-related screens must be safe by default.

## MUST

* Disable submit button when loading
* Prevent duplicate submit
* Show clear processing state
* Show pending state when backend has not finalized transaction
* Navigate success only after backend confirms final state
* Use requestId / transactionId for tracking

## MUST NOT

* Show success immediately after button click
* Allow back navigation to resubmit processing transaction
* Store OTP/PIN longer than needed
* Log sensitive information

---

# ========================

# 🔙 BACK BEHAVIOR RULE

# ========================

For transaction flow:

```txt
Input screen       → back allowed
Confirm screen     → back allowed before submit
OTP screen         → back controlled
Processing screen  → back disabled or confirmation required
Result screen      → back should go Home / TransactionDetail
```

Example:

```tsx
useFocusEffect(
  useCallback(() => {
    const subscription = BackHandler.addEventListener(
      'hardwareBackPress',
      () => {
        if (state.isProcessing) return true;
        return false;
      },
    );

    return () => subscription.remove();
  }, [state.isProcessing]),
);
```

---

# ========================

# 👀 LIFECYCLE RULE

# ========================

Screen may use lifecycle hooks for UI lifecycle only:

* `useEffect`
* `useFocusEffect`
* `useLayoutEffect`

MUST NOT put heavy business flow directly inside lifecycle.

### ❌ BAD

```tsx
useEffect(() => {
  apiClient.get('/transaction-history');
}, []);
```

### ✅ GOOD

```tsx
useEffect(() => {
  loadTransactionHistory();
}, [loadTransactionHistory]);
```

Where `loadTransactionHistory` comes from application hook.

---

# ========================

# 🧩 VIEW SPLIT RULE

# ========================

For medium/large screens, split:

```txt
screen.tsx → container
view.tsx   → render UI
style.ts   → styles
```

### screen.tsx

```tsx
export const LoginScreen = () => {
  const { state, login } = useLogin();

  return (
    <LoginView
      state={state}
      onLogin={login}
    />
  );
};
```

### view.tsx

```tsx
type LoginViewProps = {
  state: LoginState;
  onLogin: () => void;
};

export const LoginView = ({ state, onLogin }: LoginViewProps) => {
  return (
    <PrimaryButton
      title="Login"
      loading={state.isLoading}
      onPress={onLogin}
    />
  );
};
```

---

# ========================

# 🎨 STYLE RULE

# ========================

Screen styles must:

* Use theme tokens
* Avoid random magic values
* Avoid inline styles for complex UI

### ❌ BAD

```tsx
<View style={{ marginTop: 17, backgroundColor: '#ff0000' }} />
```

### ✅ GOOD

```tsx
<View style={styles.container} />
```

---

# ========================

# 🧪 TESTABILITY RULE

# ========================

Screen should be testable by mocking:

* application hook
* navigation
* route params

Screen should not require:

* real API
* real storage
* real native SDK

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Put screens under `presentation/<feature>/`
* Use `*.screen.tsx` naming
* Split complex screen into `screen.tsx` and `view.tsx`
* Use application hook for logic
* Use typed navigation params
* Keep screen free of API/storage/native SDK calls
* Handle loading/error/success state
* Protect fintech transaction navigation

AI MUST NOT:

* Call API directly in screen
* Put business validation in screen
* Put all UI and logic into one huge file
* Pass sensitive data through route params
* Navigate success before backend confirmation
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

```txt
Screen = Page Container
View = UI Rendering
Hook/ViewModel = Logic
UseCase = Business Flow
Domain = Business Rule
Infrastructure = API / Storage / Native SDK
```

This rule is mandatory for all React Native screen generation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

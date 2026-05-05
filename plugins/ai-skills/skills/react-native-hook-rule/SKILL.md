---
name: react-native-hook-rule
description: React Native hook rules. Use when writing custom hooks, stateful logic, side effects, memoization, and reusable screen behavior.
---

# React Native Hook Rule Guidelines

This skill converts `mobile-engineer/react-native/hook-rule.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🪝 HOOK RULE (REACT NATIVE)

# ========================

## 🎯 OBJECTIVE

Define strict rules for React hooks in the **presentation layer** to ensure:

* Clean UI orchestration
* Clear boundary between UI and application
* Predictable state management
* Testability
* Fintech-safe screen flows

Path:

```txt
src/presentation/<feature>/hook/
```

Important:

```txt
Hook belongs to presentation feature, NOT application.
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
UI ↔ Hook ↔ Application
```

Meaning:

```txt
View / Screen
  ↔ presentation hook
  ↔ application use case / command
```

A hook is a **presentation adapter**.

It can contain:

* UI state type
* UI props type
* form state
* screen event handlers
* navigation intent mapping
* loading / error / success state

A hook should NOT contain:

* core business rules
* raw API calls
* repository implementation
* storage implementation
* native SDK logic

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/presentation/<feature>/
  <feature>.screen.tsx
  <feature>.view.tsx
  <feature>.style.ts
  hook/
    use-<feature>.ts
    <feature>.state.ts
    <feature>.props.ts
    <feature>.event.ts
```

Example:

```txt
src/presentation/transfer/
  transfer-input.screen.tsx
  transfer-input.view.tsx
  transfer-confirm.screen.tsx
  transfer-result.screen.tsx
  transfer.style.ts
  hook/
    use-transfer.ts
    transfer.state.ts
    transfer.props.ts
    transfer.event.ts
```

Application remains separate:

```txt
src/application/transfer/
  submit-transfer.usecase.ts
  submit-transfer.command.ts
  confirm-transfer.usecase.ts
```

Domain remains separate:

```txt
src/domain/transfer/
  transfer.model.ts
  transfer-rule.ts
  transfer-error.ts
```

Infrastructure remains separate:

```txt
src/infrastructure/transfer/
  transfer.api.ts
  transfer.repository.ts
  transfer.mapper.ts
```

---

# ========================

# 🔁 RESPONSIBILITY

# ========================

Hook MUST:

* Hold screen-level state
* Define UI-friendly state type
* Define view props type when useful
* Handle input changes
* Handle submit/click events
* Build application command from UI state / route params
* Call application use case
* Map application result into UI state
* Return navigation intent to screen
* Prevent duplicate submit

Hook MUST NOT:

* Render UI
* Import UI component
* Call API client directly
* Import repository directly if use case exists
* Access AsyncStorage / Keychain / Keystore directly
* Implement core domain rule
* Decide backend success without application result

---

# ========================

# 🧾 STATE / PROPS TYPES

# ========================

Because hook belongs to presentation, it may define UI-specific types.

## State type

```ts
export type TransferState = {
  amount: string;
  receiverAccountNo: string;
  description?: string;
  isSubmitting: boolean;
  errorMessage?: string;
};
```

## View props type

```ts
export type TransferViewProps = {
  state: TransferState;
  onAmountChange: (value: string) => void;
  onReceiverChange: (value: string) => void;
  onSubmit: () => void;
};
```

Rule:

```txt
UI state can be string-based/form-based.
Application command must be clean and typed for business flow.
```

---

# ========================

# 🔁 USECASE INTEGRATION

# ========================

Hook calls application use case.

### ✅ GOOD

```ts
const submitTransfer = async () => {
  if (state.isSubmitting) return;

  setState(prev => ({ ...prev, isSubmitting: true }));

  try {
    const command: SubmitTransferCommand = {
      requestId: generateRequestId(),
      toAccountNo: state.receiverAccountNo,
      amount: Number(state.amount),
      description: state.description,
    };

    const result = await submitTransferUseCase(command);

    return {
      type: 'goToConfirm',
      requestId: result.requestId,
    } as const;
  } catch (error) {
    setState(prev => ({
      ...prev,
      errorMessage: getErrorMessage(error),
    }));

    return {
      type: 'showError',
      message: getErrorMessage(error),
    } as const;
  } finally {
    setState(prev => ({ ...prev, isSubmitting: false }));
  }
};
```

---

# ========================

# 🧭 NAVIGATION INTENT

# ========================

Hook MUST NOT navigate directly.

Instead, hook returns navigation intent to screen.

```ts
export type TransferNavigationIntent =
  | { type: 'goToConfirm'; requestId: string }
  | { type: 'goToProcessing'; transactionId: string }
  | { type: 'goToResult'; transactionId: string; status: string }
  | { type: 'showError'; message: string }
  | { type: 'none' };
```

Screen performs navigation:

```tsx
const handleSubmit = async () => {
  const intent = await submitTransfer();

  if (intent.type === 'goToConfirm') {
    navigation.navigate(RouteName.TransferConfirm, {
      requestId: intent.requestId,
    });
  }
};
```

Rule:

```txt
Hook emits intent. Screen navigates.
```

---

# ========================

# 🧱 BOUNDARY RULE

# ========================

## Hook can know:

```txt
UI state
UI props
route params
screen events
application command
application result
```

## Hook must not know:

```txt
raw HTTP client
native SDK implementation
secure storage implementation
database/cache implementation
backend raw response shape
```

---

# ========================

# 🔐 FINTECH RULE

# ========================

Hook must enforce safe UI behavior.

## MUST

* Prevent duplicate submit
* Disable submit while loading
* Generate requestId / idempotency key when required by command
* Clear OTP/PIN from state after use
* Map backend/application result to safe UI state
* Return pending state when transaction is not finalized

## MUST NOT

* Assume success without backend/application confirmation
* Store OTP/PIN longer than needed
* Store access token / refresh token in hook state
* Log sensitive values
* Retry blindly without requestId / idempotency

---

# ========================

# ⚙️ SIDE EFFECT RULE

# ========================

Hooks can handle presentation-level side effects:

* local loading state
* local error state
* form state
* screen event handlers
* calling application use case

Hooks MUST NOT perform low-level side effects directly:

* direct API call
* direct storage access
* direct native SDK call

### ❌ BAD

```ts
useEffect(() => {
  apiClient.get('/transaction-history');
}, []);
```

### ✅ GOOD

```ts
useEffect(() => {
  loadTransactionHistory();
}, [loadTransactionHistory]);
```

Where `loadTransactionHistory` calls application use case.

---

# ========================

# 🔄 DATA TRANSFORMATION

# ========================

Hook may transform data for UI display.

Allowed:

```ts
const formattedAmount = formatCurrency(Number(state.amount));
const maskedPhone = maskPhoneNumber(phoneNumber);
```

Not allowed:

```txt
fee calculation
limit validation
transaction approval decision
risk decision
```

Business logic belongs to:

```txt
domain / application
```

---

# ========================

# 🧪 TESTABILITY RULE

# ========================

Hook should be testable by mocking:

* application use case
* route params
* timers if needed

Hook should not require:

* real API
* real storage
* real native SDK
* real navigation object

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Place hooks under `src/presentation/<feature>/hook/`
* Use naming `use-<feature>.ts`
* Place UI state types in `<feature>.state.ts`
* Place view props types in `<feature>.props.ts` when needed
* Let hook call application use case
* Let hook build application command from UI state / route params
* Let hook return navigation intent
* Keep application layer free from UI-specific state/props

AI MUST NOT:

* Place React hooks inside `src/application`
* Call API directly in hook
* Import repository directly when use case exists
* Put domain validation rules inside hook
* Navigate directly inside hook
* Store sensitive data in hook state longer than needed
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

Correct flow:

```txt
presentation screen/view
  ↔ presentation hook
  ↔ application use case / command
  ↔ domain rule/model
  ↔ infrastructure repository/api
```

Hook role:

```txt
Hook = UI state + screen events + command mapping + application orchestration adapter
```

This rule is mandatory for all React Native hook generation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

---
name: state-redux-observable
description: Redux Observable standards for mobile reactive side effects. Use when implementing RxJS epics, streams, cancellation, and event-driven flows.
---

# State REDUX Observable Guidelines

This Cursor skill adapts `mobile-engineer/state-management/redux-observable.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🔁 REDUX OBSERVABLE RULE (STATE MANAGEMENT)

# ========================

## 🎯 OBJECTIVE

Define how to use Redux Observable with Redux Toolkit in React Native to handle:

* Async flows
* Side effects
* API orchestration
* Retry / timeout
* Cancellation
* Fintech-safe transaction flows

Applied for:

```txt
React Native + Redux Toolkit + Redux Observable + RxJS
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
Redux = global state
Hook = screen/UI state
Application = business use case
Epic = async side-effect orchestration
Infrastructure = API/storage/network
```

Redux Observable should be used for **complex async flows**, not simple local screen events.

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/application/store/
  store.ts
  root-reducer.ts
  root-epic.ts

src/application/slice/
  auth/
    auth.slice.ts
    auth.selector.ts
    auth.epic.ts
  transaction/
    transaction.slice.ts
    transaction.selector.ts
    transaction.epic.ts
  notification/
    notification.slice.ts
    notification.selector.ts
    notification.epic.ts
```

Feature-specific screen hooks still stay in presentation:

```txt
src/presentation/<feature>/hook/
  use-<feature>.ts
  <feature>.state.ts
  <feature>.props.ts
```

Infrastructure remains for API/storage/network:

```txt
src/infrastructure/
  api/
  repository/
  storage/
```

---

# ========================

# 🔁 STANDARD FLOW

# ========================

```txt
Screen/View
  → presentation hook
  → dispatch Redux action
  → Epic listens action
  → calls application use case / infrastructure service
  → dispatch success/failure action
  → selector returns state
  → hook maps state to UI
  → View renders
```

Example:

```txt
TransferScreen
  → useTransfer
  → dispatch(submitTransferRequested(command))
  → transferEpic
  → submitTransferUseCase(command)
  → dispatch(submitTransferSucceeded(result))
  → selector
  → useTransfer
  → TransferView
```

---

# ========================

# 🧩 WHEN TO USE EPIC

# ========================

Use Redux Observable when flow needs:

* API call triggered by Redux action
* retry / timeout
* cancellation
* debounce / throttle
* polling
* websocket/event stream
* chained async actions
* transaction state tracking
* global side effect

Do NOT use Epic for:

* simple form state
* simple button loading state
* local modal toggle
* local input validation
* UI-only state

---

# ========================

# 🧾 ACTION NAMING RULE

# ========================

Use explicit lifecycle actions:

```txt
<feature>/<action>Requested
<feature>/<action>Succeeded
<feature>/<action>Failed
<feature>/<action>Cancelled
```

Example:

```ts
submitTransferRequested
submitTransferSucceeded
submitTransferFailed
submitTransferCancelled
```

---

# ========================

# 🧱 SLICE RULE

# ========================

Slice owns state mutation only.

Slice MUST NOT:

* Call API
* Contain RxJS logic
* Contain business flow
* Access storage directly

Example:

```ts
import { createSlice, PayloadAction } from '@reduxjs/toolkit';

export type TransferAsyncState = {
  isSubmitting: boolean;
  transactionId?: string;
  errorMessage?: string;
};

const initialState: TransferAsyncState = {
  isSubmitting: false,
};

const transferSlice = createSlice({
  name: 'transfer',
  initialState,
  reducers: {
    submitTransferRequested(state, _action: PayloadAction<SubmitTransferCommand>) {
      state.isSubmitting = true;
      state.errorMessage = undefined;
    },
    submitTransferSucceeded(state, action: PayloadAction<TransferResult>) {
      state.isSubmitting = false;
      state.transactionId = action.payload.transactionId;
    },
    submitTransferFailed(state, action: PayloadAction<string>) {
      state.isSubmitting = false;
      state.errorMessage = action.payload;
    },
    submitTransferCancelled(state) {
      state.isSubmitting = false;
    },
  },
});

export const {
  submitTransferRequested,
  submitTransferSucceeded,
  submitTransferFailed,
  submitTransferCancelled,
} = transferSlice.actions;

export default transferSlice.reducer;
```

---

# ========================

# 🔁 EPIC RULE

# ========================

Epic handles async side effects.

Epic MUST:

* Listen to specific actions
* Call use case / service
* Return success/failure action
* Handle error using `catchError`
* Support cancellation for long-running flow

Epic MUST NOT:

* Mutate Redux state directly
* Render UI
* Navigate directly
* Store sensitive values
* Swallow errors silently

Example:

```ts
import { ofType } from 'redux-observable';
import { catchError, map, mergeMap, of } from 'rxjs';

export const submitTransferEpic = (action$) =>
  action$.pipe(
    ofType(submitTransferRequested.type),
    mergeMap((action) =>
      submitTransferUseCase(action.payload).pipe(
        map((result) => submitTransferSucceeded(result)),
        catchError((error) => of(submitTransferFailed(getErrorMessage(error)))),
      ),
    ),
  );
```

---

# ========================

# ⚠️ RXJS OPERATOR RULE

# ========================

Choose operators intentionally.

## `switchMap`

Use when only latest request matters.

Examples:

```txt
search
filter
autocomplete
reload latest data
```

## `mergeMap`

Use when multiple requests can run concurrently.

Examples:

```txt
parallel upload
multiple independent background actions
```

## `concatMap`

Use when order matters.

Examples:

```txt
transaction steps
queue actions
sequential sync
```

## `exhaustMap`

Use when duplicate submit must be ignored while current request is running.

Examples:

```txt
submit transfer
confirm payment
login
OTP verify
```

Fintech recommendation:

```txt
Money submit flow → prefer exhaustMap or explicit duplicate guard
Step-by-step transaction flow → prefer concatMap
Search/filter → prefer switchMap
```

---

# ========================

# ⏱️ TIMEOUT / RETRY RULE

# ========================

Every API Epic should consider:

* timeout
* retry strategy
* error mapping
* cancellation

Example:

```ts
import { catchError, map, of, timeout } from 'rxjs';

submitTransferUseCase(action.payload).pipe(
  timeout(30000),
  map(result => submitTransferSucceeded(result)),
  catchError(error => of(submitTransferFailed(getErrorMessage(error)))),
);
```

Retry must be safe.

For money flow:

```txt
Retry is allowed only with requestId / idempotency key.
```

---

# ========================

# 🛑 CANCELLATION RULE

# ========================

Long-running Epic should support cancellation.

Example:

```ts
import { takeUntil } from 'rxjs';

apiCall$.pipe(
  takeUntil(action$.pipe(ofType(submitTransferCancelled.type))),
);
```

Use cancellation for:

* screen leave
* search
* polling
* upload/download
* long transaction checking

MUST NOT cancel critical backend transaction blindly after submit.

For payment/transfer:

```txt
Cancel UI waiting does not mean cancel backend transaction.
```

---

# ========================

# 💸 FINTECH TRANSACTION RULE

# ========================

Money-related Epic MUST:

* Prevent duplicate submit
* Use requestId / idempotency key
* Support timeout safely
* Return pending state if backend result is not final
* Avoid blind retry without idempotency
* Never dispatch success before backend/application confirms

Example transaction states:

```txt
idle
submitting
processing
pending
success
failed
expired
cancelled
```

Rule:

```txt
Client-side success is not transaction success.
Backend-confirmed final state is transaction success.
```

---

# ========================

# 🔐 SECURITY RULE

# ========================

Redux / Epic MUST NOT store or log:

```txt
OTP
PIN
password
access token
refresh token
Soft OTP secret
private key
CVV
full card number
raw identity document image
```

Use secure storage for secrets.

Redux may store:

```txt
isAuthenticated
userId
maskedPhoneNumber
maskedAccountNo
session status
feature flags
```

---

# ========================

# 🧭 NAVIGATION RULE

# ========================

Epic MUST NOT navigate directly.

Allowed options:

## Option 1: State-driven navigation

```txt
Epic dispatch success → selector updates state → hook/screen navigates
```

## Option 2: Navigation intent action

```ts
transferNavigationIntentCreated({
  type: 'goToResult',
  transactionId,
  status,
});
```

Screen/hook consumes intent and performs navigation.

MUST NOT:

```txt
navigation.navigate(...) inside epic
```

---

# ========================

# 🧪 ERROR HANDLING RULE

# ========================

Epic error handling MUST:

* Normalize error
* Dispatch failure action
* Avoid raw backend error leaking to UI
* Avoid silent failure

Example:

```ts
catchError((error) =>
  of(submitTransferFailed(normalizeApiError(error).message)),
);
```

---

# ========================

# 🧪 TESTING RULE

# ========================

Epic must be testable with mocked dependencies.

Test cases:

* requested → succeeded
* requested → failed
* timeout
* cancellation
* duplicate submit
* retry with idempotency

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Put epics under `src/application/slice/<feature>/<feature>.epic.ts`
* Use lifecycle actions: requested/succeeded/failed/cancelled
* Use correct RxJS operator by flow type
* Use `catchError` for all async streams
* Keep navigation outside epic
* Keep API/storage details behind use case/service/repository
* Prevent duplicate fintech submit
* Avoid storing sensitive data in Redux

AI MUST NOT:

* Put form/local screen state into Redux
* Call navigation directly inside epic
* Dispatch success before backend/application confirms
* Store OTP/PIN/token in Redux
* Use `mergeMap` blindly for money submit flow
* Swallow error without failure action
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

Correct flow:

```txt
Screen/View
  → presentation hook
  → Redux action
  → Epic
  → application use case / service
  → success/failure action
  → selector
  → hook
  → UI
```

Golden rule:

```txt
Redux = global state
Hook = screen state
Epic = async side effect
UseCase = business flow
Domain = business rule
Infrastructure = API/storage/network
```

This rule is mandatory for all Redux Observable code generation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

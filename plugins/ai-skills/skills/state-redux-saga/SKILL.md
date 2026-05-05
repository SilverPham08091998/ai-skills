---
name: state-redux-saga
description: Redux Saga standards for mobile side effects. Use when implementing complex async flows, orchestration, cancellation, and retries.
---

# State REDUX Saga Guidelines

This skill converts `mobile-engineer/state-management/redux-saga.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🔁 REDUX SAGA RULE (STATE MANAGEMENT)

# ========================

## 🎯 OBJECTIVE

Define how to use Redux Saga with Redux Toolkit in React Native to handle:

* Async flows
* Side effects
* API orchestration
* Retry / timeout
* Cancellation
* Fintech-safe transaction flows

Applied for:

```txt
React Native + Redux Toolkit + Redux Saga
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
Redux = global state
Hook = screen/UI state
Application = business use case
Saga = async side-effect orchestration
Infrastructure = API/storage/network
```

Redux Saga should be used for complex async flows, not simple local screen events.

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/application/store/
  store.ts
  root-reducer.ts
  root-saga.ts

src/application/slice/
  auth/
    auth.slice.ts
    auth.selector.ts
    auth.saga.ts
  transaction/
    transaction.slice.ts
    transaction.selector.ts
    transaction.saga.ts
  notification/
    notification.slice.ts
    notification.selector.ts
    notification.saga.ts
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
  → Saga listens action
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
  → transferSaga
  → submitTransferUseCase(command)
  → put(submitTransferSucceeded(result))
  → selector
  → useTransfer
  → TransferView
```

---

# ========================

# 🧩 WHEN TO USE SAGA

# ========================

Use Redux Saga when flow needs:

* API call triggered by Redux action
* retry / timeout
* cancellation
* debounce / throttle
* polling
* websocket/event channel
* chained async actions
* transaction state tracking
* global side effect
* complex orchestration across multiple actions

Do NOT use Saga for:

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

```txt
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
* Contain saga logic
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

# 🔁 SAGA RULE

# ========================

Saga handles async side effects.

Saga MUST:

* Listen to specific actions
* Call use case / service with `call`
* Dispatch success/failure action with `put`
* Read global state with `select` only when needed
* Handle error with `try/catch`
* Support cancellation for long-running flow

Saga MUST NOT:

* Mutate Redux state directly
* Render UI
* Navigate directly
* Store sensitive values
* Swallow errors silently

Example:

```ts
import { call, put, takeLatest } from 'redux-saga/effects';

function* submitTransferWorker(action: PayloadAction<SubmitTransferCommand>) {
  try {
    const result: TransferResult = yield call(
      submitTransferUseCase,
      action.payload,
    );

    yield put(submitTransferSucceeded(result));
  } catch (error) {
    yield put(submitTransferFailed(getErrorMessage(error)));
  }
}

export function* transferSaga() {
  yield takeLatest(submitTransferRequested.type, submitTransferWorker);
}
```

---

# ========================

# ⚠️ SAGA EFFECT RULE

# ========================

Choose effects intentionally.

## `takeLatest`

Use when only the latest request matters.

Examples:

```txt
search
filter
autocomplete
reload latest data
```

## `takeEvery`

Use when every request must be handled independently.

Examples:

```txt
analytics event
notification read tracking
independent background action
```

## `takeLeading`

Use when duplicate action must be ignored while the first one is running.

Examples:

```txt
submit transfer
confirm payment
login
OTP verify
```

## `throttle`

Use when action should be limited by time window.

Examples:

```txt
button spam prevention
scroll/load more
refresh action
```

## `debounce`

Use when action should wait until user stops typing.

Examples:

```txt
search input
filter input
account lookup
```

Fintech recommendation:

```txt
Money submit flow → prefer takeLeading or explicit duplicate guard
Search/filter → prefer takeLatest or debounce
Analytics/background events → prefer takeEvery
Step-by-step transaction flow → use explicit orchestration with call/put and clear states
```

---

# ========================

# ⏱️ TIMEOUT / RETRY RULE

# ========================

Every API Saga should consider:

* timeout
* retry strategy
* error mapping
* cancellation

Example timeout with `race`:

```ts
import { call, put, race, delay } from 'redux-saga/effects';

function* submitTransferWorker(action: PayloadAction<SubmitTransferCommand>) {
  try {
    const { result, timeout } = yield race({
      result: call(submitTransferUseCase, action.payload),
      timeout: delay(30000),
    });

    if (timeout) {
      yield put(submitTransferFailed('Request timeout'));
      return;
    }

    yield put(submitTransferSucceeded(result));
  } catch (error) {
    yield put(submitTransferFailed(getErrorMessage(error)));
  }
}
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

Long-running Saga should support cancellation.

Use cancellation for:

* screen leave
* search
* polling
* upload/download
* long transaction checking

Example:

```ts
import { call, cancel, fork, take } from 'redux-saga/effects';

function* watchTransactionPolling() {
  while (true) {
    const action = yield take(startPollingRequested.type);
    const task = yield fork(pollTransactionWorker, action.payload);
    yield take(stopPollingRequested.type);
    yield cancel(task);
  }
}
```

MUST NOT cancel critical backend transaction blindly after submit.

For payment/transfer:

```txt
Cancel UI waiting does not mean cancel backend transaction.
```

---

# ========================

# 💸 FINTECH TRANSACTION RULE

# ========================

Money-related Saga MUST:

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

Redux / Saga MUST NOT store or log:

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

Saga MUST NOT navigate directly.

Allowed options:

## Option 1: State-driven navigation

```txt
Saga dispatch success → selector updates state → hook/screen navigates
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
navigation.navigate(...) inside saga
```

---

# ========================

# 🧪 ERROR HANDLING RULE

# ========================

Saga error handling MUST:

* Use try/catch
* Normalize error
* Dispatch failure action
* Avoid raw backend error leaking to UI
* Avoid silent failure

Example:

```ts
try {
  const result = yield call(submitTransferUseCase, command);
  yield put(submitTransferSucceeded(result));
} catch (error) {
  const appError = normalizeApiError(error);
  yield put(submitTransferFailed(appError.message));
}
```

---

# ========================

# 🧪 TESTING RULE

# ========================

Saga must be testable with mocked dependencies.

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

* Put sagas under `src/application/slice/<feature>/<feature>.saga.ts`
* Use lifecycle actions: requested/succeeded/failed/cancelled
* Use correct Saga effect by flow type
* Use `call` for async calls
* Use `put` for dispatching actions
* Use `select` only when needed
* Use `try/catch` for all async flows
* Keep navigation outside saga
* Keep API/storage details behind use case/service/repository
* Prevent duplicate fintech submit
* Avoid storing sensitive data in Redux

AI MUST NOT:

* Put form/local screen state into Redux
* Call navigation directly inside saga
* Dispatch success before backend/application confirms
* Store OTP/PIN/token in Redux
* Use `takeEvery` blindly for money submit flow
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
  → Saga
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
Saga = async side effect
UseCase = business flow
Domain = business rule
Infrastructure = API/storage/network
```

This rule is mandatory for all Redux Saga code generation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

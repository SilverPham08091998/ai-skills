---
name: state-async-flow
description: Mobile async flow standards. Use when designing request lifecycles, loading states, retries, cancellation, and error propagation.
---

# State Async Flow Guidelines

This skill converts `mobile-engineer/state-management/asyn-flow.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🔄 ASYNC FLOW RULE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define a consistent way to implement async flows across the app to ensure:

* Predictable behavior
* Clear ownership per layer
* Safe error/timeout handling
* Fintech-grade transaction safety

Applies to:

```txt
React Native
Hooks (presentation)
Application use cases
Redux Saga / Redux Observable (optional)
API client / interceptors
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
Async flow = Orchestration, not scattered awaits
```

Golden rule:

```txt
UI ↔ Hook ↔ Application ↔ (Saga/Epic) ↔ Infrastructure
```

* UI never calls API directly
* Hook orchestrates screen-level async
* Application owns business flow
* Saga/Epic handles global/complex async
* Infrastructure executes IO (API/storage/native)

---

# ========================

# 📁 WHERE ASYNC LIVES

# ========================

## 1. Presentation Hook

Handles:

```txt
form submit
button click
screen lifecycle trigger
UI loading/error state
navigation intent mapping
```

## 2. Application (UseCase)

Handles:

```txt
business flow orchestration
multi-step logic
validation via domain
calling repository/services
```

## 3. Saga / Epic (optional)

Handles:

```txt
global side effects
retry / timeout / cancellation
polling / websocket
cross-feature orchestration
```

## 4. Infrastructure

Handles:

```txt
API call
storage
native module call
```

---

# ========================

# 🔁 STANDARD ASYNC FLOW

# ========================

## Direct (Hook → UseCase)

```txt
Screen
  → hook
  → useCase(command)
  → repository/api
  → result
  → hook maps state
  → UI
```

## With Redux (Hook → Action → Saga/Epic)

```txt
Screen
  → hook
  → dispatch(action)
  → saga/epic
  → useCase/service
  → success/failure action
  → selector
  → hook
  → UI
```

---

# ========================

# 🧾 STATE LIFECYCLE

# ========================

Every async flow should have explicit states:

```ts
export type AsyncState<T> = {
  status: 'idle' | 'loading' | 'success' | 'error' | 'pending';
  data?: T;
  error?: string;
};
```

Rules:

```txt
loading → request started
success → final confirmed result
error   → known failure
pending → unknown/processing (important for fintech)
```

---

# ========================

# ⚠️ ERROR HANDLING RULE

# ========================

Errors must be normalized.

## Categories

```txt
NETWORK_OFFLINE
TIMEOUT
API_ERROR
BUSINESS_ERROR
UNKNOWN_ERROR
```

## Rule

```txt
UI never receives raw Axios/fetch error
Use error mapper in infrastructure
```

Example:

```ts
try {
  const res = await useCase(command);
} catch (e) {
  const err = normalizeError(e);
  setState({ status: 'error', error: err.message });
}
```

---

# ========================

# ⏱️ TIMEOUT RULE

# ========================

Every critical async call should consider timeout.

```txt
API call → timeout → handle safely
```

Fintech rule:

```txt
Timeout ≠ failed
Timeout may be pending/unknown
```

---

# ========================

# 🔁 RETRY RULE

# ========================

## Safe retry

```txt
GET data
non-critical update
```

## Controlled retry

```txt
preference update
analytics
```

## High-risk retry (money)

```txt
transfer
payment
cashout
```

MUST:

```txt
use requestId / idempotency
retry only once or controlled
check status before retry
```

---

# ========================

# 🛑 CANCELLATION RULE

# ========================

Cancellation applies to:

```txt
search
polling
screen leave
file upload/download
```

MUST NOT cancel blindly:

```txt
money transaction already sent to backend
```

---

# ========================

# 💸 FINTECH FLOW RULE

# ========================

For transaction async:

States:

```txt
input → confirm → auth → processing → pending → success/failed
```

Rules:

* never show success before backend confirmation
* use requestId
* handle pending state
* reconcile after reconnect
* prevent duplicate submit

---

# ========================

# 🧩 PARALLEL VS SEQUENTIAL

# ========================

## Parallel

```txt
load multiple independent data
```

Use:

```ts
await Promise.all([a(), b(), c()]);
```

## Sequential

```txt
steps that depend on each other
```

Use:

```ts
await step1();
await step2();
```

Rule:

```txt
Transaction flow → sequential
Independent data → parallel
```

---

# ========================

# 🧪 LOADING UX RULE

# ========================

MUST:

* show loading indicator
* disable submit button
* avoid flicker (debounce small loading)

MUST NOT:

* block UI thread
* allow double submit

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* put async orchestration in hook/usecase/saga
* use explicit loading/success/error/pending state
* normalize error
* handle timeout
* prevent duplicate submit
* use idempotency for fintech flows

AI MUST NOT:

* call API directly in UI
* mix async logic across layers randomly
* ignore timeout/error
* show success before confirmation

---

# ========================

# 📌 SUMMARY

# ========================

```txt
Hook = UI async orchestration
UseCase = business async flow
Saga/Epic = global async orchestration
Infrastructure = IO execution
```

Golden rule:

```txt
Async must be structured, observable, and safe — especially for money flow.
```

This rule is mandatory for all async flow implementation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

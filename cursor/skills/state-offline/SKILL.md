---
name: state-offline
description: Mobile offline state standards. Use when supporting offline-first behavior, sync queues, conflict handling, and resilient fintech workflows.
---

# State Offline Guidelines

This Cursor skill adapts `mobile-engineer/state-management/offline-state.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 📡 OFFLINE STATE RULE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define how to handle offline / poor network state in mobile applications to ensure:

* Predictable user experience
* Safe retry behavior
* Correct data synchronization
* Fintech-grade transaction safety
* No accidental duplicate money movement

Applied for:

```txt
React Native
Redux Toolkit
Redux Saga / Redux Observable
Local cache
Sync queue
API client
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
Offline support must be explicit, not accidental.
```

Offline state is not just `isConnected`.

It includes:

```txt
network connectivity
API reachability
cached data availability
pending sync actions
retry state
transaction pending state
```

Golden rule:

```txt
Read can use cache.
Money write must be handled with strict backend/idempotency design.
```

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/application/slice/network/
  network.slice.ts
  network.selector.ts
  network.saga.ts or network.epic.ts

src/application/slice/sync/
  sync.slice.ts
  sync.selector.ts
  sync.saga.ts or sync.epic.ts

src/infrastructure/network/
  network-monitor.ts
  api-reachability.ts

src/infrastructure/cache/
  cache-storage.ts
  cache-key.ts

src/infrastructure/sync/
  sync-queue.storage.ts
  sync-queue.mapper.ts
```

Presentation hook can consume offline state:

```txt
src/presentation/<feature>/hook/
  use-<feature>.ts
```

---

# ========================

# 🌐 NETWORK STATE MODEL

# ========================

Network state should be explicit.

```ts
export type NetworkState = {
  isConnected: boolean;
  isInternetReachable?: boolean;
  isApiReachable?: boolean;
  lastOnlineAt?: number;
  lastOfflineAt?: number;
};
```

Meaning:

```txt
isConnected          → device has network connection
isInternetReachable  → internet reachable
isApiReachable       → backend API reachable
lastOnlineAt         → last time app became online
lastOfflineAt        → last time app became offline
```

Rule:

```txt
Do not assume device connectivity means backend is reachable.
```

---

# ========================

# 🧾 OFFLINE UI STATE

# ========================

UI should handle these states:

```txt
online
offline
poor network
timeout
cached data shown
sync pending
sync failed
```

Example:

```ts
export type OfflineUiState = {
  mode: 'online' | 'offline' | 'poor-network';
  isShowingCachedData: boolean;
  pendingSyncCount: number;
  message?: string;
};
```

MUST:

* Show offline banner when needed
* Show cached data label when using cache
* Disable unsafe actions while offline
* Allow safe read-only navigation when possible

MUST NOT:

* Pretend offline data is live data
* Hide failed sync silently
* Allow money action without safety design

---

# ========================

# 📦 CACHE RULE

# ========================

Cache is allowed for read-only or low-risk data.

Allowed cache examples:

```txt
user preferences
app config
feature flags
transaction history snapshot
notification list snapshot
non-sensitive lookup data
biller/category list
```

Forbidden cache examples:

```txt
access token
refresh token
OTP
PIN
Soft OTP secret
CVV
full card number
raw private key
sensitive identity document image
```

Rule:

```txt
Cache must never become secret storage.
```

---

# ========================

# 🔄 SYNC QUEUE RULE

# ========================

Sync queue is for actions that can safely be retried later.

Allowed queue examples:

```txt
analytics events
read receipt
non-critical preference update
notification seen state
support draft message
```

High-risk actions require explicit design:

```txt
money transfer
bill payment
cash out
top up
card payment
QR/NFC payment
OTP verification
PIN verification
```

Rule:

```txt
Do not queue money-moving actions unless backend supports idempotency, state reconciliation, and clear user confirmation.
```

---

# ========================

# 💸 FINTECH OFFLINE RULE

# ========================

Money-related operations MUST be online unless specifically designed otherwise.

## MUST

* Check network before submit
* Check API reachability when needed
* Disable submit if offline
* Use requestId / idempotency key
* Show pending state if request result is unknown
* Reconcile transaction status after reconnect
* Never retry blindly

## MUST NOT

* Queue transfer/payment blindly
* Show success while offline
* Retry money transaction without requestId
* Duplicate submit after reconnect
* Treat timeout as failed immediately if backend may still process

Important:

```txt
Timeout does not always mean transaction failed.
Timeout can mean unknown/pending.
```

---

# ========================

# 🧠 TRANSACTION UNKNOWN STATE

# ========================

For money flow, network failure may create unknown result.

Example:

```txt
User submits transfer
  → request reaches backend
  → network timeout before response
  → app does not know final result
```

Correct state:

```txt
PENDING / UNKNOWN
```

MUST:

* Store requestId / transactionId if available
* Show pending/processing screen
* Poll or query backend when online
* Reconcile final state

MUST NOT:

* Show failed immediately
* Show success immediately
* Allow duplicate transfer without checking status

---

# ========================

# 🔁 RETRY RULE

# ========================

Retry must be classified by action type.

## Safe retry

```txt
GET profile
GET transaction history
GET config
GET biller list
```

## Controlled retry

```txt
POST preference update
POST read receipt
POST analytics
```

## High-risk retry

```txt
POST transfer
POST payment
POST cashout
POST topup
POST confirm transaction
```

High-risk retry requires:

```txt
requestId / idempotency key
backend idempotency support
status inquiry endpoint
reconciliation logic
```

---

# ========================

# 🧩 REDUX STATE RULE

# ========================

Global offline state may be stored in Redux.

Example:

```ts
export type OfflineState = {
  network: NetworkState;
  pendingSyncCount: number;
  lastSyncAt?: number;
};
```

Redux can store:

```txt
isConnected
isApiReachable
pendingSyncCount
lastSyncAt
```

Redux must NOT store:

```txt
sensitive payload
OTP/PIN/token
full payment payload
raw identity data
```

---

# ========================

# 🪝 HOOK INTEGRATION RULE

# ========================

Presentation hook can consume offline selectors.

Example:

```ts
const isConnected = useSelector(selectIsConnected);
const isApiReachable = useSelector(selectIsApiReachable);

const canSubmit = isConnected && isApiReachable && !state.isSubmitting;
```

Hook can:

* disable actions
* show offline message
* trigger reload when online
* map offline state to UI state

Hook must NOT:

* bypass application use case
* directly flush sync queue
* retry money action blindly

---

# ========================

# 🌐 API CLIENT RULE

# ========================

API client should normalize network errors.

Common error categories:

```txt
NETWORK_OFFLINE
API_UNREACHABLE
TIMEOUT
REQUEST_CANCELLED
SERVER_ERROR
UNKNOWN_ERROR
```

Example:

```ts
export type NetworkErrorCode =
  | 'NETWORK_OFFLINE'
  | 'API_UNREACHABLE'
  | 'TIMEOUT'
  | 'REQUEST_CANCELLED'
  | 'SERVER_ERROR'
  | 'UNKNOWN_ERROR';
```

Rule:

```txt
UI should not deal with raw Axios/fetch error directly.
```

---

# ========================

# 🔁 RECONNECT RULE

# ========================

When app reconnects:

MUST:

* Refresh API reachability
* Sync safe queued actions
* Re-fetch critical data if needed
* Reconcile pending transactions

MUST NOT:

* Auto-submit money action without user confirmation/status check
* Flush high-risk queue blindly
* Spam backend with all requests at once

Recommended reconnect flow:

```txt
Network online
  → check API reachability
  → sync safe queue
  → reconcile pending transactions
  → refresh visible screen data
```

---

# ========================

# 🧪 TESTING RULE

# ========================

Must test:

* app offline at startup
* app goes offline during request
* app reconnects
* cached data display
* sync queue success
* sync queue failure
* transaction timeout → pending/unknown
* reconnect transaction reconciliation
* duplicate submit prevention

Security test:

```txt
Persisted offline queue must not contain token/OTP/PIN/secret/full payment payload.
```

---

# ========================

# 🚫 ANTI-PATTERNS

# ========================

## 1. Queue money transaction blindly

### ❌ BAD

```txt
Offline transfer saved locally and auto-submitted later without confirmation/idempotency.
```

---

## 2. Treat timeout as failed

### ❌ BAD

```txt
Timeout → show failed → user submits again → duplicate transaction risk
```

---

## 3. Cache sensitive data

### ❌ BAD

```txt
Persist OTP/PIN/token in offline queue/cache
```

---

## 4. Hide stale data

### ❌ BAD

```txt
Show cached balance as if it is live balance
```

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Create explicit network/offline state
* Separate cache, sync queue, and transaction pending state
* Store only safe offline data
* Disable unsafe money actions while offline
* Use requestId/idempotency for high-risk retry
* Treat timeout as pending/unknown for money flow when appropriate
* Reconcile pending transactions after reconnect
* Normalize network errors

AI MUST NOT:

* Queue transfer/payment blindly
* Persist sensitive payload in offline queue
* Store token/OTP/PIN/Soft OTP secret in Redux/cache
* Show cached balance as live balance
* Retry money action without idempotency
* Show success without backend final confirmation
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

Correct offline model:

```txt
Network State  → connectivity/reachability
Cache State    → safe read-only snapshots
Sync Queue     → safe retryable actions
Pending Txn    → money flow waiting for reconciliation
```

Golden rule:

```txt
Offline read can be cached.
Offline money write must be explicitly designed, idempotent, and reconciled.
```

This rule is mandatory for all offline state code generation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

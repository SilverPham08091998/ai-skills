# architecture/offline-sync.md

## Objective

Define offline-first and synchronization standards for React Native applications to keep user experience stable during weak or unavailable network conditions, especially in fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript
* API layer
* Local cache
* Retry queue
* Fintech / Banking apps

Main rule:

> Offline support must be explicit, safe, and predictable.
> Never perform money movement blindly from an offline queue without backend confirmation and idempotency.

---

# 1. Core Principles

## 1.1 Offline-aware, Not Offline-random

The app must know whether it is:

```txt
online
offline
unstable network
syncing
synced
sync failed
```

Rules:

* Do not let each screen invent its own offline logic.
* Centralize network state and sync behavior.

---

## 1.2 Backend is Source of Truth

Local data is only a cache or temporary state.

Rules:

* Backend decides final transaction state.
* Mobile must reconcile with backend after reconnect.
* Do not trust local-only state for financial correctness.

---

## 1.3 Safe Degradation

When offline:

* allow read-only cached views where safe
* disable risky actions
* show clear offline state

---

# 2. Offline Capability Levels

## 2.1 Read-only Offline

User can view cached data.

Examples:

* recent transaction history
* saved profile information
* cached dashboard widgets

Rules:

* Must show data freshness.
* Do not present stale balance as real-time truth.

---

## 2.2 Offline Draft

User can prepare data but not submit final action.

Examples:

* fill transfer form
* save beneficiary draft
* compose support request

Rules:

* Mark as draft.
* Submit only when online.

---

## 2.3 Offline Queue

Actions are queued and processed later.

Allowed for:

* non-financial actions
* analytics events
* feedback forms
* low-risk sync tasks

Restricted for:

* money movement
* OTP confirmation
* payment confirmation
* account mutation

---

# 3. Network State Service

Create a centralized network state service.

```ts
export type NetworkStatus = 'ONLINE' | 'OFFLINE' | 'UNSTABLE';

export interface NetworkService {
  getStatus(): NetworkStatus;
  subscribe(listener: (status: NetworkStatus) => void): () => void;
}
```

Recommended library:

```txt
@react-native-community/netinfo
```

Rules:

* Network status must be shared across app.
* UI should react to centralized state.

---

# 4. Offline UI Rules

## 4.1 Global Offline Banner

Show clear state:

```txt
You are offline. Some features may be unavailable.
```

## 4.2 Disable Unsafe Actions

Disable:

* payment submit
* transfer confirm
* OTP verify
* KYC final submit

## 4.3 Cached Data Indicator

Example:

```txt
Last updated: 10:32 AM
```

Rules:

* Do not hide stale state.
* Do not imply cached data is real-time.

---

# 5. Cache Strategy

## 5.1 What Can Be Cached

Allowed:

* app config
* feature flags
* static content
* user preferences
* recent non-sensitive UI data

Restricted:

* tokens
* OTP/PIN
* CVV
* raw KYC documents
* sensitive transaction payloads

---

## 5.2 Cache Metadata

Each cached item should include:

```ts
type CachedItem<T> = {
  data: T;
  cachedAt: string;
  expiresAt?: string;
  source: 'CACHE' | 'NETWORK';
};
```

Rules:

* Store freshness metadata.
* Apply TTL where needed.
* Clear sensitive cache on logout.

---

# 6. Sync Queue Design

## 6.1 Queue Item Model

```ts
type SyncQueueItem = {
  id: string;
  type: string;
  payload: unknown;
  status: 'PENDING' | 'PROCESSING' | 'SUCCESS' | 'FAILED';
  retryCount: number;
  maxRetries: number;
  createdAt: string;
  updatedAt: string;
  idempotencyKey?: string;
};
```

Rules:

* Every queued item must have unique id.
* Mutating actions must have idempotency key.
* Queue must be persisted safely if required.

---

## 6.2 Queue Processor

```ts
export interface SyncQueueProcessor {
  enqueue(item: SyncQueueItem): Promise<void>;
  process(): Promise<void>;
  markSuccess(id: string): Promise<void>;
  markFailed(id: string, error: AppError): Promise<void>;
}
```

Rules:

* Process queue only when online.
* Avoid parallel processing for dependent actions.
* Limit concurrency for independent actions.

---

# 7. Retry Strategy

Use controlled retry:

```txt
retry with exponential backoff
max retry count
stop on business error
```

Rules:

* Retry network/server transient errors only.
* Do not retry validation or business errors.
* Do not retry unsafe money actions blindly.

---

# 8. Conflict Resolution

Conflicts happen when local state and backend state differ.

Strategies:

## 8.1 Server Wins

Recommended for fintech.

```txt
backend state overrides local state
```

## 8.2 Merge

Allowed for low-risk data.

Examples:

* user preferences
* drafts

## 8.3 User Decision

Ask user when conflict cannot be resolved safely.

---

# 9. Fintech Rules (CRITICAL)

## 9.1 Money Movement Must Not Be Offline-first

Do not queue final money movement actions offline.

Restricted actions:

* transfer confirm
* payment submit
* cash-in/cash-out
* refund
* OTP verification

Rules:

* User may prepare draft offline.
* Final submit requires online backend confirmation.

---

## 9.2 Idempotency Required

All retryable mutation APIs must include idempotency key.

```txt
Idempotency-Key: <uuid>
```

Rules:

* Same logical operation must reuse the same idempotency key.
* Do not generate new key for retry of same operation.

---

## 9.3 Ambiguous State Handling

Timeout after submit is not equal to failure.

Correct flow:

```txt
submit request
  → timeout / network error
  → mark state as UNKNOWN / PENDING
  → call status inquiry when online
  → show final state from backend
```

Rules:

* Never auto-submit again before inquiry.
* Backend is source of truth.

---

# 10. Status Inquiry Pattern

For critical operations:

```ts
type TransactionSyncState =
  | 'NOT_STARTED'
  | 'SUBMITTED'
  | 'UNKNOWN'
  | 'INQUIRING'
  | 'SUCCESS'
  | 'FAILED';
```

Flow:

```txt
SUBMITTED
  → timeout
  → UNKNOWN
  → INQUIRING
  → SUCCESS / FAILED
```

Rules:

* Store transaction reference safely.
* Inquiry must be idempotent.
* UI should tell user not to submit again.

---

# 11. Offline Storage Rules

Allowed storage:

* MMKV / AsyncStorage for low-risk cached data
* encrypted storage for medium-sensitive cached data
* Keychain/Keystore for secrets only

Rules:

* Do not store raw sensitive transaction payloads.
* Clear user-specific cache on logout.
* Apply TTL for cached financial data.

---

# 12. Sync Triggers

Recommended triggers:

* app startup
* app foreground
* network reconnect
* manual refresh

Rules:

* Debounce sync triggers.
* Avoid sync storm after reconnect.
* Respect backend rate limits.

---

# 13. Observability

Log safe sync events:

```txt
SYNC_QUEUE_ENQUEUED
SYNC_STARTED
SYNC_ITEM_SUCCESS
SYNC_ITEM_FAILED
SYNC_COMPLETED
SYNC_CONFLICT_DETECTED
```

Metadata allowed:

* queue item type
* retry count
* error code
* traceId

Do not log:

* raw payload
* tokens
* account numbers
* OTP/PIN

---

# 14. Testing Rules

Test scenarios:

* offline → cached data shown
* offline → unsafe button disabled
* reconnect → sync starts
* retry stops after max attempts
* business error is not retried
* timeout after submit → status inquiry
* logout clears user cache

---

# 15. Anti-patterns

* Queueing payment submit while offline.
* Retrying transfer with a new idempotency key.
* Showing stale balance without timestamp.
* Treating timeout as failed transaction.
* Syncing everything in parallel without dependency rules.
* Storing sensitive payloads in local cache.
* No conflict resolution strategy.

---

# 16. Checklist

* [ ] Network status service exists.
* [ ] Offline UI state is standardized.
* [ ] Cached data includes freshness metadata.
* [ ] Sync queue model exists.
* [ ] Retry policy is safe.
* [ ] Money movement is not queued offline blindly.
* [ ] Idempotency key is preserved for retries.
* [ ] Status inquiry handles ambiguous transactions.
* [ ] Sensitive data is not stored in offline cache.
* [ ] Sync events are observable.

---

# 17. Final Rule

> Offline sync improves resilience only when it is safe.
> In fintech apps, correctness and transaction integrity are more important than offline convenience.

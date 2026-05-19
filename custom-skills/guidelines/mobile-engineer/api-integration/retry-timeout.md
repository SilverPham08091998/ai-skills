========================

⏱️ RETRY & TIMEOUT RULE (MOBILE)

========================

🎯 OBJECTIVE

Define safe and consistent retry/timeout strategies to ensure:

* Predictable UX under poor network
* No duplicate money transactions
* Controlled retries with idempotency
* Clear timeout semantics (especially fintech)

Applied for:

API client / interceptors
Redux Saga / Redux Observable
Application use cases

⸻

========================

🧠 CORE PRINCIPLE

========================

Retry must be explicit. Timeout must be classified.

Golden rules:

- Not all requests should retry
- Timeout ≠ failed (for money flows)
- High-risk POST must be idempotent before retry

⸻

========================

🧾 REQUEST CLASSIFICATION

========================

A. SAFE (idempotent by nature)

GET /config
GET /profile
GET /biller-list
GET /transaction-history

Policy:

Retry allowed with backoff
Timeout → safe to retry

B. CONTROLLED (low risk writes)

POST /preferences
POST /analytics
POST /read-receipt

Policy:

Retry allowed (limited)
Timeout → may retry once

C. HIGH-RISK (money/auth)

POST /transfer
POST /payment
POST /cashout
POST /topup
POST /confirm
POST /verify-otp

Policy:

Retry only with idempotency key
Timeout → treat as PENDING/UNKNOWN
Never blind retry

⸻

========================

⏱️ TIMEOUT RULE

========================

Default timeouts

Standard API       → 30s
Upload/Download    → 60–120s
Partner-dependent  → configurable per endpoint

Classification

TIMEOUT_NETWORK      → no connection / unreachable
TIMEOUT_REQUEST      → client-side timeout reached
TIMEOUT_UNKNOWN_TXN  → request may have been processed by backend

Fintech rule

Timeout on money flow must map to PENDING/UNKNOWN, not FAILED.

Handling:

- Keep requestId
- Move UI to pending/processing
- Query status endpoint when online

⸻

========================

🔁 RETRY STRATEGY

========================

Backoff strategy

Use exponential backoff with jitter:

baseDelay = 300ms
retries = 2–3 (safe), 1 (controlled), 0 (high-risk unless idempotent)

Pseudo:

const delay = base * 2^attempt + randomJitter;

When to retry

Retry on:

NETWORK_OFFLINE (after reconnect)
TIMEOUT_REQUEST (safe endpoints)
SERVER_ERROR 5xx (safe endpoints)

Do NOT retry on:

4xx business error
validation error
unauthorized (handled by refresh flow)

⸻

========================

🆔 IDEMPOTENCY RULE

========================

High-risk requests MUST include idempotency key:

X-Request-Id / Idempotency-Key

Rules:

- Generated in application/use case
- Reused across retries
- Sent with every attempt

Example:

await apiClient.post('/transfer', payload, {
headers: {
'X-Request-Id': requestId,
'Idempotency-Key': requestId,
},
});

⸻

========================

🧩 SAGA / EPIC USAGE

========================

Redux Saga (example)

import { call, put, race, delay } from 'redux-saga/effects';
function* submitTransferWorker(action) {
const { result, timeout } = yield race({
result: call(submitTransferUseCase, action.payload),
timeout: delay(30000),
});
if (timeout) {
yield put(submitTransferPending(action.payload.requestId));
return;
}
yield put(submitTransferSucceeded(result));
}

Redux Observable (example)

action$.pipe(
ofType(submitTransferRequested.type),
exhaustMap(action =>
submitTransferUseCase(action.payload).pipe(
timeout(30000),
map(result => submitTransferSucceeded(result)),
catchError(() => of(submitTransferPending(action.payload.requestId)))
)
)
)

⸻

========================

🛑 CANCELLATION RULE

========================

Allowed:

search / filter
polling
upload/download
screen leave

Forbidden:

cancel already-submitted money transaction blindly

Rule:

UI cancellation ≠ backend cancellation

⸻

========================

💸 FINTECH SAFETY RULE

========================

MUST:

- Prevent duplicate submit (disable button / takeLeading/exhaustMap)
- Use requestId for all money POST
- Treat timeout as pending
- Provide status inquiry API usage
- Reconcile after reconnect

MUST NOT:

- Auto retry transfer without idempotency
- Show success before backend confirmation
- Retry with new requestId after timeout
- Fire multiple concurrent submits

⸻

========================

🧪 TESTING CHECKLIST

========================

Test scenarios:

- network offline → retry after reconnect
- timeout → pending state
- 5xx error → retry (safe endpoint)
- 4xx error → no retry
- duplicate submit → prevented
- concurrent 401 → single refresh
- idempotent retry returns same result

⸻

========================

🚫 ANTI-PATTERNS

========================

1. Blind retry money API

POST /transfer timeout → retry immediately with new requestId

2. Treat timeout as failed

Timeout → show failed → user retries → duplicate transaction risk

3. Infinite retry loop

5xx → retry → 5xx → retry forever

4. Retry inside UI component

// ❌
try { await api(); } catch { retry(); }

⸻

========================

🧪 AI GENERATION RULE

========================

AI MUST:

* Classify endpoints (safe/controlled/high-risk)
* Apply backoff for safe endpoints
* Use idempotency for high-risk POST
* Map timeout to pending when needed
* Centralize retry in saga/epic/api layer

AI MUST NOT:

* Retry blindly for money APIs
* Generate new requestId on retry of same request
* Handle retry in UI layer
* Assume timeout = failure for transactions

⸻

========================

📌 SUMMARY

========================

Safe API        → retry with backoff
Controlled API  → limited retry
Money API       → idempotent, no blind retry
Timeout         → classify (may be pending)

Golden rule:

Retry carefully. Timeout correctly. Never duplicate money.

This rule is mandatory for all retry/timeout implementation.

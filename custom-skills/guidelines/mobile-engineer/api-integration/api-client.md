# ========================

# 🌐 API CLIENT RULE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define standard API client rules for React Native mobile apps to ensure:

* Consistent backend integration
* Secure token handling
* Centralized timeout / retry / error mapping
* Fintech-grade request safety
* No direct API call from UI

Applied for:

```txt
React Native
Axios / Fetch wrapper
API interceptor
Token refresh
Error mapper
Idempotency
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
API Client = centralized network boundary
```

API client belongs to:

```txt
src/infrastructure/api/
```

UI must never call backend directly.

Correct flow:

```txt
presentation screen/view
  → presentation hook
  → application use case
  → infrastructure repository
  → infrastructure api client
  → backend
```

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/infrastructure/api/
  api-client.ts
  api-config.ts
  api-interceptor.ts
  refresh-token.interceptor.ts
  api-error.mapper.ts
  api-error.type.ts
  api-header.ts
  api-timeout.ts
```

Feature API/repository:

```txt
src/infrastructure/transfer/
  transfer.api.ts
  transfer.repository.ts
  transfer.mapper.ts

src/infrastructure/auth/
  auth.api.ts
  auth.repository.ts
  auth.mapper.ts
```

Meaning:

```txt
api-client.ts               → base axios/fetch instance
api-config.ts               → baseURL, timeout, environment config
api-interceptor.ts          → request/response interceptor
refresh-token.interceptor   → token refresh flow
api-error.mapper.ts         → normalize backend/network error
api-header.ts               → standard headers
api-timeout.ts              → timeout constants
<feature>.api.ts            → endpoint-level API function
<feature>.repository.ts     → data access implementation
<feature>.mapper.ts         → map API response to model
```

---

# ========================

# 🧱 API CLIENT RESPONSIBILITY

# ========================

API client MUST handle:

* base URL
* common headers
* request timeout
* token injection
* response normalization
* refresh token flow
* network error mapping
* request logging with sensitive masking

API client MUST NOT:

* contain UI logic
* contain business rules
* navigate user directly
* store token in Redux
* expose raw backend error directly to UI

---

# ========================

# ⚙️ API CONFIG RULE

# ========================

All API config must be centralized.

Example:

```ts
export const ApiConfig = {
  baseURL: Config.API_BASE_URL,
  timeout: 30000,
};
```

MUST NOT hardcode base URL inside feature API file.

### ❌ BAD

```ts
axios.get('https://api.example.com/users');
```

### ✅ GOOD

```ts
apiClient.get('/users');
```

---

# ========================

# 🌐 API CLIENT INSTANCE RULE

# ========================

Use one controlled API client instance per backend domain when possible.

Example:

```ts
import axios from 'axios';

export const apiClient = axios.create({
  baseURL: ApiConfig.baseURL,
  timeout: ApiConfig.timeout,
  headers: {
    'Content-Type': 'application/json',
  },
});
```

If multiple backend domains exist:

```txt
coreApiClient
paymentApiClient
publicApiClient
```

MUST:

* name clients clearly
* avoid random axios instances
* keep config centralized

---

# ========================

# 🔐 TOKEN INJECTION RULE

# ========================

Access token must be attached by interceptor only.

Token source:

```txt
tokenStorage → secure storage
```

Example:

```ts
apiClient.interceptors.request.use(async config => {
  const accessToken = await tokenStorage.getAccessToken();

  if (accessToken) {
    config.headers.Authorization = `Bearer ${accessToken}`;
  }

  return config;
});
```

MUST NOT manually attach token in screen/hook/usecase.

### ❌ BAD

```ts
apiClient.get('/profile', {
  headers: { Authorization: `Bearer ${token}` },
});
```

---

# ========================

# 🔄 REFRESH TOKEN RULE

# ========================

Refresh token flow must be centralized in response interceptor.

Correct flow:

```txt
Request returns 401
  → check if request already retried
  → call refresh token endpoint once
  → save new token to tokenStorage
  → retry original request once
  → if refresh fails, clear session
```

MUST:

* prevent refresh storm
* queue pending requests while refreshing
* retry original request only once
* clear tokens when refresh fails
* dispatch session expired event if needed

MUST NOT:

* retry forever
* refresh token inside every screen
* store refresh token in Redux
* log refresh token

---

# ========================

# 🚦 SINGLE REFRESH LOCK RULE

# ========================

Use one refresh promise/lock.

Example:

```ts
let refreshPromise: Promise<string | null> | null = null;

const refreshAccessTokenOnce = async () => {
  if (!refreshPromise) {
    refreshPromise = authRepository.refreshToken()
      .then(async tokens => {
        await tokenStorage.saveTokens(tokens);
        return tokens.accessToken;
      })
      .finally(() => {
        refreshPromise = null;
      });
  }

  return refreshPromise;
};
```

Rule:

```txt
Multiple 401 responses must trigger only one refresh request.
```

---

# ========================

# ⏱️ TIMEOUT RULE

# ========================

Use default timeout:

```txt
30 seconds for normal API
60+ seconds only for upload/download or partner-dependent flow
```

Timeout must be normalized:

```txt
TIMEOUT
```

Fintech rule:

```txt
Timeout does not always mean transaction failed.
Timeout can mean pending/unknown.
```

For money flow:

* keep requestId
* query transaction status after timeout when needed
* do not show success/failed blindly

---

# ========================

# 🔁 RETRY RULE

# ========================

Retry must be explicit and safe.

## Safe retry

```txt
GET app config
GET biller list
GET transaction history
```

## High-risk retry

```txt
POST transfer
POST payment
POST confirm transaction
POST cashout
POST topup
```

High-risk retry requires:

```txt
requestId / idempotency key
backend idempotency support
status inquiry endpoint
```

MUST NOT blindly retry money-moving request.

---

# ========================

# 🆔 IDEMPOTENCY HEADER RULE

# ========================

Money-related requests should include request id / idempotency key.

Possible headers:

```txt
X-Request-Id
Idempotency-Key
X-Idempotency-Key
```

Example:

```ts
apiClient.post('/transfers', payload, {
  headers: {
    'X-Request-Id': payload.requestId,
    'Idempotency-Key': payload.requestId,
  },
});
```

Rule:

```txt
Do not generate requestId inside apiClient silently.
Application/usecase should own requestId creation.
```

---

# ========================

# 🧾 STANDARD HEADERS RULE

# ========================

Common headers should be centralized.

Examples:

```txt
Authorization
Content-Type
Accept-Language
X-Request-Id
X-Device-Id
X-App-Version
X-Platform
X-Correlation-Id
```

Rules:

* language comes from app settings
* deviceId comes from safe device identity provider
* requestId comes from application flow
* token comes from tokenStorage

MUST NOT hardcode headers randomly across features.

---

# ========================

# 🚨 ERROR MAPPING RULE

# ========================

Raw backend/network error must be normalized before reaching UI.

Example type:

```ts
export type ApiError = {
  code: string;
  message: string;
  httpStatus?: number;
  traceId?: string;
  rawCode?: string;
};
```

Categories:

```txt
NETWORK_OFFLINE
TIMEOUT
UNAUTHORIZED
FORBIDDEN
BUSINESS_ERROR
VALIDATION_ERROR
SERVER_ERROR
UNKNOWN_ERROR
```

Example mapper:

```ts
export const mapApiError = (error: unknown): ApiError => {
  // normalize axios/fetch/backend error here
  return {
    code: 'UNKNOWN_ERROR',
    message: 'Something went wrong',
  };
};
```

Rule:

```txt
Presentation must not parse raw Axios/fetch error.
```

---

# ========================

# 🧪 FEATURE API RULE

# ========================

Feature API file should contain endpoint-level calls only.

Example:

```ts
export const transferApi = {
  submitTransfer(request: SubmitTransferApiRequest) {
    return apiClient.post<SubmitTransferApiResponse>(
      '/transfers',
      request,
      {
        headers: {
          'X-Request-Id': request.requestId,
          'Idempotency-Key': request.requestId,
        },
      },
    );
  },
};
```

MUST NOT:

* map response to UI here
* contain screen logic
* contain domain business rule

---

# ========================

# 🧩 REPOSITORY RULE

# ========================

Repository calls feature API and maps response.

Example:

```ts
export const transferRepository = {
  async submitTransfer(command: SubmitTransferCommand): Promise<TransferModel> {
    const request = mapSubmitTransferCommandToApiRequest(command);
    const response = await transferApi.submitTransfer(request);
    return mapSubmitTransferResponseToModel(response.data);
  },
};
```

Rule:

```txt
Repository hides raw API response from application/presentation.
```

---

# ========================

# 🔐 LOGGING & MASKING RULE

# ========================

API logging must mask sensitive data.

Never log:

```txt
Authorization header
access token
refresh token
OTP
PIN
password
CVV
private key
Soft OTP secret
full card number
raw identity image
```

Allowed log:

```txt
method
url path
http status
duration
requestId
traceId
safe error code
```

Example:

```txt
POST /transfers status=200 duration=350ms requestId=abc traceId=xyz
```

MUST NOT log full request/response body for money/auth APIs unless masked and approved.

---

# ========================

# 📡 NETWORK STATUS RULE

# ========================

API client should cooperate with network monitor.

If offline:

```txt
throw normalized NETWORK_OFFLINE error
```

MUST NOT:

* spam backend while offline
* show raw network error to UI
* retry indefinitely

---

# ========================

# 💸 FINTECH API RULE

# ========================

For money-related APIs:

MUST:

* include requestId / idempotency key
* use explicit timeout handling
* treat timeout as pending/unknown when appropriate
* support status inquiry flow
* prevent duplicate submit
* normalize business errors
* never show success unless backend confirms final state

MUST NOT:

* blindly retry POST payment/transfer
* log payload containing sensitive money data
* expose raw backend response directly to UI
* let API client silently generate transaction requestId

---

# ========================

# 🧪 TESTING RULE

# ========================

Must test:

* base URL config
* token injection
* missing token request
* refresh token success
* refresh token failure
* concurrent 401 single refresh
* timeout mapping
* network offline mapping
* backend business error mapping
* idempotency header for money APIs
* sensitive log masking

---

# ========================

# 🚫 ANTI-PATTERNS

# ========================

## 1. API call in screen

### ❌ BAD

```tsx
await axios.post('/transfer', payload);
```

---

## 2. Token attached manually everywhere

### ❌ BAD

```ts
headers: { Authorization: token }
```

---

## 3. Raw error to UI

### ❌ BAD

```ts
setError(error.response.data.message);
```

---

## 4. Blind retry payment

### ❌ BAD

```txt
POST /transfer timeout → retry immediately with new requestId
```

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Put base API client under `src/infrastructure/api/`
* Use centralized config and headers
* Attach token via interceptor from tokenStorage
* Handle refresh token centrally
* Prevent concurrent refresh storm
* Normalize all errors through api-error.mapper
* Use feature API files for endpoint calls
* Use repository for mapping API response to model
* Add requestId/idempotency header for money APIs
* Mask sensitive logs

AI MUST NOT:

* Call API directly from screen/component/hook
* Store token in Redux/Redux Persist
* Attach Authorization manually in feature code unless explicitly required
* Expose raw API response to UI
* Expose raw Axios/fetch error to UI
* Retry money POST blindly
* Generate requestId silently inside apiClient
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

Correct API flow:

```txt
presentation hook
  → application use case
  → infrastructure repository
  → feature api
  → api client
  → backend
```

Golden rule:

```txt
API client centralizes network behavior.
Repository maps data.
Application owns business flow.
UI never calls API directly.
```

This rule is mandatory for all API client code generation.

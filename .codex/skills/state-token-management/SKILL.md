---
name: state-token-management
description: Secure token management standards for mobile apps. Use when handling access tokens, refresh tokens, storage, interceptors, and auth session flow.
---

# State Token Management Guidelines

This Codex skill adapts `mobile-engineer/state-management/token-management.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🔐 TOKEN MANAGEMENT RULE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define secure token management rules for mobile applications to ensure:

* Safe authentication
* Secure token storage
* Clean API interceptor flow
* No token leakage
* Fintech / banking-grade security

Applied for:

```txt
React Native
Redux Toolkit
Redux Persist
API Client / Interceptor
Secure Storage
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
Token is sensitive data.
Token must NOT live in Redux, Redux Persist, route params, logs, or UI state.
```

Correct place:

```txt
Secure Storage → tokenStorage service → API interceptor
```

Wrong places:

```txt
Redux state
Redux Persist
AsyncStorage plain text
navigation params
component state
console log
analytics event
crash report metadata
```

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/infrastructure/storage/
  secure-storage.ts
  token-storage.ts

src/infrastructure/api/
  api-client.ts
  api-interceptor.ts
  refresh-token.interceptor.ts
  api-error.mapper.ts

src/application/slice/auth/
  auth.slice.ts
  auth.selector.ts

src/presentation/auth/hook/
  use-login.ts
  login.state.ts
```

Meaning:

```txt
secure-storage.ts          → Keychain / Keystore abstraction
token-storage.ts           → token-specific get/set/clear
api-interceptor.ts         → attach access token to request
refresh-token.interceptor  → handle refresh token flow
auth.slice.ts              → non-sensitive auth/session state only
use-login.ts               → screen logic, calls login use case
```

---

# ========================

# ✅ WHAT CAN BE STORED WHERE

# ========================

## Secure Storage

Allowed:

```txt
accessToken
refreshToken
tokenExpiredAt
sessionSecret if required
```

## Redux

Allowed:

```txt
isAuthenticated
userId
maskedPhoneNumber
sessionStatus
biometricEnabled flag
```

## Redux Persist

Allowed carefully:

```txt
isAuthenticated as UI hint only
maskedPhoneNumber
biometricEnabled flag
language/theme
```

## Memory only

Allowed:

```txt
short-lived access token cache if required
in-flight refresh promise
temporary authorization result
```

---

# ========================

# ❌ FORBIDDEN STORAGE

# ========================

Never store token in:

```txt
Redux
Redux Persist
AsyncStorage plain text
MMKV plain text
route params
screen state
component props
logs
analytics
crash report custom attributes
```

### ❌ BAD

```ts
state.auth.accessToken = token;
```

### ✅ GOOD

```ts
await tokenStorage.saveTokens({
  accessToken,
  refreshToken,
  expiresAt,
});
```

---

# ========================

# 🔐 SECURE STORAGE RULE

# ========================

Use platform secure storage:

```txt
iOS      → Keychain
Android  → Keystore / EncryptedSharedPreferences
RN       → secure-storage abstraction
```

Example abstraction:

```ts
export interface SecureStorage {
  setItem(key: string, value: string): Promise<void>;
  getItem(key: string): Promise<string | null>;
  removeItem(key: string): Promise<void>;
  clear(): Promise<void>;
}
```

Rule:

```txt
Application code must not know Keychain/Keystore details.
```

---

# ========================

# 🧾 TOKEN STORAGE SERVICE

# ========================

Token access must go through `tokenStorage`.

Example:

```ts
export type TokenPair = {
  accessToken: string;
  refreshToken: string;
  expiresAt?: number;
};

export const tokenStorage = {
  async saveTokens(tokens: TokenPair): Promise<void> {
    await secureStorage.setItem('accessToken', tokens.accessToken);
    await secureStorage.setItem('refreshToken', tokens.refreshToken);

    if (tokens.expiresAt) {
      await secureStorage.setItem('expiresAt', String(tokens.expiresAt));
    }
  },

  async getAccessToken(): Promise<string | null> {
    return secureStorage.getItem('accessToken');
  },

  async getRefreshToken(): Promise<string | null> {
    return secureStorage.getItem('refreshToken');
  },

  async clearTokens(): Promise<void> {
    await secureStorage.removeItem('accessToken');
    await secureStorage.removeItem('refreshToken');
    await secureStorage.removeItem('expiresAt');
  },
};
```

Rule:

```txt
Only tokenStorage knows token keys.
```

---

# ========================

# 🌐 API INTERCEPTOR RULE

# ========================

API interceptor attaches token automatically.

### ✅ GOOD

```ts
apiClient.interceptors.request.use(async config => {
  const accessToken = await tokenStorage.getAccessToken();

  if (accessToken) {
    config.headers.Authorization = `Bearer ${accessToken}`;
  }

  return config;
});
```

Presentation/application should NOT manually attach token.

### ❌ BAD

```ts
await apiClient.get('/profile', {
  headers: {
    Authorization: `Bearer ${token}`,
  },
});
```

---

# ========================

# 🔄 REFRESH TOKEN RULE

# ========================

Refresh flow must be centralized.

Correct flow:

```txt
API request returns 401
  → refresh token interceptor starts refresh
  → save new tokens to tokenStorage
  → retry original request once
  → if refresh fails, clear session and force logout
```

MUST:

* Prevent multiple refresh requests at the same time
* Queue pending requests while refreshing
* Retry original request only once
* Clear tokens if refresh fails
* Never refresh endlessly

MUST NOT:

* Trigger refresh from every screen manually
* Store refresh token in Redux
* Retry forever on 401
* Log refresh token

---

# ========================

# 🚦 SINGLE REFRESH LOCK RULE

# ========================

Use a single refresh lock/promise.

Concept:

```txt
If refresh is already running, other requests wait for it.
```

Pseudo example:

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

---

# ========================

# 🚪 LOGOUT RULE

# ========================

Logout must clear all session-related data.

MUST clear:

```txt
access token
refresh token
secure session values
Redux auth state
Redux Persist state if needed
temporary transaction state
in-memory refresh promise
```

Example:

```ts
await tokenStorage.clearTokens();
dispatch(logout());
await persistor.purge();
```

Rule:

```txt
Logout must leave no usable token behind.
```

---

# ========================

# 🧠 APP START SESSION RULE

# ========================

On app start:

```txt
Load persisted non-sensitive state
  → check token existence from secure storage
  → optionally validate session with backend
  → route user to Auth or Main
```

MUST NOT:

```txt
Navigate to Home only because Redux Persist has isAuthenticated = true
```

`isAuthenticated` is only a UI hint.

Real session depends on:

```txt
secure token storage + token validity + backend validation when needed
```

---

# ========================

# 🔐 BIOMETRIC TOKEN ACCESS RULE

# ========================

If biometric is used:

* Biometric gates access to secure storage or session unlock
* Biometric success does not mean backend session is valid
* Token still must be validated/refreshed normally

MUST NOT:

```txt
store biometric secret in JS
return biometric secret to UI
use biometric flag as login proof without token/session validation
```

---

# ========================

# 💸 FINTECH SECURITY RULE

# ========================

For banking/payment apps:

MUST:

* Use short-lived access token when possible
* Use refresh token rotation when backend supports it
* Clear tokens on suspicious device state if policy requires
* Clear tokens on root/jailbreak detection if policy requires
* Avoid token in WebView URL/query params
* Avoid token in deep link params
* Avoid token in clipboard

MUST NOT:

* Store token in plain text
* Print token in logs
* Send token to analytics
* Attach token to third-party domains accidentally
* Pass token to mini app unless explicitly approved by security design

---

# ========================

# 🧾 LOGGING RULE

# ========================

Never log:

```txt
accessToken
refreshToken
Authorization header
Set-Cookie
OTP
PIN
password
Soft OTP secret
private key
```

### ❌ BAD

```ts
console.log('accessToken', accessToken);
```

### ✅ GOOD

```ts
logger.info('Token loaded from secure storage');
```

Mask authorization headers in API logger.

---

# ========================

# 🧪 TESTING RULE

# ========================

Must test:

* token saved to secure storage
* token not saved to Redux
* token not saved to Redux Persist
* API interceptor attaches token
* refresh token flow retries once
* concurrent 401 triggers one refresh only
* refresh failure clears session
* logout clears token
* app start does not trust persisted auth blindly

Security checklist:

```txt
Search Redux state for token → none
Search persisted storage for token → none
Search logs for token → none
Search navigation params for token → none
```

---

# ========================

# 🚫 ANTI-PATTERNS

# ========================

## 1. Token in Redux

### ❌ BAD

```ts
const authState = {
  accessToken,
  refreshToken,
};
```

---

## 2. Token in route params

### ❌ BAD

```ts
navigation.navigate(RouteName.Home, { accessToken });
```

---

## 3. Manual token header everywhere

### ❌ BAD

```ts
api.get('/user', { headers: { Authorization: token } });
```

---

## 4. Infinite refresh loop

### ❌ BAD

```txt
401 → refresh → 401 → refresh → 401 → refresh forever
```

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Store token only in secure storage via `tokenStorage`
* Keep Redux auth state non-sensitive
* Use API interceptor to attach access token
* Centralize refresh token flow
* Prevent concurrent refresh storms
* Retry original request only once after refresh
* Clear tokens on logout/refresh failure
* Avoid token in logs, route params, Redux Persist, analytics

AI MUST NOT:

* Store access token / refresh token in Redux
* Persist token with Redux Persist
* Store token in plain AsyncStorage
* Pass token through navigation params
* Log Authorization header
* Refresh token endlessly
* Put token access logic inside screen/component
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

Correct token flow:

```txt
Login success
  → tokenStorage.saveTokens()
  → Redux stores non-sensitive session state
  → API interceptor attaches token
  → refresh interceptor handles 401
  → logout clears tokenStorage + Redux state
```

Golden rule:

```txt
Token belongs to secure storage, not Redux.
```

This rule is mandatory for all token management code generation.

## Mandatory For AI Code Generation

- Never store tokens in Redux, Redux Persist, AsyncStorage plain text, route params, component state, logs, analytics, or crash reports.
- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

---
name: state-storage-mmkv
description: MMKV storage standards for mobile apps. Use when storing fast local non-sensitive data and designing storage abstractions.
---

# State Storage MMKV Guidelines

This skill converts `mobile-engineer/state-management/storage-mmkv.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# ⚡ MMKV STORAGE RULE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define how to use MMKV storage safely in React Native to ensure:

* Fast local storage
* Clear storage responsibility
* Safe cache usage
* No sensitive data leakage
* Fintech / banking-grade data handling

Applied for:

```txt
React Native
react-native-mmkv
local cache
app preferences
non-sensitive persisted state
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
MMKV = fast local storage for non-sensitive data
Secure Storage = token / secret / sensitive data
Redux Persist = selected non-sensitive global state
```

MMKV MUST NOT be treated as secure storage by default.

Golden rule:

```txt
If data can authenticate, authorize, sign, pay, or identify deeply → DO NOT store in MMKV.
```

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/infrastructure/storage/
  mmkv-storage.ts
  mmkv-key.ts
  secure-storage.ts
  token-storage.ts

src/infrastructure/cache/
  cache-storage.ts
  cache-key.ts
```

Meaning:

```txt
mmkv-storage.ts   → generic MMKV wrapper
mmkv-key.ts       → centralized MMKV keys
secure-storage.ts → Keychain / Keystore abstraction
token-storage.ts  → token-specific secure storage wrapper
cache-storage.ts  → domain-safe cache wrapper
cache-key.ts      → centralized cache keys
```

---

# ========================

# ✅ WHAT CAN BE STORED IN MMKV

# ========================

Allowed:

```txt
app language
theme mode
onboarding completed flag
feature flags cache
non-sensitive app config
last selected tab
non-sensitive UI preference
masked phone number
masked account number
biometric enabled flag only
cached biller/category list
cached non-sensitive lookup data
```

Example:

```ts
await mmkvStorage.setBoolean('onboardingCompleted', true);
await mmkvStorage.setString('language', 'vi');
await mmkvStorage.setString('maskedPhoneNumber', '090*****89');
```

---

# ========================

# ❌ WHAT MUST NOT BE STORED IN MMKV

# ========================

Forbidden:

```txt
access token
refresh token
OTP
PIN
password
Soft OTP secret
private key
CVV
full card number
raw identity document image
raw eKYC data
session secret
raw payment payload
raw transfer payload
```

### ❌ BAD

```ts
mmkv.set('accessToken', accessToken);
mmkv.set('pin', pin);
mmkv.set('softOtpSecret', secret);
```

### ✅ GOOD

```ts
await tokenStorage.saveTokens(tokens);
await secureStorage.setItem('softOtpSecret', secret);
```

---

# ========================

# 🧱 MMKV WRAPPER RULE

# ========================

Do not use raw MMKV everywhere.

### ✅ GOOD

```ts
import { MMKV } from 'react-native-mmkv';

const storage = new MMKV({
  id: 'app-storage',
});

export const mmkvStorage = {
  setString(key: string, value: string): void {
    storage.set(key, value);
  },

  getString(key: string): string | undefined {
    return storage.getString(key);
  },

  setBoolean(key: string, value: boolean): void {
    storage.set(key, value);
  },

  getBoolean(key: string): boolean | undefined {
    return storage.getBoolean(key);
  },

  remove(key: string): void {
    storage.delete(key);
  },

  clearAll(): void {
    storage.clearAll();
  },
};
```

### ❌ BAD

```ts
const storage = new MMKV();
storage.set('randomKey', value);
```

Rule:

```txt
All MMKV access must go through wrapper.
```

---

# ========================

# 🏷️ KEY MANAGEMENT RULE

# ========================

All keys MUST be centralized.

### ✅ GOOD

```ts
export const MMKVKey = {
  Language: 'app.language',
  ThemeMode: 'app.themeMode',
  OnboardingCompleted: 'app.onboardingCompleted',
  FeatureFlags: 'app.featureFlags',
  MaskedPhoneNumber: 'user.maskedPhoneNumber',
} as const;
```

Usage:

```ts
mmkvStorage.setString(MMKVKey.Language, 'vi');
```

### ❌ BAD

```ts
mmkvStorage.setString('lang', 'vi');
mmkvStorage.setString('language_value', 'vi');
```

Rule:

```txt
No random storage keys.
```

---

# ========================

# 📦 CACHE STORAGE RULE

# ========================

For cached data, create cache wrapper instead of using MMKV directly.

Example:

```ts
export type CacheItem<T> = {
  data: T;
  cachedAt: number;
  expiresAt?: number;
};

export const cacheStorage = {
  set<T>(key: string, data: T, ttlMs?: number): void {
    const now = Date.now();
    const item: CacheItem<T> = {
      data,
      cachedAt: now,
      expiresAt: ttlMs ? now + ttlMs : undefined,
    };

    mmkvStorage.setString(key, JSON.stringify(item));
  },

  get<T>(key: string): T | null {
    const raw = mmkvStorage.getString(key);
    if (!raw) return null;

    const item = JSON.parse(raw) as CacheItem<T>;

    if (item.expiresAt && item.expiresAt < Date.now()) {
      mmkvStorage.remove(key);
      return null;
    }

    return item.data;
  },
};
```

Rule:

```txt
Cache must support timestamp and optional TTL.
```

---

# ========================

# 🔐 ENCRYPTED MMKV RULE

# ========================

MMKV can support encryption, but encrypted MMKV still must be used carefully.

Allowed for encrypted MMKV:

```txt
low/medium sensitivity cache
masked user info
app config cache
```

Still avoid storing:

```txt
access token
refresh token
PIN
OTP
Soft OTP secret
private key
CVV
```

Reason:

```txt
Security policy should keep secrets in platform secure storage, not generic app storage.
```

If encrypted MMKV is used:

```ts
const storage = new MMKV({
  id: 'app-secure-cache',
  encryptionKey: encryptionKeyFromSecureStorage,
});
```

Rules:

* encryption key must not be hardcoded
* encryption key must come from secure storage / platform keystore flow
* rotate key when policy requires
* clear encrypted MMKV on logout if it contains user-related data

---

# ========================

# 🔁 REDUX PERSIST WITH MMKV RULE

# ========================

MMKV may be used as Redux Persist storage only for non-sensitive slices.

Persist allowed:

```txt
app
settings
featureFlags
non-sensitive preferences
```

Persist forbidden:

```txt
auth token
OTP
PIN
Soft OTP secret
payment payload
sensitive transaction state
```

Use whitelist only:

```ts
const persistConfig = {
  key: 'root',
  storage: mmkvPersistStorage,
  whitelist: ['app', 'settings'],
};
```

Rule:

```txt
MMKV speed does not change security rules.
```

---

# ========================

# 🚪 LOGOUT / CLEAR RULE

# ========================

On logout, clear user-related MMKV data.

MUST clear:

```txt
masked user info
cached user profile snapshot
cached transaction history snapshot if user-specific
feature/session flags if user-specific
pending safe sync queue if user-specific
```

MUST NOT clear globally unless intended:

```txt
language
theme
app config
onboarding flag
```

Example:

```ts
export const clearUserLocalData = () => {
  mmkvStorage.remove(MMKVKey.MaskedPhoneNumber);
  mmkvStorage.remove(CacheKey.TransactionHistory);
  mmkvStorage.remove(CacheKey.UserProfile);
};
```

---

# ========================

# 💸 FINTECH RULE

# ========================

For banking/payment apps:

MMKV can store:

```txt
masked account number
masked phone number
last selected safe preference
cached biller/category list
pending transaction id/status if non-sensitive
```

MMKV must NOT store:

```txt
full account number when not necessary
full card number
CVV
OTP
PIN
payment password
Soft OTP secret
private signing key
raw transaction authorization payload
```

Transaction cache rule:

```txt
Store only identifiers/status needed for recovery.
Never store authorization secrets or full money payload.
```

---

# ========================

# 🧪 TESTING RULE

# ========================

Must test:

* wrapper set/get/remove
* centralized key usage
* cache TTL expiration
* logout clears user-specific keys
* Redux Persist whitelist only persists safe slices
* forbidden sensitive fields are not stored

Security checklist:

```txt
Search MMKV keys for token → none
Search MMKV values for token → none
Search MMKV for OTP/PIN → none
Search MMKV for Soft OTP secret → none
Search MMKV for full card/CVV → none
```

Expected:

```txt
No sensitive value found.
```

---

# ========================

# 🚫 ANTI-PATTERNS

# ========================

## 1. Store token in MMKV

### ❌ BAD

```ts
mmkvStorage.setString('accessToken', token);
```

---

## 2. Random keys everywhere

### ❌ BAD

```ts
mmkvStorage.setString('abc', value);
```

---

## 3. Cache without TTL for dynamic data

### ❌ BAD

```ts
mmkvStorage.setString('transactionHistory', JSON.stringify(data));
```

---

## 4. Store payment form for later submit

### ❌ BAD

```ts
mmkvStorage.setString('transferPayload', JSON.stringify(payload));
```

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Put MMKV wrapper under `src/infrastructure/storage/`
* Centralize MMKV keys in `mmkv-key.ts`
* Use cache wrapper for cached data
* Use TTL for dynamic cache when appropriate
* Store only non-sensitive data in MMKV
* Keep tokens/secrets in secure storage
* Clear user-related MMKV data on logout
* Use Redux Persist whitelist if MMKV backs Redux Persist

AI MUST NOT:

* Store access token / refresh token in MMKV
* Store OTP / PIN / Soft OTP secret in MMKV
* Store private key / CVV / full card number in MMKV
* Use random string keys directly
* Persist full payment/transfer payload
* Treat encrypted MMKV as replacement for Keychain/Keystore
* Put MMKV access inside UI component directly
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

Correct storage split:

```txt
MMKV           = fast non-sensitive local storage/cache
Secure Storage = token / secret / sensitive data
Redux Persist  = selected non-sensitive global state
Cache Storage   = MMKV wrapper with TTL/timestamp
```

Golden rule:

```txt
MMKV is fast, not automatically safe for secrets.
```

This rule is mandatory for all MMKV storage code generation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

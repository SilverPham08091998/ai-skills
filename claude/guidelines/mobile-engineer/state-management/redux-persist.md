# ========================

# 💾 REDUX PERSIST RULE (STATE MANAGEMENT)

# ========================

## 🎯 OBJECTIVE

Define how to use Redux Persist safely in React Native to ensure:

* Controlled persisted state
* Fast app startup
* Safe session recovery
* No sensitive data leakage
* Fintech-grade security

Applied for:

```txt
React Native + Redux Toolkit + Redux Persist
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
Redux Persist = Non-sensitive persisted global state only
```

Redux Persist MUST NOT be used as secure storage.

Use secure storage for secrets:

```txt
iOS      → Keychain
Android  → Keystore / EncryptedSharedPreferences
RN       → secure storage wrapper
```

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/application/store/
  store.ts
  root-reducer.ts
  persist-config.ts
  persist-transform.ts

src/application/slice/
  auth/
    auth.slice.ts
    auth.selector.ts
  app/
    app.slice.ts
    app.selector.ts
  settings/
    settings.slice.ts
    settings.selector.ts
```

Storage abstraction:

```txt
src/infrastructure/storage/
  async-storage.ts
  secure-storage.ts
  token-storage.ts
```

---

# ========================

# ✅ WHAT CAN BE PERSISTED

# ========================

Allowed persisted state:

```txt
app language
app theme
onboarding completed flag
feature flags cache
last selected environment (non-production internal builds only)
masked user info
non-sensitive user preferences
notification preference
biometric enabled flag (boolean only)
```

Examples:

```ts
{
  language: 'vi',
  themeMode: 'dark',
  onboardingCompleted: true,
  biometricEnabled: true,
  maskedPhoneNumber: '090*****89'
}
```

---

# ========================

# ❌ WHAT MUST NOT BE PERSISTED

# ========================

Forbidden persisted state:

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
session secret
raw eKYC data
raw transaction payload containing sensitive fields
```

Rule:

```txt
If data can authenticate, authorize, sign, pay, or identify user deeply → DO NOT persist in Redux Persist.
```

---

# ========================

# 🔐 TOKEN STORAGE RULE

# ========================

Tokens MUST NOT be stored in Redux Persist.

### ❌ BAD

```ts
const authState = {
  accessToken: 'abc',
  refreshToken: 'xyz',
};
```

### ✅ GOOD

```txt
Redux state:
- isAuthenticated
- userId
- maskedPhoneNumber

Secure storage:
- accessToken
- refreshToken
```

Token access flow:

```txt
API interceptor
  → tokenStorage.getAccessToken()
  → secure-storage
```

---

# ========================

# 🧱 PERSIST CONFIG RULE

# ========================

Use whitelist, not blacklist.

### ✅ GOOD

```ts
import AsyncStorage from '@react-native-async-storage/async-storage';
import { persistReducer } from 'redux-persist';

const persistConfig = {
  key: 'root',
  storage: AsyncStorage,
  whitelist: ['app', 'settings'],
};

export const persistedReducer = persistReducer(persistConfig, rootReducer);
```

### ❌ BAD

```ts
const persistConfig = {
  key: 'root',
  storage: AsyncStorage,
  blacklist: ['token'],
};
```

Reason:

```txt
Whitelist is safer because new slices are not persisted by accident.
```

---

# ========================

# 🧩 SLICE-LEVEL PERSIST RULE

# ========================

Prefer slice-level persist when only some slices need persistence.

Example:

```ts
const settingsPersistConfig = {
  key: 'settings',
  storage: AsyncStorage,
  whitelist: ['language', 'themeMode'],
};

const persistedSettingsReducer = persistReducer(
  settingsPersistConfig,
  settingsReducer,
);
```

Rule:

```txt
Persist only what is required.
```

---

# ========================

# 🔄 REHYDRATION RULE

# ========================

Rehydration must not automatically trust session.

On app start:

```txt
PersistGate rehydrates non-sensitive state
  → app checks secure token storage
  → app validates session if needed
  → app routes user to correct flow
```

MUST NOT:

```txt
Assume user is logged in only because Redux Persist has isAuthenticated = true
```

Recommended:

```txt
isAuthenticated persisted value is only a UI hint.
Real session validity comes from secure token storage + backend validation.
```

---

# ========================

# 🚪 LOGOUT / PURGE RULE

# ========================

Logout MUST clear:

```txt
Redux state
Redux Persist state when needed
Secure storage token
Sensitive in-memory state
```

Example:

```ts
await tokenStorage.clear();
persistor.purge();
dispatch(logout());
```

For fintech apps, logout should also clear:

```txt
cached transaction drafts
OTP state
PIN state
user session flags
temporary payment state
```

---

# ========================

# 💸 FINTECH TRANSACTION RULE

# ========================

Do NOT persist active transaction state blindly.

Forbidden:

```txt
OTP value
PIN value
full payment payload
raw account/card data
sensitive transfer form
```

Allowed carefully:

```txt
transactionId
requestId
masked receiver account
pending transaction status
last known non-sensitive transaction status
```

Rule:

```txt
Persist only identifiers/status needed to recover pending flow.
Never persist secrets or full money payload.
```

---

# ========================

# 🔐 TRANSFORM / FILTER RULE

# ========================

Use transform/filter if a slice contains mixed data.

Example:

```ts
import { createTransform } from 'redux-persist';

export const authPersistTransform = createTransform(
  (inboundState) => ({
    isAuthenticated: inboundState.isAuthenticated,
    userId: inboundState.userId,
    maskedPhoneNumber: inboundState.maskedPhoneNumber,
  }),
  (outboundState) => outboundState,
  { whitelist: ['auth'] },
);
```

MUST NOT rely only on developer memory to avoid persisting secrets.

---

# ========================

# ⚠️ VERSIONING / MIGRATION RULE

# ========================

Persisted state must be versioned when schema can change.

Example:

```ts
const persistConfig = {
  key: 'root',
  storage: AsyncStorage,
  version: 2,
  whitelist: ['app', 'settings'],
  migrate: createMigrate(migrations, { debug: false }),
};
```

Use migration when:

* state shape changes
* field is renamed
* persisted slice is split
* old data becomes unsafe

---

# ========================

# 🧪 TESTING RULE

# ========================

Must test:

* allowed slices are persisted
* forbidden fields are not persisted
* logout clears persisted state
* rehydration does not bypass session validation
* migration works for old persisted state

Security test checklist:

```txt
Search persisted storage for token
Search persisted storage for PIN
Search persisted storage for OTP
Search persisted storage for Soft OTP secret
```

Expected:

```txt
No sensitive value found.
```

---

# ========================

# 🚫 ANTI-PATTERNS

# ========================

## 1. Persist all Redux state

### ❌ BAD

```ts
whitelist: ['auth', 'transfer', 'payment', 'otp']
```

---

## 2. Store token in Redux

### ❌ BAD

```ts
state.auth.accessToken = token;
```

---

## 3. Trust persisted login blindly

### ❌ BAD

```ts
if (state.auth.isAuthenticated) {
  navigation.navigate(RouteName.Home);
}
```

---

## 4. Persist form state for payment

### ❌ BAD

```ts
state.transfer.amount = amount;
state.transfer.receiverAccount = receiverAccount;
state.transfer.pin = pin;
```

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Use whitelist-based persist config
* Persist only non-sensitive slices/fields
* Keep token/secret in secure storage, not Redux Persist
* Clear persisted state on logout when needed
* Add migration/version when persisted schema changes
* Add transform/filter for mixed sensitivity slices
* Treat `isAuthenticated` as UI/session hint only

AI MUST NOT:

* Persist the entire Redux store blindly
* Store access token / refresh token in Redux Persist
* Store OTP / PIN / Soft OTP secret in Redux Persist
* Persist full transaction/payment payload
* Use persisted state as proof of valid login
* Put secure storage implementation inside Redux slice
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

Correct usage:

```txt
Redux Persist = non-sensitive global preferences/state
Secure Storage = token / secret / sensitive data
Redux = current global state
Hook = screen state
Application = business flow
```

Golden rule:

```txt
Persist less. Persist safely. Never persist secrets.
```

This rule is mandatory for all Redux Persist code generation.

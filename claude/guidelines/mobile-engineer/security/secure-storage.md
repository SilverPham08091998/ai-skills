# security/secure-storage.md

## Objective

Define standards for securely storing data on mobile devices (React Native) in fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Authentication/session data
* Local persistence (Keychain/Keystore, Secure Enclave/StrongBox)

Main rule:

> Assume device compromise is possible.
> Store the minimum, protect everything, and never persist secrets unnecessarily.

---

# 1. Core Principles

## 1.1 Data Minimization

* Store only what is strictly required
* Prefer server-side state over client persistence

## 1.2 Separation of Concerns

* UI layer must not access storage directly
* Use a repository/service abstraction for storage

## 1.3 Defense in Depth

Combine:

* OS secure storage (Keychain/Keystore)
* App-level encryption (when needed)
* Runtime protections (root/jailbreak detection)

---

# 2. Storage Classification

Classify data before storing:

| Level  | Type          | Examples                  | Storage                     |
| ------ | ------------- | ------------------------- | --------------------------- |
| HIGH   | Secrets       | accessToken, refreshToken | Keychain/Keystore only      |
| MEDIUM | Sensitive     | userId, phone (masked)    | Secure storage or encrypted |
| LOW    | Non-sensitive | feature flags, UI cache   | AsyncStorage / MMKV         |

Rules:

* Never downgrade storage level
* Always treat tokens as HIGH sensitivity

---

# 3. Allowed Storage Mechanisms

## 3.1 iOS Keychain

* Encrypted by OS
* Supports access control (biometrics, device unlock)

## 3.2 Android Keystore

* Hardware-backed when available (TEE/StrongBox)
* Keys are non-exportable

## 3.3 Recommended Libraries (React Native)

* `react-native-keychain`
* `expo-secure-store` (Expo)

---

# 4. Forbidden Storage

Do NOT store sensitive data in:

* AsyncStorage
* Redux store
* MMKV (unless encrypted and approved for non-secret data)
* plain files
* logs

---

# 5. Token Storage Rules

## 5.1 Access Token

* Store in Keychain/Keystore
* Short TTL preferred

## 5.2 Refresh Token

* Store in Keychain/Keystore
* Stronger access control (biometric when required by product)

## 5.3 In-memory Cache

* Keep tokens in memory for active session
* Clear on logout / app background (configurable)

---

# 6. API Design for Storage Layer

## 6.1 Interface

```ts
export interface SecureStorage {
  setItem(key: string, value: string): Promise<void>;
  getItem(key: string): Promise<string | null>;
  removeItem(key: string): Promise<void>;
  clear(): Promise<void>;
}
```

## 6.2 Usage

```ts
await secureStorage.setItem('access_token', token);
const token = await secureStorage.getItem('access_token');
```

Rules:

* Do not expose underlying library to upper layers
* Keys must be centralized (no hardcoded strings everywhere)

---

# 7. Key Management

## 7.1 Key Naming Convention

```txt
auth.accessToken
auth.refreshToken
user.profile
```

## 7.2 Rotation

* Rotate tokens on refresh
* Overwrite old values immediately

---

# 8. Encryption (Advanced)

## 8.1 When to add extra encryption

* When storing MEDIUM sensitive data outside Keychain
* When business requires additional layer

## 8.2 Rules

* Do not hardcode encryption keys
* Use keys generated/stored in Keystore/Keychain

---

# 9. Data Lifecycle

## 9.1 On Login

* Save tokens securely
* Initialize in-memory cache

## 9.2 On Logout

```ts
await secureStorage.clear();
```

* Clear all sensitive data
* Reset app state

## 9.3 On Token Expiry

* Remove invalid tokens
* Trigger re-authentication

---

# 10. Background & App State

## 10.1 App Background

* Optionally clear sensitive in-memory data
* Keep persistent tokens only in secure storage

## 10.2 App Kill

* Rely on secure storage for restoration

---

# 11. Backup & Restore

## 11.1 iOS Backup

* Keychain may be backed up depending on configuration

## 11.2 Android Backup

* Disable backup for sensitive data if needed

Rules:

* Do not allow sensitive data restoration on another device

---

# 12. Root/Jailbreak Consideration

If device is compromised:

* Restrict secure storage usage
* Disable high-risk features
* Show warning to user

---

# 13. Logging Rules

Never log:

* token values
* secure storage keys
* decrypted content

Allowed:

* operation result (success/failure)

---

# 14. Testing Rules

* Mock secure storage in unit tests
* Do not use real Keychain/Keystore in tests

Example:

```ts
class MockSecureStorage implements SecureStorage {
  private store = new Map<string, string>();

  async setItem(key: string, value: string) {
    this.store.set(key, value);
  }

  async getItem(key: string) {
    return this.store.get(key) ?? null;
  }

  async removeItem(key: string) {
    this.store.delete(key);
  }

  async clear() {
    this.store.clear();
  }
}
```

---

# 15. Fintech Rules (CRITICAL)

## 15.1 Never Persist Secrets

Do not persist:

* OTP
* PIN
* CVV
* private keys (unless hardware-backed and strictly required)

## 15.2 Mask Sensitive Data

* Mask phone, account number when stored

## 15.3 Session Integrity

* Bind session to device when required
* Invalidate session on suspicious activity

---

# 16. Checklist

* [ ] Tokens stored in Keychain/Keystore
* [ ] No sensitive data in AsyncStorage/Redux
* [ ] Storage abstraction implemented
* [ ] Keys centralized and consistent
* [ ] Data cleared on logout
* [ ] No sensitive logging
* [ ] Backup rules reviewed

---

# 17. Final Rule

> Secure storage must rely on OS-level protection first.
> Never store secrets unless absolutely necessary.
> Always assume data at rest can be targeted and design accordingly.

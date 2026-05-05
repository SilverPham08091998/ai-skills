# security/encryption.md

## Objective

Define encryption standards for mobile applications (React Native) in fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Data at rest
* Data in transit
* Secure storage & key management

Main rule:

> Encryption is not optional for sensitive data.
> Use strong, proven cryptography and never implement custom algorithms.

---

# 1. Core Principles

## 1.1 Use Proven Standards Only

* AES (for symmetric encryption)
* RSA / ECC (for asymmetric)
* SHA-256+ (for hashing)

Rules:

* Never create your own crypto algorithm
* Never use outdated algorithms (MD5, SHA1, DES)

---

## 1.2 Encryption ≠ Security Alone

Encryption must be combined with:

* secure storage (Keychain/Keystore)
* transport security (HTTPS)
* proper key management

---

## 1.3 Minimize Encryption Scope

* Only encrypt what is necessary
* Prefer OS-level protection first

---

# 2. Data in Transit

## 2.1 HTTPS Mandatory

* TLS 1.2+
* Reject HTTP

## 2.2 SSL Pinning (Recommended)

* Prevent MITM attacks
* Use public key pinning when possible

---

# 3. Data at Rest

## 3.1 Use OS Secure Storage First

* iOS Keychain
* Android Keystore

Rules:

* Prefer OS-level encryption over manual encryption

---

## 3.2 When to Use App-level Encryption

Use additional encryption when:

* storing MEDIUM sensitive data outside secure storage
* caching sensitive responses

---

# 4. Symmetric Encryption (AES)

## 4.1 Standard

* AES-256
* Mode: GCM (preferred) or CBC with IV

## 4.2 Example (concept)

```ts
const encrypted = encryptAES(data, key);
const decrypted = decryptAES(encrypted, key);
```

Rules:

* Always use random IV
* Never reuse IV with same key

---

# 5. Key Management (CRITICAL)

## 5.1 Never Hardcode Keys

Bad:

```ts
const key = 'my-secret-key';
```

---

## 5.2 Store Keys Securely

* Store encryption keys in Keystore/Keychain
* Use hardware-backed storage when available

---

## 5.3 Key Rotation

* Rotate keys periodically
* Invalidate old keys safely

---

# 6. Asymmetric Encryption

Use for:

* key exchange
* secure communication setup

Examples:

* RSA-2048+
* ECC (preferred for mobile performance)

---

# 7. Hashing

Use for:

* data integrity
* fingerprinting

Rules:

* Use SHA-256 or higher
* Never use hashing for reversible encryption

---

# 8. Secure API Usage

## 8.1 Do NOT encrypt payload manually unless required

* HTTPS already provides encryption
* Double encryption only when business requires

---

## 8.2 When to Add Payload Encryption

* highly sensitive data
* partner API requirement

---

# 9. Fintech Rules (CRITICAL)

## 9.1 Protect Financial Data

* encrypt stored account data if needed
* never expose raw values

---

## 9.2 Token Protection

* store tokens in secure storage
* do not encrypt then store in unsafe storage

---

## 9.3 OTP / PIN

* never encrypt & store
* use in-memory only

---

# 10. Performance Consideration

* encryption is CPU intensive
* avoid encrypting large data on UI thread
* use native modules if needed

---

# 11. Logging Rules

Do NOT log:

* keys
* decrypted data
* raw encrypted payload

---

# 12. Testing Rules

* use mock keys in test
* do not use production keys

---

# 13. Checklist

* [ ] HTTPS enforced
* [ ] No hardcoded keys
* [ ] Secure key storage used
* [ ] AES-256 or equivalent used
* [ ] No weak algorithms
* [ ] Sensitive data encrypted when required

---

# 14. Final Rule

> Encryption must be implemented correctly or not at all.
> Poor cryptography is worse than no cryptography.

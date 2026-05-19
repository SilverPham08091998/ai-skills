# security/mobile-security.md

## Objective

Define security standards for mobile applications (React Native) in fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript
* API integration layer
* Authentication & session management
* Device & storage security

Main rule:

> Assume the mobile environment is hostile.
> Never trust the client. Always validate on backend.

---

# 1. Core Principles

## 1.1 Zero Trust Client

* Client can be rooted/jailbroken
* Traffic can be intercepted
* App can be reverse engineered

Rules:

* Never trust client input
* Never enforce critical business logic on mobile
* Always validate server-side

---

## 1.2 Least Privilege

* Request only necessary permissions
* Do not store unnecessary sensitive data

---

## 1.3 Defense in Depth

Combine:

* Transport security
* Storage security
* Runtime protection
* Backend validation

---

# 2. Transport Security

## 2.1 HTTPS Only

* All API calls must use HTTPS
* Reject HTTP completely

---

## 2.2 SSL Pinning (Recommended)

Use:

* TrustKit (iOS)
* Network Security Config (Android)

Rules:

* Prevent MITM attacks
* Pin public key or certificate

---

## 2.3 Disable Insecure TLS

* TLS 1.2+
* Disable weak ciphers

---

# 3. Authentication & Session

## 3.1 Token Storage

Do NOT store tokens in:

* AsyncStorage
* Redux store
* plain files

Use:

* iOS Keychain
* Android Keystore

---

## 3.2 Access Token Rules

* Short TTL
* Use refresh token
* Rotate tokens

---

## 3.3 Session Handling

* Handle 401 centrally
* Auto logout when refresh fails

---

# 4. Secure Storage

## 4.1 Sensitive Data

Never store:

* password
* PIN
* OTP
* full card number
* private keys

---

## 4.2 Encryption

* Use OS-level secure storage
* Encrypt additional data if needed

---

# 5. Input Validation

## 5.1 Client-side validation

* Improve UX only

## 5.2 Server-side validation (MANDATORY)

* Always validate again on backend

---

# 6. Logging Rules

Do NOT log:

* token
* OTP
* PIN
* personal data

Allowed:

* error code
* traceId
* status

---

# 7. Root/Jailbreak Detection

Detect:

* rooted Android
* jailbroken iOS

Actions:

* restrict features
* show warning

---

# 8. Code Protection

## 8.1 Obfuscation

* Enable ProGuard / R8 (Android)
* Use iOS symbol stripping

---

## 8.2 Reverse Engineering Protection

* Minify code
* Avoid exposing secrets in code

---

# 9. Secure API Integration

* Use Authorization header
* Do not send sensitive data in query params
* Use POST for sensitive operations

---

# 10. Fintech Rules (CRITICAL)

## 10.1 Money Movement APIs

* Must use idempotency key
* Must verify transaction status

---

## 10.2 OTP & PIN

* Never log
* Never store
* Mask input

---

## 10.3 Screenshot Protection (optional)

* Disable screenshots for sensitive screens

---

# 11. Checklist

* [ ] HTTPS enforced
* [ ] SSL pinning implemented
* [ ] Tokens stored securely
* [ ] No sensitive logs
* [ ] Root detection implemented
* [ ] Code obfuscation enabled
* [ ] API secured

---

# 12. Final Rule

> Mobile security is about reducing risk, not eliminating it.
> Critical protection must always be enforced on backend systems.

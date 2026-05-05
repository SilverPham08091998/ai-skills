# security/sensitive-data-rule.md

## Objective

Define strict rules for handling sensitive data in mobile applications (React Native) for fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript
* API integration, storage, logging, analytics
* UI rendering and screenshots

Main rule:

> Treat all sensitive data as toxic.
> Minimize collection, restrict access, protect in transit and at rest, and never expose it unnecessarily.

---

# 1. Definitions & Classification

## 1.1 Sensitive Data Types

* **Secrets (HIGH):** accessToken, refreshToken, private keys
* **Authentication Factors (HIGH):** PIN, OTP, password, biometric secrets (never accessible to app)
* **Financial (HIGH):** account number, card number, CVV, balances, transactions
* **Personal (MEDIUM):** full name, phone, email, address, national ID
* **Operational (LOW):** feature flags, non-sensitive configs

## 1.2 Golden Rules

* Collect only what is necessary
* Store the minimum possible
* Mask by default
* Never log sensitive values

---

# 2. Data Flow Rules

## 2.1 In Transit

* HTTPS only (TLS 1.2+)
* Prefer SSL pinning
* Never send secrets in query params

Bad:

```txt
GET /transfer?token=abc&amount=100
```

Good:

```txt
POST /transfer
Authorization: Bearer <token>
```

---

## 2.2 In Memory

* Keep sensitive data in memory for the shortest time
* Clear after use

```ts
let otp: string | null = getOtp();
// use otp
otp = null; // clear
```

Rules:

* Do not keep long-lived global variables for secrets
* Avoid storing in Redux store

---

## 2.3 At Rest (Storage)

* Use Keychain/Keystore for HIGH sensitivity
* Encrypt MEDIUM sensitivity if persisted
* Avoid storing HIGH sensitivity when possible

---

# 3. UI Rendering Rules

## 3.1 Masking

Always mask by default:

* account number → `**** **** 1234`
* phone → `*** *** 6789`
* ID → partially masked

## 3.2 Screenshot Protection

* Disable screenshots on sensitive screens (optional, product-driven)

## 3.3 Clipboard

* Avoid copying sensitive data to clipboard
* If needed, clear clipboard after short delay

```ts
Clipboard.setString(value);
setTimeout(() => Clipboard.setString(''), 30000);
```

---

# 4. Logging & Analytics Rules (CRITICAL)

## 4.1 Never Log Sensitive Data

Forbidden:

* tokens
* OTP/PIN/password
* full card/account numbers
* personal identifiers (full)

Bad:

```ts
logger.info('login', { token });
```

Good:

```ts
logger.info('login_success', { userId: maskedUserId });
```

## 4.2 Analytics / Crash Reporting

* Do not send sensitive payloads to analytics (e.g., Firebase, Sentry)
* Scrub PII before sending

---

# 5. API Contract Rules

## 5.1 Do Not Echo Secrets

* Backend must not return secrets unnecessarily
* Mobile must not rely on echoed sensitive fields

## 5.2 Field Minimization

* Request/response DTOs should contain only required fields

---

# 6. Caching Rules

* Do not cache sensitive API responses in disk cache
* If caching is required, encrypt and set short TTL

---

# 7. Debug & Dev Mode Rules

* Disable verbose logging in production
* In dev, still avoid printing secrets

```ts
if (__DEV__) {
  logger.debug('transfer_request', { amount }); // no tokens
}
```

---

# 8. Background & Lifecycle

## 8.1 App Background

* Optionally blur/lock sensitive screens
* Clear sensitive in-memory data

## 8.2 App Switcher Snapshot

* Prevent sensitive data appearing in app switcher preview (platform-specific)

---

# 9. Third-party SDK Rules

* Audit SDKs for data collection
* Disable auto-collection of PII where possible
* Do not pass sensitive data into SDKs unless strictly required

---

# 10. Fintech Rules (CRITICAL)

## 10.1 Payment & Transfer

* Never expose full account/card numbers
* Do not persist transaction secrets locally

## 10.2 OTP & PIN

* Never store
* Never log
* Mask input fields

## 10.3 Receipts & Statements

* Mask sensitive fields before rendering or exporting

---

# 11. Redaction Utilities

Provide shared utilities:

```ts
export function maskAccountNumber(value: string): string {
  return value.replace(/.(?=.{4})/g, '*');
}

export function maskPhone(value: string): string {
  return value.replace(/.(?=.{4})/g, '*');
}
```

Rules:

* Centralize masking utilities
* Do not duplicate regex logic across codebase

---

# 12. Incident Handling

If sensitive data leak is detected:

* immediately stop logging source
* rotate affected tokens/keys
* notify backend/security team
* trigger forced logout if needed

---

# 13. Checklist

* [ ] Sensitive data classified (HIGH/MEDIUM/LOW)
* [ ] No secrets in logs/analytics
* [ ] Masking applied in UI
* [ ] Secure storage used correctly
* [ ] No sensitive data in query params
* [ ] Clipboard usage controlled
* [ ] Third-party SDK audited

---

# 14. Final Rule

> Sensitive data must be minimized, masked, protected, and never exposed.
> If in doubt, do not store or log it.
> Security failures around sensitive data are critical incidents in fintech systems.

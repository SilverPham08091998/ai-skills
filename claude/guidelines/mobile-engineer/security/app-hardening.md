# security/app-hardening.md

## Objective

Define build-time and runtime hardening practices to protect the mobile application (React Native) from reverse engineering, tampering, and dynamic instrumentation in fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript + Native modules
* Build pipelines (CI/CD)
* Runtime security layer

Main rule:

> Hardening raises the cost of attack and limits impact.
> Combine multiple controls and enforce critical decisions on the backend.

---

# 1. Core Principles

## 1.1 Defense in Depth

* No single control is sufficient
* Layer: build-time → binary → runtime → network → backend

## 1.2 Fail Safe for Critical Flows

* Degrade or block high-risk actions (payments) when signals are suspicious

## 1.3 Minimize Attack Surface

* Remove debug code, test endpoints, and unused modules

---

# 2. Build-time Hardening

## 2.1 Code Obfuscation (Android)

* Enable R8/ProGuard (minify, shrink, obfuscate)
* Obfuscate class/method names
* Keep rules only for required public APIs

## 2.2 iOS Binary Hardening

* Strip symbols for release builds
* Disable debug flags
* Remove verbose logs

## 2.3 Resource & Config Hygiene

* Separate dev/staging/prod configs
* Do not bundle secrets in app
* Remove test URLs/keys

## 2.4 App Signing

* Protect signing keys (use secure CI secrets)
* Use separate keys for environments

---

# 3. Secret Management

## 3.1 Do NOT Hardcode Secrets

Bad:

```ts
const API_KEY = 'hardcoded';
```

## 3.2 Safer Approaches

* Fetch short-lived tokens from backend
* Store only in Keychain/Keystore

---

# 4. Runtime Protections

## 4.1 Anti-Debug

* Detect debugger attachment
* Delay or restrict sensitive flows

## 4.2 Anti-Hooking (Heuristics)

* Detect known frameworks (Frida, Xposed, Substrate)
* Check suspicious ports/processes

## 4.3 Integrity Checks

* Verify app signature / bundle id
* Optional: checksum critical assets

## 4.4 Periodic Checks

* Run lightweight checks at app start and periodically
* Cache results per session (short TTL)

---

# 5. Root/Jailbreak Integration

* Reuse device integrity signals
* Escalate controls when compromised

Actions:

* restrict features
* require step-up auth
* block high-value transactions

---

# 6. Network Hardening (Tie-in)

* Enforce HTTPS (TLS 1.2+)
* Enable certificate pinning
* Detect pinning bypass attempts (heuristics)

---

# 7. Feature Gating (Risk-based)

## 7.1 Levels

* WARN: show notice
* RESTRICT: disable sensitive features
* BLOCK: prevent login/transactions

## 7.2 Typical Restrictions

* fund transfer / payment confirmation
* biometric unlock (optional)
* exporting statements/files

---

# 8. Backend Integration

## 8.1 Send Signals

```ts
headers: {
  'x-app-integrity': isTampered ? 'TAMPERED' : 'OK'
}
```

## 8.2 Server Actions

* risk scoring
* step-up auth (OTP/biometric)
* block high-risk operations

Rules:

* Backend is the final authority
* Do not trust client flags alone

---

# 9. Logging Rules

Do NOT log:

* secrets/keys
* detailed detection logic

Allowed:

* high-level flags
* traceId

---

# 10. Performance Guidelines

* Keep checks lightweight on startup
* Defer heavy checks
* Avoid blocking UI thread

---

# 11. Testing & Dev Controls

* Provide dev toggles to simulate tamper

```ts
if (__DEV__ && process.env.MOCK_TAMPER === 'true') {
  return { isTampered: true };
}
```

* Validate WARN/RESTRICT/BLOCK paths

---

# 12. Fintech Rules (CRITICAL)

## 12.1 Money Movement

* Require step-up auth on suspicious signals
* Consider blocking high-value transactions

## 12.2 Session Hardening

* Shorten session lifetime on risk
* Force re-authentication when environment changes

## 12.3 Data Exposure

* Reduce sensitive data returned to client
* Avoid local caching

---

# 13. Checklist

* [ ] Obfuscation enabled (R8/ProGuard, iOS stripping)
* [ ] No hardcoded secrets
* [ ] Centralized integrity/tamper service
* [ ] Multiple runtime checks implemented
* [ ] Risk-based gating (warn/restrict/block)
* [ ] Backend risk integration
* [ ] Certificate pinning enabled
* [ ] No sensitive logs

---

# 14. Final Rule

> App hardening does not make the app unbreakable.
> It increases attacker cost and reduces impact.
> Combine with strong backend validation for real security.

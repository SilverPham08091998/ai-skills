# security/biometric.md

## Objective

Define standards for using biometric authentication (Fingerprint / FaceID) in mobile applications for fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Authentication & session flows
* Secure storage integration

Main rule:

> Biometrics are a convenience factor, not a source of truth.
> Never rely on biometrics alone for critical security decisions.

---

# 1. Core Principles

## 1.1 Biometrics = User Convenience Layer

Biometric is used to:

* unlock app
* approve quick actions
* reduce friction

Biometric is NOT:

* a replacement for backend authentication
* a source of identity

---

## 1.2 Always Combine with Backend Validation

* Biometric unlock must still rely on valid session/token
* Critical operations must be verified server-side

---

## 1.3 User Consent Required

* User must opt-in to biometric usage
* Never auto-enable biometrics

---

# 2. Supported Biometric Types

* Fingerprint (Touch ID / Android Fingerprint)
* Face Recognition (Face ID / Android Face Unlock)

Use library:

* `react-native-biometrics`
* `expo-local-authentication`

---

# 3. Biometric Flow Design

## 3.1 Enable Biometric

```txt
Login with password/OTP
  -> ask user to enable biometric
  -> store flag securely
```

## 3.2 Unlock App

```txt
App open
  -> check biometric enabled
  -> prompt biometric
  -> if success -> unlock UI
```

## 3.3 Approve Sensitive Action

```txt
User action (transfer/payment)
  -> require biometric confirmation
  -> proceed if success
```

---

# 4. Secure Storage Integration

## 4.1 Store Biometric Flag

```ts
await secureStorage.setItem('biometric.enabled', 'true');
```

## 4.2 Protect Token Access

* Use Keychain/Keystore with biometric access control

Example (concept):

```ts
setItem(key, value, {
  accessControl: BIOMETRY_CURRENT_SET,
});
```

Rules:

* Token must not be accessible without biometric (if enabled)
* Do not store raw biometric data

---

# 5. Authentication Rules

## 5.1 Do NOT treat biometric as login

Bad:

* biometric = login

Correct:

* biometric unlocks existing session

---

## 5.2 Session Expired Case

```txt
Biometric success
  -> token expired
  -> force login again
```

---

## 5.3 Fallback Mechanism

Always support:

* PIN
* password
* OTP

---

# 6. Security Rules (CRITICAL)

## 6.1 Do NOT store biometric data

* OS handles biometric data
* App never sees fingerprint/face data

---

## 6.2 Device Binding

* Biometric is tied to device
* Do not assume same user across devices

---

## 6.3 Root/Jailbreak Risk

If compromised device:

* disable biometric
* require full authentication

---

## 6.4 Replay Protection

* Do not cache biometric result
* Require fresh authentication for each sensitive action

---

# 7. UX Rules

## 7.1 Clear Messaging

* Explain why biometric is used
* Explain fallback option

## 7.2 Error Handling

Cases:

* user cancel
* biometric failed
* biometric not available

Example:

```ts
if (error.code === 'USER_CANCEL') {
  return;
}
```

---

# 8. Fintech Rules

## 8.1 Sensitive Actions

Biometric can be required for:

* fund transfer
* payment confirmation
* viewing sensitive data

---

## 8.2 Transaction Integrity

* Biometric confirms user intent
* Backend still validates transaction

---

## 8.3 Risk-based Control

* high-value transaction -> require OTP + biometric
* low-value -> biometric only

---

# 9. Logging Rules

Do NOT log:

* biometric result details
* authentication result

Allowed:

* success/failure (without detail)

---

# 10. Testing Rules

* Mock biometric in dev/test
* Simulate success/failure/cancel

---

# 11. Checklist

* [ ] User opt-in implemented
* [ ] Secure storage integration done
* [ ] Fallback auth exists
* [ ] Session validation enforced
* [ ] No biometric data stored
* [ ] Root detection integrated

---

# 12. Final Rule

> Biometrics improve UX but must never weaken security.
> Always treat biometric as a convenience layer on top of strong authentication.

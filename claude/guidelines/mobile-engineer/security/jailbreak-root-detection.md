# security/jailbreak-root-detection.md

## Objective

Define standards for detecting and handling rooted (Android) / jailbroken (iOS) devices in mobile applications for fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Runtime security layer

Main rule:

> Device integrity is a risk signal, not a binary gate.
> Detection must be combined with backend risk controls and feature restrictions.

---

# 1. Core Principles

## 1.1 Assume Bypass is Possible

* Root/jailbreak checks can be bypassed
* Do not rely solely on client checks for security decisions

## 1.2 Risk-based Response

* Do not always block app usage completely
* Adjust behavior based on risk level and feature sensitivity

## 1.3 Defense in Depth

Combine:

* client detection
* transport security (SSL pinning)
* secure storage
* backend risk engine

---

# 2. Detection Strategy

## 2.1 Use Multiple Signals

Android (root):

* presence of su binary
* writable system partitions
* known root management apps
* abnormal build tags (test-keys)

iOS (jailbreak):

* existence of Cydia paths
* ability to write outside sandbox
* suspicious dylibs

## 2.2 Recommended Libraries

* `react-native-jailbreak-detection`
* `react-native-root-detection`
* custom native checks (for higher assurance)

---

# 3. Detection API Design

## 3.1 Interface

```ts
export type DeviceIntegrity = {
  isCompromised: boolean;
  signals: string[];
};

export interface DeviceSecurityService {
  checkIntegrity(): Promise<DeviceIntegrity>;
}
```

## 3.2 Usage

```ts
const integrity = await deviceSecurityService.checkIntegrity();

if (integrity.isCompromised) {
  handleCompromisedDevice(integrity);
}
```

Rules:

* Do not call detection randomly across screens
* Centralize in app bootstrap or security layer

---

# 4. Response Strategy

## 4.1 Levels

### Level 1 — Warning

* show warning banner
* allow app usage

### Level 2 — Restricted

* disable sensitive features
* allow read-only access

### Level 3 — Block

* block login or critical operations

---

## 4.2 Feature Restriction Examples

Disable on compromised devices:

* fund transfer
* payment confirmation
* biometric usage
* secure storage access (optional hardening)

---

# 5. Backend Integration

## 5.1 Send Device Integrity Signal

```ts
headers: {
  'x-device-integrity': integrity.isCompromised ? 'COMPROMISED' : 'SAFE'
}
```

## 5.2 Backend Enforcement

* apply risk scoring
* require additional verification (OTP)
* block high-risk transactions

Rules:

* backend must not fully trust client signal
* use it as one input in risk engine

---

# 6. UX Rules

## 6.1 Clear Messaging

Example:

```txt
Your device may be compromised. Some features are restricted for your security.
```

## 6.2 Do Not Reveal Detection Logic

* Do not show technical reasons (e.g., “su binary found”)

---

# 7. Security Rules (CRITICAL)

## 7.1 Do Not Store Sensitive Data

On compromised devices:

* avoid caching sensitive data
* reduce data exposure

---

## 7.2 Disable Biometric (Recommended)

* biometric can be less reliable on compromised devices

---

## 7.3 Prevent Tampering

* combine with app integrity checks
* use code obfuscation

---

# 8. Evasion Considerations

Attackers may:

* hide root
* hook detection APIs
* patch app logic

Mitigation:

* multiple detection methods
* periodic checks
* server-side anomaly detection

---

# 9. Performance Rules

* run detection at app start
* avoid heavy checks on every screen
* cache result for session (short-lived)

---

# 10. Testing Rules

* test on rooted/jailbroken devices
* simulate detection in dev mode

Example:

```ts
if (__DEV__) {
  return { isCompromised: true, signals: ['mock'] };
}
```

---

# 11. Logging Rules

Do NOT log:

* full device details
* sensitive environment info

Allowed:

* compromised flag
* high-level signals

---

# 12. Fintech Rules

## 12.1 High-risk Transactions

* require OTP even if normally not required

## 12.2 Session Protection

* shorten session lifetime
* force re-authentication more frequently

---

# 13. Checklist

* [ ] Detection implemented
* [ ] Centralized security service
* [ ] Risk-based response applied
* [ ] Backend integration exists
* [ ] Sensitive features restricted
* [ ] Logging is safe

---

# 14. Final Rule

> Root/jailbreak detection is a risk signal, not a guarantee.
> Always combine client checks with backend controls for real security.

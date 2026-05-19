# security/anti-tampering.md

## Objective

Define standards to detect and mitigate app tampering and runtime manipulation in mobile applications (React Native) for fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript + Native modules
* Build & runtime security layers

Main rule:

> Assume the app binary and runtime can be modified.
> Detect, deter, and degrade functionality—do not rely on a single control.

---

# 1. Core Principles

## 1.1 No Single Point of Failure

* Any single check can be bypassed
* Use multiple, layered controls

## 1.2 Risk-based Response

* Warn → restrict → block (progressive)
* Critical flows (payments) require stricter controls

## 1.3 Server-backed Decisions

* Client signals are hints
* Backend enforces final decisions (risk engine)

---

# 2. Threat Model

Common attacks:

* Repackaging / re-signing APK/IPA
* Runtime hooking (Frida, Xposed, Substrate)
* Debugging / instrumentation
* Code injection / method swizzling
* SSL pinning bypass

---

# 3. Detection Signals

## 3.1 App Integrity

* Verify app signature / bundle identifier
* Detect re-signing (mismatched cert hash)

## 3.2 Debug / Instrumentation

* Debugger attached
* Emulator / simulator flags (optional signal)

## 3.3 Hooking Frameworks

* Known processes / libraries (Frida, Xposed)
* Suspicious open ports (Frida default 27042)

## 3.4 File System Checks

* Presence of tampering artifacts
* Modified app files / writable app dirs

## 3.5 Code Integrity (Advanced)

* Checksum of critical code/resources
* Anti-tamper flags in native layer

---

# 4. Detection API Design

```ts
export type TamperSignal = {
  code: string;
  description?: string;
};

export type TamperResult = {
  isTampered: boolean;
  signals: TamperSignal[];
};

export interface AppIntegrityService {
  checkTampering(): Promise<TamperResult>;
}
```

Usage:

```ts
const result = await appIntegrityService.checkTampering();

if (result.isTampered) {
  handleTamper(result);
}
```

Rules:

* Centralize checks in a single service
* Run at app start and periodically (lightweight)

---

# 5. Response Strategy

## 5.1 Levels

* **WARN**: show message, allow usage
* **RESTRICT**: disable sensitive features
* **BLOCK**: prevent login/transactions

## 5.2 Feature Restrictions

Disable on tamper:

* fund transfer / payment confirmation
* biometric unlock (optional)
* secure export (statements, files)

---

# 6. Backend Integration

## 6.1 Send Signals

```ts
headers: {
  'x-app-integrity': result.isTampered ? 'TAMPERED' : 'OK'
}
```

## 6.2 Server Actions

* Increase risk score
* Require step-up auth (OTP/biometric)
* Block high-risk operations

Rules:

* Do not fully trust client flags
* Correlate with device, IP, behavior

---

# 7. Build-time Protections

## 7.1 Code Obfuscation

* Android: R8/ProGuard (minify, shrink, obfuscate)
* iOS: symbol stripping, bitcode (where applicable)

## 7.2 Resource Protection

* Remove debug info, logs, test endpoints
* Separate dev/prod configs

## 7.3 App Signing

* Protect signing keys
* Use secure CI/CD secrets

---

# 8. Runtime Protections

## 8.1 Anti-Debug

* Detect debugger attach
* Delay or block sensitive flows when detected

## 8.2 Anti-Hooking (Heuristics)

* Detect known libraries/processes
* Validate function pointers (native layer)

## 8.3 Integrity Checks (Lightweight)

* Verify checksum of critical assets
* Randomized check timing

---

# 9. Network Protections

* Enforce HTTPS + TLS 1.2+
* Implement SSL pinning
* Detect pinning bypass attempts (heuristics)

---

# 10. UX Rules

## 10.1 Messaging

* Do not reveal technical details

Example:

```txt
Your app environment appears insecure. Some features are limited for your protection.
```

## 10.2 Graceful Degradation

* Allow non-sensitive browsing where possible
* Guide user to a secure device

---

# 11. Logging Rules

Do NOT log:

* detailed detection techniques
* full environment fingerprints

Allowed:

* high-level signal codes
* tamper flag
* traceId

---

# 12. Evasion Considerations

Attackers may:

* patch checks
* hide frameworks
* hook detection APIs

Mitigation:

* multiple signals
* periodic checks
* server-side anomaly detection

---

# 13. Performance Rules

* Keep checks lightweight on startup
* Defer heavy checks
* Cache result per session (short TTL)

---

# 14. Testing Rules

* Provide dev toggles to simulate tamper

```ts
if (__DEV__ && process.env.MOCK_TAMPER === 'true') {
  return { isTampered: true, signals: [{ code: 'MOCK' }] };
}
```

* Validate behavior for WARN/RESTRICT/BLOCK

---

# 15. Fintech Rules (CRITICAL)

## 15.1 Money Movement

* Always require step-up auth on tampered devices
* Consider blocking high-value transactions

## 15.2 Session Hardening

* Shorten session lifetime
* Force re-authentication on suspicious changes

## 15.3 Data Exposure

* Reduce sensitive data returned to client
* Avoid local caching

---

# 16. Checklist

* [ ] Obfuscation enabled (R8/ProGuard, iOS stripping)
* [ ] Centralized tamper detection service
* [ ] Multiple detection signals implemented
* [ ] Risk-based response (warn/restrict/block)
* [ ] Backend integration for risk scoring
* [ ] SSL pinning enabled
* [ ] No sensitive logs

---

# 17. Final Rule

> Anti-tampering is about raising the cost of attack and reducing impact.
> Combine client signals with backend enforcement for real protection.

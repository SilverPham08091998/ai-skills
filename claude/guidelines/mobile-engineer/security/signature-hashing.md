# security/signature-hashing.md

## Objective

Define standards for request signing and hashing in mobile applications (React Native) for fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript
* API integration layer
* Partner integrations requiring request signing

Main rule:

> Signing ensures integrity and authenticity, not confidentiality.
> Always combine signing with HTTPS and proper authentication.

---

# 1. Core Concepts

## 1.1 Hashing vs Encryption vs Signature

* **Hashing**: one-way (e.g., SHA-256) for integrity
* **Encryption**: reversible for confidentiality
* **Signature (HMAC/RSA/ECC)**: proves origin + integrity

Use cases:

* Hashing: checksum, fingerprint
* HMAC: client ↔ server shared-secret signing
* RSA/ECC: asymmetric signing/verification

---

# 2. When to Use Signing

* Partner APIs require signature (banks, gateways)
* Prevent request tampering (amount, account, timestamp)
* Non-repudiation (with asymmetric signatures)

---

# 3. Recommended Algorithms

* HMAC-SHA256 (most common)
* RSA-SHA256 / ECDSA-SHA256 (when asymmetric is required)

Rules:

* Do NOT use MD5 / SHA1
* Prefer SHA-256 or stronger

---

# 4. Canonical String (CRITICAL)

Signature must be built from a **canonical string**.

Example:

```txt
METHOD\nPATH\nTIMESTAMP\nBODY_HASH
```

Example values:

```txt
POST
/api/v1/transfer
1700000000
<sha256(body)>
```

Rules:

* Deterministic order (fixed field order)
* No extra spaces/newlines
* Normalize casing where defined
* Use UTF-8 encoding

---

# 5. HMAC Signing (Symmetric)

## 5.1 Flow

```txt
body -> sha256 -> bodyHash
canonical string -> HMAC(secret) -> signature
```

## 5.2 Example (concept)

```ts
import { createHmac } from 'crypto';

function signHmacSHA256(message: string, secret: string): string {
  return createHmac('sha256', secret)
    .update(message, 'utf8')
    .digest('hex');
}
```

## 5.3 Headers

```txt
x-timestamp: 1700000000
x-signature: <signature>
```

Rules:

* Secret must NEVER be hardcoded in mobile
* Prefer obtaining short-lived signing tokens from backend

---

# 6. Asymmetric Signing (RSA/ECC)

## 6.1 Flow

```txt
canonical string -> sign(privateKey) -> signature
server verifies with publicKey
```

## 6.2 Rules

* Private key must NOT be embedded in mobile app
* If required, store in secure hardware (Keystore/Keychain) and restrict usage
* Prefer backend signing whenever possible

---

# 7. Timestamp & Replay Protection

## 7.1 Timestamp Header

```txt
x-timestamp: <unix_epoch_seconds>
```

## 7.2 Validation Window

* Server accepts requests within a short window (e.g., ±5 minutes)

## 7.3 Nonce (Optional)

```txt
x-nonce: <random_uuid>
```

Rules:

* Prevent replay attacks
* Server must track used nonces (if implemented)

---

# 8. Body Hashing

## 8.1 Compute Body Hash

```ts
import { createHash } from 'crypto';

function sha256Hex(data: string): string {
  return createHash('sha256').update(data, 'utf8').digest('hex');
}
```

Rules:

* Hash the exact serialized body (same JSON string)
* Ensure consistent serialization (stable key order if required)

---

# 9. Integration with HTTP Client

## 9.1 Interceptor Pattern

```ts
httpClient.interceptors.request.use((config) => {
  const timestamp = Math.floor(Date.now() / 1000).toString();
  const body = JSON.stringify(config.data ?? {});
  const bodyHash = sha256Hex(body);

  const canonical = [
    config.method?.toUpperCase(),
    config.url,
    timestamp,
    bodyHash,
  ].join('\n');

  const signature = signHmacSHA256(canonical, getSigningSecret());

  config.headers['x-timestamp'] = timestamp;
  config.headers['x-signature'] = signature;

  return config;
});
```

Rules:

* Centralize in interceptor
* Do not duplicate signing logic across APIs

---

# 10. Key Management (CRITICAL)

## 10.1 Do NOT Hardcode Secrets

Bad:

```ts
const SECRET = 'hardcoded-secret';
```

## 10.2 Safer Approaches

* Fetch short-lived signing token from backend
* Use device-bound keys in Keystore/Keychain (advanced)

## 10.3 Rotation

* Rotate secrets/keys periodically
* Invalidate compromised keys immediately

---

# 11. Error Handling

Server may return:

* INVALID_SIGNATURE
* EXPIRED_TIMESTAMP
* NONCE_REUSED

Client behavior:

* Do not retry blindly
* Sync device time if needed
* Re-authenticate or fetch new signing token

---

# 12. Logging Rules

Do NOT log:

* secret keys
* full canonical string
* full request body when sensitive

Allowed:

* signature verification result (success/failure)
* request id / traceId

---

# 13. Fintech Rules (CRITICAL)

## 13.1 Money Movement

* Sign all sensitive fields (amount, account, currency)
* Use idempotency keys together with signatures

## 13.2 Partner Integration

* Follow partner canonical spec strictly
* Any mismatch will break verification

## 13.3 Device Time

* Ensure device time is reasonably accurate
* Consider server time sync endpoint

---

# 14. Testing Rules

* Provide deterministic test vectors (input → expected signature)
* Mock signing in unit tests

Example:

```ts
expect(signHmacSHA256(canonical, 'test-secret')).toBe('<expected>');
```

---

# 15. Checklist

* [ ] Canonical string defined and stable
* [ ] HMAC-SHA256 or stronger used
* [ ] No hardcoded secrets in app
* [ ] Timestamp/nonce implemented
* [ ] Signing centralized in interceptor
* [ ] Sensitive data not logged

---

# 16. Final Rule

> Signatures protect integrity and authenticity, not confidentiality.
> Always combine with HTTPS, proper auth, and secure key management.

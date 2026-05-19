# security/network-security.md

## Objective

Define standards to secure all network communication between the mobile app and backend services in fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* TypeScript
* HTTP clients (Axios/Fetch)
* API Gateway / BFF interactions

Main rule:

> All data in transit must be protected, validated, and observable.
> The client must never weaken server-side security guarantees.

---

# 1. Core Principles

## 1.1 HTTPS Only

* All requests MUST use HTTPS (TLS 1.2+)
* Reject any HTTP endpoint

```ts
if (!url.startsWith('https://')) {
  throw new Error('Insecure protocol not allowed');
}
```

## 1.2 Zero Trust Network

* Assume networks are hostile (public Wi-Fi, proxies)
* Do not trust intermediate infrastructure

## 1.3 Centralized Networking Layer

* All requests go through a single HTTP client
* Interceptors enforce security rules

---

# 2. TLS / Transport Rules

## 2.1 Minimum Version

* TLS 1.2 or higher
* Prefer TLS 1.3 when available

## 2.2 Disable Weak Configurations

* No SSLv3, TLS 1.0, TLS 1.1
* No weak ciphers

## 2.3 Certificate Validation

* Validate full certificate chain
* Do not bypass validation in production

---

# 3. Request Security Rules

## 3.1 Authorization Header

```txt
Authorization: Bearer <access_token>
```

Rules:

* Do not send tokens in query params
* Do not expose tokens in logs

Bad:

```txt
GET /api?token=abc
```

---

## 3.2 Sensitive Data Handling

* Use POST/PUT for sensitive payloads
* Avoid sending PII in URLs

---

## 3.3 Idempotency (for critical APIs)

```txt
Idempotency-Key: <uuid>
```

Rules:

* Required for money movement APIs
* Prevent duplicate transactions on retry

---

## 3.4 Request Signing (Optional)

* Use HMAC/RSA for high-risk APIs
* Prevent tampering of payload

---

# 4. Response Security Rules

## 4.1 Do Not Trust Client State

* Backend must validate everything
* Client should treat responses as untrusted input

## 4.2 Data Minimization

* Return only required fields
* Avoid exposing internal metadata

---

# 5. Interceptor Design

## 5.1 Request Interceptor

```ts
httpClient.interceptors.request.use((config) => {
  config.headers['Authorization'] = `Bearer ${getAccessToken()}`;
  config.headers['x-trace-id'] = generateTraceId();
  return config;
});
```

## 5.2 Response Interceptor

```ts
httpClient.interceptors.response.use(
  (response) => response,
  (error) => {
    return Promise.reject(normalizeApiError(error));
  }
);
```

Rules:

* Centralize auth, traceId, error normalization
* Do not duplicate across APIs

---

# 6. Timeout & Retry Rules

## 6.1 Timeout

* Set reasonable timeout (e.g., 10–30s)

```ts
timeout: 15000
```

## 6.2 Retry Policy

Safe to retry:

* GET
* idempotent APIs

Do NOT retry blindly:

* fund transfer
* payment
* mutation APIs

---

# 7. Certificate Pinning (Integration)

* Implement SSL pinning for high-security apps
* Pin public key or certificate

Rules:

* Fail closed (reject unknown cert)
* Plan for certificate rotation

---

# 8. Logging & Observability

## 8.1 Trace ID

```ts
headers['x-trace-id'] = uuid();
```

* Correlate client ↔ backend logs

## 8.2 Logging Rules

Do NOT log:

* tokens
* PII
* full payload

Allowed:

* endpoint
* status code
* traceId
* duration

---

# 9. Caching Rules

* Do not cache sensitive responses
* Disable cache for auth endpoints

```ts
headers['Cache-Control'] = 'no-store';
```

---

# 10. Third-party APIs

* Treat as untrusted
* Validate responses strictly
* Apply same security rules

---

# 11. Fintech Rules (CRITICAL)

## 11.1 Money Movement APIs

* Always use HTTPS + auth + idempotency
* Prefer request signing

## 11.2 Ambiguous Failures

```txt
request -> timeout
→ DO NOT retry blindly
→ perform status inquiry
```

## 11.3 Rate Limiting Awareness

* Respect server rate limits
* Avoid burst retries

---

# 12. Testing Rules

* Test on weak networks (3G, packet loss)
* Simulate timeout, retry, failure
* Validate interceptor behavior

---

# 13. Checklist

* [ ] HTTPS enforced
* [ ] TLS 1.2+ only
* [ ] Authorization header used
* [ ] No tokens in query params
* [ ] Interceptors centralized
* [ ] Retry policy safe
* [ ] TraceId implemented
* [ ] Sensitive data not logged

---

# 14. Final Rule

> Network security is the first line of defense for data in transit.
> Combine HTTPS, authentication, validation, and obse

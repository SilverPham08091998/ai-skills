# observability/logging.md

## Objective

Define logging standards for React Native applications to support debugging, production monitoring, incident investigation, and fintech/banking auditability without exposing sensitive data.

Applies to:

* React Native (iOS + Android)
* TypeScript
* API layer
* State management
* Critical user flows
* CI/CD and production monitoring

Main rule:

> Logs must be useful, structured, safe, and traceable.
> Never log sensitive data just to make debugging easier.

---

# 1. Core Principles

## 1.1 Structured Logging

Use structured logs instead of random text logs.

Bad:

```ts
console.log('transfer failed', error);
```

Good:

```ts
logger.error('TRANSFER_FAILED', {
  traceId,
  errorCode: error.code,
  screen: 'TransferConfirmScreen',
});
```

Rules:

* Use event names.
* Use key-value metadata.
* Avoid unstructured string concatenation.

---

## 1.2 Safe by Default

Logs must never expose sensitive data.

Never log:

* access token
* refresh token
* OTP
* PIN
* password
* CVV
* full card number
* full account number
* full national ID
* raw API payload containing PII

---

## 1.3 Traceable Across Systems

Every important flow should be traceable with:

* `traceId`
* `requestId`
* `sessionId` (masked or anonymous)
* `userId` (masked or hashed if needed)

---

# 2. Log Levels

## 2.1 DEBUG

For local development only.

Examples:

* screen lifecycle
* local state transition
* non-sensitive debug info

Rules:

* Disable or reduce in production.
* Never log secrets even in debug.

---

## 2.2 INFO

For important business or app lifecycle events.

Examples:

```txt
APP_STARTED
LOGIN_SUCCESS
TRANSFER_SUBMITTED
CODEPUSH_UPDATE_APPLIED
```

---

## 2.3 WARN

For recoverable problems.

Examples:

```txt
API_TIMEOUT_RETRYING
FEATURE_FLAG_MISSING
CACHE_READ_FAILED
```

---

## 2.4 ERROR

For failures that affect user flow or system correctness.

Examples:

```txt
LOGIN_FAILED
TRANSFER_FAILED
API_ERROR
UNHANDLED_EXCEPTION
```

---

# 3. Logger Interface

Create a centralized logger abstraction.

```ts
export interface Logger {
  debug(event: string, metadata?: LogMetadata): void;
  info(event: string, metadata?: LogMetadata): void;
  warn(event: string, metadata?: LogMetadata): void;
  error(event: string, metadata?: LogMetadata): void;
}

export type LogMetadata = Record<string, unknown>;
```

Rules:

* UI must not use `console.log` directly.
* All logs must go through the logger abstraction.
* Logger implementation can be changed without changing business code.

---

# 4. Recommended Structure

```txt
src/
  observability/
    logging/
      Logger.ts
      ConsoleLogger.ts
      RemoteLogger.ts
      LogSanitizer.ts
      logEventNames.ts
```

Responsibilities:

* `Logger.ts`: interface
* `ConsoleLogger.ts`: local development logging
* `RemoteLogger.ts`: production logging provider
* `LogSanitizer.ts`: mask/remove sensitive data
* `logEventNames.ts`: centralized event names

---

# 5. Event Naming Convention

Use uppercase snake case.

```txt
APP_STARTED
API_REQUEST_STARTED
API_REQUEST_FAILED
LOGIN_SUCCESS
LOGIN_FAILED
TRANSFER_SUBMITTED
TRANSFER_CONFIRMED
TRANSFER_STATUS_INQUIRY_STARTED
TRANSFER_STATUS_INQUIRY_FAILED
```

Rules:

* Event names must be stable.
* Do not use dynamic event names.
* Avoid vague names like `ERROR`, `FAILED`, `CLICKED`.

---

# 6. Metadata Standard

Common fields:

```ts
type CommonLogMetadata = {
  traceId?: string;
  requestId?: string;
  screen?: string;
  feature?: string;
  action?: string;
  errorCode?: string;
  status?: number;
  durationMs?: number;
};
```

Example:

```ts
logger.info('API_REQUEST_COMPLETED', {
  traceId,
  endpoint: '/api/v1/transfer',
  method: 'POST',
  status: 200,
  durationMs: 320,
});
```

Rules:

* Log endpoint path templates, not full URLs with query params.
* Do not log full request/response bodies.
* Do not log raw headers if they contain auth data.

---

# 7. Sensitive Data Sanitization

All remote logs must be sanitized before sending.

```ts
export function sanitizeLogMetadata(metadata: LogMetadata): LogMetadata {
  const blockedKeys = [
    'token',
    'accessToken',
    'refreshToken',
    'password',
    'pin',
    'otp',
    'cvv',
    'authorization',
  ];

  return Object.fromEntries(
    Object.entries(metadata).map(([key, value]) => {
      if (blockedKeys.includes(key)) {
        return [key, '[REDACTED]'];
      }
      return [key, value];
    }),
  );
}
```

Rules:

* Redact by key name.
* Mask sensitive identifiers.
* Prefer allowlist over blocklist for production logs when possible.

---

# 8. API Logging

## 8.1 Request Start

```ts
logger.info('API_REQUEST_STARTED', {
  traceId,
  method: 'POST',
  endpoint: '/api/v1/transfer',
});
```

## 8.2 Request Success

```ts
logger.info('API_REQUEST_COMPLETED', {
  traceId,
  method: 'POST',
  endpoint: '/api/v1/transfer',
  status: 200,
  durationMs,
});
```

## 8.3 Request Failure

```ts
logger.error('API_REQUEST_FAILED', {
  traceId,
  method: 'POST',
  endpoint: '/api/v1/transfer',
  status: error.status,
  errorCode: error.code,
  durationMs,
});
```

Rules:

* Log request lifecycle at network layer.
* Do not duplicate API logs in every screen.
* Do not log sensitive payloads.

---

# 9. Screen & User Action Logging

Useful events:

```txt
SCREEN_VIEWED
BUTTON_PRESSED
FLOW_STARTED
FLOW_COMPLETED
FLOW_FAILED
```

Example:

```ts
logger.info('SCREEN_VIEWED', {
  screen: 'TransferInputScreen',
  feature: 'transfer',
});
```

Rules:

* Log critical user journeys only.
* Avoid logging every tiny UI interaction.
* Do not log text input values for sensitive fields.

---

# 10. Critical Flow Logging

For fintech apps, critical flows must be traceable.

Examples:

* login
* OTP verification
* fund transfer
* payment
* cash-in / cash-out
* KYC upload

Example transfer flow:

```txt
TRANSFER_STARTED
TRANSFER_SUBMITTED
TRANSFER_CONFIRM_STARTED
TRANSFER_CONFIRM_SUCCESS
TRANSFER_STATUS_INQUIRY_STARTED
TRANSFER_COMPLETED
TRANSFER_FAILED
```

Rules:

* Logs must help reconstruct the flow.
* Logs must not expose money receiver details unless masked.
* Timeout must be logged as ambiguous until status inquiry completes.

---

# 11. Error Logging

Always log normalized errors.

```ts
logger.error('APP_ERROR', {
  traceId: error.traceId,
  errorCode: error.code,
  errorType: error.type,
  status: error.status,
});
```

Rules:

* Do not log raw Axios error directly.
* Do not log raw native errors directly.
* Normalize then log.

---

# 12. Crash Logging

Use crash tools such as:

* Firebase Crashlytics
* Sentry
* App Center Crashes

Rules:

* Attach non-sensitive context only.
* Mask user identifiers.
* Add breadcrumbs for critical flows.

Example breadcrumb:

```ts
logger.info('TRANSFER_CONFIRM_SCREEN_OPENED', {
  traceId,
  feature: 'transfer',
});
```

---

# 13. Production Logging Rules

In production:

* disable verbose debug logs
* send only safe structured logs
* sample high-volume logs if needed
* keep critical error logs always on

Example:

```ts
if (Config.APP_ENV === 'prod') {
  logger.setLevel('info');
}
```

---

# 14. Environment Rules

## 14.1 Dev

* Console logs allowed through logger.
* Verbose debug logs allowed.

## 14.2 Staging

* Remote logs enabled.
* Debug logs limited.

## 14.3 Production

* Safe logs only.
* No sensitive data.
* No full payload logs.

---

# 15. Offline Logging

If remote logging is unavailable:

* queue safe logs locally with short TTL
* limit queue size
* flush when network is available

Rules:

* Do not store sensitive logs offline.
* Do not create unlimited log files.
* Clear logs on logout if they contain user context.

---

# 16. Fintech Rules (CRITICAL)

## 16.1 Payment / Transfer Logs

Allowed:

* traceId
* transactionId
* status
* errorCode
* durationMs

Not allowed:

* full account number
* card number
* OTP/PIN
* raw request body

---

## 16.2 Ambiguous Transactions

Timeout or network error after submitting money movement must be logged as ambiguous.

```ts
logger.warn('TRANSFER_AMBIGUOUS_STATUS', {
  traceId,
  transactionId,
  reason: 'TIMEOUT_AFTER_SUBMIT',
});
```

Then perform status inquiry.

---

## 16.3 Auditability

Mobile logs are not audit logs.

Rules:

* Backend must own financial audit logs.
* Mobile logs only support debugging and user journey tracing.

---

# 17. Anti-patterns

* Using `console.log` directly everywhere.
* Logging raw API request/response bodies.
* Logging tokens or OTP.
* Logging too much in production.
* Logging without traceId.
* Logging user input from sensitive fields.
* Treating mobile logs as source of truth for financial audit.

---

# 18. Checklist

* [ ] Centralized logger abstraction exists.
* [ ] Direct `console.log` is forbidden in production code.
* [ ] Logs are structured.
* [ ] Sensitive data is sanitized.
* [ ] API logs include traceId and duration.
* [ ] Critical flows are traceable.
* [ ] Production logs are safe and limited.
* [ ] Crash reporting has safe breadcrumbs.
* [ ] Ambiguous payment/transfer states are logged correctly.

---

# 19. Final Rule

> Good logs reduce incident recovery time.
> Unsafe logs create security incidents.
> In fintech systems, logging must be useful enough for debugging and safe enough for compliance.

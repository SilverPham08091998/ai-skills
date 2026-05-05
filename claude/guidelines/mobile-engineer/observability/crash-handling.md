# observability/crash-handling.md

## Objective

Define standards for crash handling, crash reporting, and production crash investigation in React Native applications, especially for fintech/banking systems.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Native modules
* Crash reporting tools
* Production monitoring

Main rule:

> Crashes must be captured, classified, monitored, and fixed with traceability.
> Never collect sensitive data just to improve debugging.

---

# 1. Core Principles

## 1.1 Capture Early

Crash reporting must be initialized as early as possible during app startup.

Rules:

* Initialize crash reporting before main app rendering.
* Capture JS and native crashes.
* Capture unhandled promise rejections when supported.

---

## 1.2 Safe Context Only

Crash reports must not contain sensitive data.

Never attach:

* access token
* refresh token
* OTP
* PIN
* password
* CVV
* full card/account number
* raw API payload
* national ID / citizen ID

---

## 1.3 Actionable Reports

A crash report should help answer:

* Which version crashed?
* Which platform crashed?
* Which screen/flow was active?
* Which user journey step failed?
* Which release introduced it?

---

# 2. Recommended Tools

Use one or more:

* Firebase Crashlytics
* Sentry
* App Center Crashes

Rules:

* Use one primary crash reporting platform.
* Avoid duplicate reporting noise if multiple SDKs are installed.
* Ensure iOS dSYM and Android mapping files are uploaded.

---

# 3. Crash Categories

## 3.1 JavaScript Crash

Examples:

* undefined access
* unhandled exception
* failed render

## 3.2 Native Crash

Examples:

* Android Java/Kotlin crash
* iOS Objective-C/Swift crash
* native module crash

## 3.3 Startup Crash

Most severe because user cannot open the app.

## 3.4 Flow-specific Crash

Examples:

* login crash
* transfer crash
* payment confirmation crash
* KYC upload crash

---

# 4. Initialization Rule

Crash reporting must be initialized in app bootstrap.

Example:

```ts
export function initializeObservability(): void {
  initializeCrashReporter();
  initializeLogger();
}
```

Rules:

* Do not initialize crash SDK randomly inside screens.
* Do not delay initialization until after login.
* Environment-specific config must be respected.

---

# 5. Error Boundary

Use React Error Boundary to catch render errors.

```tsx
class AppErrorBoundary extends React.Component<Props, State> {
  componentDidCatch(error: Error, info: React.ErrorInfo) {
    crashReporter.recordError(error, {
      componentStack: info.componentStack,
    });
  }

  render() {
    if (this.state.hasError) {
      return <FallbackErrorScreen />;
    }

    return this.props.children;
  }
}
```

Rules:

* Error Boundary catches render errors, not all async errors.
* Use fallback UI for recoverable app state.
* Do not show technical stack traces to users.

---

# 6. Global Error Handling

## 6.1 Unhandled JS Errors

Register a global handler where supported.

```ts
ErrorUtils.setGlobalHandler((error, isFatal) => {
  crashReporter.recordError(error, {
    isFatal,
  });
});
```

## 6.2 Unhandled Promise Rejections

Rules:

* Avoid floating promises.
* Record unhandled promise rejections.
* Fix root cause instead of suppressing warnings.

---

# 7. Breadcrumbs

Breadcrumbs help reconstruct the user journey before the crash.

Useful breadcrumbs:

```txt
APP_STARTED
SCREEN_VIEWED
LOGIN_STARTED
LOGIN_SUCCESS
TRANSFER_STARTED
TRANSFER_CONFIRM_PRESSED
API_REQUEST_FAILED
```

Example:

```ts
crashReporter.addBreadcrumb('TRANSFER_CONFIRM_PRESSED', {
  traceId,
  screen: 'TransferConfirmScreen',
});
```

Rules:

* Breadcrumbs must be safe.
* Do not include raw input values.
* Keep breadcrumbs stable and meaningful.

---

# 8. User Context

Attach only safe user context.

Allowed:

* masked user id
* app version
* build number
* platform
* environment

Not allowed:

* phone number
* full name
* account number
* token

Example:

```ts
crashReporter.setUser({
  id: maskUserId(userId),
});
```

---

# 9. Release Tracking

Crash reports must include:

* app version
* build number
* platform
* git commit hash if available
* CodePush label if available
* environment

Rules:

* Upload source maps for JS bundle when supported.
* Upload Android mapping files for obfuscated builds.
* Upload iOS dSYM files for symbolication.

---

# 10. CodePush Crash Handling

For CodePush releases, track:

* deployment name
* deployment label
* rollout percentage
* install mode

Rules:

* Monitor crash rate immediately after CodePush release.
* Rollback if crash rate increases.
* Do not use CodePush for native crash fixes.

---

# 11. Crash Severity

## 11.1 Critical

Examples:

* app cannot start
* login blocked
* payment/transfer crash
* sensitive data exposure

Action:

* stop rollout
* rollback / hotfix
* notify incident channel

## 11.2 High

Examples:

* frequent crash in important feature
* crash affects many users

Action:

* prioritize hotfix
* monitor impact

## 11.3 Medium / Low

Examples:

* isolated crash
* rare non-critical screen crash

Action:

* fix in normal release cycle

---

# 12. Crash Triage Flow

```txt
Crash detected
  → check severity
  → identify version/platform
  → reproduce if possible
  → check breadcrumbs/logs
  → identify owner
  → fix or rollback
  → add regression test
  → monitor recovery
```

---

# 13. Crash-free Metrics

Track:

* crash-free users
* crash-free sessions
* startup crash rate
* affected version
* affected platform
* top crash groups

Recommended alerts:

```txt
Crash-free users < 99.5%
Startup crash spike detected
Payment crash detected
Login crash detected
```

---

# 14. Native Crash Rules

## 14.1 Android

* Upload ProGuard/R8 mapping file.
* Ensure native module exceptions are handled.
* Avoid crashing app for recoverable native errors.

## 14.2 iOS

* Upload dSYM files.
* Handle native module errors and return typed errors to JS.
* Avoid throwing uncaught Objective-C/Swift exceptions.

---

# 15. Fintech Rules (CRITICAL)

## 15.1 Payment / Transfer Crash

If crash occurs during money movement:

* do not assume transaction failed
* show transaction inquiry on next app open when possible
* preserve transaction reference if safe
* reconcile with backend status

---

## 15.2 Ambiguous Transaction Recovery

Flow:

```txt
app crashes after submit
  → app reopens
  → detect pending transaction reference
  → call status inquiry
  → show final state
```

Rules:

* Never duplicate submit automatically.
* Inquiry before retry.
* Backend is the source of truth.

---

## 15.3 Sensitive Data Protection

Crash reports must not include:

* transfer recipient full account number
* OTP/PIN
* raw payment payload
* personal documents

---

# 16. User-facing Crash Recovery

After a crash:

* show safe recovery screen if needed
* avoid technical messages
* allow user to continue or re-authenticate

Example:

```txt
Something went wrong. Please reopen the app or try again.
```

For payment flows:

```txt
We are checking your transaction status. Please do not submit again.
```

---

# 17. Testing Crash Handling

Test:

* Error Boundary fallback
* unhandled JS error capture
* native module failure behavior
* CodePush rollback scenario
* payment crash recovery path

Rules:

* Do not intentionally crash production builds for testing.
* Use staging/test builds for crash verification.

---

# 18. Anti-patterns

* No crash reporting in production.
* Crash SDK initialized too late.
* Missing source maps / dSYM / mapping files.
* Logging sensitive data in crash context.
* Ignoring startup crashes.
* Treating crash after transfer as failed transaction.
* Fixing crash without regression test.

---

# 19. Checklist

* [ ] Crash SDK initialized at app startup.
* [ ] JS and native crashes are captured.
* [ ] Error Boundary exists.
* [ ] Breadcrumbs are safe and useful.
* [ ] User context is masked.
* [ ] Source maps / dSYM / mapping files uploaded.
* [ ] CodePush label is tracked.
* [ ] Crash alerts configured.
* [ ] Payment/transfer crash recovery exists.
* [ ] Sensitive data is never attached.

---

# 20. Final Rule

> Crash handling is part of release safety.
> A crash report must help engineers recover quickly without creating a privacy or security incident.

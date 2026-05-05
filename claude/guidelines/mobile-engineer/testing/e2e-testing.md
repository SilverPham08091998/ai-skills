# testing/e2e-testing.md

## Objective

Define standards for End-to-End (E2E) testing to validate real user flows in React Native applications, ensuring production-level confidence for fintech/banking apps.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Full app (UI + navigation + state + network stubs)

Main rule:

> E2E tests simulate real user behavior.
> Test critical flows end-to-end with minimal mocking and high stability.

---

# 1. Core Principles

## 1.1 User-centric Testing

* Interact like a real user (tap, type, scroll)
* Assert visible outcomes, not internals

## 1.2 High Confidence, Low Count

* Fewer tests than unit/integration
* Cover only critical paths

## 1.3 Stability Over Coverage

* Avoid flaky tests
* Deterministic environment and data

---

# 2. Recommended Stack

* **Detox** (primary for React Native)
* Jest (test runner)
* Device/emulator (Android/iOS)

---

# 3. Test Scope

## 3.1 What to Test

* login/logout
* onboarding
* fund transfer / payment
* error states (network/business)
* navigation between key screens

## 3.2 What NOT to Test

* small UI details (covered by unit/integration)
* every edge case (focus on critical flows)

---

# 4. Environment Strategy

## 4.1 Use Dedicated E2E Environment

* staging or mock backend
* seeded test data

## 4.2 Avoid Real Production APIs

* do not hit real payment systems
* use controlled responses

---

# 5. Basic Example (Detox)

```ts
describe('Login Flow', () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  it('should login successfully', async () => {
    await element(by.id('username')).typeText('user');
    await element(by.id('password')).typeText('password');
    await element(by.id('loginButton')).tap();

    await expect(element(by.text('Dashboard'))).toBeVisible();
  });
});
```

---

# 6. Test IDs (CRITICAL)

Use stable identifiers:

```tsx
<Text testID="loginButton">Login</Text>
```

Rules:

* Do NOT rely on text content only
* Use consistent naming

---

# 7. Synchronization

Detox auto-waits, but still:

* avoid manual sleeps
* rely on UI visibility

Bad:

```ts
await new Promise(r => setTimeout(r, 2000));
```

Good:

```ts
await expect(element(by.id('dashboard'))).toBeVisible();
```

---

# 8. Network Handling

## 8.1 Mock or Stub Backend

Options:

* mock server
* intercept network

## 8.2 Deterministic Responses

* fixed data
* known scenarios

---

# 9. Data Management

## 9.1 Test Accounts

* dedicated accounts
* reset state between runs

## 9.2 Idempotent Setup

* tests should be repeatable

---

# 10. Error Scenarios

Test:

* invalid credentials
* network failure
* business error (e.g., insufficient balance)

---

# 11. Fintech Rules (CRITICAL)

## 11.1 Payment Flow

```txt
enter amount → confirm → success screen
```

Must validate:

* no duplicate submission
* correct navigation
* clear success/failure state

## 11.2 Security Flows

* session expiry → login screen
* unauthorized → blocked access

## 11.3 Sensitive Data

* ensure no sensitive data exposed in UI

---

# 12. Performance Guidelines

* keep test suite < 10–15 minutes
* parallelize across devices if possible

---

# 13. CI/CD Integration

* run on every release pipeline
* run on dedicated devices/emulators

---

# 14. Anti-patterns

* flaky tests with timeouts
* relying on network timing
* over-testing minor UI
* using production APIs

---

# 15. Checklist

* [ ] Critical flows covered
* [ ] Stable test IDs used
* [ ] No manual delays
* [ ] Deterministic data
* [ ] Runs in CI
* [ ] No flaky behavior

---

# 16. Final Rule

> E2E tests are your final safety net.
> If E2E passes, you can ship with confidence.

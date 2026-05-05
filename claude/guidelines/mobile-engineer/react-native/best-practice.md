# react-native/best-practice.md

## Objective

Define consolidated best practices for React Native applications covering architecture, performance, security, testing, and maintainability for fintech/banking systems.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Production-grade applications

Main rule:

> Best practices are guardrails.
> They prevent technical debt and ensure long-term scalability.

---

# 1. Architecture

## 1.1 Use Clean Architecture

```txt
UI → Hook → Application → Domain → Infrastructure
```

Rules:

* UI must not call API directly
* Business logic must be isolated
* Domain must be framework-independent

---

## 1.2 Feature-based Structure

```txt
features/
  transfer/
  payment/
  auth/
```

Rules:

* Avoid global folders like `components/`, `services/`
* Keep feature self-contained

---

# 2. TypeScript

## 2.1 Strict Mode

```json
"strict": true
```

## 2.2 No `any`

* Always define types
* Use domain-driven naming

---

# 3. State Management

## 3.1 Use Global State Carefully

* Global: business data
* Local: UI state

## 3.2 Avoid Over-rendering

* Use selectors
* Memoize data

---

# 4. Performance

## 4.1 Rendering

* Use `React.memo`
* Avoid inline functions

## 4.2 Lists

* Use `FlatList`
* Optimize props

## 4.3 Startup

* Load minimal data
* Defer non-critical tasks

---

# 5. Network

## 5.1 Centralized API Layer

* Use single HTTP client
* Add interceptors

## 5.2 Error Handling

* Normalize errors
* Avoid raw API errors

---

# 6. Security

## 6.1 Secure Storage

* Use Keychain/Keystore
* Do not store tokens in plain storage

## 6.2 SSL Pinning

* Prevent MITM attacks

## 6.3 Sensitive Data

* Never log sensitive info

---

# 7. Testing

## 7.1 Unit Testing

* Test logic in isolation

## 7.2 Integration Testing

* Test module interactions

## 7.3 E2E Testing

* Test real user flows

---

# 8. Code Quality

## 8.1 Linting

* ESLint must pass

## 8.2 Formatting

* Prettier enforced

## 8.3 Commit Rules

* Use conventional commits

---

# 9. Release

## 9.1 CI/CD

* Automated builds
* Automated tests

## 9.2 Rollout

* Progressive rollout

## 9.3 Rollback

* Always prepared

---

# 10. Fintech Rules (CRITICAL)

## 10.1 Money Flow

* Prevent duplicate submission
* Use idempotency

## 10.2 Error Handling

* Handle ambiguous states

## 10.3 Security

* Protect tokens
* Validate API responses

---

# 11. Anti-patterns

* business logic in UI
* overusing global state
* direct API calls in components
* ignoring performance
* skipping tests

---

# 12. Checklist

* [ ] clean architecture applied
* [ ] strict typing used
* [ ] performance optimized
* [ ] security enforced
* [ ] tests implemented
* [ ] CI/CD configured

---

# 13. Final Rule

> Best practices are not optional.
> They define the difference between a prototype and a production system.

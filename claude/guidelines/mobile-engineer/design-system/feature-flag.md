# architecture/feature-flag.md

## Objective

Define a feature flag (feature toggle) system for React Native applications to enable safe releases, dynamic control, and experimentation without requiring app redeploy.

Applies to:

* React Native (iOS + Android)
* Backend-integrated systems
* Fintech / Banking apps
* CI/CD and release strategy

Main rule:

> Feature flags must allow you to disable risky behavior instantly in production.

---

# 1. Core Principles

## 1.1 Runtime Control

* Features must be controlled without app release
* Config must be fetched remotely

---

## 1.2 Safe by Default

* Default state must be safe (usually OFF)

---

## 1.3 Decoupled from UI

* UI reads flags, does not define logic

---

# 2. Types of Feature Flags

## 2.1 Release Flag

```txt
Enable/disable new feature
```

## 2.2 Kill Switch

```txt
Disable feature immediately (critical)
```

## 2.3 Experiment Flag

```txt
A/B testing
```

## 2.4 Permission Flag

```txt
Enable feature for specific users/groups
```

---

# 3. Flag Structure

```ts
type FeatureFlags = {
  transfer_new_flow: boolean;
  biometric_enabled: boolean;
  payment_enabled: boolean;
  kyc_v2_enabled: boolean;
};
```

---

# 4. Data Source

Options:

* Remote config API (recommended)
* Firebase Remote Config
* LaunchDarkly / ConfigCat

Rules:

* Must support dynamic updates
* Must be highly available

---

# 5. Client Implementation

## 5.1 Feature Flag Service

```ts
class FeatureFlagService {
  private flags: FeatureFlags;

  isEnabled(key: keyof FeatureFlags): boolean {
    return this.flags[key] ?? false;
  }
}
```

---

## 5.2 Usage

```ts
if (featureFlagService.isEnabled('transfer_new_flow')) {
  showNewFlow();
} else {
  showOldFlow();
}
```

Rules:

* Do not scatter flag logic everywhere
* Keep usage simple

---

# 6. Caching Strategy

* Cache flags locally
* Use TTL (e.g., 5–15 minutes)

Rules:

* App must work if config fetch fails
* Fallback to last known state

---

# 7. Sync Strategy

```txt
App start → fetch flags → cache → use
```

Optional:

* periodic refresh
* refresh on app foreground

---

# 8. Fintech Rules (CRITICAL)

## 8.1 Kill Switch

Critical features must have kill switch:

```txt
transfer_enabled
payment_enabled
biometric_enabled
```

---

## 8.2 Payment Safety

* Ability to disable transfer/payment instantly
* Prevent duplicate transactions

---

## 8.3 Rollback Support

Feature flags must support:

* instant disable after release

---

# 9. Anti-patterns

* Hardcoding feature flags
* Using flags without default value
* Not caching flags
* No kill switch for critical features

---

# 10. Checklist

* [ ] feature flag service exists
* [ ] remote config integrated
* [ ] default values defined
* [ ] kill switches for critical flows
* [ ] flags cached locally
* [ ] safe fallback implemented

---

# 11. Final Rule

> Feature flags give you control over production behavior.
> Without them, every release is a risk.

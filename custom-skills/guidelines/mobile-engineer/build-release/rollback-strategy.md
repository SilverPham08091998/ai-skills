# release/rollback-strategy.md

## Objective

Define rollback standards for React Native applications to recover quickly and safely when a release causes production issues.

Applies to:

* React Native (iOS + Android)
* App Store / Play Store releases
* CodePush / OTA updates
* CI/CD release pipelines
* Fintech / Banking applications

Main rule:

> Every release must have a rollback plan before it goes live.
> If rollback is not possible, the release is not production-ready.

---

# 1. Core Principles

## 1.1 Rollback Must Be Planned

Rollback is not an emergency improvisation.

Every release must define:

* rollback owner
* rollback trigger
* rollback method
* verification checklist

---

## 1.2 Fast Recovery Over Perfect Fix

When production is broken:

* stop the impact first
* restore stable behavior
* investigate root cause after mitigation

---

## 1.3 Prefer Progressive Release

Use staged rollout to reduce blast radius.

Examples:

```txt
5% → 10% → 25% → 50% → 100%
```

Rules:

* Do not release 100% immediately for critical apps.
* Monitor crash rate and business KPIs before increasing rollout.

---

# 2. Rollback Types

## 2.1 CodePush Rollback

Use when the issue is caused by JS bundle or asset update.

```bash
appcenter codepush rollback -a <owner>/<app> Production
```

Rules:

* Fastest rollback path.
* Only applies to CodePush updates.
* Cannot rollback native binary changes.

---

## 2.2 App Store / Play Store Rollback

Use when the issue is caused by native code or app binary.

Options:

* stop staged rollout
* release a hotfix version
* promote previous stable version if store supports it

Rules:

* Binary rollback is slower than CodePush rollback.
* Always keep previous stable build metadata and artifacts.

---

## 2.3 Feature Flag Rollback

Use when the issue is isolated to a feature.

```txt
feature.transfer.newFlow = false
```

Rules:

* Prefer feature flag rollback when possible.
* Critical features must be guarded by kill switches.

---

## 2.4 Backend Compatibility Rollback

Use when mobile release depends on backend contract changes.

Rules:

* Backend APIs must be backward compatible.
* Do not remove old fields/endpoints immediately.
* Maintain compatibility window for mobile versions in production.

---

# 3. Rollback Triggers

Rollback should be considered when:

* crash-free rate drops below threshold
* login success rate drops
* payment / transfer success rate drops
* app startup failure increases
* severe UI blocking issue appears
* security or compliance issue is detected

Example thresholds:

```txt
Crash-free users < 99.5%
Payment success rate drops > 2%
Login failure rate increases > 5%
```

Rules:

* Define thresholds before release.
* Do not debate rollback during incident if trigger is already met.

---

# 4. Rollback Decision Flow

```txt
Issue detected
  → classify severity
  → identify affected version/platform
  → choose mitigation
      → CodePush rollback
      → feature flag off
      → stop rollout
      → hotfix binary
  → verify recovery
  → communicate status
```

---

# 5. CodePush Rollback Strategy

## 5.1 Before Release

* Test update on staging deployment.
* Use rollout percentage.
* Record deployment label.

```bash
appcenter codepush deployment list -a <owner>/<app>
```

---

## 5.2 During Incident

Rollback latest deployment:

```bash
appcenter codepush rollback -a <owner>/<app> Production
```

Rollback to specific label:

```bash
appcenter codepush rollback -a <owner>/<app> Production --target-release v12
```

---

## 5.3 After Rollback

Verify:

* crash rate decreases
* affected screens work
* users receive stable bundle

---

# 6. Store Release Rollback Strategy

## 6.1 Google Play Staged Rollout

Actions:

* halt rollout
* reduce rollout if supported
* publish hotfix AAB

---

## 6.2 Apple App Store

Actions:

* stop phased release if enabled
* submit expedited hotfix if severe
* use feature flags to mitigate while waiting

Rules:

* iOS binary rollback is limited.
* Design app so server-side kill switches can disable risky features.

---

# 7. Feature Flag / Kill Switch Strategy

Critical mobile features should have remote controls.

Examples:

```txt
payment.enabled=false
transfer.enabled=false
biometric.enabled=false
new_dashboard.enabled=false
```

Rules:

* Kill switch must be evaluated early.
* Kill switch must fail safe.
* Feature flag service must be highly available.

---

# 8. Database / Backend Compatibility

Mobile rollback often fails when backend is not backward compatible.

Rules:

* Use additive API changes.
* Never remove fields used by old app versions immediately.
* Support multiple app versions during migration.
* Use versioned APIs when needed.

---

# 9. Monitoring During Rollback

Track:

* crash-free users
* app startup success
* login success rate
* transfer/payment success rate
* API error rate
* CodePush adoption rate

Tools:

* App Center Crashes
* Firebase Crashlytics
* Sentry
* Datadog/New Relic
* backend dashboards

---

# 10. Communication Plan

Define communication channels:

* engineering
* QA
* product
* customer support
* incident channel

Message should include:

* affected version
* affected platform
* impact
* mitigation action
* current status

---

# 11. Fintech Rules (CRITICAL)

## 11.1 Money Movement

If payment/transfer is impacted:

* stop rollout immediately
* disable affected feature if needed
* prevent duplicate transactions
* preserve transaction status inquiry

---

## 11.2 Ambiguous Transactions

If users may have submitted transactions during incident:

* do not assume failure
* perform transaction reconciliation
* show pending/status inquiry flow

---

## 11.3 Security Incidents

If release leaks sensitive data or weakens auth:

* rollback immediately
* revoke affected tokens if needed
* notify security/compliance team
* preserve audit logs

---

# 12. Rollback Checklist

Before release:

* [ ] Previous stable version identified.
* [ ] Feature flags / kill switches configured.
* [ ] CodePush rollback path tested.
* [ ] Store staged rollout enabled.
* [ ] Monitoring dashboards ready.
* [ ] Rollback owner assigned.

During rollback:

* [ ] Severity classified.
* [ ] Affected version/platform identified.
* [ ] Rollout stopped or update rolled back.
* [ ] Critical features disabled if needed.
* [ ] Recovery metrics monitored.

After rollback:

* [ ] Root cause documented.
* [ ] Hotfix created if needed.
* [ ] Tests added for regression.
* [ ] Incident report completed.

---

# 13. Anti-patterns

* releasing without rollback plan
* 100% rollout immediately
* using CodePush for native-breaking changes
* removing backend compatibility too early
* relying only on app store rollback
* delaying rollback after trigger threshold is met

---

# 14. Final Rule

> Rollback is a production safety mechanism, not a failure.
> A good rollback strategy reduces customer impact, protects money flows, and keeps releases safe.

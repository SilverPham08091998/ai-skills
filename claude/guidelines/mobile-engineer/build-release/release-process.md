# release/release-process.md

## Objective

Define the end-to-end release process for React Native applications from development to production, ensuring quality, security, traceability, and safe rollout in fintech/banking environments.

Applies to:

* React Native (iOS + Android)
* CI/CD pipelines
* QA / UAT / Production releases
* App Store / Play Store / App Center / CodePush

Main rule:

> A release is not just a build.
> A release is a controlled process: validate → approve → rollout → monitor → rollback if needed.

---

# 1. Release Principles

## 1.1 Reproducible Release

* Same source code must produce the same build artifact.
* Builds must run through CI/CD, not only local machines.
* Release artifacts must be stored and traceable.

## 1.2 Progressive Delivery

* Release gradually.
* Avoid 100% rollout immediately for critical apps.

## 1.3 Observability First

* Monitor crash rate, API errors, login success, and payment/transfer flows after release.

## 1.4 Rollback Ready

* Every release must have a rollback plan before going live.

---

# 2. Release Environments

Recommended environments:

```txt
Development → QA → UAT/Staging → Production
```

## 2.1 Development

Purpose:

* local development
* developer testing

Rules:

* debug build allowed
* mock API allowed
* not for business validation

---

## 2.2 QA

Purpose:

* internal testing
* regression testing
* integration verification

Rules:

* use QA backend environment
* distribute via App Center / TestFlight internal testing

---

## 2.3 UAT / Staging

Purpose:

* business validation
* product sign-off
* pre-production verification

Rules:

* should be close to production config
* no mock data unless explicitly approved

---

## 2.4 Production

Purpose:

* real users

Rules:

* release build only
* no debug logs
* no test endpoints
* no mock mode

---

# 3. Branching Strategy

Recommended branches:

```txt
main        → production-ready
release/*   → release stabilization
develop     → integration branch
feature/*   → feature development
hotfix/*    → urgent production fix
```

Rules:

* Production releases must come from `main` or `release/*`.
* Hotfix branches must be merged back to `main` and `develop`.
* Release branches must be frozen except for bug fixes.

---

# 4. Versioning Strategy

## 4.1 Semantic Version

```txt
MAJOR.MINOR.PATCH
```

Examples:

```txt
1.0.0
1.1.0
1.1.1
```

## 4.2 Android

* `versionName`: semantic version
* `versionCode`: must increase every release

## 4.3 iOS

* `CFBundleShortVersionString`: semantic version
* `CFBundleVersion`: must increase every release

Rules:

* Never reuse build numbers.
* Version must be traceable to Git tag.

---

# 5. Release Checklist Before Build

Before creating release artifacts:

* [ ] Feature scope confirmed.
* [ ] Release notes prepared.
* [ ] Version updated.
* [ ] Environment config verified.
* [ ] Feature flags configured.
* [ ] Rollback plan prepared.
* [ ] QA test plan ready.
* [ ] Monitoring dashboards ready.

---

# 6. CI Quality Gate

CI must pass before release build:

```bash
yarn type-check
yarn lint
yarn format:check
yarn test
yarn circular-check
```

Rules:

* No release if type-check fails.
* No release if lint fails.
* No release if tests fail.
* No release if circular dependencies are detected.

---

# 7. Build Process

## 7.1 Android Build

```bash
cd android
./gradlew clean
./gradlew bundleRelease
```

Output:

```txt
android/app/build/outputs/bundle/release/app-release.aab
```

## 7.2 iOS Build

Use Xcode archive or Fastlane:

```bash
bundle exec fastlane ios release
```

Rules:

* Android and iOS builds must use production config.
* Signing credentials must come from secure CI secrets.
* Do not build production artifacts manually unless emergency process allows it.

---

# 8. Artifact Management

Store release artifacts:

* Android AAB/APK
* iOS IPA/archive metadata
* source commit hash
* Git tag
* release notes
* environment config snapshot

Rules:

* Every artifact must be traceable to commit and build number.
* Do not overwrite release artifacts.

---

# 9. QA Verification

QA must verify:

* app startup
* login/logout
* dashboard
* navigation
* API integration
* offline/weak network behavior
* critical flows

Fintech critical flows:

* fund transfer
* payment
* OTP/PIN
* transaction history
* receipt/statement download

---

# 10. UAT / Business Sign-off

UAT validates:

* business requirements
* product copy
* compliance-sensitive behavior
* customer-facing flows

Rules:

* No production rollout without sign-off.
* Any change after sign-off requires re-validation.

---

# 11. Production Rollout

## 11.1 Progressive Rollout

Recommended:

```txt
5% → 10% → 25% → 50% → 100%
```

Rules:

* Monitor metrics between each rollout step.
* Stop rollout if thresholds are breached.

---

## 11.2 Android Play Store

* Upload AAB.
* Use staged rollout.
* Monitor crash-free users and reviews.

## 11.3 iOS App Store

* Submit build for review.
* Use phased release when appropriate.
* Monitor crashes and adoption.

---

# 12. CodePush / OTA Release

Use CodePush only for:

* JS bundle fixes
* UI fixes
* non-native changes
* non-critical behavior changes

Do NOT use CodePush for:

* payment logic changes
* authentication/security changes
* native module changes
* compliance-sensitive changes

Rules:

* Test on staging deployment first.
* Use rollout percentage.
* Keep rollback command ready.

---

# 13. Monitoring After Release

Monitor:

* crash-free users
* app startup success
* login success rate
* API error rate
* payment/transfer success rate
* latency of critical APIs
* CodePush adoption rate
* customer support tickets

Tools:

* App Center
* Firebase Crashlytics
* Sentry
* backend dashboards
* observability platform

---

# 14. Rollback Decision

Rollback triggers:

* crash-free users below threshold
* severe login failure
* payment/transfer failure spike
* app cannot start
* sensitive data exposure
* critical security issue

Actions:

```txt
CodePush issue → rollback CodePush
Feature issue → disable feature flag
Store rollout issue → halt rollout
Native issue → hotfix binary
```

Rules:

* Do not wait too long when rollback threshold is met.
* Communicate rollback status clearly.

---

# 15. Hotfix Process

Hotfix flow:

```txt
production issue
  → create hotfix branch
  → fix minimal scope
  → run CI quality gate
  → QA smoke test
  → release hotfix
  → merge back to main/develop
```

Rules:

* Hotfix must be minimal and focused.
* Do not include unrelated refactors.
* Add regression test after fixing.

---

# 16. Communication Plan

Release communication should include:

* release version
* build number
* rollout percentage
* release notes
* known risks
* rollback owner
* monitoring dashboard links

Audience:

* engineering
* QA
* product
* customer support
* operations

---

# 17. Fintech Rules (CRITICAL)

## 17.1 Money Movement Safety

For payment/transfer-related releases:

* verify idempotency behavior
* verify duplicate submission prevention
* verify ambiguous transaction handling
* verify transaction status inquiry

## 17.2 Security Validation

Before release:

* no sensitive logs
* no debug endpoints
* certificate pinning verified
* secure storage verified
* token/session behavior verified

## 17.3 Compliance-sensitive Changes

Changes involving:

* KYC
* authentication
* payment
* customer data
* transaction receipts/statements

must go through stricter review and sign-off.

---

# 18. Anti-patterns

* building production app locally without traceability
* skipping QA/UAT
* releasing 100% immediately
* using CodePush for sensitive logic changes
* no rollback owner
* no monitoring after release
* mixing staging and production configs
* committing signing credentials

---

# 19. Release Done Criteria

A release is done only when:

* [ ] Production build is live.
* [ ] Rollout metrics are healthy.
* [ ] Crash rate is acceptable.
* [ ] Critical flows are verified.
* [ ] Customer support has release notes.
* [ ] Rollback window monitoring is completed.
* [ ] Release artifacts are archived.

---

# 20. Final Rule

> Safe release requires discipline.
> Build automation, quality gates, staged rollout, monitoring, and rollback are all mandatory parts of the release process.

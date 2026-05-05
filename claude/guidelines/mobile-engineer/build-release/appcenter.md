# release/appcenter.md

## Objective

Define standards for using Microsoft App Center to build, distribute, and monitor React Native applications in production.

Applies to:

* React Native (iOS + Android)
* CI/CD pipelines
* QA & distribution workflows

Main rule:

> App Center should automate build and distribution while providing fast feedback for testing and crashes.

---

# 1. Overview

App Center provides:

* Build automation
* App distribution
* Crash reporting
* Analytics

---

# 2. Setup

## 2.1 Create App

* Create separate apps for:

    * Android
    * iOS

## 2.2 Connect Repository

* GitHub / Azure DevOps / Bitbucket

---

# 3. Build Configuration

## 3.1 Android

* Select branch (e.g., develop, release)
* Enable Gradle build
* Upload keystore securely

## 3.2 iOS

* Upload certificates & provisioning profiles
* Configure signing

Rules:

* Never commit secrets
* Use App Center secure storage

---

# 4. Environment Variables

Configure:

* API_URL
* ENV (dev/staging/prod)
* Feature flags

Rules:

* Do not hardcode sensitive data
* Use environment-based builds

---

# 5. Build Scripts

## 5.1 Pre-build

```bash
yarn install
```

## 5.2 Post-clone (React Native)

```bash
yarn install
cd ios && pod install
```

---

# 6. Distribution

## 6.1 Groups

* QA team
* Internal testers
* Stakeholders

## 6.2 Release Flow

```txt
Build → Distribute → Test → Feedback
```

Rules:

* Use separate groups per environment
* Avoid sending unstable builds to broad audience

---

# 7. Crash Reporting

## 7.1 Enable App Center SDK

```bash
yarn add appcenter appcenter-crashes appcenter-analytics
```

## 7.2 Initialize

```ts
import AppCenter from 'appcenter';
import Crashes from 'appcenter-crashes';
import Analytics from 'appcenter-analytics';
```

---

## 7.3 Best Practices

* Attach userId (masked)
* Log non-sensitive context

Rules:

* Do NOT log tokens or PII

---

# 8. Analytics

Track:

* screen views
* user actions
* feature usage

---

# 9. CI/CD Integration

Typical flow:

```txt
Git push → App Center build → distribute → QA test
```

Rules:

* Automate builds per branch
* Use release branches for stable builds

---

# 10. Versioning

* Sync version with Git tags
* Ensure build numbers increment

---

# 11. Fintech Rules (CRITICAL)

## 11.1 Data Privacy

* Do not log sensitive data
* Mask user info

## 11.2 Secure Distribution

* Restrict access to builds
* Use invite-only groups

## 11.3 Crash Handling

* Monitor crashes in real-time
* Prioritize fixes for critical flows (payment, login)

---

# 12. Anti-patterns

* distributing debug builds
* exposing sensitive logs
* mixing environments
* ignoring crash reports

---

# 13. Checklist

* [ ] repo connected
* [ ] build config correct
* [ ] environment variables set
* [ ] distribution groups configured
* [ ] crash reporting enabled
* [ ] no sensitive data logged

---

# 14. Final Rule

> App Center accelerates delivery and feedback.
> Use it to automate builds and ensure fast iteration without compromising security.

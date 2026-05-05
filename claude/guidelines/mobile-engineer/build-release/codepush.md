# release/codepush.md

## Objective

Define standards for using CodePush (OTA updates) in React Native to deliver JS/asset updates quickly and safely—while respecting app store policies and fintech security constraints.

Applies to:

* React Native (iOS + Android)
* JS bundle & assets updates (no native changes)
* Production/staging environments

Main rule:

> Use OTA for non-native, non-critical fixes.
> Never bypass app store review for sensitive, security, or payment-related changes.

---

# 1. Overview

CodePush allows:

* Update JS bundle without app store resubmission
* Fast bug fixes
* Gradual rollout

Limitations:

* Cannot change native code
* Must comply with Apple/Google policies

---

# 2. Setup

## 2.1 Install SDK

```bash
yarn add react-native-code-push
```

Link (if needed):

```bash
npx pod-install
```

---

## 2.2 Configure App

Wrap root component:

```ts
import codePush from 'react-native-code-push';

export default codePush({
  checkFrequency: codePush.CheckFrequency.ON_APP_START,
})(App);
```

---

# 3. Deployment Strategy

## 3.1 Environments

* Staging
* Production

Rules:

* Use separate deployments per environment
* Do not push test updates to production

---

## 3.2 Release Command

```bash
appcenter codepush release-react \
  -a <owner>/<app> \
  -d Production
```

---

# 4. Update Modes

## 4.1 Immediate

* Apply update instantly

```ts
installMode: codePush.InstallMode.IMMEDIATE
```

## 4.2 On Next Restart (Recommended)

```ts
installMode: codePush.InstallMode.ON_NEXT_RESTART
```

## 4.3 On Resume

```ts
installMode: codePush.InstallMode.ON_NEXT_RESUME
```

Rules:

* Avoid forcing update during critical flows
* Prefer safe modes for production

---

# 5. Rollout Strategy

## 5.1 Gradual Rollout

```bash
--rollout 20
```

* Start with small percentage
* Increase gradually

---

## 5.2 Rollback

```bash
appcenter codepush rollback
```

Rules:

* Always be ready to rollback
* Monitor crashes after release

---

# 6. Version Targeting

```bash
--targetBinaryVersion "1.0.0"
```

Rules:

* Match app version
* Avoid sending incompatible updates

---

# 7. UX Guidelines

## 7.1 Silent Updates

* Apply in background

## 7.2 Optional Prompt

```ts
updateDialog: true
```

Rules:

* Do not interrupt user unnecessarily
* Avoid forcing restart without reason

---

# 8. Fintech Rules (CRITICAL)

## 8.1 What is ALLOWED

* UI fixes
* minor bug fixes
* non-critical logic adjustments

## 8.2 What is NOT ALLOWED

* payment logic changes
* authentication/security changes
* compliance-related updates

Reason:

* Must go through app store review

---

## 8.3 Critical Flow Protection

* Do not update during:

    * payment
    * transfer
    * login

---

# 9. Security Considerations

* Ensure HTTPS communication
* Validate update integrity

Rules:

* Do not expose sensitive data
* Avoid dynamic code injection risks

---

# 10. Monitoring

* Monitor crash rate after update
* Track adoption rate

---

# 11. Anti-patterns

* using CodePush for major features
* pushing untested updates
* forcing restart unexpectedly
* skipping rollout strategy

---

# 12. Checklist

* [ ] update tested
* [ ] correct deployment used
* [ ] rollout strategy applied
* [ ] version matched
* [ ] no critical logic changed

---

# 13. Final Rule

> CodePush is a powerful tool, not a shortcut.
> Use it to improve speed without sacrificing safety or compliance.

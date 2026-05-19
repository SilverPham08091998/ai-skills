# release/build-ios.md

## Objective

Define the standard process to build, sign, and release iOS applications for React Native projects in production (especially fintech/banking apps).

Applies to:

* React Native (iOS)
* Xcode
* CI/CD pipelines
* App Store release

Main rule:

> iOS builds must be reproducible, securely signed, and validated before release.

---

# 1. Build Types

## 1.1 Debug Build

```bash
yarn ios
```

* For development only
* Not optimized
* Uses development provisioning profile

---

## 1.2 Release Build (Xcode)

```bash
cd ios
open <YourProject>.xcworkspace
```

Then:

* Select **Generic iOS Device**
* Product → Archive

---

# 2. Build Output

After archive:

* Xcode Organizer → Export

Formats:

* `.ipa` (for App Store / AdHoc)

---

# 3. Signing & Certificates (CRITICAL)

## 3.1 Required

* Apple Developer Account
* Distribution Certificate
* Provisioning Profile

Types:

* Development
* AdHoc
* App Store

---

## 3.2 Certificate Management

Do NOT:

* commit certificates
* share private keys insecurely

Use:

* Apple Developer Portal
* CI secret storage

---

## 3.3 Automatic Signing (Recommended)

In Xcode:

* Signing & Capabilities
* Enable “Automatically manage signing”

---

## 3.4 Manual Signing (Advanced)

* Specify provisioning profile manually
* Required for CI/CD pipelines

---

# 4. Versioning

## 4.1 Version (CFBundleShortVersionString)

```txt
1.0.0
```

## 4.2 Build Number (CFBundleVersion)

```txt
100
```

Rules:

* Build number must increase every release
* Follow semantic versioning for version

---

# 5. Build Settings Optimization

## 5.1 Enable Release Optimizations

* Dead code stripping
* Whole module optimization

## 5.2 Disable Debug Features

* Remove debug logs
* Disable dev menu

---

# 6. Environment Config

Use environment-based configuration:

* dev
* staging
* production

Tools:

* `.env`
* xcconfig files

Rules:

* Do not hardcode API URLs
* Separate environment configs

---

# 7. Build via CLI (Optional)

```bash
cd ios
xcodebuild \
  -workspace <YourProject>.xcworkspace \
  -scheme <YourScheme> \
  -configuration Release \
  -archivePath build/<YourProject>.xcarchive \
  archive
```

---

# 8. Export IPA via CLI

```bash
xcodebuild -exportArchive \
  -archivePath build/<YourProject>.xcarchive \
  -exportOptionsPlist exportOptions.plist \
  -exportPath build/
```

---

# 9. Verification Before Release

## 9.1 Install on Device

* Test via TestFlight or direct install

## 9.2 Smoke Test

* login
* navigation
* critical flows (payment, transfer)

## 9.3 Crash Check

* No crash on launch
* No runtime errors

---

# 10. App Store Upload

Options:

* Xcode Organizer → Upload
* Transporter app
* CI/CD tools (Fastlane)

---

# 11. CI/CD Integration

Recommended tool:

* Fastlane

Example:

```bash
bundle exec fastlane ios release
```

Pipeline steps:

```bash
yarn install
yarn test
yarn lint
cd ios
fastlane build
fastlane upload
```

---

# 12. Fintech Rules (CRITICAL)

## 12.1 Secure Signing

* Protect certificates and private keys
* Use secure CI vault

## 12.2 No Debug Artifacts

* Remove logs
* Disable debug features

## 12.3 Integrity

* Use App Attest / DeviceCheck
* Prevent tampering

---

# 13. Anti-patterns

* committing certificates
* using debug build in production
* skipping release testing
* hardcoding secrets

---

# 14. Checklist

* [ ] version updated
* [ ] build number increased
* [ ] release build tested
* [ ] signing configured correctly
* [ ] no debug logs
* [ ] CI pipeline verified

---

# 15. Final Rule

> iOS release is not just an archive.
> It must be secure, validated, and production-ready before submission.

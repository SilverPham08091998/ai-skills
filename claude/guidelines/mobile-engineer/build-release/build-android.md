# release/build-android.md

## Objective

Define the standard process to build, sign, and release Android applications for React Native projects in production (especially fintech/banking apps).

Applies to:

* React Native (Android)
* CI/CD pipelines
* Play Store release

Main rule:

> Android builds must be reproducible, signed securely, and fully validated before release.

---

# 1. Build Types

## 1.1 Debug Build

```bash
yarn android
```

* For development only
* Not optimized
* Not signed for production

---

## 1.2 Release Build

```bash
cd android
./gradlew assembleRelease
```

Output:

```txt
android/app/build/outputs/apk/release/app-release.apk
```

---

## 1.3 AAB (Recommended for Play Store)

```bash
./gradlew bundleRelease
```

Output:

```txt
android/app/build/outputs/bundle/release/app-release.aab
```

---

# 2. Signing Config (CRITICAL)

## 2.1 Generate Keystore

```bash
keytool -genkeypair -v \
  -storetype PKCS12 \
  -keystore release.keystore \
  -alias app-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

---

## 2.2 Store Credentials Securely

Do NOT commit secrets:

```txt
release.keystore
keystore passwords
```

Use:

* environment variables
* CI secret manager

---

## 2.3 `gradle.properties`

```properties
MYAPP_UPLOAD_STORE_FILE=release.keystore
MYAPP_UPLOAD_KEY_ALIAS=app-key
MYAPP_UPLOAD_STORE_PASSWORD=******
MYAPP_UPLOAD_KEY_PASSWORD=******
```

---

## 2.4 `build.gradle`

```gradle
signingConfigs {
  release {
    storeFile file(MYAPP_UPLOAD_STORE_FILE)
    storePassword MYAPP_UPLOAD_STORE_PASSWORD
    keyAlias MYAPP_UPLOAD_KEY_ALIAS
    keyPassword MYAPP_UPLOAD_KEY_PASSWORD
  }
}

buildTypes {
  release {
    signingConfig signingConfigs.release
    minifyEnabled true
    shrinkResources true
    proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
  }
}
```

---

# 3. Versioning

## 3.1 versionCode

* Must be incremented every release

```gradle
versionCode 100
```

## 3.2 versionName

```gradle
versionName "1.0.0"
```

Rules:

* Follow semantic versioning
* Keep versionCode monotonic

---

# 4. Proguard / R8 (CRITICAL)

Enable minification:

```gradle
minifyEnabled true
```

Add rules:

```txt
-keep class com.myapp.** { *; }
```

Rules:

* Prevent breaking reflection-based libs
* Test release build thoroughly

---

# 5. Environment Config

Use `.env` or build variants:

* dev
* staging
* production

Rules:

* Never hardcode API URLs
* Separate config per environment

---

# 6. Build Commands

## 6.1 Clean Build

```bash
cd android
./gradlew clean
```

## 6.2 Build Release

```bash
./gradlew bundleRelease
```

---

# 7. Verification Before Release

## 7.1 Install APK

```bash
adb install app-release.apk
```

## 7.2 Smoke Test

* login
* navigation
* critical flows

---

## 7.3 Check Logs

* no crashes
* no warnings

---

# 8. Play Store Upload

* Upload AAB
* Fill release notes
* Configure rollout (10% → 50% → 100%)

---

# 9. CI/CD Integration

Example pipeline:

```bash
yarn install
yarn test
yarn lint
cd android
./gradlew bundleRelease
```

Rules:

* Build must be automated
* Do not build manually for production

---

# 10. Fintech Rules (CRITICAL)

## 10.1 Secure Signing

* Keystore must be protected
* Rotate keys if compromised

## 10.2 No Debug Artifacts

* Remove logs
* Disable debug features

## 10.3 Integrity

* Ensure app not tampered
* Use Play Integrity API (recommended)

---

# 11. Anti-patterns

* committing keystore
* using debug build in production
* skipping release testing
* hardcoding secrets

---

# 12. Checklist

* [ ] versionCode updated
* [ ] release build tested
* [ ] keystore secured
* [ ] proguard enabled
* [ ] no debug logs
* [ ] CI build verified

---

# 13. Final Rule

> A release build is not just a compiled app.
> It must be secure, tested, and reproducible.

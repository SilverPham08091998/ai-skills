========================

🚀 FASTLANE RELEASE RULE (MOBILE)

========================

🎯 OBJECTIVE

Define Fastlane release rules for mobile applications to ensure:

* Repeatable build/release process
* Safe signing management
* Environment separation
* Consistent versioning
* Secure secret handling
* Production-ready delivery pipeline

Applied for:

React Native
iOS
Android
Fastlane
AppCenter
TestFlight
Google Play
CI/CD

⸻

========================

🧠 CORE PRINCIPLE

========================

Release must be automated, repeatable, and safe.

Golden rule:

No manual production build from random local machine unless explicitly approved.

Fastlane should own:

build
signing
testing gate
versioning
changelog
distribution
metadata upload

⸻

========================

📁 STRUCTURE

========================

Recommended structure:

fastlane/
Fastfile
Appfile
Matchfile
Pluginfile
README.md
metadata/
screenshots/
android/
fastlane/
Fastfile
Appfile
ios/
fastlane/
Fastfile
Appfile

Option A: root Fastlane controls both platforms:

fastlane/Fastfile

Option B: platform-specific Fastlane:

android/fastlane/Fastfile
ios/fastlane/Fastfile

Rule:

Choose one structure and keep it consistent.

⸻

========================

🧱 LANE NAMING RULE

========================

Use clear lane names:

android_beta
android_release
ios_beta
ios_release
build_android_staging
build_android_production
build_ios_staging
build_ios_production

Avoid vague names:

do_it
build1
release_new
upload_app

⸻

========================

🌍 ENVIRONMENT RULE

========================

Each environment must be explicit.

Common environments:

dev
sit
uat
staging
production

Each build must know:

API base URL
bundle id / application id
app name
version name
version code / build number
signing config
feature flags
SSL pinning config

MUST NOT:

use production API in staging build accidentally
use staging SSL pins in production
mix production signing with dev build

⸻

========================

🔐 SECRET MANAGEMENT RULE

========================

Secrets must come from CI secret store or secure local env.

Sensitive values:

Apple API key
App Store Connect key
Google Play service account JSON
keystore password
key alias password
match password
AppCenter token
Firebase token
CodePush token
Slack webhook

MUST NOT:

commit secrets to git
print secrets in logs
hardcode secrets in Fastfile
store keystore password in plaintext repo file

Use:

ENV['SECRET_NAME']
CI secret variables
secure files / secret manager

⸻

========================

🤖 ANDROID FASTLANE RULE

========================

Build lanes

Recommended lanes:

platform :android do
desc "Build Android staging APK"
lane :build_staging do
gradle(
task: "assemble",
flavor: "staging",
build_type: "Release"
)
end
desc "Build Android production AAB"
lane :build_production do
gradle(
task: "bundle",
flavor: "production",
build_type: "Release"
)
end
end

Rules:

* Use AAB for Play Store production when required
* Use APK/AAB based on distribution target
* Use product flavors for env separation
* Signing config must be controlled and secure

⸻

========================

🍏 IOS FASTLANE RULE

========================

Build lanes

Recommended lanes:

platform :ios do
desc "Build iOS staging"
lane :build_staging do
build_app(
scheme: "App-Staging",
configuration: "Release",
export_method: "ad-hoc"
)
end
desc "Build iOS production"
lane :build_production do
build_app(
scheme: "App-Production",
configuration: "Release",
export_method: "app-store"
)
end
end

Rules:

* Scheme must match environment
* Export method must match distribution target
* Production build uses App Store distribution
* Beta/internal build can use ad-hoc/TestFlight

⸻

========================

🔏 SIGNING RULE

========================

Signing must be deterministic.

Android

MUST define:

keystore file
store password
key alias
key password

Secrets must come from CI/env.

iOS

Use one of:

fastlane match
manual signing with CI installed certificates/profiles
Xcode automatic signing only if team approves

MUST NOT:

commit certificates/private keys openly
commit provisioning profiles without approval
use personal Apple account for production CI release

⸻

========================

🔢 VERSIONING RULE

========================

Version must be managed consistently.

Android

versionName → user-facing version
versionCode → monotonically increasing build number

iOS

CFBundleShortVersionString → user-facing version
CFBundleVersion → build number

Rules:

* build number must increase for each upload
* production release version must be traceable to git tag/commit
* CI should inject build number when possible

Example:

increment_build_number(build_number: ENV['BUILD_NUMBER'])

⸻

========================

🧪 PRE-RELEASE CHECK RULE

========================

Before release lane uploads build, it should run quality gates.

Recommended checks:

install dependencies
lint
typecheck
unit tests
component tests
security config check
env config check
version check

Example:

lane :precheck do
sh("yarn lint")
sh("yarn test --watchAll=false")
sh("yarn tsc --noEmit")
end

Rule:

Release lane must not bypass test gate unless explicitly approved.

⸻

========================

📦 DISTRIBUTION RULE

========================

Distribution targets:

AppCenter
Firebase App Distribution
TestFlight
Google Play Internal Testing
Google Play Production
App Store Production

Internal/Beta

Use:

AppCenter
Firebase App Distribution
TestFlight
Google Play Internal Testing

Production

Use:

App Store Connect
Google Play Console

MUST NOT:

upload production build to wrong app/project
use wrong bundle id/application id
send production build to public before approval

⸻

========================

📝 CHANGELOG RULE

========================

Every distributed build should have changelog.

Changelog can include:

version
build number
git commit
branch
environment
feature summary
bug fixes
known issues

Example:

Version: 1.8.0
Build: 180
Branch: release/1.8.0
Commit: abc1234
Environment: UAT
Changes:
- Add transfer confirmation screen
- Fix biometric login crash

MUST NOT include sensitive internal details.

⸻

========================

🔐 FINTECH RELEASE RULE

========================

For banking/payment app releases, MUST verify:

SSL pinning config correct
API base URL correct
analytics disabled/masked for sensitive data
logs do not print token/OTP/PIN
root/jailbreak policy correct
secure storage enabled
production signing used
version/build number correct
feature flags correct

MUST NOT release if:

debug mode enabled
cleartext traffic enabled
staging API in production
SSL pinning disabled
sensitive logs enabled
wrong signing config

⸻

========================

🚨 ROLLBACK / HOTFIX RULE

========================

Release process must support:

hotfix branch
emergency build
build re-distribution
CodePush/OTA when allowed
store rollback strategy when possible

Rules:

* OTA/CodePush must not change native code
* critical security fixes may require store release
* rollback must preserve version/build traceability

⸻

========================

🧾 LOGGING RULE

========================

Fastlane logs must not expose secrets.

MUST mask:

keystore password
Apple API key
Google service account JSON
AppCenter token
CodePush token
match password

MUST NOT:

puts ENV['SECRET']
print service account JSON
print signing passwords

⸻

========================

🧪 TESTING CHECKLIST

========================

Before production release:

Android build success
iOS build success
unit tests pass
typecheck pass
lint pass
release notes generated
version/build incremented
correct env selected
signing verified
SSL pinning verified
app launches on real device
login works
critical payment flow smoke tested

⸻

========================

🚫 ANTI-PATTERNS

========================

1. Hardcoded secrets

❌ BAD

appcenter_upload(api_token: "abc123")

2. Manual version bump only

❌ BAD

Developer manually edits build number randomly.

3. Wrong environment release

❌ BAD

Production app points to UAT API.

4. Disable security for release

❌ BAD

Turn off SSL pinning because build fails.

⸻

========================

🧪 AI GENERATION RULE

========================

AI MUST:

* Create clear Fastlane lanes for Android/iOS
* Separate staging/production lanes
* Use ENV for secrets
* Add precheck lane for lint/test/typecheck
* Include version/build number strategy
* Include changelog/release notes generation
* Verify fintech security config before production
* Avoid printing secrets

AI MUST NOT:

* Hardcode credentials in Fastfile
* Disable SSL pinning/security checks for release
* Mix staging and production config
* Upload to store without version/build validation
* Skip tests silently
* Commit signing secrets
* Create modules/<feature> folder

⸻

========================

📌 SUMMARY

========================

Correct release model:

Precheck → Build → Sign → Package → Distribute → Track

Golden rule:

Fastlane release must be repeatable, secure, environment-aware, and traceable.

This rule is mandatory for all Fastlane release automation.

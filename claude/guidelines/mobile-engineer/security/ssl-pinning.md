========================

🔐 SSL PINNING RULE (MOBILE SECURITY)

========================

🎯 OBJECTIVE

Define SSL Pinning rules for mobile applications to protect API communication against:

* Man-in-the-middle attack
* Rogue CA attack
* Proxy interception
* Fake certificate chain
* Banking/payment data leakage

Applied for:

React Native
Android Native
Android Network Security Config
OkHttp / native SDK
TrustKit iOS
URLSession iOS
iOS / Android native modules

⸻

========================

🧠 CORE PRINCIPLE

========================

SSL Pinning = verify server identity beyond normal TLS validation

Mobile app MUST NOT trust every certificate signed by system CA blindly for sensitive banking APIs.

Golden rule:

For fintech/banking APIs, TLS is required but SSL Pinning adds an extra protection layer.

⸻

========================

📁 STRUCTURE

========================

Recommended structure:

src/security/
ssl-pinning/
ssl-pinning.rule.ts
ssl-pinning.config.ts
ssl-pinning.error.ts
android/app/src/main/res/xml/
network_security_config.xml
ios/
Security/
TrustKitConfig.swift
SSLPinningValidator.swift

If using native module / service wrapper:

src/service/module/security/
device-security.module.ts
device-security.interface.ts

⸻

========================

🔥 WHAT MUST BE PINNED

========================

Pin only sensitive backend domains.

Examples:

api.bank.com
payment.bank.com
auth.bank.com
wallet.bank.com

Do NOT pin random third-party domains unless required and controlled.

Examples usually NOT pinned by app team:

analytics provider
crash reporting provider
remote config provider
public CDN

Rule:

Pin domains that carry authentication, payment, wallet, identity, or transaction data.

⸻

========================

📌 PIN TYPE RULE

========================

Preferred pinning strategy:

Public key pinning / SPKI hash pinning

Avoid pinning full leaf certificate when possible because certificate renewal can break the app.

Recommended:

Pin primary key + backup key

Example concept:

pins:
- current public key hash
- backup public key hash

MUST:

* have at least one backup pin
* prepare rotation plan
* coordinate with backend/infra/security team

MUST NOT:

* hardcode only one leaf cert with no backup
* pin staging cert in production build
* reuse dev pins in production

⸻

========================

🤖 ANDROID RULE

========================

1. Network Security Config

Use Android Network Security Config when applicable.

Path:

android/app/src/main/res/xml/network_security_config.xml

Example:

<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">api.bank.com</domain>
        <pin-set expiration="2027-12-31">
            <pin digest="SHA-256">BASE64_PRIMARY_PIN</pin>
            <pin digest="SHA-256">BASE64_BACKUP_PIN</pin>
        </pin-set>
    </domain-config>
</network-security-config>

AndroidManifest:

<application
android:networkSecurityConfig="@xml/network_security_config"
android:usesCleartextTraffic="false">
</application>

⸻

2. OkHttp CertificatePinner

If using OkHttp directly/native SDK:

val certificatePinner = CertificatePinner.Builder()
.add("api.bank.com", "sha256/BASE64_PRIMARY_PIN")
.add("api.bank.com", "sha256/BASE64_BACKUP_PIN")
.build()
val client = OkHttpClient.Builder()
.certificatePinner(certificatePinner)
.build()

Rules:

* use production pins only in production
* use debug pins only in debug builds
* do not disable pinning in release
* do not allow cleartext traffic in release

⸻

========================

🍏 iOS RULE

========================

1. TrustKit

If using TrustKit, configure pinned domains centrally.

Example concept:

let trustKitConfig: [String: Any] = [
kTSKSwizzleNetworkDelegates: true,
kTSKPinnedDomains: [
"api.bank.com": [
kTSKIncludeSubdomains: true,
kTSKEnforcePinning: true,
kTSKPublicKeyHashes: [
"BASE64_PRIMARY_PIN",
"BASE64_BACKUP_PIN"
]
]
]
]

Rules:

* enforce pinning in production
* include backup pin
* do not pin dev/staging in production config
* ensure native SDK requests are covered if they use separate networking stack

⸻

2. URLSession custom validation

If implementing manually:

URLSessionDelegate
→ serverTrust challenge
→ evaluate trust
→ compare SPKI hash
→ allow/reject

MUST:

* validate normal TLS chain first
* then validate pin
* reject on mismatch
* avoid bypass in release builds

⸻

========================

⚙️ REACT NATIVE RULE

========================

React Native JS code should not own pinning logic directly.

Correct ownership:

Android native networking / network security config
iOS TrustKit / URLSession / native networking layer

React Native can expose safe status/check only when needed:

src/service/module/security/
device-security.module.ts

MUST NOT:

* implement fake pinning only in JS
* bypass native TLS validation
* disable SSL validation in JS HTTP client
* use insecure debug proxy config in release

⸻

========================

🧪 DEBUG / DEV RULE

========================

Debug builds may support proxy/debug CA only with strict separation.

Allowed in debug:

local dev certificate
proxy tool certificate
staging pins

Forbidden in release:

trust all certificates
allow user-installed CA for banking API
disable pinning
allow cleartext traffic

Build separation:

debug     → dev/staging config allowed
release   → production pinning enforced

MUST NOT:

ship debug network config in release build

⸻

========================

🔄 PIN ROTATION RULE

========================

Pin rotation must be planned.

MUST have:

primary pin
backup pin
expiration/rotation calendar
release rollout plan
emergency update plan

Rotation flow:

1. App ships with current + backup pin
2. Backend rotates cert/key to backup-compatible pin
3. App update ships new current + new backup

MUST NOT:

* rotate server key without app containing matching pin
* remove backup pin without replacement
* use expired pin config

⸻

========================

🚨 FAILURE HANDLING RULE

========================

When pinning fails:

MUST:

* block request
* show safe generic error
* log safe event code only
* never expose pin/hash/cert details to user

User message example:

Secure connection failed. Please try again later.

Internal safe error code:

SSL_PINNING_FAILED

MUST NOT:

* fallback to unpinned request
* retry using insecure client
* show certificate details to user
* ask user to install certificate

⸻

========================

🧾 LOGGING RULE

========================

Allowed logs:

SSL_PINNING_FAILED
host
build type
app version
safe error code

Forbidden logs:

access token
refresh token
Authorization header
full certificate dump
private key
OTP/PIN
raw identity data

Rule:

Security logs must be useful but not leak secrets.

⸻

========================

💸 FINTECH SECURITY RULE

========================

For banking/payment APIs:

MUST:

* enforce pinning in release
* pin auth/payment/wallet domains
* block transaction APIs on pin failure
* prevent downgrade to insecure transport
* coordinate pin update with backend certificate lifecycle

MUST NOT:

* allow payment API over cleartext
* allow banking API through untrusted CA in release
* ignore pin failure and continue transaction
* disable pinning to “fix production quickly”

⸻

========================

📦 THIRD-PARTY SDK RULE

========================

Some SDKs use their own networking stack.

MUST verify:

Does SDK use app network stack?
Does SDK support pinning?
Does SDK call sensitive backend?
Does SDK need separate config?

For eKYC/payment SDK:

* confirm SDK TLS/pinning capability
* avoid passing token to SDK unless required
* validate SDK endpoint security

⸻

========================

🧪 TESTING RULE

========================

Must test:

valid certificate → request succeeds
invalid certificate → request blocked
wrong pin → request blocked
expired pin config → reviewed before release
release build → pinning enforced
debug build → debug config only
cleartext HTTP → blocked in release

MITM test:

Proxy with custom CA → banking API must fail in release

Regression test:

Cert rotation with backup pin → app still works

⸻

========================

🚫 ANTI-PATTERNS

========================

1. Trust all certificates

❌ BAD

TrustManager accepts all certificates

⸻

2. Disable pinning in release

❌ BAD

if release issue occurs → turn off SSL pinning

⸻

3. Single pin only

❌ BAD

Only one leaf certificate pin, no backup

⸻

4. Pin mismatch fallback

❌ BAD

Pin failed → retry without pinning

⸻

========================

🧪 AI GENERATION RULE

========================

AI MUST:

* Use platform-native SSL pinning approach
* Add Android Network Security Config or OkHttp CertificatePinner when appropriate
* Add iOS TrustKit or URLSession trust validation when appropriate
* Include primary and backup pins
* Separate debug/staging/release pin config
* Block request on pin failure
* Use safe error code SSL_PINNING_FAILED
* Avoid logging sensitive data

AI MUST NOT:

* Implement SSL pinning only in JavaScript
* Disable TLS validation
* Trust all certificates
* Add release bypass flag
* Use one pin with no backup
* Fallback to insecure request after pin failure
* Put pinning logic in UI component/screen
* Create modules/<feature> folder

⸻

========================

📌 SUMMARY

========================

Correct SSL Pinning ownership:

Android → Network Security Config / OkHttp CertificatePinner
iOS     → TrustKit / URLSession trust validation
RN JS   → does not own TLS validation

Golden rule:

Pin sensitive banking domains, enforce in release, never fallback insecurely.

This rule is mandatory for all SSL Pinning implementation.

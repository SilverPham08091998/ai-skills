# architecture/super-app-architecture.md

## Objective

Define Super App architecture standards for React Native applications that host multiple business domains, mini apps, and shared platform capabilities in one mobile application.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Super App / Mini App architecture
* Modular mobile platforms
* Fintech / Banking apps

Main rule:

> A Super App is a platform, not a collection of screens.
> Mini apps must be isolated, governed, observable, and integrated through stable contracts.

---

# 1. Core Principles

## 1.1 Platform-first Architecture

The host app provides platform capabilities:

* authentication
* navigation shell
* design system
* secure storage
* observability
* feature flags
* network client
* permissions
* release controls

Mini apps provide business capabilities:

* wallet
* payment
* transfer
* bill payment
* rewards
* KYC
* profile

---

## 1.2 Strong Boundaries

Mini apps must not depend on host internals.

Rules:

* Mini apps consume host contracts only.
* Mini apps must not import private host files.
* Host must not depend on mini app internals.

---

## 1.3 Independent Ownership

Each mini app should have:

* owner/team
* public contract
* version
* test scope
* release notes

---

# 2. High-level Structure

```txt
src/
  app/
    AppShell.tsx
    AppBootstrap.ts
    AppNavigator.tsx
  platform/
    auth/
    network/
    storage/
    observability/
    feature-flag/
    security/
    permissions/
  design-system/
  mini-apps/
    wallet/
    payment/
    transfer/
    bill-payment/
    kyc/
  shared/
  di/
```

Rules:

* `app/` owns root app lifecycle.
* `platform/` owns shared runtime capabilities.
* `mini-apps/` owns business domains.
* `design-system/` owns UI primitives and tokens.

---

# 3. App Shell Responsibilities

The App Shell owns:

* app bootstrap
* authentication gate
* root navigation
* global error boundary
* global offline banner
* global feature flag loading
* global observability initialization

Rules:

* App Shell must be thin.
* App Shell wires platform services and mini apps.
* App Shell must not contain business logic for mini apps.

---

# 4. Platform Layer

## 4.1 Platform Services

Common platform services:

```txt
AuthService
HttpClient
SecureStorage
Logger
CrashReporter
FeatureFlagService
NetworkService
PermissionService
AnalyticsService
```

Rules:

* Platform services must be stable.
* Mini apps receive services through contracts/DI.
* Mini apps should not instantiate platform services directly.

---

## 4.2 Platform Contracts

Example:

```ts
export type PlatformServices = {
  authService: AuthService;
  httpClient: HttpClient;
  logger: Logger;
  featureFlagService: FeatureFlagService;
  secureStorage: SecureStorage;
};
```

Rules:

* Contracts must be typed.
* Contracts must avoid leaking implementation details.

---

# 5. Mini App Contract

Each mini app exposes a public contract.

```ts
export type MiniAppDefinition = {
  id: string;
  name: string;
  version: string;
  registerRoutes: (registry: RouteRegistry) => void;
  initialize?: (services: PlatformServices) => Promise<void>;
  dispose?: () => Promise<void>;
};
```

Rules:

* Mini apps must expose only public contract.
* Internal screens, hooks, services must remain private.
* Mini app lifecycle must be explicit.

---

# 6. Navigation Architecture

## 6.1 Route Registration

Mini apps register routes through the host route registry.

```ts
transferMiniApp.registerRoutes(routeRegistry);
```

Rules:

* Host owns root navigation.
* Mini apps own their internal navigation.
* Route names must be typed and namespaced.

Example:

```txt
transfer.input
transfer.confirm
transfer.result
```

---

## 6.2 Navigation Params

Rules:

* Pass only small, serializable params.
* Prefer IDs over large objects.
* Validate route params.

Bad:

```ts
navigation.navigate('transfer.confirm', { fullUserObject });
```

Good:

```ts
navigation.navigate('transfer.confirm', { transactionDraftId });
```

---

# 7. Mini App Internal Architecture

Each mini app should follow Clean Architecture internally.

```txt
mini-apps/transfer/
  index.ts
  presentation/
  application/
  domain/
  infrastructure/
  navigation/
  types/
  __tests__/
```

Rules:

* UI does not call API directly.
* Application layer orchestrates flows.
* Domain layer is framework-independent.
* Infrastructure owns API/storage/native integration.

---

# 8. Dynamic Mini App Loading

If mini apps are loaded dynamically:

Rules:

* Validate bundle integrity.
* Verify version compatibility.
* Handle load failure gracefully.
* Do not execute untrusted code.
* Record load metrics and errors.

Flow:

```txt
fetch manifest
  → validate manifest
  → download bundle
  → verify integrity
  → register mini app
  → render entry point
```

---

# 9. Manifest Design

Mini app manifest may include:

```ts
type MiniAppManifest = {
  id: string;
  version: string;
  bundleUrl: string;
  checksum: string;
  minHostVersion: string;
  permissions: string[];
  routes: string[];
};
```

Rules:

* Manifest must be signed or verified.
* Bundle must match checksum.
* Host must reject incompatible mini apps.

---

# 10. Permission Model

Mini apps must request capabilities explicitly.

Examples:

```txt
network
secureStorage
camera
biometric
location
contacts
```

Rules:

* Mini app gets only required permissions.
* Host mediates sensitive capabilities.
* Mini app must not access native permissions directly without platform approval.

---

# 11. Feature Flag Integration

Mini apps must support feature flags.

Examples:

```txt
transfer.enabled
payment.enabled
kyc.v2.enabled
miniapp.wallet.enabled
```

Rules:

* Host can disable mini app entry point.
* Critical mini apps must have kill switches.
* Feature flags must fail safe.

---

# 12. Security Rules (CRITICAL)

## 12.1 Trust Boundary

A mini app is not fully trusted by default.

Rules:

* Validate all mini app inputs.
* Restrict sensitive APIs through platform services.
* Do not expose tokens directly to mini apps.

---

## 12.2 No Secret Exposure

Mini apps must not receive:

* access token raw value
* refresh token raw value
* private keys
* OTP/PIN

Instead:

* mini apps call platform `HttpClient`
* platform injects auth headers internally

---

## 12.3 Bundle Integrity

For dynamic mini apps:

* verify checksum
* use HTTPS
* prefer signed manifest
* block tampered bundles

---

# 13. Observability

Host must capture:

* mini app loaded
* mini app failed to load
* route opened
* critical flow started/completed/failed
* crash by mini app id/version

Required metadata:

```txt
miniAppId
miniAppVersion
hostVersion
traceId
screen
errorCode
```

Rules:

* Logs must be safe.
* Crashes must include mini app version.
* Metrics must separate host vs mini app issues.

---

# 14. State Management

## 14.1 Host State

Host owns:

* auth session
* app config
* feature flags
* network status
* global user profile summary

## 14.2 Mini App State

Mini app owns:

* feature state
* form state
* feature-specific cache

Rules:

* Do not put all mini app state into global store.
* Avoid cross-mini-app state coupling.
* Communicate through typed events/contracts.

---

# 15. Cross Mini App Communication

Use typed events or platform services.

Example:

```ts
type BeneficiaryAddedEvent = {
  beneficiaryId: string;
};
```

Rules:

* Do not directly call another mini app internal service.
* Events must be meaningful business events.
* Avoid event spaghetti.

---

# 16. Release Strategy

## 16.1 Host App Release

Host app release controls:

* native updates
* platform capability changes
* security changes
* app shell changes

## 16.2 Mini App Release

Mini app release controls:

* feature UI
* business flow JS updates
* mini app-specific fixes

Rules:

* Critical payment/security changes must follow stricter release review.
* Dynamic mini app release must support rollback.
* Host compatibility must be verified before publishing mini app.

---

# 17. Version Compatibility

Mini app must declare compatibility.

```txt
miniAppVersion: 2.1.0
minHostVersion: 1.8.0
```

Rules:

* Host rejects incompatible mini apps.
* Breaking platform contract changes require versioning.
* Keep backward compatibility when possible.

---

# 18. Fintech Rules (CRITICAL)

## 18.1 Money Flow Isolation

Payment, transfer, wallet modules must be isolated.

Rules:

* No shared mutable transaction state.
* Idempotency required for mutation APIs.
* Ambiguous transaction handling must be implemented.
* Backend remains source of truth.

---

## 18.2 Compliance-sensitive Mini Apps

Examples:

* KYC
* payment
* transfer
* authentication

Require:

* stronger review
* security validation
* observability
* rollback plan
* test evidence

---

## 18.3 Platform-owned Security

Host platform owns:

* auth token handling
* secure storage
* certificate pinning
* root/jailbreak policy
* app hardening

Mini apps must consume secure capabilities through platform contracts.

---

# 19. Testing Strategy

Test layers:

* host app shell tests
* platform service tests
* mini app unit tests
* mini app integration tests
* cross-mini-app contract tests
* E2E tests for critical journeys

Rules:

* Mini app should be testable independently.
* Host integration must be tested before release.
* Contract tests prevent breaking platform/mini app integration.

---

# 20. Anti-patterns

* Super App as one giant app with no module boundaries.
* Mini apps importing host internals.
* Host depending on mini app internals.
* No manifest/version compatibility.
* No kill switch per mini app.
* Exposing raw tokens to mini apps.
* Dynamic bundle without integrity verification.
* Shared global store for all mini app state.
* No observability by mini app id/version.

---

# 21. Checklist

* [ ] Host app shell is separated from mini apps.
* [ ] Platform services are centralized.
* [ ] Mini app public contract exists.
* [ ] Mini apps expose routes through registry.
* [ ] No deep imports across boundaries.
* [ ] Feature flags/kill switches exist per mini app.
* [ ] Dynamic bundles are verified if used.
* [ ] Mini app permissions are explicit.
* [ ] Observability includes mini app id/version.
* [ ] Critical fintech flows are isolated and auditable.
* [ ] Contract tests exist.

---

# 22. Final Rule

> A Super App must behave like a secure mobile platform.
> Strong contracts, isolation, observability, and release control are mandatory to keep it scalable and safe.

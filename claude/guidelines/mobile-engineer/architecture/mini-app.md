# architecture/mini-app.md

## Objective

Define standards for building a Mini App within a Super App: clear boundaries, stable public contract, safe integration with platform services, and independent development lifecycle.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Super App / Modular architecture
* Fintech / Banking apps

Main rule:

> A Mini App is a self-contained feature module with a well-defined public contract.
> It must not depend on host or other mini app internals.

---

# 1. Core Principles

## 1.1 Self-contained

A mini app contains everything needed for its feature:

* presentation
* application
* domain
* infrastructure
* navigation
* tests

Rules:

* No deep imports from other modules.
* No reliance on global mutable state.

---

## 1.2 Contract-first

Expose a minimal, stable public API via `index.ts`.

```ts
export type MiniApp = {
  id: string;
  version: string;
  registerRoutes: (r: RouteRegistry) => void;
  init?: (deps: PlatformServices) => Promise<void>;
  dispose?: () => Promise<void>;
};
```

Rules:

* Everything else is private.
* Changes to contract require versioning.

---

## 1.3 Platform-driven

Mini app consumes platform services via DI, not by instantiating them.

Examples:

* HttpClient
* AuthService
* Logger
* FeatureFlagService
* SecureStorage

---

# 2. Structure

```txt
mini-apps/transfer/
  index.ts
  navigation/
  presentation/
  application/
  domain/
  infrastructure/
  types/
  __tests__/
  README.md
```

Rules:

* Follow Clean Architecture internally.
* Keep layers strictly separated.

---

# 3. Navigation Contract

## 3.1 Route Names

Use namespaced routes:

```txt
transfer.input
transfer.confirm
transfer.result
```

## 3.2 Params

```ts
type TransferConfirmParams = {
  draftId: string;
};
```

Rules:

* Pass IDs, not large objects.
* Validate params at entry.

---

# 4. Initialization

```ts
export const transferApp: MiniApp = {
  id: 'transfer',
  version: '1.0.0',
  registerRoutes,
  init: async (deps) => {
    // warmup, prefetch, feature flags
  },
};
```

Rules:

* Keep init fast.
* Fail gracefully.

---

# 5. Dependency Injection

```ts
export type TransferDeps = {
  httpClient: HttpClient;
  logger: Logger;
  featureFlags: FeatureFlagService;
};

export function createTransferModule(deps: TransferDeps) {
  const repo = new TransferRepository(deps.httpClient);
  const useCase = new SubmitTransfer(repo);
  return { useCase };
}
```

Rules:

* No hidden singletons.
* Easy to mock for tests.

---

# 6. Data & Models

* Map API DTO → domain model in `infrastructure`.
* Expose only domain-safe types to upper layers.

Rules:

* Do not leak raw API payloads to UI.

---

# 7. State Management

* Keep state local to mini app.
* Use global state only for cross-cutting concerns (auth, flags, network).

---

# 8. Feature Flags

* Gate entry and risky flows with flags.

```ts
if (!flags.isEnabled('transfer.enabled')) return <Unavailable />;
```

---

# 9. Observability

Log and trace with mini app metadata:

```txt
miniAppId=transfer
miniAppVersion=1.0.0
traceId=...
```

Events:

```txt
MINIAPP_LOADED
ROUTE_OPENED
FLOW_STARTED
FLOW_COMPLETED
FLOW_FAILED
```

Rules:

* No sensitive data in logs.

---

# 10. Security (CRITICAL)

* Do not expose tokens to mini app.
* Use platform HttpClient (auth injected by platform).
* Validate all inputs.

---

# 11. Fintech Rules

## 11.1 Money Flow

* Implement idempotency for mutations.
* Handle ambiguous states with status inquiry.

## 11.2 Offline

* Do not queue final payment/transfer offline.
* Allow drafts only.

---

# 12. Testing

* Unit: domain/application
* Integration: module flow
* Component: key screens
* Contract tests with host

---

# 13. Versioning

```txt
miniAppVersion: 1.0.0
minHostVersion: 1.5.0
```

Rules:

* Host rejects incompatible versions.

---

# 14. Release

* Support remote enable/disable via feature flags.
* Support rollback (disable or revert bundle).

---

# 15. Anti-patterns

* Deep imports across modules
* Using global store for all state
* Exposing internal services
* Logging sensitive data
* Retrying payment with new idempotency key

---

# 16. Checklist

* [ ] Public contract defined
* [ ] No deep imports
* [ ] DI used for services
* [ ] Routes namespaced & typed
* [ ] Feature flags integrated
* [ ] Observability included
* [ ] Security rules enforced
* [ ] Tests exist

---

# 17. Final Rule

> A Mini App is a product inside a platform.
> Keep it isolated, contract-driven, observable, and safe to evolve.

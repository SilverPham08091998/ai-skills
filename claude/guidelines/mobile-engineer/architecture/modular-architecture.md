# architecture/modular-architecture.md

## Objective

Define modular architecture standards for React Native applications to support scalable feature development, Super App structure, mini-app integration, team ownership, and long-term maintainability.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Super App / Mini App architecture
* Feature-based development
* Large engineering teams
* Fintech / Banking apps

Main rule:

> A module must be independently understandable, testable, and maintainable.
> Do not let features leak implementation details into each other.

---

# 1. Core Principles

## 1.1 Feature Ownership

Each module should represent a clear business capability.

Examples:

```txt
auth
transfer
payment
wallet
notification
kyc
profile
```

Rules:

* A module must have a clear owner.
* A module must not depend on another module's internal files.
* Cross-module communication must go through public contracts.

---

## 1.2 Encapsulation

Modules must hide internal implementation.

Bad:

```ts
import { InternalTransferValidator } from '@features/transfer/internal/validator';
```

Good:

```ts
import { TransferModule } from '@features/transfer';
```

Rules:

* Export only public APIs.
* Do not deep import from another module.
* Internal folders must stay private.

---

## 1.3 Independent Evolution

A module should be able to evolve without breaking unrelated modules.

Rules:

* Keep module contracts stable.
* Avoid shared mutable state across modules.
* Avoid circular dependencies.

---

# 2. Recommended Structure

```txt
src/
  modules/
    auth/
      index.ts
      presentation/
      application/
      domain/
      infrastructure/
      navigation/
      types/
      __tests__/
    transfer/
      index.ts
      presentation/
      application/
      domain/
      infrastructure/
      navigation/
      types/
      __tests__/
  shared/
  design-system/
  app/
  di/
```

Rules:

* Each module can follow Clean Architecture internally.
* Shared code must live in `shared/` or `design-system/`.
* App-level wiring belongs in `app/` or `di/`.

---

# 3. Module Layers

Each business module should contain:

```txt
presentation → application → domain → infrastructure
```

## 3.1 Presentation

Contains:

* screens
* components
* hooks
* local UI types

Rules:

* No direct API calls.
* No business rules.
* UI communicates with hooks/use cases.

---

## 3.2 Application

Contains:

* use cases
* commands
* orchestration logic

Rules:

* Coordinates business flow.
* Calls domain services/repositories.
* Handles async flow and transaction-like orchestration.

---

## 3.3 Domain

Contains:

* models
* domain rules
* repository contracts

Rules:

* Framework-independent.
* No React Native dependency.
* No API DTO dependency.

---

## 3.4 Infrastructure

Contains:

* API clients
* repository implementations
* storage
* native integration

Rules:

* External systems stay here.
* Map DTOs to domain models.
* Do not leak raw API responses upward.

---

# 4. Module Public API

Each module must expose a stable public API through `index.ts`.

```ts
export { TransferNavigator } from './navigation/TransferNavigator';
export { createTransferModule } from './TransferModuleFactory';
export type { TransferRouteParams } from './types/TransferRouteParams';
```

Rules:

* Other modules may import only from the module root.
* Internal file imports are forbidden.
* Public API must be intentionally designed.

---

# 5. Dependency Rules

## 5.1 Allowed Dependencies

```txt
module → shared
module → design-system
module → app contracts
```

## 5.2 Restricted Dependencies

```txt
module A → module B internals ❌
module A → module B infrastructure ❌
module A ↔ module B circular dependency ❌
```

Rules:

* Cross-module dependencies must be explicit.
* Prefer contracts/events over direct coupling.

---

# 6. Cross-module Communication

## 6.1 Navigation Contract

Modules may expose route contracts.

```ts
type TransferRouteParams = {
  amount?: number;
  beneficiaryId?: string;
};
```

Rules:

* Route params must be typed.
* Do not pass huge objects through navigation.
* Pass IDs and reload data from source when needed.

---

## 6.2 Domain Events

Use events for loose coupling.

```ts
type UserLoggedInEvent = {
  userId: string;
};
```

Examples:

```txt
auth emits USER_LOGGED_IN
notification refreshes token
profile reloads user info
```

Rules:

* Events must be typed.
* Avoid event spaghetti.
* Use events for meaningful business state changes only.

---

## 6.3 Shared Services

For common capabilities:

```txt
Logger
Analytics
FeatureFlagService
NetworkService
SecureStorage
```

Rules:

* Shared services must be injected.
* Do not instantiate shared services randomly inside modules.

---

# 7. Super App / Mini App Rules

## 7.1 Mini App Boundary

A mini app should be treated as a module with a public contract.

Public contract may include:

* entry screen
* navigation routes
* initialization config
* exposed actions

---

## 7.2 Dynamic Loading

If mini apps are loaded dynamically:

Rules:

* Validate bundle integrity.
* Handle loading failure gracefully.
* Do not allow untrusted code execution.
* Keep host app contracts stable.

---

## 7.3 Host App Responsibilities

Host app owns:

* authentication/session
* global navigation shell
* design system
* observability
* feature flags
* security policy

Mini app owns:

* feature UI
* feature use cases
* feature-specific API integration

---

# 8. State Management Rules

## 8.1 Module-local State

Feature state should stay inside module.

Examples:

* transfer form state
* KYC upload state
* payment flow state

## 8.2 Global State

Only global business/session state should be shared.

Examples:

* authenticated user
* session state
* app config
* feature flags

Rules:

* Do not put every module state into global store.
* Avoid cross-module selectors that depend on internals.

---

# 9. API Ownership

Each module owns its own API integration when it is feature-specific.

```txt
transfer/infrastructure/api/TransferApi.ts
payment/infrastructure/api/PaymentApi.ts
```

Shared API client belongs to:

```txt
shared/network/httpClient.ts
```

Rules:

* HTTP client is shared.
* Endpoint logic is module-owned.
* API DTOs do not leak into UI.

---

# 10. Dependency Injection

Use factories or DI container to wire module dependencies.

```ts
export function createTransferModule(deps: TransferModuleDeps) {
  const repository = new TransferRepository(deps.httpClient);
  const useCase = new SubmitTransferUseCase(repository);

  return {
    useCase,
  };
}
```

Rules:

* Module should receive shared dependencies from outside.
* Avoid hidden singletons.
* Tests should be able to inject mocks.

---

# 11. Testing Strategy

Each module should have:

* unit tests for domain/application logic
* integration tests for module flow
* component tests for important UI
* mock builders for module data

Recommended structure:

```txt
modules/transfer/__tests__/
  unit/
  integration/
  builders/
```

Rules:

* Test module behavior through public API when possible.
* Avoid testing private internals too heavily.

---

# 12. Build & Ownership Rules

## 12.1 Module Ownership

Each module should have:

* owner/team
* README
* public API definition
* dependency list

## 12.2 Review Boundary

Changes to module public API require stricter review.

Rules:

* Public API changes can break other modules.
* Update module documentation when public API changes.

---

# 13. Fintech Rules (CRITICAL)

## 13.1 Critical Flow Isolation

Payment/transfer modules must be isolated and easy to audit.

Rules:

* Keep money movement logic inside its module.
* Do not spread transaction logic across unrelated modules.
* Keep idempotency and ambiguous-state handling explicit.

---

## 13.2 Security Boundary

Security-sensitive modules must not expose raw secrets.

Examples:

* auth
* biometric
* secure storage
* payment

Rules:

* Public APIs must return safe types.
* Sensitive errors must be normalized.
* No sensitive logs inside modules.

---

## 13.3 Compliance-sensitive Modules

Modules such as KYC, payment, and auth require:

* stronger review
* test coverage
* release notes
* rollback plan

---

# 14. Anti-patterns

* One huge `features/` folder with no ownership.
* Deep imports across modules.
* Shared folder becoming a dumping ground.
* Circular dependencies.
* Business logic spread across screens.
* Global store containing all feature states.
* Mini apps depending on host internals.
* Module public API changing without review.

---

# 15. Checklist

* [ ] Each module has clear business responsibility.
* [ ] Each module exposes public API through `index.ts`.
* [ ] No deep imports across modules.
* [ ] No circular dependencies.
* [ ] Shared services are injected.
* [ ] API DTOs do not leak to UI.
* [ ] Module state is local by default.
* [ ] Critical flows are isolated.
* [ ] Module tests exist.
* [ ] Module README exists for large modules.

---

# 16. Final Rule

> Modular architecture is about boundaries.
> Good boundaries let teams move fast without breaking each other.
> Bad boundaries turn every feature into a global side effect.

# react-native/react-native-template.md

## Objective

Define a standard template structure for React Native applications using Clean Architecture, ensuring scalability, maintainability, and consistency across fintech/banking projects.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Clean Architecture projects

Main rule:

> Structure defines scalability.
> A good template prevents bad code from being written.

---

# 1. Core Principles

## 1.1 Separation of Concerns

* UI ≠ Business Logic ≠ Data
* Each layer has a single responsibility

## 1.2 Feature-based Structure

* Organize by feature, not by technical type

## 1.3 Scalable by Default

* Template must support large-scale apps

---

# 2. Root Structure

```txt
src/
  application/
  domain/
  infrastructure/
  presentation/
  shared/
  config/
  di/
```

---

# 3. Layer Definitions

## 3.1 Presentation Layer

```txt
presentation/
  features/
    transfer/
      screen/
      component/
      hook/
      type/
```

Responsibilities:

* UI rendering
* user interaction
* call hooks

Rules:

* No business logic
* No direct API call

---

## 3.2 Application Layer

```txt
application/
  usecase/
  command/
  service/
```

Responsibilities:

* business flow orchestration
* transaction management

Example:

```ts
class TransferUseCase {
  execute(command: TransferCommand) {}
}
```

---

## 3.3 Domain Layer

```txt
domain/
  model/
  repository/
  service/
```

Responsibilities:

* pure business logic
* domain rules

Rules:

* no framework dependency

---

## 3.4 Infrastructure Layer

```txt
infrastructure/
  api/
  repository/
  storage/
  native/
```

Responsibilities:

* API calls
* database/storage
* native modules

---

## 3.5 Shared Layer

```txt
shared/
  utils/
  constants/
  types/
```

---

## 3.6 Config Layer

```txt
config/
  env/
  theme/
```

---

## 3.7 DI Layer

```txt
di/
  container.ts
```

Responsibilities:

* dependency injection
* wiring services

---

# 4. Feature Structure

Example:

```txt
presentation/features/transfer/
  screen/TransferScreen.tsx
  component/TransferForm.tsx
  hook/useTransfer.ts
  type/TransferState.ts
```

---

# 5. Data Flow

```txt
UI → Hook → UseCase → Repository → API
```

Rules:

* UI never calls API directly
* UseCase orchestrates logic

---

# 6. Hook Layer

Hooks act as bridge:

```txt
UI ↔ Hook ↔ Application
```

Responsibilities:

* manage state
* call usecases
* handle side effects

---

# 7. Native Integration

```txt
infrastructure/native/
  biometric/
  device/
```

Rules:

* expose via service
* typed interface required

---

# 8. State Management

Options:

* Redux Toolkit
* Redux Observable
* Context (small apps)

Rules:

* avoid global state overuse
* keep UI state local

---

# 9. Navigation

```txt
presentation/navigation/
```

Rules:

* centralize navigation config
* avoid deep navigation logic in components

---

# 10. API Layer

```txt
infrastructure/api/
  client.ts
  endpoint/
```

Rules:

* centralize API config
* handle error normalization

---

# 11. Error Handling

```txt
shared/types/AppError.ts
```

Rules:

* normalize errors
* avoid throwing raw API errors

---

# 12. Fintech Rules

## 12.1 Critical Flow Isolation

* transfer/payment must be isolated

## 12.2 Idempotency Awareness

* prevent duplicate actions

## 12.3 Security First

* no sensitive logs
* secure storage usage

---

# 13. Anti-patterns

* calling API from UI
* mixing layers
* huge global state
* feature scattered across folders

---

# 14. Checklist

* [ ] clean architecture applied
* [ ] feature-based structure
* [ ] hooks used as bridge
* [ ] no direct API in UI
* [ ] domain isolated

---

# 15. Final Rule

> A good template prevents bad architecture.
> Invest in structure early to scale safely later.

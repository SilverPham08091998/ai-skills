---
name: mobile-dependency-rule
description: Mobile dependency direction rules. Use when wiring React Native modules, services, hooks, stores, and infrastructure dependencies.
---

# Mobile Dependency Rule Guidelines

This skill converts `mobile-engineer/architecture/dependency-rule.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🔗 DEPENDENCY RULE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define strict dependency rules for mobile projects using global layer architecture to ensure:

* Loose coupling
* High cohesion
* Testability
* Scalability
* Fintech-grade safety

Applied structure:

```txt
src/
  presentation/
  component/
  application/
  domain/
  infrastructure/
  common/
  utils/
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

Dependencies must follow **ONE DIRECTION ONLY**:

```txt
OUTER LAYER → INNER LAYER
```

Where:

```txt
presentation/component (outer)
        ↓
application
        ↓
domain (inner, most stable)
```

Infrastructure is a special case (external world adapter):

```txt
application → (abstraction) → infrastructure
infrastructure → (implements) → application contract
```

---

# ========================

# 🔁 DEPENDENCY DIRECTION

# ========================

## Allowed direction

```txt
presentation → application
presentation → component
presentation → common
presentation → utils

component → common
component → utils

application → domain
application → common
application → utils
application → infrastructure (via repository/service interface)

domain → common (only generic types)
domain → utils (pure only)

infrastructure → domain
infrastructure → common
infrastructure → utils

common → utils
```

---

## Forbidden direction

```txt
domain → application ❌
domain → presentation ❌
domain → infrastructure ❌
domain → React / React Native ❌

tpresentation → infrastructure (direct) ❌
component → application ❌
component → infrastructure ❌

utils → any layer ❌
common → application/domain/infrastructure (feature logic) ❌
```

---

# ========================

# 🧱 DEPENDENCY BY LAYER

# ========================

## 1. PRESENTATION

Can depend on:

* application
* component
* common
* utils

Must NOT depend on:

* infrastructure (directly)
* API client
* storage

### ❌ BAD

```ts
// direct API call
apiClient.post('/transfer')
```

### ✅ GOOD

```ts
const { submitTransfer } = useTransfer();
```

---

## 2. COMPONENT

Can depend on:

* common
* utils

Must NOT depend on:

* application
* infrastructure
* API

### ❌ BAD

```ts
import { transferRepository } from '@/infrastructure';
```

---

## 3. APPLICATION

Can depend on:

* domain
* infrastructure (through abstraction)
* common
* utils

Must NOT depend on:

* presentation
* component

### Example (correct abstraction)

```ts
// contract
export interface TransferRepository {
  submit(command: SubmitTransferCommand): Promise<TransferModel>;
}
```

---

## 4. DOMAIN

Can depend on:

* common (generic only)
* utils (pure only)

Must NOT depend on:

* application
* presentation
* infrastructure
* React / Native SDK

### ❌ BAD

```ts
import { apiClient } from '@/infrastructure';
```

---

## 5. INFRASTRUCTURE

Can depend on:

* domain
* common
* utils

Must NOT depend on:

* presentation
* component

### Example

```ts
export class TransferRepositoryImpl implements TransferRepository {
  async submit(command: SubmitTransferCommand) {
    const res = await apiClient.post('/transfer', command);
    return mapTransfer(res.data);
  }
}
```

---

## 6. COMMON

Can depend on:

* utils

Must NOT depend on:

* feature logic
* application
* infrastructure

---

## 7. UTILS

Must be:

* pure
* dependency-free

Must NOT depend on:

* any layer

---

# ========================

# 🔌 DEPENDENCY INJECTION RULE

# ========================

Application should NOT instantiate infrastructure directly.

### ❌ BAD

```ts
const repo = new TransferRepositoryImpl();
```

### ✅ GOOD

```ts
export const submitTransferUseCase = (
  repo: TransferRepository
) => async (command: SubmitTransferCommand) => {
  return repo.submit(command);
};
```

Injection can be done at:

* bootstrap layer
* service locator
* simple singleton (controlled)

---

# ========================

# 🔄 MAPPING RULE

# ========================

Mapping must happen at boundaries:

```txt
API response → infrastructure mapper → domain model → application → UI
```

### ❌ BAD

```ts
// passing raw response to UI
setState(response.data)
```

### ✅ GOOD

```ts
const model = mapTransfer(response.data);
setState(model);
```

---

# ========================

# 💸 FINTECH DEPENDENCY RULE

# ========================

Money flow MUST follow strict layering:

```txt
presentation → application → domain → infrastructure
```

Example:

```txt
TransferScreen
  → useTransfer
  → submitTransferUseCase
  → validateTransferAmount
  → transferRepository.submit
```

MUST:

* Use idempotency at application layer
* Validate at domain layer
* Execute via infrastructure

MUST NOT:

* Skip domain validation
* Call API directly from UI
* Return raw API response to UI

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Respect dependency direction strictly
* Use interface/contract between application and infrastructure
* Keep domain isolated
* Keep UI clean

AI MUST NOT:

* Break dependency direction
* Import infrastructure into domain
* Import API client into presentation/component
* Create circular dependency

---

# ========================

# 📌 SUMMARY

# ========================

Golden rule:

```txt
OUTER → INNER ONLY
```

And:

```txt
UI never talks to API directly
Domain never talks to outside world
Infrastructure hides external complexity
```

This rule is mandatory for all mobile code generation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

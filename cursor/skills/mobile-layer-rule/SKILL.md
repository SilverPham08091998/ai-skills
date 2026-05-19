---
name: mobile-layer-rule
description: Mobile layer rules for React Native apps. Use when separating presentation, application, domain, and infrastructure responsibilities.
---

# Mobile Layer Rule Guidelines

This Cursor skill adapts `mobile-engineer/architecture/layer-rule.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🧱 LAYER RULE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define strict layer rules for mobile projects using global layer architecture.

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

This rule applies to:

* React Native
* iOS Swift
* Android Kotlin / Java

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

Each layer has ONE clear responsibility.

A layer MUST NOT steal responsibility from another layer.

Rule:

```txt
UI renders.
Application orchestrates.
Domain decides.
Infrastructure connects.
Common shares.
Utils helps.
```

---

# ========================

# 🔁 ALLOWED FLOW

# ========================

Standard flow:

```txt
presentation / component
        ↓
application
        ↓
domain
        ↓
infrastructure
```

Practical flow:

```txt
Screen → Hook/ViewModel → UseCase → Domain Rule → Repository/API
```

---

# ========================

# 1. PRESENTATION LAYER

# ========================

Path:

```txt
src/presentation
```

Responsibilities:

* Screen-level UI
* Page composition
* Navigation trigger
* Bind UI state from application
* Render loading / empty / success / error state

Allowed to use:

* application hooks / view models
* component
* common types/constants
* utils formatting helpers

MUST NOT:

* Call API directly
* Access storage directly
* Contain business rules
* Contain money calculation logic
* Import infrastructure directly

Example:

```tsx
const TransferScreen = () => {
  const { state, submitTransfer } = useTransfer();

  return (
    <TransferView
      state={state}
      onSubmit={submitTransfer}
    />
  );
};
```

---

# ========================

# 2. COMPONENT LAYER

# ========================

Path:

```txt
src/component
```

Responsibilities:

* Reusable UI components
* Design system components
* Shared widgets

Allowed to use:

* common
* utils
* assets

MUST NOT:

* Call API
* Access application use case directly
* Access infrastructure
* Know backend response shape
* Own fintech business flow

Good examples:

```txt
PrimaryButton
AmountInput
OtpInput
PinInput
TransactionStatusBadge
```

Rule:

```txt
component receives data via props and emits actions via callbacks.
```

---

# ========================

# 3. APPLICATION LAYER

# ========================

Path:

```txt
src/application
```

Responsibilities:

* Use cases
* Hooks / ViewModels
* App flow orchestration
* UI state orchestration
* Command creation
* Transaction step orchestration

Allowed to use:

* domain
* infrastructure repository / gateway abstraction
* common
* utils

MUST NOT:

* Render UI
* Import React Native UI components
* Contain raw API response as UI state
* Contain low-level HTTP logic
* Contain native SDK implementation details

Example:

```ts
export const submitTransferUseCase = async (
  command: SubmitTransferCommand,
) => {
  validateTransferAmount(command.amount);
  return transferRepository.submit(command);
};
```

---

# ========================

# 4. DOMAIN LAYER

# ========================

Path:

```txt
src/domain
```

Responsibilities:

* Business models
* Business rules
* Domain validation
* Domain errors
* Domain enums / status
* Pure business logic

Allowed to use:

* common types only when generic
* utils only if pure and framework-free

MUST NOT:

* Import React
* Import React Native
* Import Redux
* Import API client
* Import storage
* Import infrastructure
* Access device API

Example:

```ts
export const validateAmount = (amount: number) => {
  if (amount <= 0) {
    throw new Error('Amount must be greater than zero');
  }
};
```

Rule:

```txt
domain must be testable without device, network, storage, or UI.
```

---

# ========================

# 5. INFRASTRUCTURE LAYER

# ========================

Path:

```txt
src/infrastructure
```

Responsibilities:

* API client
* Repository implementation
* Data source
* Secure storage
* Local storage
* Native SDK integration
* React Native bridge integration
* External services

Allowed to use:

* common
* utils
* domain model for mapping target
* application command when required by use case boundary

MUST NOT:

* Render UI
* Own business policy
* Decide transaction success by UI assumption
* Expose raw API response directly to presentation

Example:

```ts
export class TransferRepository {
  async submit(command: SubmitTransferCommand): Promise<TransferModel> {
    const response = await apiClient.post('/transfers', command);
    return mapTransferResponseToModel(response.data);
  }
}
```

---

# ========================

# 6. COMMON LAYER

# ========================

Path:

```txt
src/common
```

Responsibilities:

* Shared constants
* Shared types
* Shared error shape
* Logger abstraction
* Result wrapper
* Base response type

Allowed to use:

* utils when needed

MUST NOT:

* Become dumping ground
* Contain feature business logic
* Contain API implementation
* Contain UI implementation

Good examples:

```txt
common/constants
common/types
common/errors
common/logger
common/result
```

---

# ========================

# 7. UTILS LAYER

# ========================

Path:

```txt
src/utils
```

Responsibilities:

* Pure helper functions
* Formatting
* Date helper
* Currency helper
* Masking helper
* ID generation helper

MUST:

* Be pure
* Be small
* Be reusable
* Avoid side effects

MUST NOT:

* Call API
* Access store
* Access storage
* Access navigation
* Depend on feature flow

Example:

```ts
export const formatCurrency = (amount: number, currency = 'VND') => {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency,
  }).format(amount);
};
```

---

# ========================

# 🚫 IMPORT RULE

# ========================

## Allowed imports

```txt
presentation → application, component, common, utils
component    → common, utils, assets
application  → domain, infrastructure, common, utils
domain       → common, utils
infrastructure → domain, common, utils
common       → utils
utils        → no app layer dependency
```

## Forbidden imports

```txt
domain → presentation
domain → application
domain → infrastructure
domain → React Native
component → infrastructure
component → API client
presentation → API client
presentation → storage
utils → application/domain/infrastructure/presentation
```

---

# ========================

# 💸 FINTECH LAYER RULE

# ========================

For money-related features:

```txt
presentation  → show form/result only
application   → orchestrate transaction flow
domain        → validate business rule
infrastructure → call backend / native SDK / secure storage
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

* Generate requestId / idempotency key in application or utility called by application
* Validate amount in domain
* Submit through infrastructure repository
* Display final backend-confirmed state in presentation

MUST NOT:

* Generate transaction success in UI
* Calculate business fee in component
* Store OTP/PIN in presentation state longer than needed
* Log token, OTP, PIN, or Soft OTP secret

---

# ========================

# 🍏 iOS SWIFT LAYER MAPPING

# ========================

```txt
Presentation  → View / ViewController / SwiftUI View
Application   → ViewModel / UseCase
Domain        → Model / Rule / Error / Enum
Infrastructure → API Service / Repository / Keychain / Native SDK
Common        → Shared types / constants
Utils         → Pure helper
```

Rules:

* ViewController must not call API directly
* ViewModel owns UI state
* Keychain belongs to infrastructure
* Business validation belongs to domain

---

# ========================

# 🤖 ANDROID LAYER MAPPING

# ========================

```txt
Presentation  → Activity / Fragment / Compose Screen
Application   → ViewModel / UseCase
Domain        → Model / Rule / Error / Enum
Infrastructure → Repository / DataSource / Retrofit / Keystore / SDK
Common        → Shared types / constants
Utils         → Pure helper
```

Rules:

* Activity / Fragment must not call Retrofit directly
* ViewModel owns state
* Keystore belongs to infrastructure
* Business validation belongs to domain

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Place files in the correct layer
* Respect import direction
* Keep UI clean
* Keep domain pure
* Keep infrastructure responsible for external systems
* Use application layer for business flow orchestration

AI MUST NOT:

* Create `modules/<feature>` folder
* Put everything in one file
* Put API call in screen/component
* Put business rule in UI
* Put storage/native SDK logic in domain/application
* Mix React Native, Swift, and Android code in the same file

---

# ========================

# 📌 SUMMARY

# ========================

Layer rule summary:

```txt
presentation = screen UI
component = reusable UI
application = flow/usecase/state
domain = business rule/model
infrastructure = API/storage/native SDK
common = shared base
utils = pure helpers
```

This rule is mandatory for all mobile code generation.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

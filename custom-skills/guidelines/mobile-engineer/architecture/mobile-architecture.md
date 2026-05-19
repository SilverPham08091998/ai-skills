# ========================

# 🧱 MOBILE ARCHITECTURE (GLOBAL LAYER STRUCTURE)

# ========================

## 🎯 OBJECTIVE

Define a production-grade mobile architecture for:

* React Native
* iOS (Swift)
* Android (Kotlin / Java)

This architecture follows a **global layer structure**, NOT feature/module-based folder structure.

The project must be organized by technical responsibility:

```txt
./application
./domain
./infrastructure
./component
./presentation
./common
./utils
```

Focused on:

* Scalability
* Maintainability
* Fintech-grade reliability
* Clear separation of responsibility

---

# ========================

# 🧠 ARCHITECTURE OVERVIEW

# ========================

Mobile app MUST follow layered architecture:

```txt
presentation / component
        ↓
application
        ↓
domain
        ↓
infrastructure
```

Supporting layers:

```txt
common
utils
```

Rule:

```txt
UI must depend on application.
Application may depend on domain.
Infrastructure implements external communication.
Domain must stay clean and independent.
```

---

# ========================

# 📁 ROOT STRUCTURE

# ========================

Recommended root structure:

```txt
src/
  application/
  domain/
  infrastructure/
  component/
  presentation/
  common/
  utils/
  navigation/
  assets/
  config/
```

Meaning:

```txt
application     → app flow, use cases, hooks, state orchestration
domain          → business models, business rules, pure logic
infrastructure  → API, storage, native SDK, external integration
component       → reusable UI components
presentation    → screens, views, feature UI composition
common          → shared constants, types, base classes, shared helpers
utils           → pure utility functions
navigation      → app navigation config
assets          → images, fonts, icons
config          → env config, app config
```

---

# ========================

# 📦 LAYER RESPONSIBILITY

# ========================

## 1. PRESENTATION LAYER

Path:

```txt
./presentation
```

Responsibilities:

* Screen composition
* Page-level UI
* Connect screen with application hook / view model
* Handle navigation events
* Display loading / success / error state

MUST:

* Use application hook / use case / state
* Delegate reusable UI to `component`
* Keep screen readable

MUST NOT:

* Call API directly
* Access storage directly
* Contain complex business logic
* Contain money calculation logic

Example:

```tsx
const TransferScreen = () => {
  const {
    amount,
    setAmount,
    isSubmitting,
    submitTransfer,
  } = useTransfer();

  return (
    <TransferView
      amount={amount}
      onAmountChange={setAmount}
      isSubmitting={isSubmitting}
      onSubmit={submitTransfer}
    />
  );
};
```

---

## 2. COMPONENT LAYER

Path:

```txt
./component
```

Responsibilities:

* Reusable UI components
* Design system components
* Shared visual blocks

Examples:

```txt
component/
  button/
  input/
  modal/
  card/
  list-item/
  amount-input/
  pin-input/
  otp-input/
```

MUST:

* Be reusable
* Be mostly stateless
* Receive data via props
* Emit actions via callbacks

MUST NOT:

* Call API
* Access Redux/store directly unless it is a global UI component with clear reason
* Know fintech business flow
* Know backend response shape

Example:

```tsx
type PrimaryButtonProps = {
  title: string;
  loading?: boolean;
  disabled?: boolean;
  onPress: () => void;
};

export const PrimaryButton = ({
  title,
  loading,
  disabled,
  onPress,
}: PrimaryButtonProps) => {
  return (
    <Button
      title={title}
      disabled={disabled || loading}
      onPress={onPress}
    />
  );
};
```

---

## 3. APPLICATION LAYER

Path:

```txt
./application
```

Responsibilities:

* App use cases
* Screen hooks
* View models
* State orchestration
* Transaction flow orchestration
* Mapping UI input into use case command

Examples:

```txt
application/
  transfer/
    use-transfer.ts
    submit-transfer.usecase.ts
    submit-transfer.command.ts
    transfer.state.ts
  auth/
    use-login.ts
    login.usecase.ts
    login.command.ts
```

MUST:

* Manage business flow
* Handle loading / success / error state
* Create requestId / idempotency key when needed
* Call domain service / infrastructure repository through abstraction
* Coordinate validation before execution

MUST NOT:

* Render UI
* Know native UI implementation details
* Directly depend on concrete UI component
* Put reusable pure business rule here if it belongs to domain

Example:

```ts
export type SubmitTransferCommand = {
  requestId: string;
  fromAccountId: string;
  toAccountNo: string;
  amount: number;
  description?: string;
};

export const submitTransferUseCase = async (
  command: SubmitTransferCommand,
) => {
  validateTransferAmount(command.amount);
  return transferRepository.submitTransfer(command);
};
```

---

## 4. DOMAIN LAYER

Path:

```txt
./domain
```

Responsibilities:

* Business models
* Business rules
* Pure validation
* Domain constants / enums
* Domain errors

Examples:

```txt
domain/
  transaction/
    transaction.model.ts
    transaction-status.ts
    transaction-rule.ts
  transfer/
    transfer.model.ts
    transfer-rule.ts
    transfer-error.ts
```

MUST:

* Be pure TypeScript / Swift / Kotlin logic
* Have no UI dependency
* Have no API dependency
* Have no storage dependency
* Be easy to unit test

MUST NOT:

* Import React / React Native
* Import API client
* Import AsyncStorage / Keychain / Keystore
* Depend on infrastructure

Example:

```ts
export const validateTransferAmount = (amount: number) => {
  if (amount <= 0) {
    throw new Error('Transfer amount must be greater than zero');
  }
};
```

---

## 5. INFRASTRUCTURE LAYER

Path:

```txt
./infrastructure
```

Responsibilities:

* API client
* HTTP services
* Repository implementation
* Secure storage
* Local cache
* Native SDK integration
* React Native bridge integration
* External providers

Examples:

```txt
infrastructure/
  api/
    api-client.ts
    api-error.mapper.ts
  repository/
    transfer.repository.ts
    auth.repository.ts
  storage/
    secure-storage.ts
    token-storage.ts
  native/
    biometric-native.ts
    ekyc-native.ts
    pdf-signature-native.ts
```

MUST:

* Own external communication
* Map raw API response to domain/application model
* Handle low-level network errors
* Hide SDK implementation details from application

MUST NOT:

* Render UI
* Put business policy here
* Expose raw backend response directly to presentation

Example:

```ts
class TransferRepository {
  async submitTransfer(command: SubmitTransferCommand) {
    const response = await apiClient.post('/transfers', command);
    return mapTransferResponse(response.data);
  }
}

export const transferRepository = new TransferRepository();
```

---

## 6. COMMON LAYER

Path:

```txt
./common
```

Responsibilities:

* Shared constants
* Shared types
* Base response shape
* Common errors
* App-wide helpers that are not domain-specific

Examples:

```txt
common/
  constants/
  types/
  errors/
  logger/
  result/
```

MUST:

* Be generic
* Be reusable across layers
* Avoid feature-specific logic

MUST NOT:

* Become a dumping ground
* Contain hidden business logic
* Contain API-specific implementation details

---

## 7. UTILS LAYER

Path:

```txt
./utils
```

Responsibilities:

* Pure helper functions
* Formatting
* Date helpers
* Currency helpers
* String helpers
* Validation helpers when generic

Examples:

```txt
utils/
  format-currency.ts
  format-date.ts
  mask-phone-number.ts
  generate-request-id.ts
```

MUST:

* Be pure
* Be small
* Be reusable

MUST NOT:

* Call API
* Access global state
* Access storage
* Contain feature business flow

Example:

```ts
export const maskPhoneNumber = (phone: string) => {
  if (phone.length < 5) return phone;
  return `${phone.slice(0, 3)}*****${phone.slice(-2)}`;
};
```

---

# ========================

# 🔁 STANDARD DATA FLOW

# ========================

## Request Flow

```txt
presentation screen
  → application hook / view model
  → application use case
  → domain validation / rule
  → infrastructure repository
  → infrastructure api client
  → backend
```

## Response Flow

```txt
backend
  → infrastructure api client
  → infrastructure mapper
  → application state
  → presentation screen
```

Rule:

```txt
Raw API response must not leak directly to UI.
```

---

# ========================

# 💸 FINTECH MONEY FLOW RULE

# ========================

Every money-related action MUST follow this flow:

```txt
Validate Input
  → Create RequestId / Idempotency Key
  → Submit Request
  → Handle Pending / Processing
  → Confirm Final State
  → Display Result
```

Examples:

* Transfer money
* Bill payment
* Wallet top up
* Cash out
* QR payment
* NFC payment
* Soft OTP confirmation

MUST:

* Prevent duplicate submit
* Disable button while submitting
* Use requestId / idempotency key
* Handle timeout safely
* Handle pending transaction state
* Never assume success from client-side only

MUST NOT:

* Show success before backend confirms
* Retry blindly without idempotency
* Allow user to spam action button
* Store sensitive transaction data in plain text

---

# ========================

# ⚙️ REACT NATIVE ARCHITECTURE RULE

# ========================

Preferred flow:

```txt
Screen → Hook → UseCase → Repository → API Client
```

Example mapping:

```txt
presentation/transfer/transfer.screen.tsx
application/transfer/use-transfer.ts
application/transfer/submit-transfer.usecase.ts
domain/transfer/transfer-rule.ts
infrastructure/repository/transfer.repository.ts
infrastructure/api/api-client.ts
```

---

# ========================

# 🍏 iOS SWIFT ARCHITECTURE RULE

# ========================

Preferred flow:

```txt
View / ViewController
  → ViewModel
  → UseCase
  → Repository / Service
  → API / Keychain / Native SDK
```

Rules:

* ViewController must stay small
* ViewModel owns state
* Repository owns data access
* Service owns external SDK/API integration
* Keychain access belongs to infrastructure

---

# ========================

# 🤖 ANDROID ARCHITECTURE RULE

# ========================

Preferred flow:

```txt
Activity / Fragment / Compose Screen
  → ViewModel
  → UseCase
  → Repository
  → DataSource / API / Keystore / Native SDK
```

Rules:

* UI observes state only
* ViewModel exposes state
* Repository abstracts data source
* DataSource handles API / local / SDK details
* Keystore access belongs to infrastructure

---

# ========================

# 🚫 DEPENDENCY RULE

# ========================

Allowed dependency direction:

```txt
presentation → application → domain
application → infrastructure abstraction
infrastructure → external systems
component → common / utils only
```

Strict rules:

* `domain` must not import `presentation`
* `domain` must not import `infrastructure`
* `component` must not import API service
* `presentation` must not call API directly
* `utils` must not depend on app state
* `common` must not become business logic dumping ground

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

When AI generates mobile code, AI MUST follow this structure:

```txt
application/
domain/
infrastructure/
component/
presentation/
common/
utils/
```

AI MUST:

* Put screen/page UI in `presentation`
* Put reusable UI in `component`
* Put hook / use case / state flow in `application`
* Put pure model / validation / business rule in `domain`
* Put API / storage / native SDK logic in `infrastructure`
* Put shared constants/types in `common`
* Put pure helpers in `utils`

AI MUST NOT:

* Create `modules/<feature>` folder unless explicitly requested
* Call API directly from screen/component
* Put business logic in UI
* Put UI component in application/domain/infrastructure
* Put API response shape directly into UI
* Mix React Native, Swift, Android native responsibilities randomly

---

# ========================

# 📌 FINAL SUMMARY

# ========================

This project uses **global layer architecture**:

```txt
application
component
domain
infrastructure
presentation
common
utils
```

Good architecture means:

* Clear responsibility
* Easy to scale
* Easy to test
* Safe for fintech / banking
* No hidden business logic
* No direct API call from UI

This rule is mandatory for all mobile code generation.

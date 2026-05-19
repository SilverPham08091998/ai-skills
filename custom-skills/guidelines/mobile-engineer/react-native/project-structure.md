# ========================

# 📁 REACT NATIVE PROJECT STRUCTURE

# ========================

## 🎯 OBJECTIVE

Define the standard React Native project structure for a mobile app using **global layer architecture**.

This project DOES NOT use feature module folder like:

```txt
modules/<feature>/...
```

Instead, the project is organized by global layers:

```txt
application/
domain/
infrastructure/
component/
presentation/
common/
utils/
```

---

# ========================

# 🧱 ROOT STRUCTURE

# ========================

Recommended structure:

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
  theme/
  localization/
```

Meaning:

```txt
application    → hooks, use cases, app state, business flow orchestration
domain         → models, business rules, domain errors, domain enums
infrastructure → API, repositories, storage, native bridge, external SDK
component      → reusable UI components / design system
presentation   → screens, views, page composition
common         → shared constants, types, logger, result wrapper
utils          → pure helpers
aavigation     → navigation config, route names, route types
assets         → images, icons, fonts, animations
config         → environment config, app config
theme          → colors, spacing, typography
localization   → i18n resources
```

---

# ========================

# 📦 FULL EXAMPLE TREE

# ========================

```txt
src/
  application/
    auth/
      use-login.ts
      login.usecase.ts
      login.command.ts
      auth.state.ts
    transfer/
      use-transfer.ts
      submit-transfer.usecase.ts
      submit-transfer.command.ts
      transfer.state.ts
    transaction/
      use-transaction-detail.ts
      get-transaction-detail.usecase.ts

  domain/
    auth/
      auth.model.ts
      auth-rule.ts
      auth-error.ts
    transfer/
      transfer.model.ts
      transfer-rule.ts
      transfer-error.ts
    transaction/
      transaction.model.ts
      transaction-status.ts
      transaction-rule.ts

  infrastructure/
    api/
      api-client.ts
      api-config.ts
      api-error.mapper.ts
      api-interceptor.ts
    auth/
      auth.api.ts
      auth.repository.ts
      auth.mapper.ts
    transfer/
      transfer.api.ts
      transfer.repository.ts
      transfer.mapper.ts
    transaction/
      transaction.api.ts
      transaction.repository.ts
      transaction.mapper.ts
    storage/
      secure-storage.ts
      token-storage.ts
    native/
      biometric-native.ts
      ekyc-native.ts
      pdf-signature-native.ts

  component/
    button/
      primary-button.tsx
      secondary-button.tsx
    input/
      text-input.tsx
      amount-input.tsx
      otp-input.tsx
      pin-input.tsx
    modal/
      confirm-modal.tsx
      error-modal.tsx
    card/
      transaction-card.tsx
    list-item/
      transaction-list-item.tsx

  presentation/
    auth/
      login.screen.tsx
      login.view.tsx
      login.style.ts
    transfer/
      transfer-input.screen.tsx
      transfer-confirm.screen.tsx
      transfer-result.screen.tsx
      transfer.view.tsx
      transfer.style.ts
    transaction/
      transaction-detail.screen.tsx
      transaction-history.screen.tsx

  navigation/
    app-navigation.tsx
    root-navigator.tsx
    auth-navigator.tsx
    main-navigator.tsx
    route-name.ts
    navigation-type.ts
    navigation-service.ts

  common/
    constants/
      app.constant.ts
      error-code.constant.ts
    types/
      base-response.type.ts
      result.type.ts
    errors/
      app-error.ts
    logger/
      logger.ts

  utils/
    format-currency.ts
    format-date.ts
    mask-phone-number.ts
    generate-request-id.ts
    validate-email.ts

  theme/
    colors.ts
    spacing.ts
    typography.ts
    radius.ts

  localization/
    i18n.ts
    vi.json
    en.json

  assets/
    images/
    icons/
    fonts/
    animations/

  config/
    env.ts
    app-config.ts
```

---

# ========================

# 🔥 STRUCTURE RULES

# ========================

## 1. DO NOT CREATE MODULES FOLDER

### ❌ BAD

```txt
src/modules/transfer/
  presentation/
  application/
  domain/
  infrastructure/
```

### ✅ GOOD

```txt
src/application/transfer/
src/domain/transfer/
src/infrastructure/transfer/
src/presentation/transfer/
```

---

## 2. FEATURE MUST BE SPLIT BY LAYER

Example: Transfer feature

```txt
application/transfer     → transfer flow / use case / hook
domain/transfer          → transfer model / rule / error
infrastructure/transfer  → transfer api / repository / mapper
presentation/transfer    → transfer screens / views
component                → reusable transfer UI only if generic enough
```

---

## 3. SHARED COMPONENTS GO TO COMPONENT

Use `component` for reusable UI.

Examples:

```txt
PrimaryButton
AmountInput
OtpInput
PinInput
TransactionCard
```

Do NOT put reusable UI inside presentation feature folder unless it is screen-specific.

---

## 4. SCREEN-SPECIFIC UI CAN STAY IN PRESENTATION

Example:

```txt
presentation/transfer/
  transfer.view.tsx
  transfer-result-summary.tsx
```

Rule:

```txt
If UI is reused across features → component
If UI is used only by one screen/flow → presentation
```

---

# ========================

# 🧠 FILE NAMING RULE

# ========================

Use kebab-case file names.

```txt
login.screen.tsx
login.view.tsx
use-login.ts
login.usecase.ts
login.command.ts
auth.repository.ts
auth.mapper.ts
auth.model.ts
```

Use PascalCase for React components.

```tsx
export const LoginScreen = () => {};
export const PrimaryButton = () => {};
```

Use camelCase for functions and variables.

```ts
const submitTransfer = async () => {};
const transactionList = [];
```

---

# ========================

# 📄 FILE RESPONSIBILITY

# ========================

## screen.tsx

Responsibility:

* Screen container
* Connect to application hook
* Handle navigation trigger

MUST NOT:

* Call API directly
* Contain heavy UI details
* Contain business logic

---

## view.tsx

Responsibility:

* Render UI
* Receive props from screen
* Emit events through callbacks

MUST NOT:

* Call API
* Access repository
* Own transaction flow

---

## hook.ts / use-*.ts

Responsibility:

* Manage screen logic
* Call use case
* Manage loading / error / success state
* Return UI-friendly state

---

## usecase.ts

Responsibility:

* Execute business flow
* Validate domain rule
* Call repository
* Return result

---

## command.ts

Responsibility:

* Input object for use case
* Contains data from screen/form/navigation params

Example:

```ts
export type SubmitTransferCommand = {
  requestId: string;
  fromAccountId: string;
  toAccountNo: string;
  amount: number;
  description?: string;
};
```

---

## model.ts

Responsibility:

* Domain model
* Stable business object
* Not raw API response

---

## repository.ts

Responsibility:

* Abstract data access
* Call API / storage / SDK
* Return mapped model

---

## mapper.ts

Responsibility:

* Convert API response to domain/application model
* Convert command to API request if needed

---

# ========================

# 🔁 STANDARD FEATURE FLOW

# ========================

Example: Transfer

```txt
presentation/transfer/transfer-input.screen.tsx
  → application/transfer/use-transfer.ts
  → application/transfer/submit-transfer.usecase.ts
  → domain/transfer/transfer-rule.ts
  → infrastructure/transfer/transfer.repository.ts
  → infrastructure/transfer/transfer.api.ts
  → infrastructure/api/api-client.ts
```

Response:

```txt
api response
  → transfer.mapper.ts
  → transfer.model.ts
  → transfer.state.ts
  → transfer.view.tsx
```

---

# ========================

# 🔐 FINTECH STRUCTURE RULE

# ========================

For money-related features, minimum required files:

```txt
application/<feature>/
  use-<feature>.ts
  <action>.usecase.ts
  <action>.command.ts
  <feature>.state.ts

domain/<feature>/
  <feature>.model.ts
  <feature>-rule.ts
  <feature>-error.ts

infrastructure/<feature>/
  <feature>.api.ts
  <feature>.repository.ts
  <feature>.mapper.ts

presentation/<feature>/
  <feature>.screen.tsx
  <feature>.view.tsx
  <feature>.style.ts
```

MUST support:

* loading state
* error state
* success state
* requestId / idempotency key
* safe retry
* backend-confirmed result

---

# ========================

# 🚫 ANTI-PATTERNS

# ========================

## 1. API call in screen

### ❌ BAD

```tsx
const TransferScreen = () => {
  const submit = async () => {
    await apiClient.post('/transfer');
  };
};
```

---

## 2. Raw API response in UI

### ❌ BAD

```ts
setTransaction(response.data);
```

---

## 3. Business rule in component

### ❌ BAD

```tsx
if (amount > dailyLimit) {
  showError();
}
```

---

## 4. Common becomes trash folder

### ❌ BAD

```txt
common/transfer-helper.ts
common/login-flow.ts
common/payment-business-rule.ts
```

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Follow global layer structure
* Create feature folder inside each layer when needed
* Use kebab-case file naming
* Use typed command/model/state
* Put screens in `presentation`
* Put reusable UI in `component`
* Put use cases and hooks in `application`
* Put business rules in `domain`
* Put API/repository/mapper in `infrastructure`
* Put generic shared code in `common`
* Put pure helpers in `utils`

AI MUST NOT:

* Create `modules/<feature>`
* Put all feature files in one folder
* Call API from screen/component
* Put raw API response into UI
* Put business rules in component
* Put feature-specific logic into common
* Create duplicate files with same responsibility

---

# ========================

# 📌 SUMMARY

# ========================

React Native project structure:

```txt
src/application
src/domain
src/infrastructure
src/component
src/presentation
src/common
src/utils
```

Feature code is organized across global layers, not inside module folders.

This rule is mandatory for all React Native code generation.

---
name: react-native-component-rule
description: React Native component rules. Use when writing reusable components, screen components, props, styling, and rendering logic.
---

# React Native Component Rule Guidelines

This Codex skill adapts `mobile-engineer/react-native/component-rule.md` into Codex skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🧩 COMPONENT RULE (MOBILE)

# ========================

## 🎯 OBJECTIVE

Define strict rules for reusable UI components to ensure:

* Reusability
* Consistency (Design System)
* Testability
* Zero business logic leakage

Applied for:

* React Native (TypeScript)
* iOS (SwiftUI / UIKit views)
* Android (Compose / XML views)

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
Component = Pure UI
```

* Receives data via **props/inputs**
* Emits events via **callbacks/outputs**
* Contains **NO business logic**

---

# ========================

# 📁 STRUCTURE

# ========================

Path:

```txt
src/component/
```

Recommended structure:

```txt
component/
  button/
    primary-button.tsx
    secondary-button.tsx
    index.ts
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
```

Rule:

```txt
Group by UI type, not by feature.
```

---

# ========================

# 🔥 DO & DON'T

# ========================

## MUST

* Be reusable across features
* Be mostly stateless
* Receive all data via props
* Expose clear callbacks
* Follow design system (theme, spacing, typography)

## MUST NOT

* Call API
* Import repository / service
* Import application hooks
* Contain business rules (e.g., transfer limits, fees)
* Depend on navigation directly (except via callback)
* Know backend response shape

---

# ========================

# 🧾 PROPS CONTRACT

# ========================

Props must be **explicit and typed**.

### ✅ GOOD

```tsx
type PrimaryButtonProps = {
  title: string;
  loading?: boolean;
  disabled?: boolean;
  onPress: () => void;
};
```

### ❌ BAD

```tsx
// any / implicit props
const PrimaryButton = (props: any) => {}
```

Rules:

* Avoid `any`
* Use clear names
* Keep props minimal

---

# ========================

# 🔁 DATA FLOW

# ========================

```txt
Parent (presentation)
  → props
Component
  → callback
Parent (presentation/application)
```

### Example

```tsx
<PrimaryButton
  title="Transfer"
  loading={isSubmitting}
  disabled={!isValid}
  onPress={submitTransfer}
/>
```

---

# ========================

# ⚙️ REACT NATIVE RULES

# ========================

## 1. FUNCTIONAL COMPONENT ONLY

* Prefer function components
* Use hooks only for UI concerns (animation, local state)

## 2. AVOID INLINE HEAVY LOGIC

### ❌ BAD

```tsx
const onPress = () => {
  if (amount > limit) {
    showError(); // ❌ business rule
  }
};
```

### ✅ GOOD

```tsx
// logic handled in hook/usecase
<PrimaryButton onPress={onPress} />
```

## 3. MEMOIZATION

Use `React.memo` for list items or heavy components.

```tsx
export const TransactionItem = React.memo(({ item }: Props) => {
  return <View />;
});
```

## 4. STYLE ISOLATION

* Keep styles in same file or separate `*.style.ts`
* Use theme tokens

---

# ========================

# 🍏 iOS RULES

# ========================

* Use **SwiftUI View** or **UIKit custom View**
* Keep View lightweight
* No API calls in View
* Expose actions via closures/delegate

```swift
struct PrimaryButton: View {
    let title: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
        }
    }
}
```

---

# ========================

# 🤖 ANDROID RULES

# ========================

* Use **Composable** or custom View
* No business logic inside composable
* Expose events via lambda

```kotlin
@Composable
fun PrimaryButton(
    title: String,
    onClick: () -> Unit
) {
    Button(onClick = onClick) {
        Text(title)
    }
}
```

---

# ========================

# 🎨 DESIGN SYSTEM RULE

# ========================

Component MUST use:

* theme colors
* spacing tokens
* typography
* radius

### ❌ BAD

```tsx
style={{ backgroundColor: 'red', margin: 7 }}
```

### ✅ GOOD

```tsx
style={{
  backgroundColor: colors.primary,
  margin: spacing.md,
}}
```

---

# ========================

# 🔐 FINTECH RULE

# ========================

Components must NEVER handle:

* OTP validation
* PIN verification
* balance calculation
* fee calculation
* transaction state decision

### ❌ BAD

```tsx
if (amount > dailyLimit) {
  showError();
}
```

All fintech logic must be in:

```txt
application or domain
```

---

# ========================

# 🧪 TESTABILITY RULE

# ========================

Component should be easy to test:

* deterministic output
* no side effects
* controlled via props

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Create reusable components under `component/`
* Use typed props
* Keep component pure
* Emit actions via callbacks
* Use theme tokens

AI MUST NOT:

* Put API call in component
* Put business logic in component
* Import repository/service
* Depend on navigation directly
* Use random inline styles or magic values

---

# ========================

# 📌 SUMMARY

# ========================

```txt
Component = Pure UI
Input = props
Output = callbacks
No business logic
No API call
```

Reusable, predictable, and design-system compliant.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

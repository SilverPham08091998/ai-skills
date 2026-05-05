# design-system/design-system.md

## Objective

Define a scalable design system for React Native applications to ensure UI consistency, reusability, and fast development across teams.

Applies to:

* React Native (iOS + Android)
* TypeScript
* UI/UX consistency
* Fintech / Super App environments

Main rule:

> A design system is a single source of truth for UI.
> No component should be built ad-hoc without following system rules.

---

# 1. Core Principles

## 1.1 Consistency First

* Same UI → same component
* Same spacing → same token
* Same interaction → same behavior

---

## 1.2 Reusability

* Components must be reusable across features
* Avoid duplication

---

## 1.3 Scalability

* Must support large apps (Super App / multi-feature)
* Must support theming and branding

---

# 2. Structure

```txt
src/
  design-system/
    components/
    tokens/
    theme/
    typography/
    icons/
    spacing/
```

---

# 3. Design Tokens

Tokens are the foundation.

## 3.1 Colors

```ts
export const colors = {
  primary: '#0066FF',
  secondary: '#00C48C',
  danger: '#FF3B30',
  background: '#FFFFFF',
  text: '#1A1A1A',
};
```

---

## 3.2 Spacing

```ts
export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
};
```

---

## 3.3 Typography

```ts
export const typography = {
  h1: { fontSize: 32, fontWeight: '700' },
  h2: { fontSize: 24, fontWeight: '600' },
  body: { fontSize: 16 },
  caption: { fontSize: 12 },
};
```

---

# 4. Component Layers

## 4.1 Base Components

Reusable primitives:

```txt
Button
Text
Input
Card
Modal
```

Rules:

* No business logic
* Pure UI only

---

## 4.2 Composite Components

Built from base components:

```txt
TransferCard
TransactionItem
AccountBalanceView
```

Rules:

* May contain light logic
* Must remain reusable

---

## 4.3 Feature Components

Specific to feature:

```txt
TransferForm
LoginForm
```

Rules:

* Located in feature folder
* Can use design-system components

---

# 5. Theming

Support multiple themes:

```ts
export const lightTheme = {
  background: '#FFFFFF',
};

export const darkTheme = {
  background: '#000000',
};
```

Rules:

* Do not hardcode colors in components
* Always use theme

---

# 6. Component API Rules

Good:

```ts
type ButtonProps = {
  label: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary';
};
```

Bad:

```ts
<Button style={{ backgroundColor: 'red' }} />
```

---

# 7. Naming Convention

* PascalCase for components
* camelCase for props

Examples:

```txt
PrimaryButton
TransactionItem
```

---

# 8. Layout Rules

* Use spacing tokens
* Avoid hardcoded margin/padding

Bad:

```ts
marginTop: 13
```

Good:

```ts
marginTop: spacing.md
```

---

# 9. Accessibility

* Add accessibility labels
* Support screen readers

```tsx
<Button accessibilityLabel="Submit transfer" />
```

---

# 10. Fintech Rules

## 10.1 Sensitive UI

* Mask account numbers
* Mask card numbers

Example:

```txt
**** **** **** 1234
```

---

## 10.2 Error UI

* Clear message
* No technical details

---

## 10.3 Critical Actions

* Confirm dialogs for payments
* Disable double tap

---

# 11. Anti-patterns

* inline styles everywhere
* duplicated components
* hardcoded colors
* mixing business logic in UI

---

# 12. Checklist

* [ ] tokens defined
* [ ] components reusable
* [ ] no hardcoded values
* [ ] theme supported
* [ ] accessibility considered

---

# 13. Final Rule

> A strong design system enables fast development and consistent UX.
> Without it, UI becomes inconsistent and unscalable.

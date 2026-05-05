# design-system/layout-system.md

## Objective

Define layout standards for React Native applications to ensure consistent spacing, alignment, and structure across all screens and features.

Applies to:

* React Native (iOS + Android)
* Design System
* Fintech / Banking apps
* Super App environments

Main rule:

> Layout must be predictable and consistent.
> Do not invent spacing or structure per screen.

---

# 1. Core Principles

## 1.1 Consistency

* Same layout pattern → same spacing
* Same section → same structure

---

## 1.2 Spacing System First

* Use spacing tokens
* No arbitrary margins/padding

---

## 1.3 Flexbox First

* Prefer flex layout
* Avoid absolute positioning unless necessary

---

# 2. Layout Structure

## 2.1 Screen Structure

```txt
SafeArea
  → Container
    → Header
    → Content
    → Footer
```

Rules:

* Every screen follows this base layout
* Avoid mixing layout patterns

---

## 2.2 Container

```ts
const container = {
  flex: 1,
  paddingHorizontal: spacing.md,
  backgroundColor: theme.colors.background,
};
```

Rules:

* Use consistent horizontal padding
* Avoid per-screen padding differences

---

# 3. Spacing System

## 3.1 Spacing Tokens

```ts
spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
}
```

---

## 3.2 Usage

Bad:

```ts
marginTop: 13
```

Good:

```ts
marginTop: spacing.md
```

Rules:

* Only use defined spacing tokens
* Maintain vertical rhythm

---

# 4. Layout Patterns

## 4.1 Vertical Stack

```ts
<View style={{ gap: spacing.md }}>
```

Used for:

* forms
* sections
* lists

---

## 4.2 Horizontal Layout

```ts
<View style={{ flexDirection: 'row', alignItems: 'center' }}>
```

Used for:

* icon + text
* action rows

---

## 4.3 Grid Layout (Optional)

```ts
flexDirection: 'row'
flexWrap: 'wrap'
```

Rules:

* Use only when necessary

---

# 5. Alignment Rules

## 5.1 Horizontal Alignment

* `flex-start` (default)
* `center`
* `space-between`

---

## 5.2 Vertical Alignment

* `center`
* `flex-start`

---

# 6. Section Layout

Example:

```txt
Section
  → Title
  → Content
```

Rules:

* Title spacing consistent
* Section spacing consistent

---

# 7. Safe Area

Use:

* SafeAreaView
* react-native-safe-area-context

Rules:

* No content under notch
* No content under home indicator

---

# 8. Scroll Layout

```tsx
<ScrollView contentContainerStyle={{ padding: spacing.md }} />
```

Rules:

* Always use contentContainerStyle for spacing
* Avoid nested scrolls

---

# 9. Fixed vs Flexible Layout

Bad:

```ts
height: 500
```

Good:

```ts
flex: 1
```

Rules:

* Prefer flexible layout
* Avoid fixed heights unless necessary

---

# 10. Fintech Rules (CRITICAL)

## 10.1 Critical Actions

* Primary action must always be visible
* Avoid placing critical buttons off-screen

---

## 10.2 Content Priority

* Important financial data must not be truncated
* Ensure readability on all devices

---

## 10.3 Error States

* Error messages must be clearly visible
* Do not hide errors due to layout overflow

---

# 11. Anti-patterns

* Hardcoded spacing values
* Absolute positioning everywhere
* Inconsistent padding per screen
* Over-nested layouts
* Mixing layout styles

---

# 12. Checklist

* [ ] consistent container usage
* [ ] spacing tokens applied
* [ ] no hardcoded values
* [ ] safe area handled
* [ ] flexible layout used

---

# 13. Final Rule

> Layout system defines visual structure.
> Without it, UI becomes inconsistent and hard to scale.

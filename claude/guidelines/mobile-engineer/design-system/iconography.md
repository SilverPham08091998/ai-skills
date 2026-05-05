# design-system/iconography.md

## Objective

Define icon usage standards for React Native applications to ensure visual consistency, accessibility, semantic clarity, and scalable UI across features.

Applies to:

* React Native (iOS + Android)
* Design System
* Fintech / Banking apps
* Super App environments

Main rule:

> Icons must communicate meaning clearly and consistently.
> Do not use icons randomly as decoration.

---

# 1. Core Principles

## 1.1 Semantic Usage

Icons must represent clear meaning.

Examples:

```txt
check → success
warning → caution
x / close → dismiss
trash → delete
lock → security
```

Rules:

* Same meaning must use the same icon.
* Do not use different icons for the same action.
* Do not use the same icon for different meanings.

---

## 1.2 Consistency

Icons must follow the same visual style.

Choose one style system:

```txt
outline
filled
rounded
```

Rules:

* Avoid mixing styles randomly.
* Icon stroke width must be consistent.
* Icon corner radius should match the brand style.

---

## 1.3 Accessibility

Icons must not be the only way to communicate important information.

Rules:

* Add text label for critical actions.
* Use accessibility labels for interactive icons.
* Decorative icons should be hidden from screen readers when possible.

---

# 2. Icon Size Tokens

Use predefined size tokens.

```ts
export const iconSize = {
  xs: 12,
  sm: 16,
  md: 20,
  lg: 24,
  xl: 32,
};
```

Rules:

* Do not use arbitrary icon sizes.
* Default size should be `md` or `lg` depending on component.

---

# 3. Icon Color Rules

Icon colors must come from theme.

```ts
export const iconColor = {
  default: theme.colors.iconDefault,
  muted: theme.colors.iconMuted,
  primary: theme.colors.primary,
  success: theme.colors.success,
  warning: theme.colors.warning,
  danger: theme.colors.danger,
};
```

Rules:

* Do not hardcode hex colors.
* Use semantic color tokens.
* Do not rely only on color to communicate state.

---

# 4. Icon Component API

Create a centralized icon component.

```tsx
type IconName =
  | 'check'
  | 'close'
  | 'warning'
  | 'info'
  | 'lock'
  | 'trash'
  | 'search';

type IconProps = {
  name: IconName;
  size?: keyof typeof iconSize;
  color?: keyof typeof iconColor;
  accessibilityLabel?: string;
};
```

Example:

```tsx
<Icon name="warning" size="md" color="warning" />
```

Rules:

* Consumers should use design-system `Icon`, not import raw SVGs directly.
* Icon names must be typed.
* Icon size and color must use tokens.

---

# 5. Interactive Icons

Interactive icons must use a pressable wrapper.

```tsx
<Pressable accessibilityRole="button" accessibilityLabel="Close">
  <Icon name="close" size="lg" color="default" />
</Pressable>
```

Rules:

* Interactive icons must have touch target size at least 44x44.
* Must include accessibility label.
* Must provide press feedback.

---

# 6. Decorative Icons

Decorative icons should not distract users.

Rules:

* Avoid decorative icons in critical fintech flows.
* Do not overload screens with too many icons.
* Hide decorative icons from accessibility tree when possible.

---

# 7. State Icons

Standardize state icons.

```txt
success → check-circle
error → x-circle / error-circle
warning → warning-triangle
info → info-circle
pending → clock / loading
locked → lock
```

Rules:

* State icons must be consistent across app.
* State icons must be paired with text.

---

# 8. Fintech Rules (CRITICAL)

## 8.1 Critical Actions

For money-related actions:

* icon alone is not enough
* must include clear text label

Bad:

```txt
[trash icon only]
```

Good:

```txt
[trash icon] Delete beneficiary
```

---

## 8.2 Status Communication

Transaction status must use consistent icon + color + text.

Examples:

```txt
SUCCESS → check icon + success color + "Successful"
FAILED → error icon + danger color + "Failed"
PENDING → clock icon + warning/neutral color + "Processing"
```

---

## 8.3 Security Icons

Use security icons carefully.

Examples:

```txt
lock → protected / secure
shield → security warning / protection
fingerprint → biometric
```

Rules:

* Do not use security icons as decoration.
* Icons must not imply stronger security than actually implemented.

---

# 9. Asset Management

Recommended structure:

```txt
src/
  design-system/
    icons/
      assets/
      Icon.tsx
      iconRegistry.ts
      icon.types.ts
```

Rules:

* Centralize all icons.
* Avoid importing icons directly from random paths.
* Remove unused icons.

---

# 10. SVG Rules

Use SVG for scalable icons.

Rules:

* Optimize SVG files before adding.
* Remove unnecessary metadata.
* Prefer currentColor-like theming when possible.
* Keep icon viewBox consistent.

---

# 11. Performance Rules

* Avoid rendering many complex SVGs in large lists.
* Memoize icon component when needed.
* Prefer lightweight icons for transaction history or dashboard lists.

Example:

```ts
export const Icon = React.memo(IconComponent);
```

---

# 12. Testing Rules

Test:

* correct icon renders by name
* invalid icon handling
* accessibility label for interactive icons
* semantic state icons

Rules:

* Do not snapshot huge SVG trees unnecessarily.
* Prefer testing the wrapper behavior.

---

# 13. Anti-patterns

* Hardcoding SVG imports in feature screens.
* Using random icon sizes.
* Using icon-only buttons for critical actions.
* Mixing outline and filled styles without rule.
* Using color-only status indication.
* Using security icons as decoration.
* Keeping unused icons in bundle.

---

# 14. Checklist

* [ ] Centralized `Icon` component exists.
* [ ] Icon names are typed.
* [ ] Size tokens are used.
* [ ] Color tokens are used.
* [ ] Interactive icons have accessibility labels.
* [ ] Critical actions include text labels.
* [ ] State icons are standardized.
* [ ] SVG assets are optimized.
* [ ] Unused icons are removed.

---

# 15. Final Rule

> Icons are part of the communication system.
> In fintech apps, unclear icon usage can confuse users and create risk in critical flows.

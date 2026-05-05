# design-system/component-standard.md

## Objective

Define standards for designing, implementing, and maintaining reusable UI components in a React Native design system.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Design System components
* Fintech / Banking apps
* Super App / multi-feature environments

Main rule:

> Components must be reusable, typed, theme-driven, accessible, and predictable.
> Do not create one-off UI components when a design-system component already exists.

---

# 1. Core Principles

## 1.1 Reusable by Default

A design-system component must support reuse across multiple features.

Rules:

* Keep component API generic.
* Do not include feature-specific business logic.
* Do not depend on feature state directly.

---

## 1.2 Theme-driven Styling

All visual values must come from theme/tokens.

Use:

* colors
* spacing
* typography
* radius
* shadows

Do not hardcode:

* hex colors
* random spacing values
* font sizes

---

## 1.3 Typed Public API

Every component must expose typed props.

```ts
type ButtonProps = {
  label: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary' | 'danger';
  disabled?: boolean;
  loading?: boolean;
};
```

Rules:

* No `any` in props.
* Use union types for variants.
* Keep props minimal and intentional.

---

# 2. Component Categories

## 2.1 Primitive Components

Examples:

```txt
Text
Button
Input
Icon
Divider
Spacer
```

Rules:

* Pure UI only.
* No business logic.
* Must be highly reusable.

---

## 2.2 Composite Components

Examples:

```txt
Card
ListItem
BottomSheet
Header
EmptyState
ErrorState
```

Rules:

* Built from primitives.
* May include layout logic.
* Still must not include feature business logic.

---

## 2.3 Feature Components

Examples:

```txt
TransferForm
PaymentSummary
TransactionCard
```

Rules:

* Live inside feature folder.
* Can consume design-system components.
* Can contain feature-specific UI logic.

---

# 3. Folder Structure

Recommended:

```txt
src/
  design-system/
    components/
      Button/
        Button.tsx
        Button.types.ts
        Button.styles.ts
        Button.test.tsx
        index.ts
      Input/
        Input.tsx
        Input.types.ts
        Input.styles.ts
        Input.test.tsx
        index.ts
```

Rules:

* Each component owns its types, styles, tests, and export.
* Export components from a central design-system index.

---

# 4. Component API Design

## 4.1 Prefer Explicit Props

Good:

```tsx
<Button variant="primary" size="lg" />
```

Bad:

```tsx
<Button type="blueBig" />
```

---

## 4.2 Avoid Style Escape Hatch Abuse

Allow `style` only when necessary.

```ts
type ButtonProps = {
  style?: StyleProp<ViewStyle>;
};
```

Rules:

* `style` must not be used to override core visual identity.
* Prefer variants over random style overrides.

---

## 4.3 Use Variants

```ts
type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger';
type ButtonSize = 'sm' | 'md' | 'lg';
```

Rules:

* Variants must map to theme tokens.
* Do not create uncontrolled variant names.

---

# 5. Styling Rules

## 5.1 Use Tokens

Bad:

```ts
padding: 13,
backgroundColor: '#FF0000',
```

Good:

```ts
padding: theme.spacing.md,
backgroundColor: theme.colors.danger,
```

---

## 5.2 Style Factory Pattern

```ts
export const createStyles = (theme: Theme) =>
  StyleSheet.create({
    container: {
      padding: theme.spacing.md,
      backgroundColor: theme.colors.primary,
    },
  });
```

Rules:

* Styles should be generated from theme.
* Avoid inline styles for stable components.

---

# 6. Accessibility Rules

Components must support accessibility by default.

Examples:

```tsx
<Pressable
  accessibilityRole="button"
  accessibilityLabel={accessibilityLabel ?? label}
/>
```

Rules:

* Interactive components must have accessibility role.
* Important UI must have accessibility label.
* Disabled state must be accessible.
* Do not rely only on color to communicate meaning.

---

# 7. Interaction Rules

## 7.1 Prevent Double Submit

Critical buttons should support loading/disabled state.

```tsx
<Button loading={isSubmitting} disabled={isSubmitting} />
```

## 7.2 Press Feedback

* Use visible feedback for pressable components.
* Keep behavior consistent across app.

---

# 8. Error & Empty State Components

Standardize:

```txt
ErrorState
EmptyState
RetryView
```

Rules:

* User-facing messages only.
* No technical stack traces.
* Support retry action where applicable.

---

# 9. Input Components

Input must support:

* label
* placeholder
* value
* error message
* disabled state
* secure text entry
* keyboard type
* accessibility label

Example:

```ts
type TextInputProps = {
  label?: string;
  value: string;
  onChangeText: (value: string) => void;
  error?: string;
  disabled?: boolean;
};
```

Fintech rules:

* Mask sensitive fields.
* Never log input values.
* OTP/PIN components must not store values longer than needed.

---

# 10. Performance Rules

## 10.1 Memoization

Use `React.memo` for reusable pure components.

```ts
export const Button = React.memo(ButtonComponent);
```

## 10.2 Stable Props

* Avoid passing new objects/functions every render.
* Prefer memoized handlers in parent components.

## 10.3 Avoid Heavy Logic

* No expensive computation inside component render.
* Move logic to hooks or application layer.

---

# 11. Testing Rules

Each design-system component should have tests for:

* render state
* disabled state
* loading state
* error state
* user interaction
* accessibility behavior

Example:

```ts
it('calls onPress when pressed', () => {
  const onPress = jest.fn();
  render(<Button label="Submit" onPress={onPress} />);
  fireEvent.press(screen.getByText('Submit'));
  expect(onPress).toHaveBeenCalled();
});
```

---

# 12. Documentation Rules

Each component should document:

* purpose
* props
* variants
* examples
* accessibility behavior
* do/don't usage

Example:

```md
## Button

Use for primary user actions.

Do:
- Use `primary` for main action.
- Use `danger` for destructive action.

Don't:
- Use danger color for non-destructive action.
```

---

# 13. Fintech Rules (CRITICAL)

## 13.1 Critical Actions

For payment/transfer confirmation:

* button must prevent double tap
* show loading state
* disable while submitting
* use explicit confirmation copy

---

## 13.2 Sensitive Display

Components showing sensitive data must support masking.

Examples:

```txt
**** **** 1234
090****789
```

---

## 13.3 Error Display

* Do not expose technical errors.
* Show safe, localized, user-friendly messages.

---

# 14. Anti-patterns

* Hardcoded colors/spacing.
* Business logic inside design-system components.
* Huge component with too many unrelated props.
* Uncontrolled variants.
* Missing accessibility labels.
* Duplicated button/input components across features.
* Using style override to break design consistency.

---

# 15. Checklist

* [ ] Component has typed props.
* [ ] Component uses theme/tokens.
* [ ] Component has accessibility support.
* [ ] Component has tests.
* [ ] Component has clear variants.
* [ ] Component has loading/disabled states if interactive.
* [ ] Component does not contain business logic.
* [ ] Component is exported through public index.
* [ ] Sensitive UI behavior is safe.

---

# 16. Final Rule

> A design-system component is a contract.
> Keep it stable, typed, accessible, theme-driven, tested, and free from business logic.

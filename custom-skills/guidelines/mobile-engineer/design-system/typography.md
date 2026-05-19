# design-system/typography.md

## Objective

Define typography standards for React Native applications to ensure readability, consistency, accessibility, and brand alignment across devices and themes.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Design System
* Fintech / Banking apps

Main rule:

> Text must be readable, consistent, and theme-driven.
> Do not use arbitrary font sizes or weights.

---

# 1. Core Principles

## 1.1 Readability First

* Prioritize legibility on small screens
* Maintain sufficient contrast with background
* Avoid overly small font sizes

---

## 1.2 Consistency

* Same semantic role → same style
* Use predefined text styles instead of ad-hoc values

---

## 1.3 Token-driven

* Typography must come from tokens (no hardcoded sizes/weights)

---

# 2. Typography Tokens

## 2.1 Font Families

```ts
export const fontFamily = {
  regular: 'System',
  medium: 'System',
  bold: 'System',
};
```

Rules:

* Use system fonts by default for performance
* If using custom fonts, ensure both platforms are supported

---

## 2.2 Font Sizes

```ts
export const fontSize = {
  xs: 12,
  sm: 14,
  md: 16,
  lg: 18,
  xl: 20,
  xxl: 24,
  display: 32,
};
```

---

## 2.3 Line Heights

```ts
export const lineHeight = {
  xs: 16,
  sm: 20,
  md: 24,
  lg: 28,
  xl: 32,
  xxl: 36,
  display: 40,
};
```

Rules:

* Line height should be ≥ font size * 1.2
* Maintain vertical rhythm

---

## 2.4 Font Weights

```ts
export const fontWeight = {
  regular: '400',
  medium: '500',
  semiBold: '600',
  bold: '700',
};
```

---

# 3. Semantic Text Styles

Define semantic styles instead of using raw tokens directly.

```ts
export const textStyles = {
  h1: {
    fontSize: fontSize.display,
    lineHeight: lineHeight.display,
    fontWeight: fontWeight.bold,
  },
  h2: {
    fontSize: fontSize.xxl,
    lineHeight: lineHeight.xxl,
    fontWeight: fontWeight.semiBold,
  },
  body: {
    fontSize: fontSize.md,
    lineHeight: lineHeight.md,
    fontWeight: fontWeight.regular,
  },
  caption: {
    fontSize: fontSize.sm,
    lineHeight: lineHeight.sm,
    fontWeight: fontWeight.regular,
  },
};
```

Rules:

* Use semantic styles (h1, body, caption)
* Avoid mixing raw tokens in components

---

# 4. Usage in Components

```tsx
<Text style={textStyles.body}>Hello</Text>
```

Rules:

* Do not inline font styles repeatedly
* Use shared styles from design system

---

# 5. Responsive Scaling

Combine with responsive-scale utilities.

```ts
fontSize: moderateScale(fontSize.md)
```

Rules:

* Scale moderately
* Do not break readability

---

# 6. Theming Integration

Typography must integrate with theme.

```ts
color: theme.colors.text
```

Rules:

* Do not hardcode text color
* Support light/dark mode

---

# 7. Accessibility

## 7.1 Font Scaling

* Respect system font scaling (Accessibility settings)

```tsx
<Text allowFontScaling />
```

## 7.2 Minimum Size

* Avoid text smaller than 12dp

## 7.3 Contrast

* Ensure sufficient contrast ratio

---

# 8. Truncation & Wrapping

Rules:

* Use ellipsis for long text when necessary

```tsx
<Text numberOfLines={1} ellipsizeMode="tail" />
```

* Avoid truncating critical financial data

---

# 9. Fintech Rules (CRITICAL)

## 9.1 Monetary Values

* Use clear, consistent formatting
* Avoid small fonts for money

```txt
$1,200.00
```

---

## 9.2 Sensitive Data

* Mask when needed

```txt
****1234
```

---

## 9.3 Error Messages

* Clear, non-technical language
* Proper emphasis (color + weight)

---

# 10. Anti-patterns

* Hardcoding font sizes
* Mixing multiple font styles randomly
* Using too many font sizes
* Ignoring accessibility scaling

---

# 11. Checklist

* [ ] font tokens defined
* [ ] semantic styles defined
* [ ] no hardcoded values
* [ ] accessible sizes used
* [ ] theme integration applied

---

# 12. Final Rule

> Typography defines readability and trust.
> In fintech apps, unclear text leads to user errors and loss of confidence.

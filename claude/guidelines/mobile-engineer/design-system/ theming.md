# design-system/theming.md

## Objective

Define theming standards for React Native applications to support multiple themes (light/dark/brand) while maintaining consistency and scalability.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Design System
* Multi-brand / White-label apps

Main rule:

> UI must never depend on hardcoded values.
> All visual styling must come from theme.

---

# 1. Core Principles

## 1.1 Theme-driven UI

* All colors, typography, spacing come from theme
* No hardcoded styles in components

---

## 1.2 Single Source of Truth

* Theme is the only source for UI values

---

## 1.3 Runtime Switchable

* Support switching theme dynamically

---

# 2. Theme Structure

```ts
export type Theme = {
  colors: {
    primary: string;
    background: string;
    text: string;
    danger: string;
  };
  spacing: typeof spacing;
  typography: typeof typography;
};
```

---

# 3. Default Themes

## 3.1 Light Theme

```ts
export const lightTheme: Theme = {
  colors: {
    primary: '#0066FF',
    background: '#FFFFFF',
    text: '#000000',
    danger: '#FF3B30',
  },
  spacing,
  typography,
};
```

---

## 3.2 Dark Theme

```ts
export const darkTheme: Theme = {
  colors: {
    primary: '#4D8DFF',
    background: '#000000',
    text: '#FFFFFF',
    danger: '#FF453A',
  },
  spacing,
  typography,
};
```

---

# 4. Theme Provider

```tsx
const ThemeContext = React.createContext<Theme>(lightTheme);

export const ThemeProvider = ({ children }) => {
  const [theme, setTheme] = useState(lightTheme);

  return (
    <ThemeContext.Provider value={theme}>
      {children}
    </ThemeContext.Provider>
  );
};
```

---

# 5. Usage

```ts
const theme = useContext(ThemeContext);

<View style={{ backgroundColor: theme.colors.background }} />
```

Rules:

* Always use theme values
* Never use raw color values

---

# 6. Multi-brand Support

```ts
export const brandATheme = {
  colors: { primary: '#FF0000' }
};

export const brandBTheme = {
  colors: { primary: '#00FF00' }
};
```

Rules:

* Brand differences handled via theme only
* No branching logic inside UI

---

# 7. Dynamic Theme Switch

```ts
setTheme(darkTheme);
```

---

# 8. Fintech Rules

## 8.1 Sensitive UI

* Colors must not mislead user
* Red = error/danger only

---

## 8.2 Consistency

* Same action → same color

---

# 9. Anti-patterns

* hardcoded colors
* inline styles
* theme duplication

---

# 10. Checklist

* [ ] theme defined
* [ ] no hardcoded values
* [ ] supports dark mode
* [ ] supports multi-brand

---

# 11. Final Rule

> Theming is the foundation of scalable UI.
> Without it, multi-brand and consistency become impossible.

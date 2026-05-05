# design-system/responsive-scale.md

## Objective

Define responsive scaling standards for React Native apps to ensure UI consistency across different screen sizes, pixel densities, and orientations.

Applies to:

* React Native (iOS + Android)
* Phones (small → large)
* Tablets (optional support)
* Design System

Main rule:

> UI must scale predictably.
> Do not design for a single screen size.

---

# 1. Core Principles

## 1.1 Density-independent Design

* Use dp (density-independent pixels)
* Avoid raw pixel assumptions

---

## 1.2 Scale, Don’t Stretch

* Scale spacing and typography
* Avoid stretching layouts unnaturally

---

## 1.3 Base Design Reference

Choose a base screen (e.g., iPhone 11):

```txt
Width: 375
Height: 812
```

All scaling should be relative to this baseline.

---

# 2. Scaling Utilities

## 2.1 Scale Functions

```ts
import { Dimensions } from 'react-native';

const { width, height } = Dimensions.get('window');

const BASE_WIDTH = 375;
const BASE_HEIGHT = 812;

export const scale = (size: number) => (width / BASE_WIDTH) * size;
export const verticalScale = (size: number) => (height / BASE_HEIGHT) * size;
export const moderateScale = (size: number, factor = 0.5) =>
  size + (scale(size) - size) * factor;
```

---

# 3. Typography Scaling

```ts
fontSize: moderateScale(16)
```

Rules:

* Do not scale fonts aggressively
* Maintain readability

---

# 4. Spacing Scaling

Use tokens:

```ts
spacing.md = moderateScale(16)
```

Rules:

* Keep spacing proportional
* Avoid inconsistent gaps

---

# 5. Layout Rules

## 5.1 Use Flexbox

* Prefer flex layouts over fixed sizes

## 5.2 Avoid Fixed Widths

Bad:

```ts
width: 320
```

Good:

```ts
width: '100%'
```

---

# 6. Breakpoints (Optional)

```ts
export const isTablet = width >= 768;
```

Rules:

* Use breakpoints for layout changes
* Not for micro adjustments

---

# 7. Orientation Handling

Rules:

* Support portrait by default
* Handle landscape if required

---

# 8. Safe Area

Use:

* SafeAreaView
* react-native-safe-area-context

Rules:

* Avoid content under notch/home indicator

---

# 9. Fintech Rules

## 9.1 Critical UI

* Payment confirmation must always be visible
* Buttons must not overflow screen

## 9.2 Accessibility

* Respect system font scaling

---

# 10. Anti-patterns

* Hardcoding dimensions
* Ignoring small screen devices
* Over-scaling fonts

---

# 11. Checklist

* [ ] scale utilities implemented
* [ ] typography readable
* [ ] layout flexible
* [ ] safe area handled

---

# 12. Final Rule

> Responsive design ensures usability across devices.
> Without it, UI breaks on real users’ screens.

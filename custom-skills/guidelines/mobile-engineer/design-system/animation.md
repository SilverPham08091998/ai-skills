# design-system/animation.md

## Objective

Define animation standards for React Native applications to ensure smooth, consistent, accessible, and production-safe motion design.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Design System
* Fintech / Banking apps
* Super App environments

Main rule:

> Animation must improve clarity and perceived performance.
> Do not use animation as decoration if it slows down or distracts users.

---

# 1. Core Principles

## 1.1 Purposeful Motion

Animations should help users understand:

* state changes
* navigation transitions
* loading progress
* success/failure feedback
* hierarchy and focus

Rules:

* Every animation must have a purpose.
* Avoid unnecessary decorative animations.
* Critical flows must prioritize clarity over delight.

---

## 1.2 Consistency

Same interaction should use the same motion behavior.

Examples:

```txt
button press → same feedback
modal open → same transition
screen transition → same timing
```

---

## 1.3 Performance First

Animations must be smooth and avoid blocking the JS thread.

Rules:

* Prefer native-driven animations.
* Avoid heavy calculations inside animation callbacks.
* Avoid animating layout-heavy properties when possible.

---

# 2. Recommended Libraries

Use:

* `react-native-reanimated`
* `react-native-gesture-handler`
* React Native `Animated` for simple cases

Rules:

* Prefer Reanimated for complex gestures or high-frequency animations.
* Use native driver when using React Native `Animated`.

---

# 3. Animation Tokens

Define motion tokens in the design system.

```ts
export const motion = {
  duration: {
    fast: 150,
    normal: 250,
    slow: 400,
  },
  easing: {
    standard: 'ease-out',
    emphasized: 'ease-in-out',
  },
};
```

Rules:

* Do not hardcode durations randomly.
* Use shared motion tokens.
* Keep animation timing consistent across app.

---

# 4. Duration Guidelines

Recommended defaults:

```txt
Micro interaction: 100–150ms
Button feedback: 100–200ms
Modal/bottom sheet: 200–300ms
Screen transition: 250–400ms
Skeleton shimmer: 800–1500ms loop
```

Rules:

* Avoid long animations in critical flows.
* Do not delay user actions for animation completion unless required.

---

# 5. What to Animate

Prefer animating GPU-friendly properties:

```txt
opacity
transform: translateX / translateY / scale / rotate
```

Avoid when possible:

```txt
width
height
top
left
margin
padding
```

Reason:

* Layout animations can trigger expensive re-layout.
* Transform/opacity animations are usually smoother.

---

# 6. Button & Press Feedback

Buttons should provide immediate feedback.

Example behavior:

```txt
press in → slight scale down / opacity change
press out → restore
```

Rules:

* Feedback must be fast.
* Do not block the actual action.
* Critical action buttons must support loading and disabled states.

---

# 7. Loading Animation

Use loading animations for:

* API wait state
* submit processing
* screen loading

Rules:

* Use spinner for action-level loading.
* Use skeleton for content-level loading.
* Avoid infinite loaders without timeout or fallback.

---

# 8. Skeleton Animation

Skeleton should:

* match final layout
* use lightweight shimmer
* avoid too many animated nodes

Rules:

* Do not skeleton everything.
* Avoid heavy shimmer on large lists.
* Disable shimmer if performance drops.

---

# 9. Modal / Bottom Sheet Animation

Standard behavior:

```txt
open → slide up + fade backdrop
close → slide down + fade backdrop
```

Rules:

* Backdrop and content motion must be synchronized.
* Do not use aggressive bounce for fintech critical flows.
* Bottom sheet should support gesture dismissal only when safe.

---

# 10. Navigation Transition

Rules:

* Keep transitions consistent.
* Avoid custom transitions unless product requires it.
* Payment/transfer flows should use predictable transitions.

---

# 11. Success / Failure Feedback

Use subtle animation for:

* success checkmark
* error shake
* confirmation state

Rules:

* Success animation must not delay transaction result display.
* Error animation must not hide the error message.
* Avoid playful animation for serious financial failures.

---

# 12. Accessibility

## 12.1 Reduce Motion

Respect system reduce motion setting when possible.

Rules:

* Disable or simplify non-essential animations.
* Keep critical feedback visible without motion.

---

## 12.2 Do Not Rely Only on Motion

Motion must not be the only signal.

Bad:

```txt
field shakes but no error text
```

Good:

```txt
field shakes + error message is shown
```

---

# 13. Performance Rules

## 13.1 Avoid JS Thread Blocking

Bad:

```ts
onUpdate(() => {
  heavyCalculation();
});
```

Good:

```ts
// Keep animation callback lightweight
```

---

## 13.2 Use Reanimated for Complex Animations

Use Reanimated for:

* gestures
* bottom sheets
* drag/swipe
* high-frequency animations

---

## 13.3 Avoid Too Many Animated Elements

Especially in:

* large lists
* dashboard cards
* transaction history

---

# 14. Fintech Rules (CRITICAL)

## 14.1 Critical Actions

For payment/transfer flows:

* animations must not delay confirmation
* animations must not hide final status
* loading state must prevent duplicate submission

---

## 14.2 Serious States

For errors, fraud warnings, failed transactions:

* use clear static messaging
* animation may support but never replace text

---

## 14.3 User Trust

Avoid overly playful animations in money movement flows.

Reason:

* Financial apps must feel stable, serious, and trustworthy.

---

# 15. Testing Rules

Test:

* loading state appears
* disabled state prevents interaction
* final UI state after animation
* reduced motion fallback where applicable

Rules:

* Do not make tests depend on exact animation timing unless necessary.
* Prefer asserting final state.

---

# 16. Anti-patterns

* Animating layout-heavy properties everywhere.
* Using long animations in critical flows.
* Skeleton shimmer on too many list items.
* Animation hides error state.
* Button animation allows duplicate submit.
* Custom animation per screen with no system rule.
* Ignoring reduce motion accessibility setting.

---

# 17. Checklist

* [ ] Animation has clear purpose.
* [ ] Uses motion tokens.
* [ ] Uses transform/opacity when possible.
* [ ] Avoids blocking JS thread.
* [ ] Supports reduced motion.
* [ ] Does not hide critical information.
* [ ] Does not delay payment/transfer result.
* [ ] Prevents duplicate submit during loading.
* [ ] Tested by final state, not fragile timing.

---

# 18. Final Rule

> Good animation makes the app feel faster, clearer, and more trustworthy.
> Bad animation creates delay, confusion, and performance issues.

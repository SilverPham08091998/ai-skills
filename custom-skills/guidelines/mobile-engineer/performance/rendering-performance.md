# performance/rendering-performance.md

## Objective

Define standards to optimize rendering performance in React Native applications for smooth UI/UX in production (especially fintech/banking apps).

Applies to:

* React Native (iOS + Android)
* TypeScript
* UI layer (components, lists, animations)

Main rule:

> Rendering must be predictable, minimal, and efficient.
> Avoid unnecessary re-renders and heavy computations on the UI thread.

---

# 1. Core Principles

## 1.1 Minimize Re-renders

* Only re-render when necessary
* Avoid cascading renders

## 1.2 Keep UI Thread Light

* No heavy logic in render()
* Avoid blocking JS thread

## 1.3 Measure Before Optimize

* Use profiling tools
* Identify real bottlenecks

---

# 2. Component Optimization

## 2.1 Use React.memo

```ts
export default React.memo(MyComponent);
```

Rules:

* Use for pure components
* Ensure props are stable

---

## 2.2 useCallback / useMemo

```ts
const handleClick = useCallback(() => {
  doSomething();
}, []);
```

```ts
const computed = useMemo(() => heavyCalc(data), [data]);
```

Rules:

* Use only when needed
* Do not overuse blindly

---

## 2.3 Avoid Inline Functions in JSX

Bad:

```tsx
onPress={() => handleClick()}
```

Good:

```tsx
onPress={handleClick}
```

---

# 3. List Performance (CRITICAL)

## 3.1 Use FlatList / SectionList

* Never use map() for large lists

---

## 3.2 Key Extractor

```ts
keyExtractor={(item) => item.id}
```

---

## 3.3 Optimize Rendering

```ts
initialNumToRender={10}
maxToRenderPerBatch={10}
windowSize={5}
```

---

## 3.4 Avoid Anonymous renderItem

```ts
const renderItem = useCallback(({ item }) => (
  <Item item={item} />
), []);
```

---

## 3.5 Use getItemLayout (when possible)

```ts
getItemLayout={(data, index) => ({
  length: ITEM_HEIGHT,
  offset: ITEM_HEIGHT * index,
  index,
})}
```

---

# 4. State Management Optimization

## 4.1 Avoid Global State Overuse

* Do not put everything in Redux
* Keep UI state local

---

## 4.2 Selectors Optimization

* Use memoized selectors

---

## 4.3 Avoid Unnecessary Updates

* Do not update state with same value

---

# 5. Image Optimization

* Use optimized image formats (WebP)
* Resize images before rendering
* Use caching libraries

---

# 6. Animation Performance

## 6.1 Use Native Driver

```ts
useNativeDriver: true
```

## 6.2 Use Reanimated (Recommended)

* Offload animation to UI thread

---

# 7. Avoid Heavy Computation in Render

Bad:

```tsx
const result = heavyCalculation(data);
```

Good:

```ts
const result = useMemo(() => heavyCalculation(data), [data]);
```

---

# 8. Avoid Layout Thrashing

* Do not trigger multiple layout passes
* Minimize dynamic style changes

---

# 9. Profiling Tools

* React DevTools Profiler
* Flipper (React Native)
* Performance Monitor (FPS)

---

# 10. Fintech Rules

## 10.1 Critical Screens

* Home dashboard
* Transaction history
* Payment flow

Must be:

* fast
* smooth
* no frame drops

---

## 10.2 Avoid Lag in Money Flow

* No delay in confirm/payment button
* Disable button instead of re-rendering whole screen

---

# 11. Common Anti-patterns

* Rendering large lists with map()
* Passing new objects every render
* Inline styles/handlers everywhere
* Uncontrolled re-renders from global state

---

# 12. Checklist

* [ ] React.memo used correctly
* [ ] useCallback/useMemo optimized
* [ ] FlatList configured properly
* [ ] No heavy logic in render
* [ ] Images optimized
* [ ] Animations use native driver
* [ ] No unnecessary re-renders

---

# 13. Final Rule

> Smooth UI = controlled rendering + optimized state + efficient lists.
> Performance issues usually come from unnecessary re-renders, not slow devices.

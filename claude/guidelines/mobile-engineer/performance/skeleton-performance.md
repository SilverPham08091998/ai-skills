# performance/skeleton-performance.md

## Objective

Define standards for using skeleton loading (placeholder UI) to improve perceived performance and user experience in React Native applications.

Applies to:

* React Native (iOS + Android)
* TypeScript
* UI/UX layer

Main rule:

> Skeletons do not make the app faster — they make it feel faster.
> Use them to reduce perceived latency, not to hide bad performance.

---

# 1. Core Principles

## 1.1 Perceived Performance > Actual Delay

* Users care about visual feedback
* Immediate UI response reduces frustration

## 1.2 Show Structure Early

* Skeleton should mimic final layout
* Avoid layout shift after data loads

## 1.3 Do Not Overuse

* Use only for meaningful loading states
* Avoid skeleton for very fast APIs (<200ms)

---

# 2. When to Use Skeleton

Use skeleton when:

* API takes noticeable time (>300ms)
* Data-heavy UI (lists, dashboard)
* First load screen

Do NOT use when:

* instant UI (local data)
* simple loaders (button click → spinner is enough)

---

# 3. Skeleton Design Rules

## 3.1 Match Final Layout

Bad:

```txt
Generic gray box
```

Good:

```txt
Avatar + text lines + button placeholder
```

## 3.2 Avoid Layout Shift

* Same size as final content
* Same spacing/margin

---

## 3.3 Use Consistent Style

* gray shades
* shimmer animation (optional)

---

# 4. Implementation Patterns

## 4.1 Conditional Rendering

```tsx
if (loading) {
  return <Skeleton />;
}

return <RealContent data={data} />;
```

---

## 4.2 Inline Skeleton

```tsx
<Text>
  {loading ? <SkeletonText /> : data.title}
</Text>
```

---

# 5. List Skeleton (CRITICAL)

## 5.1 Render Placeholder Items

```tsx
<FlatList
  data={loading ? skeletonData : realData}
  renderItem={renderItem}
/>
```

---

## 5.2 Fixed Count

* Render fixed number (e.g., 5–10 items)
* Avoid dynamic skeleton list size

---

# 6. Animation Rules

## 6.1 Shimmer Effect (Optional)

* Use lightweight animation
* Avoid heavy CPU usage

## 6.2 Avoid Over-animation

Bad:

* too many animated elements

---

# 7. Performance Rules

## 7.1 Lightweight Components

* No heavy logic inside skeleton
* No unnecessary re-renders

## 7.2 Memoization

```ts
export default React.memo(SkeletonComponent);
```

---

## 7.3 Avoid Re-creation

* Do not recreate skeleton structure every render

---

# 8. Transition Strategy

## 8.1 Smooth Switch

* Replace skeleton with content seamlessly

## 8.2 Avoid Flicker

* Keep skeleton visible until data is ready

Bad:

```txt
skeleton → blank → content
```

Good:

```txt
skeleton → content
```

---

# 9. Fintech Rules

## 9.1 Dashboard

* Use skeleton for balances, transactions

## 9.2 Transaction History

* Show list skeleton

## 9.3 Payment Flow

* Avoid skeleton on confirm step
* Use spinner instead for action feedback

---

# 10. UX Rules

* Show meaningful structure
* Avoid misleading placeholders

Example:

```txt
Skeleton shows 5 items but real data has 1 → confusing ❌
```

---

# 11. Common Anti-patterns

* Skeleton for everything
* Different layout than real UI
* Too many animated elements
* Flicker during loading

---

# 12. Checklist

* [ ] Skeleton matches real layout
* [ ] No layout shift
* [ ] Lightweight component
* [ ] No flicker
* [ ] Used only when needed

---

# 13. Final Rule

> Skeleton improves perceived speed, not actual performance.
> Combine skeleton with real performance optimization for best UX.

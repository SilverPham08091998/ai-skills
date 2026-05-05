# performance/memory-leak.md

## Objective

Define standards to prevent, detect, and fix memory leaks in React Native applications for stable performance in production (especially fintech/banking apps).

Applies to:

* React Native (iOS + Android)
* TypeScript
* Components, hooks, async flows, event systems

Main rule:

> Any resource you create must be properly cleaned up.
> Unreleased references will accumulate and degrade performance over time.

---

# 1. Core Principles

## 1.1 Lifecycle Awareness

* Understand component mount/unmount
* Clean up all side effects

## 1.2 Avoid Retaining References

* Do not hold unnecessary references to large objects
* Avoid global mutable state misuse

## 1.3 Detect Early

* Memory leaks are easier to fix early
* Monitor during development

---

# 2. Common Causes

## 2.1 Uncleaned useEffect

Bad:

```ts
useEffect(() => {
  const interval = setInterval(() => {
    fetchData();
  }, 1000);
}, []);
```

Good:

```ts
useEffect(() => {
  const interval = setInterval(() => {
    fetchData();
  }, 1000);

  return () => clearInterval(interval);
}, []);
```

---

## 2.2 Event Listeners Not Removed

Bad:

```ts
useEffect(() => {
  window.addEventListener('resize', handler);
}, []);
```

Good:

```ts
useEffect(() => {
  window.addEventListener('resize', handler);

  return () => window.removeEventListener('resize', handler);
}, []);
```

---

## 2.3 Async Calls After Unmount

Bad:

```ts
useEffect(() => {
  fetchData().then(setData);
}, []);
```

Good:

```ts
useEffect(() => {
  let isMounted = true;

  fetchData().then((data) => {
    if (isMounted) setData(data);
  });

  return () => {
    isMounted = false;
  };
}, []);
```

---

## 2.4 Timers Not Cleared

* setTimeout
* setInterval

Always clear them on unmount

---

## 2.5 Large Objects in State

Bad:

```ts
setState(hugeObject);
```

Rules:

* Store only necessary data
* Avoid keeping large payloads

---

## 2.6 Navigation Leaks

* Screens not properly unmounted
* Listeners not removed when navigating

---

# 3. React Native Specific Issues

## 3.1 Native Module Leaks

* Improper native resource handling
* Not releasing listeners

## 3.2 Image Memory

* Large images not cached properly
* Multiple re-renders of heavy images

## 3.3 Animated Values

* Not stopping animations

```ts
animation.stop();
```

---

# 4. Cleanup Patterns

## 4.1 Standard useEffect Cleanup

```ts
useEffect(() => {
  // setup

  return () => {
    // cleanup
  };
}, []);
```

---

## 4.2 AbortController for API Calls

```ts
const controller = new AbortController();

fetch(url, { signal: controller.signal });

return () => controller.abort();
```

---

## 4.3 Subscription Cleanup

```ts
const subscription = event.subscribe();

return () => subscription.unsubscribe();
```

---

# 5. State Management Leaks

## 5.1 Redux / Global Store

* Avoid storing large datasets
* Clear state on logout

---

## 5.2 Observables / Streams

* Always unsubscribe

```ts
subscription.unsubscribe();
```

---

# 6. Profiling & Detection

Tools:

* React DevTools Profiler
* Flipper Memory Plugin
* Xcode Instruments (iOS)
* Android Studio Profiler

Symptoms:

* increasing memory usage
* slow UI after long usage
* app crashes due to OOM

---

# 7. Fintech Rules

## 7.1 Long Session Stability

* banking apps stay open long time
* memory leaks accumulate → crash risk

---

## 7.2 Transaction Screens

* must not leak memory
* avoid retaining transaction data unnecessarily

---

## 7.3 Background Behavior

* release resources when app backgrounded

---

# 8. Logging Rules

* do not log large objects
* avoid keeping logs in memory

---

# 9. Checklist

* [ ] All useEffect have cleanup
* [ ] No untracked async updates
* [ ] Timers cleared
* [ ] Subscriptions unsubscribed
* [ ] Large objects not retained
* [ ] Navigation listeners cleaned

---

# 10. Final Rule

> Memory leaks are silent killers.
> They do not break immediately but degrade performance over time.
> Always clean up what you create.

# performance/startup-performance.md

## Objective

Define standards to optimize app startup time in React Native applications for fast launch and smooth first interaction (critical for fintech/banking apps).

Applies to:

* React Native (iOS + Android)
* TypeScript
* App initialization flow

Main rule:

> First impression matters.
> App must become interactive as quickly as possible.

---

# 1. Core Principles

## 1.1 Fast Time To Interactive (TTI)

* Minimize time from launch → usable UI

## 1.2 Defer Non-critical Work

* Load only what is needed for first screen

## 1.3 Avoid Blocking JS Thread

* Do not execute heavy logic during startup

---

# 2. Startup Phases

```txt
App Launch
 → Native Initialization
 → JS Bundle Load
 → App Init
 → First Screen Render
 → Background Tasks
```

---

# 3. JS Bundle Optimization

## 3.1 Reduce Bundle Size

* Remove unused dependencies
* Avoid large libraries

## 3.2 Code Splitting (Advanced)

* Lazy load non-critical modules

---

# 4. App Initialization

## 4.1 Keep Init Minimal

Bad:

```ts
await loadEverything();
```

Good:

```ts
await loadCriticalData();
runBackgroundTasks();
```

---

## 4.2 Defer Tasks

* analytics init
* feature flags
* non-critical API calls

---

# 5. Splash Screen Strategy

## 5.1 Use Native Splash Screen

* Show instantly
* Avoid blank screen

## 5.2 Control Hide Timing

* Hide only when first screen is ready

---

# 6. Navigation Optimization

* Load only initial screen
* Lazy load other screens

---

# 7. Network Optimization

* Avoid blocking startup with API calls
* Use cached data if available

---

# 8. Storage Optimization

* Avoid heavy reads during startup
* Load only essential keys

---

# 9. Image Optimization

* Avoid loading large images on first screen
* Use lightweight assets

---

# 10. Native Optimization

* Enable Hermes engine
* Optimize bridge usage

---

# 11. Fintech Rules

## 11.1 Login Flow

* Must be fast
* Avoid unnecessary checks before showing UI

## 11.2 Dashboard

* Show skeleton/loading state
* Do not block rendering

---

# 12. Metrics

* App launch time
* Time to first render
* Time to interactive

---

# 13. Tools

* React Native Performance Monitor
* Flipper
* Android Studio Profiler
* Xcode Instruments

---

# 14. Common Anti-patterns

* Loading all data before UI render
* Heavy synchronous logic on startup
* Large bundle size
* Blocking network calls

---

# 15. Checklist

* [ ] Minimal startup logic
* [ ] Non-critical tasks deferred
* [ ] Bundle size optimized
* [ ] Splash screen handled correctly
* [ ] No blocking API calls
* [ ] First screen loads fast

---

# 16. Final Rule

> Startup performance defines user perception.
> Optimize first render, then load everything else progressively.

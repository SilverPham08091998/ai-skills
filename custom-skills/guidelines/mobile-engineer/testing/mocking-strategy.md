# testing/mocking-strategy.md

## Objective

Define a clear, consistent mocking strategy for React Native applications to keep tests fast, deterministic, and meaningful—especially for fintech/banking flows.

Applies to:

* Jest
* @testing-library/react-native
* Redux/RTK/Observable
* Network (Axios/Fetch), storage, native modules

Main rule:

> Mock at system boundaries, not inside the behavior under test.
> Over-mocking reduces confidence; under-mocking makes tests flaky.

---

# 1. Core Principles

## 1.1 Boundary-first Mocking

Mock only external dependencies:

* HTTP (API)
* Storage (Keychain/AsyncStorage)
* Native modules (biometric, FS, etc.)

Do NOT mock:

* reducers/selectors
* pure business logic
* component behavior under test

---

## 1.2 Deterministic & Isolated

* No real network
* No real time (use fake timers if needed)
* No shared mutable state between tests

---

## 1.3 Prefer Real Implementations Inside the Slice

* Use real reducers/thunks/epics
* Mock only the edges

---

# 2. Mocking Layers (Recommended)

```txt
UI (real)
↓
State (real)
↓
Repository (real)
↓
HTTP (mocked)  ← boundary
```

---

# 3. What to Mock

## 3.1 Network Layer

Options:

* Axios mock adapter
* MSW (recommended for integration-like tests)

```ts
jest.mock('axios');
(axios.get as jest.Mock).mockResolvedValue({ data: mockData });
```

Rules:

* Centralize mock setup
* Do not mock per-component unless necessary

---

## 3.2 Storage

```ts
jest.mock('../secureStorage', () => ({
  getItem: jest.fn(),
  setItem: jest.fn(),
}));
```

Rules:

* Never use real Keychain/Keystore in tests

---

## 3.3 Native Modules

```ts
jest.mock('react-native-biometrics', () => ({
  simplePrompt: jest.fn().mockResolvedValue({ success: true }),
}));
```

---

## 3.4 Time & Timers

```ts
jest.useFakeTimers();
jest.advanceTimersByTime(1000);
```

---

# 4. What NOT to Mock

* Reducers
* Selectors
* Pure functions
* Component internal state

Bad:

```ts
jest.spyOn(reducer, 'updateState');
```

---

# 5. Mock Patterns

## 5.1 Static Mock

```ts
(api.fetch as jest.Mock).mockResolvedValue({ data: mockData });
```

## 5.2 Dynamic Mock

```ts
(api.transfer as jest.Mock).mockImplementation((req) => {
  if (req.amount > 1000) throw buildBusinessError('LIMIT');
  return success;
});
```

## 5.3 Scenario-based Mock

```ts
enum Scenario { SUCCESS, ERROR, TIMEOUT }

function mockTransfer(s: Scenario) {
  switch (s) {
    case Scenario.SUCCESS:
      return Promise.resolve(success);
    case Scenario.ERROR:
      return Promise.reject(buildBusinessError('ERR'));
    case Scenario.TIMEOUT:
      return new Promise(() => {});
  }
}
```

---

# 6. Test Data Builders

```ts
function buildUser(overrides = {}) {
  return { id: 'u1', name: 'Test', ...overrides };
}
```

Benefits:

* Reusable
* Clear intent
* Easy overrides

---

# 7. Reset & Cleanup

```ts
afterEach(() => {
  jest.clearAllMocks();
  jest.resetModules();
});
```

Rules:

* Do not leak mocks between tests

---

# 8. MSW (Recommended for Integration)

* Intercept HTTP at network layer
* Keep repository/state real

```ts
import { rest } from 'msw';

export const handlers = [
  rest.post('/transfer', (req, res, ctx) => {
    return res(ctx.json(success));
  }),
];
```

---

# 9. Fintech Rules (CRITICAL)

## 9.1 Money Flows

* Mock API responses only
* Keep flow real (UI → state → repo)

## 9.2 Error Coverage

* business errors
* network errors
* timeout/ambiguous states

## 9.3 Idempotency

* simulate duplicate submit
* verify no double execution

---

# 10. Anti-patterns

* Over-mocking (mock everything)
* Mocking internals of the unit under test
* Using real network/storage
* Global mocks that hide test intent

---

# 11. Checklist

* [ ] Mock only boundaries (HTTP, storage, native)
* [ ] Real reducers/thunks/epics used
* [ ] Deterministic (no randomness/time)
* [ ] Mocks reset between tests
* [ ] Critical scenarios covered

---

# 12. Final Rule

> Mocking is a tool to isolate behavior, not to fake correctness.
> Keep the core flow real and mock only the edges for high-confidence tests.

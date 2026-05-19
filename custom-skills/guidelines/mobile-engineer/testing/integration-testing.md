# testing/integration-testing.md

## Objective

Define standards for integration testing in React Native applications to verify interactions between modules (UI ↔ state ↔ network ↔ storage) with high confidence, especially for fintech/banking flows.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Features/modules (e.g., transfer, auth, payments)
* Repository/API layer, state management (Redux/RTK/Observable), navigation

Main rule:

> Test real interactions between layers with controlled dependencies.
> Mock at system boundaries, not within the flow under test.

---

# 1. Core Principles

## 1.1 Behavior Over Implementation

* Validate user-visible outcomes and side effects
* Do not assert internal function calls unless necessary

## 1.2 Controlled Environment

* No real network
* No real timers (unless controlled)
* Deterministic data and time

## 1.3 Test the Slice, Not the World

* Integrate modules within a feature boundary
* Mock external systems (HTTP, storage, device APIs)

---

# 2. Test Scope Definition

## 2.1 What to Include

* Component(s)
* State layer (Redux/RTK/Observable)
* Repository layer (with mocked HTTP)
* Navigation (lightweight)

## 2.2 What to Mock

* HTTP client (Axios/Fetch)
* Secure storage / Async storage
* Native modules (biometric, file system)

---

# 3. Recommended Stack

* Jest
* @testing-library/react-native
* MSW (Mock Service Worker) or Axios mock adapter
* Redux test utilities (configureStore)

---

# 4. Folder & Naming

```txt
__tests__/
  integration/
    transfer.integration.test.ts
    auth.integration.test.ts
```

Naming:

```txt
<feature>.integration.test.ts
```

---

# 5. Setup Utilities

## 5.1 Render with Providers

```ts
function renderWithProviders(ui: React.ReactElement, { store } = {}) {
  return render(
    <Provider store={store}>
      {ui}
    </Provider>
  );
}
```

## 5.2 Mock HTTP (example: axios)

```ts
import axios from 'axios';
jest.mock('axios');

(axios.post as jest.Mock).mockResolvedValue({ data: mockResponse });
```

---

# 6. Example: Transfer Flow

```ts
it('submits transfer and shows success', async () => {
  (api.transfer as jest.Mock).mockResolvedValue({ status: 'SUCCESS' });

  const { getByText, findByText } = renderWithProviders(<TransferScreen />, { store });

  fireEvent.changeText(getByPlaceholderText('Amount'), '1000');
  fireEvent.press(getByText('Submit'));

  expect(await findByText('Success')).toBeTruthy();
});
```

Rules:

* Assert final UI state
* Avoid asserting intermediate implementation details

---

# 7. Error & Edge Cases

## 7.1 Business Error

```ts
(api.transfer as jest.Mock).mockRejectedValue(buildBusinessError('INSUFFICIENT_BALANCE'));

expect(await findByText('Insufficient balance')).toBeTruthy();
```

## 7.2 Network/Timeout

* Simulate timeout error
* Verify fallback UI / retry state

---

# 8. State Management Integration

## 8.1 Redux Toolkit

* Use real reducers
* Dispatch real thunks

```ts
await store.dispatch(submitTransfer(payload));
```

## 8.2 Observable/Epics

* Use real epics
* Mock HTTP layer only

---

# 9. Navigation Integration (Lightweight)

* Mock navigation where needed
* Verify navigation side effects

```ts
expect(mockNavigate).toHaveBeenCalledWith('SuccessScreen');
```

---

# 10. Time Control

```ts
jest.useFakeTimers();

jest.advanceTimersByTime(1000);
```

Rules:

* Control timers explicitly
* Avoid real-time waits

---

# 11. Data Builders (Recommended)

Create test data factories:

```ts
function buildTransferRequest(overrides = {}) {
  return {
    amount: 1000,
    account: '123',
    ...overrides,
  };
}
```

Benefits:

* Reusable
* Clear intent

---

# 12. Fintech Rules (CRITICAL)

## 12.1 Critical Flows to Cover

* request → confirm → verify
* idempotency behavior (no duplicate submission)
* error handling (business/network)

## 12.2 Ambiguous Outcomes

* Simulate timeout after submit
* Verify status inquiry path (if implemented)

## 12.3 Security States

* 401 → logout flow
* 403 → permission UI

---

# 13. Anti-patterns

* Mocking internal functions of the unit under test
* Asserting private state
* Over-mocking (losing integration value)
* Using real network/storage
* Flaky tests with uncontrolled timers

---

# 14. Performance Guidelines

* Keep tests under ~50ms where possible
* Limit heavy renders
* Parallelize tests (default Jest behavior)

---

# 15. Checklist

* [ ] External systems mocked (HTTP, storage)
* [ ] Real reducers/epics used
* [ ] UI behavior asserted (not internals)
* [ ] Error paths covered
* [ ] Timers controlled
* [ ] No flaky tests

---

# 16. Final Rule

> Integration tests give confidence that modules work together.
> Mock only at the boundaries and validate real user flows end-to-end within the app.

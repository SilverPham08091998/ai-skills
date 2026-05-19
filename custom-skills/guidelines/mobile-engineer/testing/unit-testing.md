# testing/unit-testing.md

## Objective

Define standards for unit testing in React Native applications to ensure correctness of small, isolated units of logic (functions, hooks, services) with fast feedback.

Applies to:

* React Native (iOS + Android)
* TypeScript
* Utilities, services, hooks, reducers

Main rule:

> Unit tests validate logic in isolation.
> If a test depends on multiple layers, it is NOT a unit test.

---

# 1. Core Principles

## 1.1 Isolation

* Test a single unit only
* Mock all dependencies

## 1.2 Deterministic

* Same input → same output
* No randomness, no real time

## 1.3 Fast

* Execution in milliseconds
* No heavy setup

---

# 2. What is a Unit?

Valid units:

* pure functions
* utility helpers
* reducers
* hooks (with controlled deps)
* small services

Not unit tests:

* UI + API + state together
* full user flows

---

# 3. Test Structure

```ts
describe('<function name>', () => {
  it('should <expected behavior>', () => {
    // arrange
    // act
    // assert
  });
});
```

---

# 4. Example: Pure Function

```ts
function sum(a: number, b: number) {
  return a + b;
}

it('should add numbers correctly', () => {
  expect(sum(1, 2)).toBe(3);
});
```

---

# 5. Example: Reducer

```ts
it('should update state correctly', () => {
  const initial = { count: 0 };
  const action = { type: 'INCREMENT' };

  const result = reducer(initial, action);

  expect(result.count).toBe(1);
});
```

---

# 6. Example: Hook

```ts
const { result } = renderHook(() => useCounter());

act(() => {
  result.current.increment();
});

expect(result.current.count).toBe(1);
```

---

# 7. Mocking Rules

* Mock all external dependencies

```ts
jest.mock('../api');
```

* Use jest.fn()

```ts
const mockFn = jest.fn();
```

---

# 8. Async Testing

```ts
it('should fetch data', async () => {
  const result = await fetchData();
  expect(result).toEqual(mockData);
});
```

---

# 9. Error Testing

```ts
await expect(fetchData()).rejects.toThrow();
```

---

# 10. Edge Cases

Always test:

* null/undefined
* empty values
* boundary values

---

# 11. Fintech Rules

## 11.1 Critical Logic

Must unit test:

* validation rules
* calculation logic
* business rules

## 11.2 Deterministic Behavior

* no dependency on time
* no dependency on network

---

# 12. Anti-patterns

* testing multiple layers
* relying on real APIs
* flaky tests
* asserting implementation details

---

# 13. Checklist

* [ ] Unit is isolated
* [ ] Dependencies mocked
* [ ] Tests are deterministic
* [ ] Edge cases covered
* [ ] Fast execution

---

# 14. Final Rule

> Unit tests protect your core logic.
> If unit tests fail, your foundation is broken.

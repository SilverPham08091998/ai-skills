# testing/jest-testing.md

## Objective

Define standards for unit testing using Jest in React Native applications to ensure reliability, maintainability, and fast feedback loops (critical for fintech/banking apps).

Applies to:

* React Native (iOS + Android)
* TypeScript
* Business logic, hooks, utilities, components

Main rule:

> Tests must be fast, deterministic, and isolated.
> Focus on behavior, not implementation details.

---

# 1. Core Principles

## 1.1 Deterministic Tests

* No randomness
* No dependency on external systems

## 1.2 Fast Execution

* Unit tests should run in milliseconds
* Avoid heavy setup

## 1.3 Isolation

* Mock all external dependencies

---

# 2. Test Structure

## 2.1 File Naming

```txt
*.test.ts
*.spec.ts
```

## 2.2 Folder Structure

```txt
__tests__/
  utils/
  hooks/
  components/
```

---

# 3. Basic Example

```ts
describe('sum', () => {
  it('should return correct result', () => {
    expect(sum(1, 2)).toBe(3);
  });
});
```

---

# 4. Mocking

## 4.1 Mock Functions

```ts
const mockFn = jest.fn();
```

## 4.2 Mock Modules

```ts
jest.mock('../api');
```

## 4.3 Mock API Calls

```ts
(api.fetchData as jest.Mock).mockResolvedValue(mockData);
```

---

# 5. Testing Async Code

```ts
it('fetches data', async () => {
  const result = await fetchData();
  expect(result).toEqual(mockData);
});
```

---

# 6. Testing React Components

Use:

* @testing-library/react-native

Example:

```ts
render(<MyComponent />);
expect(screen.getByText('Hello')).toBeTruthy();
```

Rules:

* Test UI behavior, not internal state

---

# 7. Testing Hooks

Use:

* @testing-library/react-hooks (or built-in utils)

---

# 8. Snapshot Testing

```ts
expect(tree).toMatchSnapshot();
```

Rules:

* Use sparingly
* Avoid large snapshots

---

# 9. Coverage

* Aim for meaningful coverage (>60%)
* Focus on critical logic

---

# 10. Fintech Rules

## 10.1 Critical Flows

* transaction logic
* validation rules
* error handling

Must be fully tested

---

## 10.2 Avoid Flaky Tests

* no timers without control
* no network calls

---

# 11. Common Anti-patterns

* testing implementation details
* overusing snapshots
* not mocking dependencies
* slow tests

---

# 12. Checklist

* [ ] Tests are deterministic
* [ ] External dependencies mocked
* [ ] Critical logic covered
* [ ] Fast execution
* [ ] No flaky tests

---

# 13. Final Rule

> Good tests increase confidence and speed up development.
> Bad tests slow you down and provide false confidence.

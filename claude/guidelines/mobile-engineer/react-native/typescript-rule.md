# react-native/typescript-rule.md

## Objective

Define TypeScript standards for React Native applications to ensure type safety, maintainability, and scalability in fintech/banking systems.

Applies to:

* React Native (iOS + Android)
* TypeScript
* All layers (UI, state, API, domain)

Main rule:

> Types are part of your architecture.
> Poor typing leads to runtime bugs and fragile code.

---

# 1. Core Principles

## 1.1 Strict Type Safety

* Enable strict mode

```json
"strict": true
```

* Avoid `any`

Bad:

```ts
const data: any = response;
```

Good:

```ts
const data: UserResponse = response;
```

---

## 1.2 Explicit Over Implicit

* Always define return types for functions

```ts
function sum(a: number, b: number): number {
  return a + b;
}
```

---

## 1.3 Domain-driven Types

* Types must reflect business meaning

Bad:

```ts
type Data = { value: number };
```

Good:

```ts
type Balance = { amount: number };
```

---

# 2. Type Organization

Recommended structure:

```txt
types/
  api/
  domain/
  ui/
```

Rules:

* Separate API types from domain models
* Avoid leaking API response types into UI

---

# 3. Interface vs Type

Use:

* `type` for unions, utility types
* `interface` for object contracts

```ts
interface User {
  id: string;
}


type Status = 'ACTIVE' | 'LOCKED';
```

---

# 4. Optional & Nullable

## 4.1 Explicit Null Handling

```ts
name?: string; // optional
name: string | null; // explicit null
```

Rules:

* Prefer explicit null over undefined for API data

---

# 5. API Typing

## 5.1 Separate DTOs

```ts
type UserResponse = {
  id: string;
  full_name: string;
};
```

## 5.2 Mapping to Domain

```ts
function mapUser(res: UserResponse): User {
  return {
    id: res.id,
    name: res.full_name,
  };
}
```

---

# 6. Generics

Use generics for reusable logic

```ts
function identity<T>(value: T): T {
  return value;
}
```

---

# 7. Enums vs Union Types

Prefer union types

```ts
type Status = 'SUCCESS' | 'FAILED';
```

Avoid:

```ts
enum Status { SUCCESS, FAILED }
```

---

# 8. Utility Types

Use built-in helpers

```ts
Partial<T>
Pick<T, K>
Omit<T, K>
Record<K, T>
```

---

# 9. Component Props

```ts
type Props = {
  title: string;
  onPress: () => void;
};
```

Rules:

* Avoid passing large objects
* Keep props minimal

---

# 10. Hooks Typing

```ts
function useUser(): User {
  return user;
}
```

---

# 11. Error Handling Types

```ts
type AppError = {
  code: string;
  message: string;
};
```

---

# 12. Fintech Rules

## 12.1 Money Types

```ts
type Money = {
  amount: number;
  currency: string;
};
```

* Never use plain number for money everywhere

---

## 12.2 Status Types

```ts
type TransactionStatus = 'PENDING' | 'SUCCESS' | 'FAILED';
```

---

## 12.3 API Safety

* Always validate API response before use

---

# 13. Anti-patterns

* using `any`
* mixing API & domain types
* large untyped objects
* implicit return types

---

# 14. Checklist

* [ ] strict mode enabled
* [ ] no `any`
* [ ] API & domain separated
* [ ] union types used
* [ ] types reflect business meaning

---

# 15. Final Rule

> Strong typing prevents bugs before runtime.
> Treat TypeScript as a design tool, not just a compiler.

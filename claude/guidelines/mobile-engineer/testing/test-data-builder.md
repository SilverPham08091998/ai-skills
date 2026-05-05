# testing/test-data-builder.md

## Objective

Define standards for creating reusable test data builders in React Native applications to keep tests clean, readable, deterministic, and scalable.

Applies to:

* Jest
* Unit tests
* Integration tests
* E2E test setup
* TypeScript models, DTOs, API responses

Main rule:

> Tests should describe behavior, not spend most of their code building objects.
> Use test data builders to create valid defaults and override only what matters.

---

# 1. Core Principles

## 1.1 Valid by Default

Every builder must return a valid object by default.

Bad:

```ts
const user = {};
```

Good:

```ts
const user = buildUser();
```

---

## 1.2 Override Only What Matters

```ts
const user = buildUser({ status: 'LOCKED' });
```

Rules:

* Do not repeat full object setup in every test
* Each test should highlight only the field relevant to the scenario

---

## 1.3 Deterministic Data

* Avoid random values unless explicitly needed
* Prefer stable IDs and timestamps

Bad:

```ts
id: Math.random().toString()
```

Good:

```ts
id: 'user-001'
```

---

# 2. Basic Builder Pattern

```ts
type User = {
  id: string;
  name: string;
  phone: string;
  status: 'ACTIVE' | 'LOCKED';
};

export function buildUser(overrides: Partial<User> = {}): User {
  return {
    id: 'user-001',
    name: 'Test User',
    phone: '0900000000',
    status: 'ACTIVE',
    ...overrides,
  };
}
```

Usage:

```ts
const lockedUser = buildUser({ status: 'LOCKED' });
```

---

# 3. API Response Builder

```ts
type ApiResponse<T> = {
  code: string;
  message: string;
  data: T;
};

export function buildApiResponse<T>(data: T, overrides: Partial<ApiResponse<T>> = {}): ApiResponse<T> {
  return {
    code: 'SUCCESS',
    message: 'Success',
    data,
    ...overrides,
  };
}
```

Usage:

```ts
const response = buildApiResponse(buildUser());
```

---

# 4. Error Builder

```ts
export function buildAppError(overrides: Partial<AppError> = {}): AppError {
  return {
    code: 'UNKNOWN_ERROR',
    message: 'Something went wrong',
    type: AppErrorType.UNKNOWN,
    ...overrides,
  };
}
```

Scenario examples:

```ts
const networkError = buildAppError({
  code: 'NETWORK_ERROR',
  type: AppErrorType.NETWORK,
});

const insufficientBalance = buildAppError({
  code: 'INSUFFICIENT_BALANCE',
  type: AppErrorType.BUSINESS,
});
```

---

# 5. Fintech Builder Examples

## 5.1 Transfer Request

```ts
type TransferRequest = {
  fromAccount: string;
  toAccount: string;
  amount: number;
  currency: string;
  note?: string;
};

export function buildTransferRequest(overrides: Partial<TransferRequest> = {}): TransferRequest {
  return {
    fromAccount: 'ACC-001',
    toAccount: 'ACC-002',
    amount: 100000,
    currency: 'VND',
    note: 'Test transfer',
    ...overrides,
  };
}
```

## 5.2 Transfer Response

```ts
type TransferResponse = {
  transactionId: string;
  status: 'PENDING' | 'SUCCESS' | 'FAILED';
};

export function buildTransferResponse(overrides: Partial<TransferResponse> = {}): TransferResponse {
  return {
    transactionId: 'tx-001',
    status: 'SUCCESS',
    ...overrides,
  };
}
```

---

# 6. Builder Organization

Recommended structure:

```txt
src/
  test/
    builders/
      user.builder.ts
      auth.builder.ts
      transfer.builder.ts
      api-response.builder.ts
      error.builder.ts
```

Rules:

* Group builders by domain/feature
* Reuse shared builders for common objects
* Do not place builders inside production source unless explicitly shared for test fixtures only

---

# 7. Nested Builders

Use builders inside builders for nested objects.

```ts
export function buildUserProfile(overrides: Partial<UserProfile> = {}): UserProfile {
  return {
    user: buildUser(),
    accounts: [buildAccount()],
    ...overrides,
  };
}
```

Rules:

* Keep defaults valid
* Allow override at each level

---

# 8. Scenario Builders

For common business scenarios, provide named scenario builders.

```ts
export function buildLockedUser(): User {
  return buildUser({ status: 'LOCKED' });
}

export function buildSuccessfulTransfer(): TransferResponse {
  return buildTransferResponse({ status: 'SUCCESS' });
}

export function buildPendingTransfer(): TransferResponse {
  return buildTransferResponse({ status: 'PENDING' });
}
```

Rules:

* Use scenario builders for business meaning
* Do not hide too much data when the field matters to the test

---

# 9. Faker / Random Data Rule

Avoid random data by default.

Allowed only when:

* testing uniqueness
* testing formatting robustness
* property-based style tests

Rules:

* Seed random generators if used
* Do not use random data for normal unit tests

---

# 10. E2E Test Data

For E2E:

* Use seeded backend data
* Use dedicated test accounts
* Avoid creating uncontrolled data in test runtime

Example:

```txt
E2E_USER_ACTIVE
E2E_USER_LOCKED
E2E_USER_LOW_BALANCE
```

---

# 11. Fintech Rules (CRITICAL)

## 11.1 Money Values

* Use realistic values
* Include boundary values

Examples:

```ts
buildTransferRequest({ amount: 0 });
buildTransferRequest({ amount: 1 });
buildTransferRequest({ amount: 100000000 });
```

## 11.2 Transaction Status

Always provide builders for:

* SUCCESS
* FAILED
* PENDING
* EXPIRED

## 11.3 Sensitive Data

* Use fake data only
* Never use real customer data
* Mask fields when required

---

# 12. Anti-patterns

* Copy-pasting large objects in every test
* Using random values everywhere
* Building invalid objects by default
* Hiding important test data inside too many helper layers
* Reusing production data samples containing real user info

---

# 13. Checklist

* [ ] Builders return valid defaults
* [ ] Overrides supported
* [ ] Deterministic data used
* [ ] Builders organized by feature/domain
* [ ] Scenario builders exist for critical flows
* [ ] No real customer data used

---

# 14. Final Rule

> Test data builders make tests easier to read and maintain.
> Build valid defaults, override only what matters, and keep data determinist

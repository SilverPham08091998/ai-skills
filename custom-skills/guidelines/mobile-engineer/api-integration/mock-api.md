# api-integration/mock-api.md

## Objective

Standardize how the mobile application mocks APIs for development, testing, and offline scenarios.

Applies to:

* React Native
* TypeScript
* Axios / Fetch
* Redux / RTK / Redux Observable
* Mobile Clean Architecture
* Fintech / Banking applications

Main rule:

> Mocking must be controllable, predictable, and isolated from business logic.
> Do not mix mock logic directly inside production code paths.

---

# 1. Core Principles

## 1.1 Mock must be optional and switchable

Mocking must be enabled/disabled via configuration.

```ts
export const ENABLE_API_MOCK = __DEV__ && process.env.ENABLE_API_MOCK === 'true';
```

Rules:

* Never hardcode mock inside API functions
* Must be toggled via env/config
* Production build must not use mock

---

## 1.2 Do not mix mock logic with business logic

Bad:

```ts
if (__DEV__) {
  return fakeResponse;
}
```

Good:

```ts
if (ENABLE_API_MOCK) {
  return mockHandler.handle(request);
}

return realHttpClient(request);
```

---

## 1.3 Use centralized mock layer

Recommended structure:

```txt
src/
  infrastructure/
    network/
      httpClient.ts
      mock/
        mockHandler.ts
        mockRegistry.ts
        mocks/
          transfer.mock.ts
          auth.mock.ts
          user.mock.ts
```

---

# 2. Mock Strategy Options

## 2.1 Static Mock

Return fixed JSON.

```ts
export const mockTransferSuccess = {
  transactionId: 'tx-123',
  status: 'SUCCESS',
};
```

Use case:

* UI development
* basic flow testing

---

## 2.2 Dynamic Mock

Return data based on input.

```ts
export function mockTransfer(request: TransferRequest) {
  if (request.amount > 1000000) {
    throw buildBusinessError('LIMIT_EXCEEDED');
  }

  return {
    transactionId: generateId(),
    status: 'SUCCESS',
  };
}
```

Use case:

* simulate business rules
* test edge cases

---

## 2.3 Scenario-based Mock

Allow switching between scenarios.

```ts
export enum TransferMockScenario {
  SUCCESS = 'SUCCESS',
  INSUFFICIENT_BALANCE = 'INSUFFICIENT_BALANCE',
  TIMEOUT = 'TIMEOUT',
}
```

```ts
export function mockTransferScenario(scenario: TransferMockScenario) {
  switch (scenario) {
    case TransferMockScenario.SUCCESS:
      return successResponse;

    case TransferMockScenario.INSUFFICIENT_BALANCE:
      throw buildBusinessError('INSUFFICIENT_BALANCE');

    case TransferMockScenario.TIMEOUT:
      throw buildTimeoutError();
  }
}
```

Use case:

* QA testing
* demo flows
* error simulation

---

# 3. Mock Handler

Central entry for all mock requests.

```ts
export class MockHandler {
  handle(request: HttpRequest) {
    const mock = mockRegistry[request.path];

    if (!mock) {
      throw new Error(`No mock defined for ${request.path}`);
    }

    return mock(request);
  }
}
```

---

# 4. Mock Registry

```ts
export const mockRegistry: Record<string, Function> = {
  '/api/v1/transfer': mockTransfer,
  '/api/v1/login': mockLogin,
};
```

Rules:

* Map by endpoint path or key
* Do not scatter mock across files
* Keep mapping centralized

---

# 5. Integrate with HTTP Client

```ts
async function request(config: HttpRequest) {
  if (ENABLE_API_MOCK) {
    return mockHandler.handle(config);
  }

  return axios(config);
}
```

Rules:

* Mock must be injected at network layer
* Do not modify repository layer for mocking

---

# 6. Error Mocking

Always reuse AppError format.

```ts
function buildBusinessError(code: string): AppError {
  return {
    code,
    message: 'Mocked business error',
    type: AppErrorType.BUSINESS,
  };
}
```

```ts
function buildTimeoutError(): AppError {
  return {
    code: 'TIMEOUT_ERROR',
    message: 'Mock timeout',
    type: AppErrorType.TIMEOUT,
  };
}
```

Rules:

* Mock error must match real API error structure
* Do not throw random error shape

---

# 7. Delay Simulation

Simulate network delay.

```ts
function delay(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
```

```ts
await delay(1000);
```

Use case:

* loading state testing
* UX behavior

---

# 8. Fintech Rules

## 8.1 Must simulate real flows

Mock must support:

* request → confirm → verify
* success / failure / pending
* OTP flow

---

## 8.2 Do not fake success only

Bad:

* always return success

Good:

* simulate failure cases
* simulate timeout
* simulate partial flow

---

## 8.3 Simulate transaction state

```ts
status: 'PENDING' | 'SUCCESS' | 'FAILED'
```

---

# 9. Logging Rule

Mock logs must be visible in dev mode.

```ts
console.log('[MOCK_API]', request.path);
```

Rules:

* Must not log in production
* Must not log sensitive data

---

# 10. Test Integration

Mock must be reusable for:

* unit test
* integration test
* storybook

---

# 11. Checklist

* [ ] Mock is configurable via env
* [ ] Mock is centralized
* [ ] Mock does not leak into production
* [ ] Error shape matches AppError
* [ ] Supports multiple scenarios
* [ ] Supports delay simulation

---

# 12. Final Rule

> Mock API must behave like real API as much as possible.
> It must support success, failure, timeout, and business scenarios.
> Mocking is a tool for development and testing, not a shortcut for skipping real integration.

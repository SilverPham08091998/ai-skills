# TypeScript — Error Handling Patterns

## 1. Custom Error Classes — typed error hierarchy

```typescript
// Base error — tất cả app errors kế thừa từ đây
class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500,
  ) {
    super(message);
    this.name = this.constructor.name;
    // Fix prototype chain cho instanceof checks
    Object.setPrototypeOf(this, new.target.prototype);
  }
}

// Domain errors — vi phạm business rule
class DomainError extends AppError {
  constructor(message: string, code: string) {
    super(message, code, 422);
  }
}

// Infrastructure errors — network, DB, storage
class InfrastructureError extends AppError {
  constructor(message: string, public readonly cause?: Error) {
    super(message, 'INFRASTRUCTURE_ERROR', 500);
  }
}

// Specific domain errors
class NotFoundError extends DomainError {
  constructor(resource: string, id: string) {
    super(`${resource} with id "${id}" not found`, 'NOT_FOUND');
  }
}

class ValidationError extends DomainError {
  constructor(
    public readonly field: string,
    message: string,
  ) {
    super(message, 'VALIDATION_ERROR');
  }
}

class UnauthorizedError extends AppError {
  constructor(message = 'Unauthorized') {
    super(message, 'UNAUTHORIZED', 401);
  }
}

// Dùng
if (!user) throw new NotFoundError('User', userId);
if (amount < 0) throw new ValidationError('amount', 'Amount must be positive');
if (!session) throw new UnauthorizedError();
```

---

## 2. Result Type — expected failures không dùng throw

```typescript
// Expected failures = nghiệp vụ bình thường (validation fail, không tìm thấy...)
// → Dùng Result type, không throw exception

type Result<T, E = AppError> =
  | { ok: true; value: T }
  | { ok: false; error: E };

// Helpers
function ok<T>(value: T): Result<T> {
  return { ok: true, value };
}
function fail<T = never, E extends AppError = AppError>(error: E): Result<T, E> {
  return { ok: false, error };
}

// Domain service
function validateTransfer(
  amount: number,
  balance: number,
): Result<void, ValidationError> {
  if (amount <= 0) {
    return fail(new ValidationError('amount', 'Amount must be positive'));
  }
  if (amount > balance) {
    return fail(new ValidationError('amount', 'Insufficient balance'));
  }
  return ok(undefined);
}

// Caller — không cần try/catch
const validation = validateTransfer(params.amount, account.balance);
if (!validation.ok) {
  dispatch(showFieldError(validation.error.field, validation.error.message));
  return;
}
// Tiếp tục với transfer...

// ─────────────────────────────────────────
// Khi nào throw exception vs Result:
//
// throw      — unexpected errors (network down, DB crash, bug)
// Result     — expected business failures (validation, not found, limit exceeded)
```

---

## 3. Không swallow errors

```typescript
// ❌ — error bị nuốt, không ai biết xảy ra gì
try {
  await processOrder(order);
} catch {
  // nothing — nguy hiểm
}

// ❌ — log và tiếp tục như không có gì
try {
  await processOrder(order);
} catch (error) {
  console.error(error); // log nhưng không handle
}

// ✅ — handle hoặc rethrow có context
try {
  await processOrder(order);
} catch (error) {
  if (error instanceof NotFoundError) {
    return null; // graceful handle
  }
  if (error instanceof ValidationError) {
    throw error; // rethrow — caller cần biết
  }
  // Unexpected error — wrap với context
  throw new InfrastructureError(
    'Failed to process order',
    error instanceof Error ? error : undefined,
  );
}
```

---

## 4. Type-safe error narrowing trong catch

```typescript
// TypeScript 4.0+ — catch variable là unknown
try {
  await riskyOperation();
} catch (error: unknown) {
  // ❌ — TypeScript error: error is unknown
  console.error(error.message);

  // ✅ — narrow trước khi dùng
  if (error instanceof AppError) {
    handleAppError(error); // typed AppError
  } else if (error instanceof Error) {
    handleGenericError(error); // generic Error
  } else {
    handleUnknown(String(error));
  }
}

// Utility — normalize bất kỳ thrown value thành Error
function toError(value: unknown): Error {
  if (value instanceof Error) return value;
  if (typeof value === 'string') return new Error(value);
  return new Error(String(value));
}

// Error type guard
function isAppError(error: unknown): error is AppError {
  return error instanceof AppError;
}

function isDomainError(error: unknown): error is DomainError {
  return error instanceof DomainError;
}
```

---

## 5. Error trong async context

```typescript
// ❌ — unhandled promise rejection
async function loadData() {
  const data = await fetchFromApi(); // nếu throw → unhandled
  setData(data);
}

// ✅ — explicit error handling
async function loadData() {
  try {
    const data = await fetchFromApi();
    setData(data);
  } catch (error: unknown) {
    if (isAppError(error)) {
      setError(error.message);
    } else {
      setError('Unexpected error occurred');
      // log to monitoring
    }
  }
}

// ✅ — Promise chain với .catch()
fetchFromApi()
  .then(setData)
  .catch((error: unknown) => {
    setError(isAppError(error) ? error.message : 'Unknown error');
  });
```

---

## 6. Error Boundary trong React (Web/Mobile)

```typescript
// Catch unhandled render errors
class ErrorBoundary extends React.Component<
  { children: React.ReactNode; fallback: React.ReactNode },
  { hasError: boolean; error: Error | null }
> {
  state = { hasError: false, error: null };

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, info: React.ErrorInfo) {
    // Log to monitoring (Sentry, etc.)
    logError(error, info);
  }

  render() {
    if (this.state.hasError) return this.props.fallback;
    return this.props.children;
  }
}
```

---

## 7. Never throw trong domain layer

```typescript
// Domain layer không throw — trả về Result hoặc typed error value
// Chỉ infrastructure layer throw (network error, parse error)

// ❌ — domain service throw
class FeeCalculationService {
  calculate(amount: number): number {
    if (amount < 0) throw new Error('Invalid amount'); // domain không nên throw
    return amount * this.rate;
  }
}

// ✅ — domain service trả về Result
class FeeCalculationService {
  calculate(amount: number): Result<number, ValidationError> {
    if (amount < 0) return fail(new ValidationError('amount', 'Must be positive'));
    return ok(amount * this.rate);
  }
}
```

---

## 8. Global Error Handler

```typescript
// Catch tất cả unhandled errors
process.on('unhandledRejection', (reason: unknown) => {
  const error = toError(reason);
  logger.error('Unhandled rejection', { error });
  // Không exit process — chỉ log
});

// React Native — global JS error handler
ErrorUtils.setGlobalHandler((error: Error, isFatal?: boolean) => {
  logger.error('Global error', { error, isFatal });
  if (isFatal) {
    // Show crash screen
  }
});
```

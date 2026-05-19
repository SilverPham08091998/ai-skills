# TypeScript — Naming Conventions

## 1. Bảng convention tổng hợp

| Context | Convention | Ví dụ |
|---|---|---|
| Variable, function | `camelCase` | `getUserById`, `totalAmount` |
| Class, Interface, Type, Enum | `PascalCase` | `UserEntity`, `OrderStatus` |
| Interface prefix | `I` + PascalCase | `IUserRepository` |
| Enum values | `PascalCase` | `OrderStatus.Active` |
| Constants (module-level) | `SCREAMING_SNAKE_CASE` | `MAX_RETRY_COUNT` |
| Generic type param | `T` hoặc `T` + Noun | `T`, `TEntity`, `TParam` |
| Private class field | `_camelCase` hoặc `#camelCase` | `_cache`, `#config` |
| Boolean variable | `is/has/can/should` prefix | `isLoading`, `hasError` |
| Event handler prop | `on` + Event | `onPress`, `onChange` |
| Event handler function | `handle` + Event | `handleSubmit`, `handlePress` |
| Type predicate function | `is` + Type | `isUserEntity`, `isString` |
| Factory function | `create` + Type | `createDefaultConfig` |

---

## 2. Tên phải mô tả intent, không phải implementation

```typescript
// ❌ — tên mô tả "cái gì", không phải "tại sao"
const arr = users.filter(u => u.active);
const flag = count > 0;
function doStuff(data: unknown) { ... }
const x = total * 0.1;

// ✅ — tên mô tả intent
const activeUsers = users.filter(u => u.active);
const hasResults = count > 0;
function parseApiResponse(data: unknown): UserEntity { ... }
const serviceFee = total * SERVICE_FEE_RATE;
```

---

## 3. Function naming patterns

```typescript
// Getter — get + Noun hoặc noun phrase
function getUserById(id: string): UserEntity | null
function getFullName(user: User): string
function fullName(user: User): string  // OK khi context rõ

// Action — Verb + Object
function submitOrder(order: Order): Promise<void>
function cancelSubscription(id: string): Promise<void>
function refreshToken(): Promise<string>

// Predicate — is/has/can + Condition
function isEligibleForDiscount(user: User): boolean
function hasActiveSubscription(userId: string): boolean
function canWithdraw(account: Account, amount: Money): boolean

// Event handler
function handleFormSubmit(event: FormEvent): void
function handlePaymentError(error: PaymentError): void

// Factory
function createDefaultConfig(): AppConfig
function createOrderFromCart(cart: Cart): Order

// Async — KHÔNG thêm Async suffix
function fetchUser(id: string): Promise<UserEntity>    // ✅
function fetchUserAsync(id: string): Promise<UserEntity> // ❌
```

---

## 4. Generic type parameter naming

```typescript
// T đơn — khi context đủ rõ
interface Container<T> { value: T }
function identity<T>(value: T): T { return value }

// Descriptive — khi có nhiều type params
function map<TInput, TOutput>(arr: TInput[], fn: (item: TInput) => TOutput): TOutput[]
function transform<TSource, TTarget>(src: TSource, mapper: Mapper<TSource, TTarget>): TTarget

// Convention phổ biến:
// T, TEntity     — main entity/domain type
// TId            — identifier type
// TParam/TInput  — input parameter type
// TResult/TOutput — output/return type
// TError         — error type
// TKey, TValue   — map/dictionary key-value pair

interface Repository<TEntity, TId = string> {
  findById(id: TId): Promise<TEntity | null>;
  save(entity: TEntity): Promise<TEntity>;
}

type Handler<TParam, TResult, TError = Error> = (
  param: TParam,
) => Promise<Result<TResult, TError>>;
```

---

## 5. Boolean naming — luôn rõ ràng

```typescript
// ❌ — không rõ true/false nghĩa là gì
let status = true;
let mode = false;
let check = isValid && !isDuplicate;

// ✅ — đọc như câu hỏi yes/no
let isLoading = true;
let isSubmitting = false;
let hasValidationErrors = false;
let canRetry = retryCount < MAX_RETRIES;
let shouldShowBanner = user.isNew && !user.hasSeenBanner;

// ✅ — component props
interface ButtonProps {
  isDisabled?: boolean;
  isLoading?: boolean;
  isFullWidth?: boolean;
}

// ❌ — double negative khó đọc
let isNotEmpty = true;
let hasNoError = false;

// ✅ — positive framing
let isEmpty = false;
let hasError = true;
```

---

## 6. File naming conventions

| File type | Convention | Ví dụ |
|---|---|---|
| Component | `PascalCase.tsx` | `UserProfileCard.tsx` |
| Hook | `camelCase.ts` | `useUserProfile.ts` |
| Utility | `camelCase.ts` | `formatCurrency.ts` |
| Entity/Interface | `PascalCase.ts` | `UserEntity.ts` |
| Enum | `PascalCase.ts` | `OrderStatus.ts` |
| Repository | `PascalCase.ts` | `HttpUserRepository.ts` |
| Slice | `camelCase + Slice.ts` | `userSlice.ts` |
| Constants | `SCREAMING_SNAKE_CASE.ts` hoặc `camelCase.ts` | `apiEndpoints.ts` |
| Test | tên gốc + `.test.ts` | `UserEntity.test.ts` |
| Index/barrel | `index.ts` | `index.ts` |

---

## 7. Tránh các tên mơ hồ phổ biến

```typescript
// ❌ — quá generic
const data = await fetch();
const result = process(input);
const info = getDetails();
const temp = calculateSomething();
const val = getValue();
const obj = createObject();

// ✅ — cụ thể
const userProfile = await fetchUserProfile();
const validationResult = validateOrderInput(input);
const transactionDetails = getTransactionDetails(id);
const discountedPrice = calculateDiscountedPrice(price, coupon);
const orderTotal = getOrderTotal(cart);
const paymentConfig = createPaymentConfig(method);
```

---

## 8. Abbreviation — khi nào viết tắt

```typescript
// ✅ — abbreviation phổ biến, ai cũng hiểu
id, url, http, api, ui, db, dto, err, ctx, fn, cb

// ❌ — abbreviation nội bộ, không rõ ràng
const usr = getUser();    // → user
const amt = getAmount();  // → amount
const frq = frequency;    // → frequency
const cfg = config;       // → config (đôi khi OK nếu scope nhỏ)
const mgr = manager;      // → manager

// ✅ — viết đủ cho domain concepts
const beneficiaryAccount = getBeneficiaryAccount();
const transactionFee = calculateTransactionFee();
const scheduledTransfer = getScheduledTransfer();
```

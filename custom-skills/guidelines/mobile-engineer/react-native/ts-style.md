# TypeScript — Code Style

## 1. Destructuring — luôn dùng khi truy cập nhiều fields

```typescript
// ❌ — repetitive access
function greet(user: UserEntity): string {
  return `Hello ${user.profile.firstName} ${user.profile.lastName}, `
    + `you have ${user.notifications.unreadCount} notifications`;
}

// ✅ — destructure
function greet({ profile, notifications }: UserEntity): string {
  const { firstName, lastName } = profile;
  const { unreadCount } = notifications;
  return `Hello ${firstName} ${lastName}, you have ${unreadCount} notifications`;
}

// ✅ — rename khi có naming conflict
const { id: userId, name: userName } = user;
const { id: orderId, status: orderStatus } = order;

// ✅ — default values trong destructure
const { timeout = 30_000, retries = 3, debug = false } = config;

// ✅ — destructure trong function params
function processOrder({
  id,
  items,
  total,
  status = OrderStatus.Pending,
}: OrderEntity): void { ... }

// ❌ — destructure quá sâu gây mất context
const { a: { b: { c: { d } } } } = deeply.nested.object;
// → chỉ destructure 1-2 level, truy cập trực tiếp cho level sâu hơn
```

---

## 2. Spread — immutable updates

```typescript
// ❌ — mutate object trực tiếp
function updateUser(user: UserEntity, name: string): UserEntity {
  user.name = name; // mutation!
  return user;
}

// ✅ — spread tạo object mới
function updateUser(user: UserEntity, name: string): UserEntity {
  return { ...user, name };
}

// ✅ — nested immutable update
function updateCity(user: UserEntity, city: string): UserEntity {
  return {
    ...user,
    address: { ...user.address, city },
  };
}

// ✅ — merge objects
const merged = { ...defaults, ...userOverrides };

// ✅ — array spread (immutable)
const added = [...existingItems, newItem];
const removed = existingItems.filter(item => item.id !== targetId);
const updated = existingItems.map(item =>
  item.id === targetId ? { ...item, ...changes } : item,
);

// ❌ — spread quá nhiều lớp gây khó đọc và performance
const bad = { ...a, ...b, ...c, ...d, ...e, overrideProp: 'x' };
// → extract thành named steps
const withBase = { ...a, ...b };
const withExtensions = { ...withBase, ...c, ...d };
const final = { ...withExtensions, overrideProp: 'x' };
```

---

## 3. Magic numbers và strings — luôn đặt tên

```typescript
// ❌ — magic numbers
if (status === 200) { ... }
if (retries >= 3) { ... }
setTimeout(fn, 30000);
const fee = amount * 0.025;
if (password.length < 8) { ... }

// ✅ — named constants
const HTTP_OK = 200;
const MAX_RETRIES = 3;
const REQUEST_TIMEOUT_MS = 30_000;
const TRANSACTION_FEE_RATE = 0.025;
const MIN_PASSWORD_LENGTH = 8;

if (status === HTTP_OK) { ... }
if (retries >= MAX_RETRIES) { ... }
setTimeout(fn, REQUEST_TIMEOUT_MS);
const fee = amount * TRANSACTION_FEE_RATE;
if (password.length < MIN_PASSWORD_LENGTH) { ... }

// ✅ — nhóm constants liên quan vào object với as const
const LIMITS = {
  MIN_TRANSFER_AMOUNT: 1_000,
  MAX_TRANSFER_AMOUNT: 500_000_000,
  MAX_DAILY_TRANSFERS: 10,
  MAX_BENEFICIARIES: 50,
} as const;

// ✅ — numeric separator cho số lớn
const MAX_AMOUNT = 1_000_000_000;
const BATCH_SIZE = 10_000;
const ONE_HOUR_MS = 60 * 60 * 1_000;
```

---

## 4. Comment — chỉ giải thích WHY, không WHAT

```typescript
// ❌ — comment giải thích code (code tự giải thích được)
// Loop through users and filter active ones
const activeUsers = users.filter(u => u.isActive);

// ❌ — comment lặp lại tên function
// Get user by ID
function getUserById(id: string): UserEntity | null { ... }

// ❌ — outdated comment (khác với code)
// Returns user by email
function getUserById(id: string): UserEntity | null { ... }

// ❌ — TODO không có ticket
// TODO: fix this later
const workaround = hackySolution();

// ✅ — giải thích constraint ẩn
// Backend rounds down to avoid overdraft — never use Math.round
const fee = Math.floor(amount * FEE_RATE);

// ✅ — giải thích business rule không hiển nhiên
// VCB requires exactly 16 digits, padded with leading zeros
const accountNumber = id.padStart(16, '0');

// ✅ — giải thích workaround cho bug cụ thể
// React Native Animated has a known issue with nested transforms on Android < 10
// Using margin instead of translateX as workaround — remove after RN 0.80
const animatedStyle = { marginLeft: translateX };

// ✅ — TODO với ticket reference
// TODO [TICKET-1234]: Remove feature flag after A/B test concludes 2025-Q3
if (featureFlags.newCheckout) { ... }

// ✅ — document non-obvious ordering dependency
// authService.restore() must complete before router.init()
// router reads auth state synchronously during initialization
await authService.restore();
router.init();
```

---

## 5. Template Literals — ưu tiên hơn string concatenation

```typescript
// ❌ — concatenation
const message = 'Hello ' + user.name + ', you have ' + count + ' messages';
const url = baseUrl + '/api/v1/users/' + userId;

// ✅ — template literal
const message = `Hello ${user.name}, you have ${count} messages`;
const url = `${baseUrl}/api/v1/users/${userId}`;

// ✅ — multiline template literal
const query = `
  SELECT *
  FROM users
  WHERE status = '${UserStatus.Active}'
  ORDER BY created_at DESC
  LIMIT ${pageSize}
`;

// ✅ — tagged template literal cho type-safe SQL (với library)
const result = sql`SELECT * FROM users WHERE id = ${userId}`;
```

---

## 6. Object shorthand

```typescript
const name = 'Alice';
const age = 30;

// ❌
const user = { name: name, age: age };

// ✅ — shorthand
const user = { name, age };

// ✅ — method shorthand
const service = {
  // ❌
  getUser: function(id: string) { ... },
  // ✅
  getUser(id: string) { ... },
};
```

---

## 7. Conditional expressions — rõ ràng, không lồng nhau

```typescript
// ❌ — nested ternary, khó đọc
const label = status === 'active'
  ? count > 0
    ? 'Active with items'
    : 'Active empty'
  : status === 'inactive'
    ? 'Inactive'
    : 'Unknown';

// ✅ — function hoặc switch
function getLabel(status: Status, count: number): string {
  if (status === 'inactive') return 'Inactive';
  if (status !== 'active') return 'Unknown';
  return count > 0 ? 'Active with items' : 'Active empty';
}

// ✅ — simple ternary OK cho 2 cases rõ ràng
const displayName = user.nickname ?? user.fullName;
const buttonText = isLoading ? 'Đang xử lý...' : 'Xác nhận';
```

---

## 8. Type assertions — tối thiểu và có lý do

```typescript
// ❌ — assertion không cần thiết
const id = (user.id as string).toUpperCase();
// user.id đã là string, as string thừa

// ❌ — assertion che giấu bug
const admin = user as AdminEntity;
admin.permissions.forEach(...); // crash nếu user không phải AdminEntity

// ✅ — assertion sau discriminant check
if (state.status === 'success') {
  // TypeScript biết đây là SuccessState
  const { data } = state; // OK, không cần as
}

// ✅ — as const cho literal type
const config = { env: 'production', debug: false } as const;
type Config = typeof config; // { readonly env: "production"; readonly debug: false }

// ✅ — double assertion chỉ khi thực sự cần (hiếm)
// Cần giải thích tại sao trong comment
const element = document.getElementById('root') as unknown as SpecialElement;
// Reason: third-party library wraps DOM element but doesn't export its type
```

---

## 9. `Object.freeze` vs `as const`

```typescript
// as const — compile-time only (no runtime enforcement)
const COLORS = { primary: '#007AFF', secondary: '#5856D6' } as const;
// Type: { readonly primary: "#007AFF"; readonly secondary: "#5856D6" }
// Runtime: object vẫn mutable nếu cast sang any

// Object.freeze — runtime enforcement
const COLORS = Object.freeze({ primary: '#007AFF', secondary: '#5856D6' });
// Runtime: throw nếu cố mutate (strict mode)

// Kết hợp cả hai — tốt nhất cho config objects
const CONFIG = Object.freeze({
  apiVersion: 'v2',
  maxRetries: 3,
  timeout: 30_000,
} as const);
```

---

## 10. `for...of` thay vì `forEach` khi cần control flow

```typescript
// forEach không hỗ trợ break/continue/return-from-outer
items.forEach(item => {
  if (item.isExpired) return; // chỉ skip iteration hiện tại, không break loop
  process(item);
});

// ✅ — for...of hỗ trợ break, continue, return, await
for (const item of items) {
  if (item.isExpired) continue;
  if (await isInvalid(item)) break;
  await process(item);
}

// ✅ — forEach vẫn OK cho simple transformations không cần control flow
items.forEach(item => dispatch(addItem(item)));

// ✅ — map/filter/reduce cho transformations
const activeItems = items
  .filter(item => !item.isExpired)
  .map(item => ({ ...item, processedAt: new Date() }));
```

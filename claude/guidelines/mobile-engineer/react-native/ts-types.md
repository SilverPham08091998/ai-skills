# TypeScript — Type System Rules

## 1. Nghiêm cấm `any`

`any` vô hiệu hoá toàn bộ type system.

```typescript
// ❌
function parse(data: any): any { ... }
const result: any = await api.get('/endpoint');

// ✅ unknown — có type check trước khi dùng
function parse(data: unknown): UserEntity {
  if (!isUserEntity(data)) throw new TypeError('Invalid shape');
  return data;
}

// ✅ Generic — type được truyền từ caller
function identity<T>(value: T): T {
  return value;
}
```

**Ngoại lệ duy nhất:**
```typescript
// eslint-disable-next-line @typescript-eslint/no-explicit-any
// Reason: third-party lib XYZ does not ship types
const sdk = (window as any).__sdk;
```

---

## 2. `unknown` là escape hatch đúng cách

```typescript
// JSON.parse luôn là any — wrap ngay
function safeJsonParse<T>(json: string, guard: (v: unknown) => v is T): T {
  const parsed: unknown = JSON.parse(json);
  if (!guard(parsed)) throw new TypeError('JSON shape mismatch');
  return parsed;
}

// Validate từng field khi nhận data từ ngoài
function processPayload(payload: unknown): ProcessedData {
  if (typeof payload !== 'object' || payload === null) {
    throw new TypeError('Payload must be an object');
  }
  if (!('id' in payload) || typeof payload.id !== 'string') {
    throw new TypeError('Payload.id must be a string');
  }
  return { id: payload.id };
}
```

---

## 3. Explicit Return Types cho public functions

```typescript
// ❌ — inference ẩn
async function fetchUser(id: string) {
  return api.get(id);
}

// ✅
async function fetchUser(id: string): Promise<UserEntity | null> {
  return api.get(id);
}

// ❌ — hook return type ẩn
export function useProfile() {
  const [user, setUser] = useState(null);
  return { user, setUser };
}

// ✅
interface UseProfileReturn {
  user: UserEntity | null;
  isLoading: boolean;
  refresh: () => void;
}
export function useProfile(): UseProfileReturn { ... }
```

Không cần explicit return type: simple one-liner, private helpers, React components.

---

## 4. `interface` vs `type` — dùng đúng chỗ

```typescript
// interface — object shapes, domain entities, props (extendable)
interface UserEntity {
  id: string;
  name: string;
}
interface AdminEntity extends UserEntity {
  permissions: string[];
}

// type — union, intersection, conditional, alias
type UserId = string;
type Status = 'active' | 'inactive' | 'banned';
type ApiResponse<T> = SuccessResponse<T> | ErrorResponse;
type Nullable<T> = T | null;
```

---

## 5. Named Interface cho mọi domain object

```typescript
// ❌ — inline type cho objects có ý nghĩa nghiệp vụ
function submitOrder(order: { id: string; items: string[]; total: number }) { ... }

// ✅
interface SubmitOrderParams {
  id: string;
  items: string[];
  total: number;
}
function submitOrder(params: SubmitOrderParams): Promise<OrderEntity> { ... }
```

---

## 6. String Enum cho nhóm constants

```typescript
// ❌ — magic strings
if (status === 'ACTIVE') { ... }

// ❌ — number enum khó debug (log ra số)
enum Direction { Up, Down }

// ✅ — string enum: log ra giá trị có nghĩa, match API response
enum UserStatus {
  Active = 'ACTIVE',
  Inactive = 'INACTIVE',
  Banned = 'BANNED',
}

// const enum — khi không cần iterate, compiler inlines value
const enum Direction {
  Up = 'UP',
  Down = 'DOWN',
}
```

---

## 7. Generic Types với proper constraints

```typescript
// ❌ — constraint quá rộng
function first<T>(arr: T[]): T { ... }

// ✅ — constraint đủ chặt
function findById<T extends { id: string }>(list: T[], id: string): T | undefined {
  return list.find(item => item.id === id);
}

// ✅ — default generic
interface Repository<T, TId = string> {
  findById(id: TId): Promise<T | null>;
  save(entity: T): Promise<T>;
}

// ✅ — multiple constraints
function merge<T extends object, U extends object>(t: T, u: U): T & U {
  return { ...t, ...u };
}

// ✅ — conditional generic
type DeepReadonly<T> = T extends (infer U)[]
  ? ReadonlyArray<DeepReadonly<U>>
  : T extends object
  ? { readonly [K in keyof T]: DeepReadonly<T[K]> }
  : T;
```

---

## 8. Type Guard — runtime narrowing

```typescript
// Object shape guard
function isUserEntity(data: unknown): data is UserEntity {
  return (
    typeof data === 'object' &&
    data !== null &&
    'id' in data &&
    typeof (data as Record<string, unknown>).id === 'string'
  );
}

// Discriminated union narrowing
type ApiResult<T> =
  | { success: true; data: T }
  | { success: false; error: string };

function handleResult<T>(result: ApiResult<T>): T {
  if (!result.success) throw new Error(result.error);
  return result.data;
}

// Assertion function — throw nếu sai
function assertNonNull<T>(value: T | null | undefined, msg: string): asserts value is T {
  if (value == null) throw new Error(msg);
}

assertNonNull(user, 'User must be logged in');
user.profile; // TypeScript biết user không null
```

**Khi nào `as` chấp nhận được:**
- Narrow từ union đã check trước (`state as LoadedState` sau `if (state.status === 'loaded')`)
- `as const` cho literal types
- Test code

---

## 9. Readonly — bảo vệ immutability

```typescript
// Domain entity
interface OrderEntity {
  readonly id: string;
  readonly createdAt: Date;
  readonly items: readonly OrderItem[];
  status: OrderStatus; // mutable — có workflow
}

// Config — hoàn toàn immutable
const API_CONFIG = {
  baseUrl: 'https://api.example.com',
  timeout: 30_000,
} as const;

// Function params — không mutate input
function processItems(items: readonly string[]): string[] {
  return items.map(item => item.toUpperCase());
  // items.push(...) → lỗi compile
}
```

---

## 10. Discriminated Union + Exhaustive Check

```typescript
// ❌ — data và error có thể cùng tồn tại
interface State {
  isLoading: boolean;
  data: User | null;
  error: Error | null;
}

// ✅ — consistent, exhaustive
type FetchState<T> =
  | { phase: 'idle' }
  | { phase: 'loading' }
  | { phase: 'success'; data: T; fetchedAt: Date }
  | { phase: 'error'; error: Error; retryCount: number };

function render(state: FetchState<User>): string {
  switch (state.phase) {
    case 'idle':    return 'Chưa tải';
    case 'loading': return 'Đang tải...';
    case 'success': return state.data.name;   // data có sẵn
    case 'error':   return state.error.message; // error có sẵn
    default: {
      // Nếu thêm case mới mà quên xử lý → lỗi compile
      const _: never = state;
      return _;
    }
  }
}
```

---

## 11. Utility Types — dùng đúng chỗ

```typescript
// Partial — update partial
function updateUser(id: string, updates: Partial<UserEntity>): Promise<UserEntity>

// Required — force all optional
function initConfig(config: Required<AppConfig>): void

// Pick — subset fields
type UserPreview = Pick<UserEntity, 'id' | 'name' | 'avatarUrl'>;

// Omit — loại sensitive fields
type PublicUserDTO = Omit<UserEntity, 'passwordHash' | 'secretToken'>;

// Record — typed dictionary
type ErrorCodeMap = Record<ErrorCode, string>;
type FeatureFlags = Record<string, boolean>;

// Extract / Exclude — filter union
type OnlyString = Extract<string | number | boolean, string>; // string
type NoBoolean = Exclude<string | number | boolean, boolean>; // string | number

// NonNullable
type StrictUser = NonNullable<UserEntity | null | undefined>; // UserEntity

// ReturnType / Parameters / Awaited
type HandlerReturn = ReturnType<typeof handler.handle>;
type HandlerParams = Parameters<typeof handler.handle>;
type UserResult = Awaited<Promise<UserEntity>>; // UserEntity
```

---

## 12. Template Literal Types

```typescript
// Type-safe event names
type EventName = 'click' | 'change' | 'submit';
type EventHandler = `on${Capitalize<EventName>}`; // 'onClick' | 'onChange' | 'onSubmit'

// Type-safe spacing
type SpacingUnit = 4 | 8 | 12 | 16 | 24 | 32;
type SpacingValue = `${SpacingUnit}px`;

// Type-safe API versioning
type ApiVersion = 'v1' | 'v2';
type ApiEndpoint = `/api/${ApiVersion}/${string}`;
```

---

## 13. Mapped Types

```typescript
// Optional version
type Nullable<T> = { [K in keyof T]: T[K] | null };

// Deep readonly
type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object ? DeepReadonly<T[K]> : T[K];
};

// Loading flags per field
type LoadingMap<T> = {
  [K in keyof T as `${string & K}Loading`]: boolean;
};
```

---

## 14. Conditional Types

```typescript
// Flatten array one level
type Flatten<T> = T extends (infer U)[] ? U : T;

// Async return type
type AsyncReturnType<T extends (...args: never[]) => Promise<unknown>> =
  T extends (...args: never[]) => Promise<infer R> ? R : never;

// Strict vs Partial DTO
type CreateDTO<T, Strict extends boolean = true> = Strict extends true
  ? Required<Omit<T, 'id' | 'createdAt'>>
  : Partial<Omit<T, 'id'>>;
```

---

## 15. Nullish Coalescing và Optional Chaining

```typescript
// ?? chỉ fallback khi null/undefined (không phải 0, '', false)
const name = user?.profile?.name ?? 'Guest';
const count = data.count ?? 0;
const firstItem = list?.[0];
const formatted = value?.toString().trim();

// Nullish assignment
config.timeout ??= DEFAULT_TIMEOUT;

// ❌ || override falsy values
const flag = data.enabled || true; // data.enabled = false → sai, trả về true
const flag2 = data.enabled ?? true; // data.enabled = false → đúng, trả về false
```

# TypeScript — Module & Import Patterns

## 1. Import order convention

Thứ tự import phải nhất quán — dùng ESLint `import/order` để enforce tự động.

```typescript
// ─── 1. Node built-ins (nếu có) ───────────────
import { readFile } from 'fs/promises';
import path from 'path';

// ─── 2. External packages ──────────────────────
import { injectable, inject } from 'inversify';
import { createSlice, createSelector } from '@reduxjs/toolkit';
import React, { useCallback, useEffect } from 'react';

// ─── 3. Internal aliases (@src, @domain, @presentation...) ─
import type { UserEntity } from '@domain/entities/UserEntity';
import { UserStatus } from '@domain/entities/UserEntity';
import { TYPES } from '@di/types';
import { container } from '@di/container';

// ─── 4. Relative imports (gần nhất trước) ──────
import { mapToUserEntity } from './mappers/userMapper';
import type { CreateUserDTO } from '../dto/CreateUserDTO';
import { validateUserInput } from '../../utils/validation';
```

---

## 2. `import type` bắt buộc cho type-only imports

Type-only imports bị xoá hoàn toàn tại compile time → bundle nhỏ hơn, không có circular dependency runtime.

```typescript
// ❌ — import value khi chỉ cần type
import { UserEntity } from '@domain/entities/UserEntity';
import { IUserRepository } from '@domain/interfaces/IUserRepository';

// ✅ — compiler removes at runtime
import type { UserEntity } from '@domain/entities/UserEntity';
import type { IUserRepository } from '@domain/interfaces/IUserRepository';

// ✅ — mixed import (value + type từ cùng module)
import { OrderStatus, type OrderEntity } from '@domain/entities/OrderEntity';
//       ^value          ^type-only

// ✅ — type assertion sau import type
import type { AppConfig } from './config';
function isAppConfig(data: unknown): data is AppConfig { ... }
```

---

## 3. Barrel exports — explicit, không wildcard

```typescript
// ❌ — wildcard: không kiểm soát public API, gây circular dependency risk,
//              tree-shaking kém, IDE autocomplete ồn
export * from './UserEntity';
export * from './OrderEntity';
export * from './TransactionEntity';

// ✅ — explicit: rõ ràng public API, dễ tìm, dễ refactor
// src/domain/entities/index.ts
export type { UserEntity, UserId } from './UserEntity';
export { UserStatus } from './UserEntity';
export type { OrderEntity } from './OrderEntity';
export { OrderStatus } from './OrderEntity';
export type { TransactionEntity } from './TransactionEntity';
```

---

## 4. Circular dependency — phát hiện và phòng tránh

```typescript
// Dấu hiệu: import lẫn nhau
// user.ts imports order.ts → order.ts imports user.ts → circular

// ❌ — circular dependency
// user.ts
import { Order } from './order';
interface User { orders: Order[] }

// order.ts
import { User } from './user';
interface Order { owner: User }

// ✅ — dùng ID reference trong domain
interface UserEntity { id: string; orderIds: string[] }
interface OrderEntity { id: string; ownerId: string }

// ✅ — shared types module (không import từ nhau)
// shared-types.ts
export interface Identifiable { id: string }
// user.ts imports shared-types.ts
// order.ts imports shared-types.ts
// Không có circular
```

**Tool phát hiện circular dependency:**
```bash
npx madge --circular src/
```

---

## 5. Re-export — không dùng cùng tên cho type và value

```typescript
// ❌ — confusing, có thể gây runtime issue
export const UserStatus = { Active: 'ACTIVE' };
export type UserStatus = 'ACTIVE' | 'INACTIVE';

// ✅ — enum giải quyết cả hai
export enum UserStatus {
  Active = 'ACTIVE',
  Inactive = 'INACTIVE',
}
// UserStatus vừa là value (object) vừa là type
```

---

## 6. Path aliases — dùng nhất quán

```typescript
// tsconfig.json paths
{
  "paths": {
    "@domain/*": ["src/domain/*"],
    "@application/*": ["src/application/*"],
    "@infrastructure/*": ["src/infrastructure/*"],
    "@presentation/*": ["src/presentation/*"],
    "@di/*": ["src/di/*"],
    "@config/*": ["src/config/*"],
    "@utils/*": ["src/utils/*"]
  }
}

// ❌ — relative hell
import { UserEntity } from '../../../domain/entities/UserEntity';
import { container } from '../../../../di/container';

// ✅ — alias
import type { UserEntity } from '@domain/entities/UserEntity';
import { container } from '@di/container';
```

---

## 7. Index file (barrel) — khi nào nên tạo

```typescript
// ✅ — tạo index.ts cho public API của một module/layer
// src/domain/entities/index.ts — export entities cho layer khác dùng

// ❌ — KHÔNG tạo index.ts cho mọi folder
// src/domain/entities/user/index.ts  ← quá nhiều barrel, gây circular risk

// Rule of thumb:
// - Một barrel per layer boundary
// - Không barrel trong nội bộ layer (dùng relative import)
// - Barrel chỉ export những gì layer khác thực sự cần
```

---

## 8. Dynamic import — code splitting

```typescript
// Lazy load feature module
const OrderHistory = React.lazy(() => import('./screens/OrderHistory'));

// Conditional import — chỉ load khi cần
async function loadAnalytics(): Promise<void> {
  if (isProduction()) {
    const { Analytics } = await import('./services/Analytics');
    Analytics.init();
  }
}

// Type-safe dynamic import
async function getValidator(type: 'email' | 'phone'): Promise<Validator> {
  const module = await import(`./validators/${type}Validator`);
  return module.default;
}
```

---

## 9. Declaration files (`.d.ts`) — khi nào cần

```typescript
// Khi extend global types
// global.d.ts
declare global {
  interface Window {
    __APP_CONFIG__: AppConfig;
  }
}

// Khi declare module cho file không có types
// assets.d.ts
declare module '*.png' {
  const content: string;
  export default content;
}
declare module '*.svg' {
  const content: React.FC<React.SVGProps<SVGSVGElement>>;
  export default content;
}

// Khi augment third-party module
// react-navigation.d.ts
declare module '@react-navigation/native' {
  export type RootParamList = {
    Home: undefined;
    Profile: { userId: string };
    Orders: { filter?: OrderStatus };
  };
}
```

---

## 10. Namespace — tuyệt đối tránh

```typescript
// ❌ — namespace là TypeScript legacy, không phải ES module
namespace UserModule {
  export interface User { id: string; name: string }
  export function createUser(name: string): User { ... }
  export namespace Validators {
    export function isValidEmail(email: string): boolean { ... }
  }
}

// ✅ — ES modules
// user.ts
export interface User { id: string; name: string }
export function createUser(name: string): User { ... }

// userValidators.ts
export function isValidEmail(email: string): boolean { ... }
```

Namespace chỉ chấp nhận trong `.d.ts` files để type-augment library.

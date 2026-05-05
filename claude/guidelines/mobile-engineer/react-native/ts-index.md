# TypeScript Rules — Index

Tổng hợp tất cả TypeScript coding rules. Mỗi chủ đề là một slash command riêng:

| Command | Nội dung |
|---|---|
| `/ts-types` | Type system: any, unknown, interface, enum, generic, type guard, readonly, union |
| `/ts-naming` | Naming conventions: variables, functions, classes, generics |
| `/ts-functions` | Function & class patterns: pure functions, params, arrow vs declaration, access modifiers |
| `/ts-errors` | Error handling: custom errors, Result type, catch narrowing |
| `/ts-async` | Async patterns: await, parallel, cancellation, timeout |
| `/ts-modules` | Module & import: import order, import type, barrel exports, circular deps |
| `/ts-style` | Code style: destructuring, spread, magic numbers, comments |
| `/ts-config` | tsconfig.json và ESLint rules bắt buộc |

## Master Checklist

### Type System
```
[ ] Không có `any` — dùng unknown + type guard
[ ] Explicit return type cho public functions và hooks
[ ] Named interface/type cho mọi domain object
[ ] String enum cho nhóm constants
[ ] Generic constraints đủ ketat
[ ] Type guard thay vì type assertion (as)
[ ] Readonly cho immutable fields
[ ] Discriminated union + exhaustive switch
[ ] import type cho type-only imports
```

### Naming & Style
```
[ ] camelCase cho variables/functions, PascalCase cho types/classes
[ ] Boolean vars: is/has/can/should prefix
[ ] Event handlers: handle + Event hoặc on + Event
[ ] Không có magic numbers/strings
[ ] Early return thay vì deep nesting
[ ] Destructure thay vì repetitive access
[ ] Spread cho immutable updates
[ ] Comment chỉ giải thích WHY, không phải WHAT
```

### Functions & Classes
```
[ ] Pure functions ưu tiên
[ ] Options object khi > 3 parameters
[ ] Access modifiers explicit (public/private/protected)
[ ] readonly cho injected dependencies
[ ] Không dùng Class khi Function đủ
```

### Error & Async
```
[ ] Custom Error classes cho typed errors
[ ] Result type cho expected failures
[ ] Không swallow errors trong catch
[ ] error: unknown trong catch block
[ ] async/await thay vì .then() chains
[ ] Promise.all cho parallel operations độc lập
```

### Modules
```
[ ] Import order: built-ins → external → internal → relative
[ ] Explicit barrel exports (không wildcard *)
[ ] Không có circular dependencies
```

# react-native/react-native-library.md

## Objective

Define standards for creating, maintaining, and publishing reusable React Native libraries in TypeScript.

Applies to:

* React Native library modules
* TypeScript packages
* Native Modules / Native UI Components
* Internal company packages
* Public npm packages

Main rule:

> A React Native library must expose a stable API, support both platforms clearly, and avoid leaking implementation details to consumers.

---

# 1. Core Principles

## 1.1 Stable Public API

* Export only what consumers need.
* Avoid exposing internal files directly.
* Treat exported types/functions/components as contract.

```ts
export { BiometricService } from './service/BiometricService';
export type { BiometricResult } from './types/BiometricResult';
```

---

## 1.2 TypeScript First

* Library must provide type declarations.
* Avoid `any` in public APIs.
* Public types must be explicit and documented.

---

## 1.3 Platform Awareness

* Clearly define Android/iOS support.
* If one platform is unsupported, fail with clear error.

```ts
if (Platform.OS !== 'ios') {
  throw new Error('This feature is only supported on iOS');
}
```

---

# 2. Recommended Library Structure

```txt
react-native-my-library/
  src/
    index.ts
    types/
    service/
    components/
    hooks/
    native/
  android/
  ios/
  example/
  package.json
  tsconfig.json
  README.md
```

Rules:

* `src/index.ts` is the public export boundary.
* `native/` wraps low-level NativeModules.
* `service/` exposes typed service APIs.
* `components/` contains reusable UI components.
* `example/` must demonstrate real usage.

---

# 3. Public Export Rule

## 3.1 Export from `src/index.ts`

```ts
export { MyLibraryService } from './service/MyLibraryService';
export { MyNativeView } from './components/MyNativeView';
export type { MyLibraryConfig } from './types/MyLibraryConfig';
```

Rules:

* Do not ask consumers to import from deep paths.
* Keep internal files private.

Bad:

```ts
import { Foo } from 'my-lib/src/internal/Foo';
```

Good:

```ts
import { Foo } from 'my-lib';
```

---

# 4. Native Modules vs Native UI

## 4.1 Native Modules

Native Modules expose functions/capabilities.

Examples:

* biometric check
* encryption
* device info
* PDF signature validation

Recommended structure:

```txt
src/
  native/
    BiometricNativeModule.ts
  service/
    BiometricService.ts
  types/
    BiometricTypes.ts
```

Example:

```ts
export interface BiometricNativeModuleSpec {
  isEnabled(): Promise<boolean>;
}
```

```ts
const isEnabled: boolean = await BiometricService.isEnabled();
```

Rules:

* Native module must be wrapped by a typed service.
* UI should not call `NativeModules` directly.
* Always define TypeScript interface for native functions.

---

## 4.2 Native UI Components

Native UI exposes rendered UI from native platform.

Examples:

* native PDF viewer
* camera preview
* map view
* video player

Recommended structure:

```txt
src/
  components/
    NativePdfView.tsx
  native/
    NativePdfViewNativeComponent.ts
  types/
    NativePdfViewProps.ts
```

Rules:

* Native UI should be exported as React components.
* Props must be typed.
* Keep platform-specific behavior documented.

---

# 5. Type Design

## 5.1 Public Types

```ts
type UploadResult = {
  fileId: string;
  status: 'SUCCESS' | 'FAILED';
};
```

Rules:

* Use union types for status.
* Avoid leaking native response shapes directly.
* Map native responses to stable domain-friendly types.

---

## 5.2 Error Types

```ts
export type LibraryError = {
  code: string;
  message: string;
  platform?: 'ios' | 'android';
  cause?: unknown;
};
```

Rules:

* Do not throw raw native errors to consumers.
* Normalize native errors into stable error codes.

---

# 6. Example App

Every library should include an example app.

Example app must show:

* installation
* initialization
* basic usage
* error handling
* Android/iOS behavior

Rules:

* Example must run after fresh install.
* Example should not require company secrets.

---

# 7. Build Output

Library should output:

```txt
lib/
  commonjs/
  module/
  typescript/
```

Recommended tools:

* `react-native-builder-bob`
* `tsup` for pure JS libraries

---

# 8. package.json Rules

```json
{
  "main": "lib/commonjs/index.js",
  "module": "lib/module/index.js",
  "types": "lib/typescript/index.d.ts",
  "react-native": "src/index.ts",
  "files": [
    "src",
    "lib",
    "android",
    "ios",
    "README.md"
  ],
  "peerDependencies": {
    "react": "*",
    "react-native": "*"
  }
}
```

Rules:

* React and React Native must be peer dependencies.
* Do not bundle React Native into library output.
* Only publish necessary files.

---

# 9. Native Dependency Rules

## 9.1 Android

* Keep Gradle config minimal.
* Avoid forcing consumer app versions unless required.
* Document required permissions.

## 9.2 iOS

* Provide Podspec.
* Document required Info.plist keys.
* Support CocoaPods integration.

---

# 10. Versioning

Use semantic versioning:

```txt
MAJOR.MINOR.PATCH
```

Rules:

* Breaking public API change → major version.
* New backward-compatible feature → minor version.
* Bug fix → patch version.

---

# 11. Testing Rules

Library must include:

* unit tests for JS/TS logic
* mock NativeModules for tests
* example app smoke test

```ts
jest.mock('react-native', () => ({
  NativeModules: {
    MyNativeModule: {
      isEnabled: jest.fn(),
    },
  },
}));
```

Rules:

* Do not require real device for unit tests.
* Native behavior should be verified by example app / E2E where needed.

---

# 12. Documentation Rules

README must include:

* installation
* linking/autolinking notes
* iOS setup
* Android setup
* usage examples
* API reference
* troubleshooting

---

# 13. Security Rules

For fintech/banking libraries:

* Do not log sensitive data.
* Do not store secrets by default.
* Normalize native errors.
* Document security-sensitive behavior.
* Avoid dynamic code execution.

---

# 14. Anti-patterns

* Exposing raw `NativeModules` to consumers.
* Deep import dependency on internal files.
* Missing TypeScript declarations.
* Bundling React or React Native inside library.
* No example app.
* No platform behavior documentation.
* Breaking API without major version bump.

---

# 15. Checklist

* [ ] Public exports defined in `src/index.ts`.
* [ ] TypeScript declarations generated.
* [ ] NativeModules wrapped by typed service.
* [ ] Native UI exported as typed React components.
* [ ] React/React Native are peer dependencies.
* [ ] Android/iOS setup documented.
* [ ] Example app works.
* [ ] Unit tests exist.
* [ ] README complete.
* [ ] Version follows semantic versioning.

---

# 16. Final Rule

> A React Native library is a product consumed by other developers.
> Keep its API stable, typed, documented, tested, and platform-aware.

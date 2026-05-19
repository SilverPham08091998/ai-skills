# generators/create-native-module.md

## Objective

Generate a React Native Native Module or Native UI Component with a clean TypeScript wrapper, platform-aware implementation, safe error handling, and proper separation between infrastructure, service, and UI layers.

Applies to:

* React Native
* TypeScript
* Android Native Module
* iOS Native Module
* Native UI Components
* Clean Architecture
* Fintech / Banking apps

Main rule:

> NativeModule exposes native functions/capabilities.
> NativeUI exposes native-rendered UI components.
> UI must never call raw `NativeModules` directly.

---

# 1. Input Format

AI must ask for or infer the following input:

```txt
Native Feature Name:
Native Type: module | ui | both
Platform: android | ios | both
Capability Description:
Methods:
Events Needed: yes/no
Permissions Needed: yes/no
Sensitive Data: yes/no
Requires UI Component: yes/no
Error Cases:
Example Usage:
```

Example:

```txt
Native Feature Name: Biometric
Native Type: module
Platform: both
Methods:
- isEnabled(): Promise<boolean>
- authenticate(reason: string): Promise<BiometricResult>
Events Needed: no
Permissions Needed: no
Sensitive Data: yes
```

Rules:

* If `Native Type = module`, generate function service wrapper.
* If `Native Type = ui`, generate typed React component wrapper.
* If `both`, generate separate module and UI folders.
* Do not mix native function logic into UI component.

---

# 2. NativeModule vs NativeUI

## 2.1 NativeModule

NativeModule is for native capabilities/functions.

Examples:

* biometric
* encryption
* device info
* PDF signature validation
* secure storage
* camera permission check

Usage example:

```ts
const isEnabled: boolean = await BiometricService.isEnabled();
```

Rules:

* Must expose a TypeScript interface.
* Must be wrapped by a service.
* UI must call service/hook, not `NativeModules`.

---

## 2.2 NativeUI

NativeUI is for native-rendered UI components.

Examples:

* PDF viewer
* camera preview
* map view
* video player
* document scanner view

Usage example:

```tsx
<NativePdfView source={filePath} onLoaded={handleLoaded} />
```

Rules:

* Must expose typed props.
* Must live under `component/` or `components/`.
* Must not expose raw native view manager directly to feature screens.

---

# 3. Target Folder Structure

Recommended structure for a feature-specific native integration:

```txt
src/modules/<feature>/
  infrastructure/
    native/
      <native-feature>/
        module/
          <NativeFeature>NativeModule.ts
          <NativeFeature>NativeModule.types.ts
        service/
          <NativeFeature>Service.ts
          <NativeFeature>Service.types.ts
        mapper/
          <NativeFeature>NativeMapper.ts
        error/
          <NativeFeature>Error.ts
  presentation/
    component/
      <NativeFeature>View.tsx        # only for NativeUI
    hook/
      use<NativeFeature>.ts
```

For shared platform native module:

```txt
src/platform/native/<native-feature>/
  module/
  service/
  mapper/
  error/
```

Native platform files:

```txt
android/app/src/main/java/.../<NativeFeature>Module.kt
android/app/src/main/java/.../<NativeFeature>Package.kt

ios/<NativeFeature>Module.swift
ios/<NativeFeature>Module.m
```

Rules:

* Function module and UI component must be separated.
* Infrastructure owns raw native access.
* Service exposes safe typed API.

---

# 4. TypeScript Native Module Spec

Generate a typed native module interface.

```ts
export interface <NativeFeature>NativeModuleSpec {
  isEnabled(): Promise<boolean>;
}
```

Raw module wrapper:

```ts
import { NativeModules, Platform } from 'react-native';

import type { <NativeFeature>NativeModuleSpec } from './<NativeFeature>NativeModule.types';

const LINKING_ERROR =
  `The package '<native-feature>' is not linked properly. ` +
  `Make sure native modules are installed and rebuilt.`;

const NativeModule = NativeModules.<NativeFeature>Module as <NativeFeature>NativeModuleSpec | undefined;

export function get<NativeFeature>NativeModule(): <NativeFeature>NativeModuleSpec {
  if (!NativeModule) {
    throw new Error(LINKING_ERROR);
  }

  return NativeModule;
}
```

Rules:

* Do not export `NativeModules.<NativeFeature>Module` directly.
* Always guard missing native module.
* Always type native methods.

---

# 5. Service Wrapper

Generate service layer that feature code consumes.

```ts
import { normalizeNativeError } from './<NativeFeature>Error';
import { get<NativeFeature>NativeModule } from '../module/<NativeFeature>NativeModule';

export class <NativeFeature>Service {
  static async isEnabled(): Promise<boolean> {
    try {
      return await get<NativeFeature>NativeModule().isEnabled();
    } catch (error) {
      throw normalizeNativeError(error);
    }
  }
}
```

Rules:

* Service wraps all native calls.
* Service normalizes native errors.
* UI/presentation imports service or hook, never raw module.
* Service method return types must be explicit.

---

# 6. Hook Wrapper

Generate a hook only when UI needs stateful usage.

```ts
import { useCallback, useState } from 'react';

import type { AppError } from '@shared/error';

import { <NativeFeature>Service } from '../../infrastructure/native/<native-feature>/service/<NativeFeature>Service';

export function use<NativeFeature>() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<AppError | null>(null);

  const checkEnabled = useCallback(async (): Promise<boolean> => {
    setLoading(true);
    setError(null);

    try {
      return await <NativeFeature>Service.isEnabled();
    } catch (err) {
      setError(err as AppError);
      return false;
    } finally {
      setLoading(false);
    }
  }, []);

  return {
    state: {
      loading,
      error,
    },
    actions: {
      checkEnabled,
    },
  };
}
```

Rules:

* Hook manages UI state.
* Hook does not call `NativeModules` directly.
* Hook exposes UI-friendly state/actions.

---

# 7. Native UI Component Wrapper

If `Native Type = ui`, generate typed component wrapper.

Native component spec:

```ts
import { requireNativeComponent } from 'react-native';

import type { <NativeFeature>ViewProps } from './<NativeFeature>View.types';

export const Native<NativeFeature>View = requireNativeComponent<<NativeFeature>ViewProps>(
  'Native<NativeFeature>View',
);
```

Presentation wrapper:

```tsx
import React from 'react';

import { Native<NativeFeature>View } from '../../infrastructure/native/<native-feature>/ui/Native<NativeFeature>View';
import type { <NativeFeature>ViewProps } from './<NativeFeature>View.types';

export function <NativeFeature>View(props: <NativeFeature>ViewProps): React.JSX.Element {
  return <Native<NativeFeature>View {...props} />;
}
```

Rules:

* Feature screens import `<NativeFeature>View`, not raw `requireNativeComponent`.
* Props must be typed.
* Events must be normalized.
* Native UI must live in presentation/component wrapper.

---

# 8. Event Handling

If native module emits events, generate typed event contract.

```ts
export type <NativeFeature>Event = {
  type: 'STARTED' | 'COMPLETED' | 'FAILED';
  payload?: unknown;
};
```

Event subscription:

```ts
import { NativeEventEmitter } from 'react-native';

export function subscribe<NativeFeature>Events(
  listener: (event: <NativeFeature>Event) => void,
): () => void {
  const emitter = new NativeEventEmitter(get<NativeFeature>NativeModule() as any);
  const subscription = emitter.addListener('<NativeFeature>Event', listener);

  return () => subscription.remove();
}
```

Rules:

* Always return unsubscribe cleanup.
* Do not leak native event listeners.
* Normalize event payload before exposing to UI.

---

# 9. Error Handling

Generate normalized error type.

```ts
import { AppErrorType } from '@shared/error';
import type { AppError } from '@shared/error';

export function normalizeNativeError(error: unknown): AppError {
  return {
    code: 'NATIVE_MODULE_ERROR',
    message: 'Native feature is currently unavailable.',
    type: AppErrorType.UNKNOWN,
    raw: error,
  };
}
```

Rules:

* Do not expose raw native exceptions to UI.
* Map native platform errors to stable error codes.
* User-facing messages must be safe.

---

# 10. Android Generation Rules

For Android, generate Kotlin module when requested.

```kotlin
class <NativeFeature>Module(
  reactContext: ReactApplicationContext
) : ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String = "<NativeFeature>Module"

  @ReactMethod
  fun isEnabled(promise: Promise) {
    try {
      promise.resolve(true)
    } catch (e: Exception) {
      promise.reject("NATIVE_ERROR", e.message, e)
    }
  }
}
```

Package:

```kotlin
class <NativeFeature>Package : ReactPackage {
  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    return listOf(<NativeFeature>Module(reactContext))
  }

  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    return emptyList()
  }
}
```

Rules:

* Use promise for async methods.
* Reject with stable error code.
* Do not expose sensitive native data.
* Handle permissions explicitly.

---

# 11. iOS Generation Rules

For iOS, generate Swift/Objective-C bridge when requested.

Swift module concept:

```swift
@objc(<NativeFeature>Module)
class <NativeFeature>Module: NSObject {
  @objc
  func isEnabled(
    _ resolve: RCTPromiseResolveBlock,
    rejecter reject: RCTPromiseRejectBlock
  ) {
    resolve(true)
  }
}
```

Objective-C bridge:

```objc
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(<NativeFeature>Module, NSObject)
RCT_EXTERN_METHOD(isEnabled:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
@end
```

Rules:

* Export promise-based methods clearly.
* Use stable error codes.
* Do not throw uncaught native exceptions.

---

# 12. Permissions

If permissions are required, generate permission documentation and checks.

Examples:

* camera
* microphone
* location
* photo library
* Bluetooth

Rules:

* Request permission before native action.
* Add Android Manifest entries.
* Add iOS Info.plist usage descriptions.
* Do not request permissions until needed.

---

# 13. Security Rules (CRITICAL)

For fintech/banking apps:

* Do not expose secrets through native modules.
* Do not log native sensitive values.
* Do not store OTP/PIN/CVV.
* Use Keychain/Keystore for secrets.
* Normalize native errors.
* Validate native input parameters.

If native module handles crypto/signature:

* never hardcode keys
* use OS secure hardware where possible
* return only safe results

---

# 14. Observability Rules

Native module calls should emit safe logs when useful.

Allowed metadata:

* feature name
* platform
* result status
* error code
* durationMs

Forbidden metadata:

* tokens
* OTP/PIN
* raw document content
* private keys

Example:

```ts
logger.info('<NATIVE_FEATURE>_CALL_COMPLETED', {
  platform: Platform.OS,
  durationMs,
});
```

---

# 15. Testing Rules

Generate or suggest tests for:

```txt
service calls native module
service normalizes native error
hook exposes loading/error state
event subscription cleans up
NativeUI renders with required props
```

Mock NativeModules:

```ts
jest.mock('react-native', () => ({
  NativeModules: {
    <NativeFeature>Module: {
      isEnabled: jest.fn().mockResolvedValue(true),
    },
  },
  Platform: {
    OS: 'ios',
  },
}));
```

Rules:

* Unit tests must not require real native device.
* Native behavior should be validated in example app or E2E tests.

---

# 16. Documentation Rules

Generated README section must include:

* feature purpose
* supported platforms
* installation/linking notes
* Android setup
* iOS setup
* permissions
* usage example
* error codes
* troubleshooting

---

# 17. Output Format

AI must output files grouped by path:

```txt
File: src/platform/native/<native-feature>/module/<NativeFeature>NativeModule.types.ts
<code>

File: src/platform/native/<native-feature>/module/<NativeFeature>NativeModule.ts
<code>

File: src/platform/native/<native-feature>/service/<NativeFeature>Service.ts
<code>
```

Rules:

* Generate TypeScript wrapper first.
* Generate platform native files only when requested.
* Do not create NativeUI files for function-only module.
* Do not create function module files for UI-only component unless required.

---

# 18. Anti-patterns

* Calling `NativeModules` directly from screen.
* No TypeScript interface for native methods.
* Throwing raw native errors to UI.
* Mixing NativeModule and NativeUI responsibilities.
* Missing event cleanup.
* Logging sensitive data from native layer.
* Requesting permissions at app start without need.
* Platform-specific behavior undocumented.
* Returning platform-specific raw response shapes to UI.

---

# 19. Checklist

* [ ] Native type selected: module/ui/both.
* [ ] TypeScript native spec generated.
* [ ] Raw NativeModule guarded.
* [ ] Service wrapper generated.
* [ ] Hook generated if UI state is needed.
* [ ] NativeUI wrapper generated only if required.
* [ ] Events typed and cleaned up if required.
* [ ] Errors normalized.
* [ ] Permissions documented.
* [ ] Android/iOS setup included when requested.
* [ ] Tests or test plan included.
* [ ] Sensitive data rules enforced.

---

# 20. Final Rule

> Native integration must be typed, wrapped, safe, and platform-aware.
> Raw native APIs belong in infrastructure; UI consumes clean services/components only.

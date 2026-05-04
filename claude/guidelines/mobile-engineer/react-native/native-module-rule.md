# ========================

# 📱 NATIVE MODULE & NATIVE UI RULE (REACT NATIVE)

# ========================

## 🎯 OBJECTIVE

Define strict rules for React Native native integration with two separate concerns:

```txt
NativeModules = Native functions / native services
NativeUI      = Native UI components / native views
```

This project separates native integration clearly:

```txt
service/module/  → NativeModules function wrappers
component/       → NativeUI components
infrastructure/  → API, storage, network, external infrastructure only
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

React Native native integration has 2 parts:

```txt
1. NativeModules → functions / capabilities
2. NativeUI      → native views / UI components
```

Examples:

```txt
NativeModules:
- BiometricModules.isEnable()
- BiometricModules.authenticate()
- DeviceSecurityModules.isRooted()
- PdfSignatureModules.verifySignature()

NativeUI:
- NativePdfView
- NativeEkycView
- NativeCameraView
- NativeMapView
```

Rule:

```txt
NativeModules are services.
NativeUI belongs to component.
Infrastructure is for API/storage/network infrastructure.
```

---

# ========================

# 📁 REACT NATIVE STRUCTURE

# ========================

## 1. NativeModules structure

NativeModules wrapper MUST be placed under:

```txt
src/service/module/
```

Recommended:

```txt
src/service/module/
  biometric/
    biometric.module.ts
    biometric.interface.ts
    biometric.type.ts
  device-security/
    device-security.module.ts
    device-security.interface.ts
    device-security.type.ts
  pdf-signature/
    pdf-signature.module.ts
    pdf-signature.interface.ts
    pdf-signature.type.ts
```

## 2. NativeUI structure

Native UI components MUST be placed under:

```txt
src/component/native/
```

Recommended:

```txt
src/component/native/
  pdf-view/
    native-pdf-view.tsx
    native-pdf-view.props.ts
  ekyc-view/
    native-ekyc-view.tsx
    native-ekyc-view.props.ts
  camera-view/
    native-camera-view.tsx
    native-camera-view.props.ts
```

## 3. Infrastructure structure

Infrastructure remains for hạ tầng:

```txt
src/infrastructure/
  api/
  storage/
  repository/
  mapper/
  network/
```

Infrastructure MUST NOT become the place for native UI or generic NativeModules.

---

# ========================

# 🔁 STANDARD FLOW

# ========================

## NativeModules flow

```txt
presentation hook
  → application use case
  → service/module wrapper
  → NativeModules
  → iOS / Android function implementation
```

Example:

```txt
useBiometricLogin
  → biometricLoginUseCase
  → BiometricModules.isEnable()
  → NativeModules.BiometricModules.isEnable()
```

## NativeUI flow

```txt
presentation screen/view
  → component/native/<native-ui>
  → requireNativeComponent / codegen native view
  → iOS / Android native view implementation
```

Example:

```txt
PdfSignatureScreen
  → NativePdfView
  → iOS PDFKit View / Android PDF Renderer View
```

---

# ========================

# 🧾 NATIVE MODULE INTERFACE RULE

# ========================

Every NativeModule MUST have an interface/type contract.

Example:

```ts
export interface BiometricModuleInterface {
  isEnable(): Promise<boolean>;
  authenticate(reason: string): Promise<BiometricAuthResult>;
}
```

Typed usage:

```ts
const isEnable: boolean = await BiometricModules.isEnable();
```

MUST NOT use untyped `any` NativeModules access.

---

# ========================

# ⚙️ NATIVE MODULE WRAPPER RULE

# ========================

NativeModules must be wrapped before use.

### ✅ GOOD

```ts
import { NativeModules } from 'react-native';
import type { BiometricModuleInterface } from './biometric.interface';

const LINKING_ERROR =
  'BiometricModules is not linked. Please rebuild the app.';

const NativeBiometricModules = NativeModules.BiometricModules
  ? NativeModules.BiometricModules
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      },
    );

export const BiometricModules: BiometricModuleInterface = {
  isEnable(): Promise<boolean> {
    return NativeBiometricModules.isEnable();
  },

  authenticate(reason: string): Promise<BiometricAuthResult> {
    return NativeBiometricModules.authenticate(reason);
  },
};
```

Usage:

```ts
const isEnable: boolean = await BiometricModules.isEnable();
```

### ❌ BAD

```ts
const isEnable = await NativeModules.BiometricModules.isEnable();
```

Rule:

```txt
Application/hook must call typed module wrapper, not raw NativeModules.
```

---

# ========================

# 🧩 NATIVE UI COMPONENT RULE

# ========================

Native UI must be exposed as React component under `component/native`.

Example:

```tsx
import { requireNativeComponent } from 'react-native';

export type NativePdfViewProps = {
  filePath: string;
  onLoad?: () => void;
  onError?: (error: { code: string; message: string }) => void;
};

export const NativePdfView = requireNativeComponent<NativePdfViewProps>(
  'NativePdfView',
);
```

Usage:

```tsx
<NativePdfView
  filePath={filePath}
  onLoad={handleLoad}
  onError={handleError}
/>
```

Rule:

```txt
NativeUI is component, not service/module and not infrastructure.
```

---

# ========================

# 🧱 RESPONSIBILITY SPLIT

# ========================

## NativeModules = service/module

Use for native functions:

```txt
biometric check
device security check
PDF signature verification
file picker
secure native operation
SDK function call
```

Example:

```ts
await BiometricModules.isEnable();
await DeviceSecurityModules.isRooted();
await PdfSignatureModules.verifySignature(filePath);
```

---

## NativeUI = component/native

Use for native UI:

```txt
PDF viewer
camera preview
eKYC capture screen
map view
video player
native document viewer
```

Example:

```tsx
<NativePdfView filePath={filePath} />
<NativeEkycView sessionId={sessionId} />
```

---

## Infrastructure = hạ tầng

Use for:

```txt
API client
HTTP interceptor
repository
storage
network config
API mapper
cache
```

Infrastructure MUST NOT store:

```txt
NativePdfView
NativeEkycView
BiometricModules wrapper
DeviceSecurityModules wrapper
```

---

# ========================

# 🍏 iOS SWIFT RULE

# ========================

## NativeModules

Use Swift for function implementation.

```swift
@objc(BiometricModules)
class BiometricModules: NSObject {

    @objc
    func isEnable(
        _ resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        // check biometric availability
        resolve(true)
    }
}
```

## NativeUI

Use native view manager for native UI.

```swift
@objc(NativePdfViewManager)
class NativePdfViewManager: RCTViewManager {
    override func view() -> UIView! {
        return NativePdfView()
    }
}
```

Rule:

```txt
iOS NativeModules expose functions.
iOS NativeUI exposes UIView / ViewManager.
```

---

# ========================

# 🤖 ANDROID KOTLIN RULE

# ========================

## NativeModules

Use Kotlin for function module.

```kotlin
class BiometricModules(
    reactContext: ReactApplicationContext
) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String = "BiometricModules"

    @ReactMethod
    fun isEnable(promise: Promise) {
        promise.resolve(true)
    }
}
```

## NativeUI

Use ViewManager for native UI.

```kotlin
class NativePdfViewManager : SimpleViewManager<NativePdfView>() {
    override fun getName(): String = "NativePdfView"

    override fun createViewInstance(
        reactContext: ThemedReactContext
    ): NativePdfView {
        return NativePdfView(reactContext)
    }
}
```

Rule:

```txt
Android NativeModules expose functions.
Android NativeUI exposes ViewManager/View.
```

---

# ========================

# 🔐 SECURITY RULE

# ========================

NativeModules often touch sensitive capability.

MUST:

* Validate inputs
* Return typed result
* Never log sensitive data
* Never return private key / biometric secret / raw OTP / PIN
* Normalize native errors
* Clear temporary sensitive values after use

NativeUI MUST:

* Not expose sensitive raw data through props/events
* Mask sensitive display when needed
* Avoid sending full document/card data back to JS unless required and safe

---

# ========================

# 🚨 ERROR HANDLING RULE

# ========================

NativeModules must return stable errors.

Example error codes:

```txt
BIOMETRIC_NOT_AVAILABLE
BIOMETRIC_CANCELLED
PERMISSION_DENIED
DEVICE_ROOTED
PDF_SIGNATURE_INVALID
SDK_INITIALIZATION_FAILED
UNKNOWN_ERROR
```

Typed error:

```ts
export type NativeModuleError = {
  code: string;
  message: string;
};
```

NativeUI error event:

```ts
export type NativeViewErrorEvent = {
  nativeEvent: {
    code: string;
    message: string;
  };
};
```

---

# ========================

# 🔄 THREADING RULE

# ========================

## NativeModules

* Heavy crypto/PDF/file work must not block UI thread
* Promise must resolve/reject exactly once

## NativeUI

* UI work must run on native main/UI thread
* Avoid blocking JS thread with heavy events

---

# ========================

# 💸 FINTECH RULE

# ========================

## BiometricModules

```ts
const isEnable: boolean = await BiometricModules.isEnable();
```

* Return only capability/auth result
* Do not return biometric secret

## PdfSignatureModules

```ts
const result = await PdfSignatureModules.verifySignature(filePath);
```

* Return verification result only
* Do not silently modify signed PDF

## NativePdfView

```tsx
<NativePdfView filePath={filePath} />
```

* Display PDF via native UI
* Error events must be typed
* Sensitive file path handling must be controlled

## EkycModules / NativeEkycView

* Function calls belong to service/module
* Native capture UI belongs to component/native
* Return only required eKYC result fields

---

# ========================

# 🧪 TESTING RULE

# ========================

NativeModules must test:

* method exists
* typed return
* success
* permission denied
* unsupported device
* user cancelled
* unknown native error

NativeUI must test:

* required props
* event callbacks
* render fallback
* native error event

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Put NativeModules wrappers under `src/service/module/<name>/`
* Create interface file for every NativeModule
* Use typed module usage, e.g. `const isEnable: boolean = await BiometricModules.isEnable()`
* Put NativeUI under `src/component/native/<name>/`
* Keep infrastructure for API/storage/network only
* Separate native function from native UI
* Use Swift for iOS native function/UI implementation
* Use Kotlin for Android native function/UI implementation
* Normalize native errors

AI MUST NOT:

* Put NativeModules wrapper under `infrastructure/native`
* Put NativeUI under `infrastructure`
* Call raw `NativeModules.X` directly from screen/component/hook/application
* Use `any` for native module interface
* Mix function module and native UI in the same JS wrapper
* Return secret values to JS
* Log OTP/PIN/token/private key/biometric secret
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

Correct split:

```txt
NativeModules → src/service/module/<module-name>/
NativeUI      → src/component/native/<native-ui-name>/
Infrastructure → API / storage / network / repository only
```

Correct flow:

```txt
UI ↔ hook ↔ application ↔ service/module ↔ native function
```

Native UI flow:

```txt
presentation screen/view ↔ component/native ↔ iOS/Android native view
```

Golden rule:

```txt
NativeModules = functions
NativeUI = UI components
Infrastructure = hạ tầng/API/storage/network
```

This rule is mandatory for all React Native native integration generation.

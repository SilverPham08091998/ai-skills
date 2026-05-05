# generators/create-screen.md

## Objective

Generate a new screen in a React Native application following:

* Clean Architecture
* Feature-based structure
* Hook as bridge (UI ↔ Application)
* Design System usage
* Type-safe implementation

---

# STEP 1 — INPUT FORMAT

AI must ask user for the following:

```txt
Feature Name:
Screen Name:
Route Name:
Params (if any):
UI Description:
Use Cases (if any):
API needed? (yes/no):
```

---

# STEP 2 — GENERATION RULES

## 2.1 Folder Structure

```txt
src/presentation/features/<feature>/
  screen/<ScreenName>Screen.tsx
  hook/use<ScreenName>.ts
  type/<ScreenName>State.ts
```

---

## 2.2 Naming Convention

```txt
TransferScreen
useTransfer
TransferState
```

Rules:

* PascalCase for Screen
* camelCase for hook
* suffix Screen / use / State

---

# STEP 3 — SCREEN TEMPLATE

```tsx
import React from 'react';
import { View } from 'react-native';
import { use<ScreenName> } from '../hook/use<ScreenName>';
import { Text, Button } from '@/design-system';

export const <ScreenName>Screen = () => {
  const { state, actions } = use<ScreenName>();

  return (
    <View style={{ flex: 1 }}>
      <Text>{state.title}</Text>

      <Button
        label=\"Submit\"
        onPress={actions.onSubmit}
        disabled={state.loading}
      />
    </View>
  );
};
```

Rules:

* No business logic in screen
* Only render UI
* Only call hook

---

# STEP 4 — HOOK TEMPLATE

```ts
import { useState } from 'react';

export const use<ScreenName> = () => {
  const [state, setState] = useState({
    title: '',
    loading: false,
  });

  const onSubmit = async () => {
    setState(prev => ({ ...prev, loading: true }));

    try {
      // call usecase
    } catch (e) {
      // handle error
    } finally {
      setState(prev => ({ ...prev, loading: false }));
    }
  };

  return {
    state,
    actions: {
      onSubmit,
    },
  };
};
```

Rules:

* Hook handles state + side effects
* Call application layer (usecase)
* No UI rendering here

---

# STEP 5 — STATE TYPE

```ts
export type <ScreenName>State = {
  title: string;
  loading: boolean;
};
```

Rules:

* Define explicit state type
* No implicit state

---

# STEP 6 — NAVIGATION

```ts
navigation.navigate('<routeName>', params);
```

Rules:

* Route name must be namespaced
* Params must be typed

---

# STEP 7 — DESIGN SYSTEM USAGE

Must use:

* Text
* Button
* Input
* Layout from design-system

Forbidden:

* raw Text from react-native
* inline styles
* hardcoded colors

---

# STEP 8 — ERROR HANDLING

```ts
try {
  await useCase.execute();
} catch (error) {
  // map error → UI
}
```

Rules:

* Do not throw raw error to UI
* Use normalized error

---

# STEP 9 — FINTECH RULES

If screen is critical (payment / transfer):

* disable button while loading
* prevent double submit
* show loading state
* handle ambiguous state

---

# STEP 10 — OUTPUT FORMAT

AI must generate:

1. Screen file
2. Hook file
3. State type
4. Navigation usage (if needed)

---

# FINAL RULE

> Screen = UI only
> Hook = state + side effects
> Application = business logic

Never mix responsibilities.

---
name: state-redux-toolkit
description: Redux Toolkit standards for mobile state management. Use when creating slices, actions, selectors, thunks, and normalized client state.
---

# State REDUX Toolkit Guidelines

This Cursor skill adapts `mobile-engineer/state-management/redux-toolkit.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🗂️ REDUX TOOLKIT RULE (STATE MANAGEMENT)

# ========================

## 🎯 OBJECTIVE

Define how to use Redux Toolkit in mobile architecture to ensure:

* Predictable global state
* Clean separation with hook/application
* Scalable for super app
* Fintech-safe state handling

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
Redux = Global State Only
Hook = Screen State
Application = Business Flow
```

---

# ========================

# 📁 STRUCTURE

# ========================

```txt
src/application/store/
  store.ts
  root-reducer.ts

src/application/slice/
  auth/
    auth.slice.ts
    auth.selector.ts
  app/
    app.slice.ts
    app.selector.ts
```

---

# ========================

# 🔁 DATA FLOW

# ========================

```txt
Screen → Hook → dispatch(action)
Redux Store → selector → Hook → UI
```

---

# ========================

# 🔥 WHAT GOES INTO REDUX

# ========================

## ✅ SHOULD STORE

* user session
* auth state
* global config
* feature flags
* theme
* notification badge

## ❌ SHOULD NOT STORE

* form input (use hook)
* temporary UI state
* loading per screen
* sensitive data (OTP, PIN)

---

# ========================

# 🧾 SLICE RULE

# ========================

Example:

```ts
import { createSlice, PayloadAction } from '@reduxjs/toolkit';

type AuthState = {
  isAuthenticated: boolean;
  userId?: string;
};

const initialState: AuthState = {
  isAuthenticated: false,
};

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    setAuth(state, action: PayloadAction<AuthState>) {
      return action.payload;
    },
    logout() {
      return initialState;
    },
  },
});

export const { setAuth, logout } = authSlice.actions;
export default authSlice.reducer;
```

---

# ========================

# 🎯 SELECTOR RULE

# ========================

```ts
export const selectIsAuthenticated = (state: RootState) =>
  state.auth.isAuthenticated;
```

---

# ========================

# 🪝 HOOK INTEGRATION

# ========================

```ts
const isAuthenticated = useSelector(selectIsAuthenticated);
const dispatch = useDispatch();
```

---

# ========================

# 🔐 FINTECH RULE

# ========================

## MUST

* clear state on logout
* mask sensitive info

## MUST NOT

* store OTP
* store PIN
* store token in plain redux

---

# ========================

# 🧪 AI RULE

# ========================

AI MUST:

* use Redux Toolkit
* create slice per domain
* use selector

AI MUST NOT:

* store screen state in redux
* mix redux with business logic

---

# ========================

# 📌 SUMMARY

# ========================

```txt
Redux = global state
Hook = local state
UseCase = business logic
```

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

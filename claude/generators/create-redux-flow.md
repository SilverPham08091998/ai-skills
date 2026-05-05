# generators/create-redux-flow.md

## Objective

Generate a complete Redux-based state flow for a React Native feature following Clean Architecture, modular architecture, type safety, error normalization, observability, and fintech production rules.

Applies to:

* React Native
* TypeScript
* Redux Toolkit
* Redux Observable
* Redux Saga
* Clean Architecture
* Fintech / Banking apps

Main rule:

> Redux is a state orchestration tool, not a place to hide business logic.
> UI must dispatch actions through hooks, async logic must be isolated, and API calls must go through application/usecase/repository layers.

---

# 1. Input Format

AI must ask for or infer the following input:

```txt
Feature Name:
Redux Style: redux-toolkit | redux-observable | redux-saga
Flow Name:
State Shape:
Actions:
Async Flow Needed: yes/no
Use Case Name:
API Needed: yes/no
Error Handling Needed: yes/no
Persist Needed: yes/no
Critical Flow: yes/no
Fintech Flow: yes/no
```

Example:

```txt
Feature Name: Fund Transfer
Redux Style: redux-observable
Flow Name: Submit Transfer
State Shape:
- loading
- error
- transaction
Actions:
- submitTransferRequested
- submitTransferSucceeded
- submitTransferFailed
Use Case Name: SubmitTransferUseCase
API Needed: yes
Critical Flow: yes
Fintech Flow: yes
```

Rules:

* If Redux style is missing, default to `redux-toolkit`.
* If project already uses Redux Observable or Redux Saga, follow the existing style.
* Do not mix Redux Observable and Redux Saga in the same feature unless explicitly requested.

---

# 2. Target Folder Structure

Generate Redux flow inside the owning feature/module:

```txt
src/modules/<feature>/
  presentation/
    hook/
      use<FlowName>.ts
  application/
    usecase/
      <FlowName>UseCase.ts
    command/
      <FlowName>Command.ts
  state/
    <feature>Slice.ts
    <feature>Actions.ts
    <feature>Selectors.ts
    <feature>State.ts
    <feature>Thunks.ts          # redux-toolkit only
    <feature>Epics.ts           # redux-observable only
    <feature>Sagas.ts           # redux-saga only
  __tests__/
    unit/
    integration/
    builders/
```

Rules:

* State files belong to feature/module.
* Hook belongs to presentation.
* Use cases belong to application.
* API/repository stays outside Redux state files.

---

# 3. Redux Responsibility Rules

## 3.1 Redux State

Redux state stores:

* feature state
* async status
* normalized error
* domain-safe data

Redux state must NOT store:

* raw API response
* Axios error
* token / OTP / PIN
* large sensitive payload
* temporary input values unless needed globally

---

## 3.2 Reducer

Reducer must be pure.

Allowed:

* update loading/error/data state
* reset state
* apply deterministic transformations

Forbidden:

* API calls
* async/await
* navigation
* logging side effects
* reading secure storage

---

## 3.3 Async Flow

Async flow must call application use case, not API directly.

Correct:

```txt
Redux async flow → UseCase → Repository → API
```

Incorrect:

```txt
Redux async flow → Axios directly ❌
```

---

## 3.4 Hook Bridge

UI must consume Redux through feature hook.

```txt
Screen → useFeatureHook → Redux dispatch/selectors
```

Rules:

* Screens should not import actions/selectors directly when a hook exists.
* Hook maps Redux state/actions to UI-friendly state/actions.

---

# 4. State Type Generation

Generate explicit state type.

```ts
import type { AppError } from '@shared/error';

export type <FeatureName>State = {
  loading: boolean;
  error: AppError | null;
  data: <FlowName>Model | null;
  lastUpdatedAt?: string;
};
```

Initial state:

```ts
export const initial<FeatureName>State: <FeatureName>State = {
  loading: false,
  error: null,
  data: null,
};
```

Rules:

* State must be explicitly typed.
* Store normalized `AppError`, never raw errors.
* Store domain model, not DTO.

---

# 5. Redux Toolkit Generator

Use when `Redux Style: redux-toolkit`.

## 5.1 Slice

```ts
import { createSlice, PayloadAction } from '@reduxjs/toolkit';

import type { AppError } from '@shared/error';

import type { <FlowName>Model } from '../domain/model/<FlowName>Model';
import type { <FeatureName>State } from './<FeatureName>State';

const initialState: <FeatureName>State = {
  loading: false,
  error: null,
  data: null,
};

export const <featureName>Slice = createSlice({
  name: '<featureName>',
  initialState,
  reducers: {
    <flowName>Requested(state) {
      state.loading = true;
      state.error = null;
    },
    <flowName>Succeeded(state, action: PayloadAction<<FlowName>Model>) {
      state.loading = false;
      state.data = action.payload;
      state.lastUpdatedAt = new Date().toISOString();
    },
    <flowName>Failed(state, action: PayloadAction<AppError>) {
      state.loading = false;
      state.error = action.payload;
    },
    reset<FeatureName>State() {
      return initialState;
    },
  },
});

export const <featureName>Actions = <featureName>Slice.actions;
export const <featureName>Reducer = <featureName>Slice.reducer;
```

Rules:

* Reducers must remain pure.
* Do not perform async operations in reducers.
* Avoid storing raw API DTO.

---

## 5.2 createAsyncThunk

```ts
import { createAsyncThunk } from '@reduxjs/toolkit';

import { normalizeApiError } from '@shared/error';

import type { <FlowName>Command } from '../application/command/<FlowName>Command';
import type { <FlowName>UseCase } from '../application/usecase/<FlowName>UseCase';

export function create<FlowName>Thunk(useCase: <FlowName>UseCase) {
  return createAsyncThunk(
    '<featureName>/<flowName>',
    async (command: <FlowName>Command, { rejectWithValue }) => {
      try {
        return await useCase.execute(command);
      } catch (error) {
        return rejectWithValue(normalizeApiError(error));
      }
    },
  );
}
```

Rules:

* Thunk calls use case only.
* Thunk must normalize error using `rejectWithValue`.
* Do not call Axios directly inside thunk.

---

# 6. Redux Observable Generator

Use when `Redux Style: redux-observable`.

## 6.1 Actions

```ts
import { createAction } from '@reduxjs/toolkit';

import type { AppError } from '@shared/error';
import type { <FlowName>Command } from '../application/command/<FlowName>Command';
import type { <FlowName>Model } from '../domain/model/<FlowName>Model';

export const <flowName>Requested = createAction<<FlowName>Command>('<featureName>/<flowName>Requested');
export const <flowName>Succeeded = createAction<<FlowName>Model>('<featureName>/<flowName>Succeeded');
export const <flowName>Failed = createAction<AppError>('<featureName>/<flowName>Failed');
```

---

## 6.2 Epic

```ts
import { of } from 'rxjs';
import { catchError, exhaustMap, map } from 'rxjs/operators';
import { ofType } from 'redux-observable';

import { normalizeApiError } from '@shared/error';

export const create<FlowName>Epic = (useCase: <FlowName>UseCase) => (action$) =>
  action$.pipe(
    ofType(<flowName>Requested.type),
    exhaustMap((action) =>
      useCase.execute(action.payload).then(<flowName>Succeeded).catch((error) => <flowName>Failed(normalizeApiError(error))),
    ),
  );
```

Preferred RxJS version:

```ts
import { from, of } from 'rxjs';
import { catchError, exhaustMap, map } from 'rxjs/operators';
import { ofType } from 'redux-observable';

export const create<FlowName>Epic = (useCase: <FlowName>UseCase) => (action$) =>
  action$.pipe(
    ofType(<flowName>Requested.type),
    exhaustMap((action) =>
      from(useCase.execute(action.payload)).pipe(
        map(<flowName>Succeeded),
        catchError((error) => of(<flowName>Failed(normalizeApiError(error)))),
      ),
    ),
  );
```

Rules:

* Use `exhaustMap` for submit actions to prevent duplicate execution.
* Use `switchMap` for search/typeahead flows.
* Use `concatMap` for ordered queues.
* Use `mergeMap` for independent parallel work.
* Always use `catchError` inside inner stream.
* Do not let epic stream die.

---

# 7. Redux Saga Generator

Use when `Redux Style: redux-saga`.

```ts
import { call, put, takeLeading } from 'redux-saga/effects';

import { normalizeApiError } from '@shared/error';

function* handle<FlowName>(action: ReturnType<typeof <flowName>Requested>) {
  try {
    const result: <FlowName>Model = yield call([useCase, useCase.execute], action.payload);
    yield put(<flowName>Succeeded(result));
  } catch (error) {
    yield put(<flowName>Failed(normalizeApiError(error)));
  }
}

export function* <featureName>Saga() {
  yield takeLeading(<flowName>Requested.type, handle<FlowName>);
}
```

Rules:

* Use `takeLeading` for submit actions.
* Use `takeLatest` for search flows.
* Use `takeEvery` only for independent events.
* Saga calls use case only.
* Do not call Axios directly in saga.

---

# 8. Selector Generation

Generate selectors for state access.

```ts
import type { RootState } from '@app/store';

export const select<FeatureName>State = (state: RootState) => state.<featureName>;

export const select<FeatureName>Loading = (state: RootState) =>
  select<FeatureName>State(state).loading;

export const select<FeatureName>Error = (state: RootState) =>
  select<FeatureName>State(state).error;

export const select<FeatureName>Data = (state: RootState) =>
  select<FeatureName>State(state).data;
```

Rules:

* UI should use selectors through hooks.
* Use memoized selectors for derived data.
* Do not expose raw state structure widely.

---

# 9. Hook Generation

Generate a feature hook that hides Redux details from screens.

```ts
import { useCallback } from 'react';
import { useDispatch, useSelector } from 'react-redux';

export function use<FlowName>() {
  const dispatch = useDispatch();
  const loading = useSelector(select<FeatureName>Loading);
  const error = useSelector(select<FeatureName>Error);
  const data = useSelector(select<FeatureName>Data);

  const submit = useCallback(
    (command: <FlowName>Command): void => {
      if (loading) return;
      dispatch(<flowName>Requested(command));
    },
    [dispatch, loading],
  );

  return {
    state: {
      loading,
      error,
      data,
    },
    actions: {
      submit,
    },
  };
}
```

Rules:

* Screen consumes hook only.
* Hook prevents duplicate submit when needed.
* Hook returns UI-friendly state/actions.

---

# 10. Store Registration

Generate reducer registration instructions.

```ts
import { <featureName>Reducer } from '@modules/<feature>/state/<featureName>Slice';

export const rootReducer = {
  <featureName>: <featureName>Reducer,
};
```

For epics:

```ts
combineEpics(
  create<FlowName>Epic(useCase),
);
```

For sagas:

```ts
yield all([
  <featureName>Saga(),
]);
```

Rules:

* Feature reducer key must be stable.
* Lazy module registration is allowed if project supports it.

---

# 11. Persist Rules

Use Redux Persist only when needed.

Allowed:

* non-sensitive preferences
* feature flags cache
* lightweight UI state if required

Forbidden:

* access token
* refresh token
* OTP
* PIN
* sensitive transaction payload
* full account/card number

Rules:

* Persist whitelist must be explicit.
* Sensitive data must use secure storage, not Redux Persist.

---

# 12. Error Handling Rules

Redux failure action must contain `AppError`.

```ts
<flowName>Failed(normalizeApiError(error));
```

Rules:

* Do not dispatch raw Axios error.
* Do not store raw native error.
* UI must render safe user-facing error.

---

# 13. Loading & Duplicate Submit Rules

For critical actions:

* set loading on request
* disable submit button
* ignore duplicate submit while loading
* use `exhaustMap` / `takeLeading` / loading guard

Rules:

* Do not allow multiple transfer/payment submits from double tap.
* Do not rely on UI disabled only; async layer must also protect.

---

# 14. Fintech Rules (CRITICAL)

If `Fintech Flow: yes`, generator must enforce:

## 14.1 Idempotency

Command must include:

```ts
idempotencyKey: string;
```

Rules:

* Same operation reuses same idempotency key.
* Retry must not generate a new key.

---

## 14.2 No Blind Retry

Redux async flow must not blindly retry:

* transfer submit
* payment submit
* OTP verify
* wallet mutation

Timeout after submit must become ambiguous/pending and trigger status inquiry when applicable.

---

## 14.3 Safe State

State should include transaction status when needed:

```ts
type TransactionState = {
  status: 'IDLE' | 'SUBMITTING' | 'PENDING' | 'SUCCESS' | 'FAILED' | 'UNKNOWN';
};
```

Rules:

* Timeout after submit is not automatic failure.
* Backend remains source of truth.

---

# 15. Observability Rules

Generated flow should log safe events:

```txt
<FEATURE>_<FLOW>_REQUESTED
<FEATURE>_<FLOW>_SUCCEEDED
<FEATURE>_<FLOW>_FAILED
<FEATURE>_<FLOW>_AMBIGUOUS
```

Allowed metadata:

* traceId
* requestId
* errorCode
* durationMs
* status

Forbidden metadata:

* token
* OTP/PIN
* raw payload
* full account/card number

---

# 16. Tests to Generate

Generate or suggest tests for:

```txt
Reducer sets loading on requested
Reducer stores data on succeeded
Reducer stores AppError on failed
Selector returns correct state
Hook dispatches requested action
Hook prevents duplicate submit
Epic/Saga/Thunk calls use case
Epic/Saga/Thunk normalizes errors
Critical flow does not double submit
```

For Redux Observable:

* test `exhaustMap` behavior
* test stream does not die on error

For Redux Saga:

* test success path
* test failure path
* test `takeLeading` behavior when applicable

---

# 17. Output Format

AI must output files grouped by path:

```txt
File: src/modules/<feature>/state/<feature>State.ts
<code>

File: src/modules/<feature>/state/<feature>Slice.ts
<code>

File: src/modules/<feature>/state/<feature>Selectors.ts
<code>

File: src/modules/<feature>/presentation/hook/use<FlowName>.ts
<code>
```

Rules:

* Generate only relevant files for selected Redux style.
* Do not generate thunk + epic + saga together unless requested.
* If existing store conventions exist, follow them.

---

# 18. Anti-patterns

* API call directly inside screen.
* API call directly inside reducer.
* Storing raw DTO in Redux.
* Storing raw Axios error in Redux.
* Storing sensitive data in Redux Persist.
* Mixing saga and observable without reason.
* Missing `catchError` in epic.
* Using `mergeMap` for payment submit.
* Retrying money movement with a new idempotency key.
* UI importing too many Redux internals instead of using hook.

---

# 19. Checklist

* [ ] Redux style selected.
* [ ] State type generated.
* [ ] Initial state generated.
* [ ] Actions generated.
* [ ] Reducer/slice generated.
* [ ] Async flow generated using use case.
* [ ] Selectors generated.
* [ ] Presentation hook generated.
* [ ] Store registration shown.
* [ ] Error normalized as AppError.
* [ ] Duplicate submit prevention applied.
* [ ] Fintech idempotency applied when needed.
* [ ] Tests generated or test plan included.

---

# 20. Final Rule

> Redux flow must coordinate state, not own business rules.
> Keep async behavior predictable, errors normalized, and critical fintech actions safe from duplicate execution.

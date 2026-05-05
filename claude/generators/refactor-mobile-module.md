# generators/refactor-mobile-module.md

## Objective

Refactor an existing React Native feature/module into the project’s Mobile Clean Architecture and modular structure without changing behavior.

Applies to:

* React Native
* TypeScript
* Existing source code
* Feature modules
* Redux / hooks / API integrations
* Native Module / Native UI integrations
* Fintech / Banking apps

Main rule:

> Refactor structure and responsibility boundaries, not business behavior.
> Preserve existing behavior unless the user explicitly requests behavior changes.

---

# 1. Input Format

AI must ask for or infer the following input:

```txt
Module / Feature Name:
Current Path:
Target Path:
Current Problems:
State Management Used:
API Calls Exist: yes/no
Native Integration Exists: yes/no
Screens:
Hooks:
Services:
Known Bugs To Preserve or Fix:
Refactor Scope: structure-only | structure-and-cleanup | structure-and-tests
```

Example:

```txt
Module / Feature Name: Fund Transfer
Current Path: src/features/fundTransfer
Target Path: src/modules/fund-transfer
Current Problems:
- API call inside screen
- DTO leaks into UI
- duplicated loading state
- no error normalization
State Management Used: redux-observable
API Calls Exist: yes
Native Integration Exists: no
Refactor Scope: structure-and-tests
```

Rules:

* If information is missing, inspect existing code and make minimal safe assumptions.
* Do not create a new module from scratch if user wants refactor.
* Preserve public behavior and route names unless explicitly requested.

---

# 2. Refactor Goals

The refactor must achieve:

```txt
UI → Hook → Application → Domain → Infrastructure
```

Goals:

* Screen contains UI only.
* Hook bridges UI and application/state.
* Application owns use cases and flow orchestration.
* Domain owns pure models/contracts/rules.
* Infrastructure owns API/storage/native implementations.
* Errors are normalized.
* Sensitive data is not logged or persisted incorrectly.

---

# 3. Target Structure

Default target:

```txt
src/modules/<feature>/
  index.ts
  README.md
  presentation/
    screen/
    component/
    hook/
    type/
  application/
    command/
    usecase/
    service/
  domain/
    model/
    repository/
    service/
  infrastructure/
    api/
    dto/
    mapper/
    repository/
    storage/
    native/
  state/
    <feature>State.ts
    <feature>Slice.ts
    <feature>Actions.ts
    <feature>Selectors.ts
    <feature>Epics.ts
    <feature>Sagas.ts
    <feature>Thunks.ts
  navigation/
  __tests__/
    unit/
    integration/
    builders/
```

Rules:

* Generate only folders/files needed by the existing feature.
* Do not create empty folders unless project convention requires it.
* If current project uses `presentation/features/<feature>`, preserve project convention unless user asks to migrate to `modules/`.

---

# 4. Refactor Process

## Step 1 — Analyze Current Module

AI must identify:

* screens/components
* hooks
* API calls
* services
* models/types
* Redux state/actions/epics/sagas/thunks
* navigation routes
* native integrations
* storage usage
* duplicated logic
* layer violations

Output analysis before code changes when possible.

---

## Step 2 — Classify Existing Code

Classify each file into target layer:

```txt
Screen / Component → presentation
Custom hook → presentation/hook
Business flow → application/usecase
Business data → domain/model
Repository interface → domain/repository
API client → infrastructure/api
API DTO → infrastructure/dto
DTO mapper → infrastructure/mapper
Storage/native → infrastructure
Redux state → state
```

Rules:

* Do not keep API DTO in UI.
* Do not keep business logic in screen.
* Do not keep HTTP calls in hook.

---

## Step 3 — Move Files Safely

When moving files:

* update imports
* preserve exports
* preserve tests where possible
* avoid changing logic unnecessarily
* do not delete old files until new references are verified

Rules:

* Prefer small, traceable changes.
* Do not rename public routes unless requested.
* Do not rename public API contracts unless requested.

---

## Step 4 — Extract Use Cases

If screen/hook/service contains business flow, extract it to application use case.

Before:

```ts
async function onSubmit() {
  const response = await api.submitTransfer(form);
  setResult(response);
}
```

After:

```ts
export class SubmitTransferUseCase {
  constructor(private readonly repository: TransferRepository) {}

  async execute(command: SubmitTransferCommand): Promise<TransferModel> {
    return this.repository.submit(command);
  }
}
```

Rules:

* Use case receives command.
* Use case returns domain model/application result.
* Use case must not return DTO.

---

## Step 5 — Extract Repository Boundary

Create domain repository interface when missing.

```ts
export interface TransferRepository {
  submit(command: SubmitTransferCommand): Promise<TransferModel>;
}
```

Create infrastructure implementation.

```ts
export class TransferRepositoryImpl implements TransferRepository {
  constructor(private readonly api: TransferApi) {}

  async submit(command: SubmitTransferCommand): Promise<TransferModel> {
    const dto = TransferMapper.toRequestDto(command);
    const response = await this.api.submit(dto);
    return TransferMapper.toModel(response);
  }
}
```

Rules:

* Domain owns interface.
* Infrastructure owns implementation.
* API DTO must stay in infrastructure.

---

# 5. Presentation Refactor Rules

## 5.1 Screen Rule

Screen must only:

* render UI
* call hook actions
* read hook state

Forbidden:

* API calls
* repository calls
* business rules
* raw error parsing
* secure storage access

---

## 5.2 Hook Rule

Hook may:

* manage UI state
* dispatch Redux actions
* call use case
* map AppError to UI state

Hook must not:

* call Axios directly
* access raw NativeModules directly
* store sensitive data unsafely

---

# 6. API Refactor Rules

If existing code calls API directly from UI/hook, move it to:

```txt
infrastructure/api
infrastructure/repository
application/usecase
```

Rules:

* Generate DTOs for request/response.
* Generate mapper DTO ↔ model.
* Normalize API errors.
* Preserve endpoint, method, headers, and payload behavior.

---

# 7. Redux Refactor Rules

If existing module uses Redux:

* keep reducer pure
* move async API calls to thunk/epic/saga
* async flow must call use case, not API directly
* selectors must be centralized
* screen must use hook, not import many Redux internals

For Redux Observable:

* add `catchError` inside inner stream
* choose correct operator:

    * `exhaustMap` for submit
    * `switchMap` for search
    * `concatMap` for ordered queue
    * `mergeMap` for independent parallel work

For Redux Saga:

* use `takeLeading` for submit
* use `takeLatest` for search
* saga calls use case only

---

# 8. Native Integration Refactor Rules

If existing code uses `NativeModules` directly:

Refactor to:

```txt
infrastructure/native/<feature>/module
infrastructure/native/<feature>/service
presentation/hook or component
```

Rules:

* NativeModule = functions/capabilities.
* NativeUI = native-rendered component.
* UI must not call raw `NativeModules`.
* Add TypeScript interface for native methods.
* Normalize native errors.
* Clean up native event subscriptions.

---

# 9. Error Handling Refactor Rules

Replace raw error handling:

Bad:

```ts
Alert.alert(error.response.data.message);
```

Good:

```ts
const appError = normalizeApiError(error);
setError(appError);
```

Rules:

* Store `AppError`, not raw Axios error.
* Preserve `traceId` if available.
* UI displays safe messages only.

---

# 10. Security Refactor Rules

During refactor, check and fix:

* tokens in AsyncStorage
* sensitive data in Redux
* OTP/PIN stored in state longer than needed
* raw payload logs
* account/card numbers not masked
* debug logs in production paths

Rules:

* Do not introduce new sensitive logs.
* Do not persist secrets in Redux Persist.
* Move secrets to secure storage service.

---

# 11. Performance Refactor Rules

During refactor, improve only safe performance issues:

* memoize pure components when needed
* avoid inline heavy calculations
* use selectors for derived state
* avoid re-rendering whole screen unnecessarily
* clean up timers/subscriptions

Rules:

* Do not over-optimize.
* Do not change behavior to chase micro-performance.

---

# 12. Fintech Rules (CRITICAL)

If feature is payment/transfer/wallet mutation:

## 12.1 Preserve Transaction Integrity

* Do not change submit semantics without approval.
* Do not add blind retry.
* Do not generate new idempotency key for retry.

## 12.2 Add Missing Protections

If missing, suggest or implement:

* duplicate submit prevention
* loading disabled state
* idempotency key support
* timeout as ambiguous state
* status inquiry after ambiguous submit

## 12.3 Backend Source of Truth

* Do not decide final transaction success from local state only.
* Always respect backend status.

---

# 13. Testing Requirements

Depending on scope, add or update tests:

Unit tests:

* mapper
* use case
* reducer
* selector

Integration tests:

* hook/use case flow
* Redux async flow
* API error normalization

Critical fintech tests:

* duplicate submit prevention
* timeout → status inquiry
* business error not retried
* same idempotency key reused

---

# 14. Output Format

AI must output:

```txt
1. Refactor analysis
2. Target structure
3. File move plan
4. Generated/updated files grouped by path
5. Test plan or generated tests
6. Risks / assumptions
```

File output format:

```txt
File: src/modules/<feature>/application/usecase/<UseCase>.ts
<code>
```

Rules:

* Do not output one huge undifferentiated code block.
* Group code by file path.
* Mention deleted/renamed files explicitly.

---

# 15. Migration Safety Rules

* Preserve behavior by default.
* Prefer incremental refactor.
* Keep route names stable.
* Keep API contracts stable.
* Keep analytics/log event names stable unless requested.
* Keep storage keys stable unless migration is provided.

If storage key changes are required:

* provide migration strategy
* preserve backward compatibility

---

# 16. Anti-patterns

* Creating a new feature beside the old one instead of refactoring.
* Moving files without updating imports.
* Calling API from screen after refactor.
* Returning DTO to UI.
* Creating duplicate repository/use case for same behavior.
* Mixing NativeModule and NativeUI responsibilities.
* Adding blind retry to money movement.
* Changing route names without migration.
* Deleting tests without replacement.

---

# 17. Checklist

* [ ] Existing behavior understood.
* [ ] Files classified by layer.
* [ ] Target structure defined.
* [ ] Screens contain UI only.
* [ ] Hooks bridge UI and application/state.
* [ ] Use cases extracted.
* [ ] Repository boundary created/updated.
* [ ] DTOs stay in infrastructure.
* [ ] Mappers created/updated.
* [ ] Errors normalized.
* [ ] Redux flow respects selected style.
* [ ] Native access wrapped if any.
* [ ] Sensitive data handling reviewed.
* [ ] Critical fintech rules preserved.
* [ ] Tests updated or test plan provided.

---

# 18. Final Rule

> Refactor must reduce coupling without changing business meaning.
> Preserve behavior, improve boundaries, and make the module easier to test, maintain, and release safely.

# generators/create-feature.md

## Objective

Generate a complete React Native feature/module following Clean Architecture, modular architecture, design-system rules, testing rules, and fintech production standards.

Applies to:

* React Native
* TypeScript
* Clean Architecture
* Feature-based modules
* Super App / Mini App architecture
* Fintech / Banking apps

Main rule:

> A feature must be generated as a complete module, not as scattered files.
> UI, business flow, domain rules, infrastructure, navigation, and tests must be separated clearly.

---

# 1. Input Format

AI must ask for or infer the following input:

```txt
Feature Name:
Feature Type: screen-only | api-driven | flow | mini-app
Description:
Routes:
Screens:
Use Cases:
API Needed: yes/no
Storage Needed: yes/no
Native Module Needed: yes/no
State Management: local | redux-toolkit | redux-observable | redux-saga
Critical Flow: yes/no
Fintech Flow: yes/no
```

Example:

```txt
Feature Name: Fund Transfer
Feature Type: flow
Routes:
- transfer.input
- transfer.confirm
- transfer.result
Use Cases:
- create transfer draft
- submit transfer
- inquire transaction status
API Needed: yes
State Management: local
Critical Flow: yes
Fintech Flow: yes
```

Rules:

* If required information is missing, generate a safe baseline and clearly mark assumptions.
* Do not create unrelated folders/classes.
* Do not duplicate existing feature logic.

---

# 2. Target Folder Structure

Generate feature under:

```txt
src/modules/<feature-name>/
  index.ts
  README.md
  presentation/
    screen/
    component/
    hook/
    type/
  application/
    usecase/
    command/
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
  navigation/
  __tests__/
    unit/
    integration/
    builders/
```

If the project uses `src/presentation/features`, generate presentation files there only when the existing project structure requires it.

Default rule:

> Prefer `src/modules/<feature>` for modular architecture.

---

# 3. Layer Responsibility Rules

## 3.1 Presentation Layer

Contains:

* screens
* components
* hooks
* UI state types

Responsibilities:

* render UI
* receive user actions
* call hooks
* show loading/error/success state

Forbidden:

* direct API calls
* business rules
* repository access
* raw native module access

---

## 3.2 Hook Layer

Hook is the bridge:

```txt
UI ↔ Hook ↔ Application
```

Responsibilities:

* manage UI state
* call use cases
* handle side effects
* map normalized error to UI state
* prevent duplicate submit

Rules:

* Hook may contain state and props types.
* Hook must not render UI.
* Hook must not call raw API directly.

---

## 3.3 Application Layer

Contains:

* use cases
* commands
* orchestration services

Responsibilities:

* orchestrate business flow
* validate command-level rules
* call domain services/repositories
* handle transaction-like flow
* coordinate retry/status inquiry when needed

Forbidden:

* UI rendering
* React Native imports
* raw API DTO exposure

---

## 3.4 Domain Layer

Contains:

* domain models
* repository contracts
* pure business rules

Rules:

* No framework dependency.
* No React Native dependency.
* No API DTO dependency.
* No storage/native implementation.

---

## 3.5 Infrastructure Layer

Contains:

* API clients
* DTOs
* mappers
* repository implementations
* storage implementations
* native module wrappers if feature-specific

Responsibilities:

* communicate with external systems
* map DTO ↔ domain model
* normalize external errors

Forbidden:

* UI state
* business decisions that belong to domain/application

---

# 4. Naming Convention

Use PascalCase for classes/types and camelCase for variables/functions.

Example for `FundTransfer`:

```txt
FundTransferScreen.tsx
useFundTransfer.ts
FundTransferState.ts
SubmitFundTransferUseCase.ts
SubmitFundTransferCommand.ts
FundTransferModel.ts
FundTransferRepository.ts
FundTransferApi.ts
FundTransferDto.ts
FundTransferMapper.ts
```

Rules:

* Screen suffix: `Screen`
* Hook prefix: `use`
* Use case suffix: `UseCase`
* Command suffix: `Command`
* Domain model suffix: `Model`
* Repository interface suffix: `Repository`
* API class suffix: `Api`
* DTO suffix: `Dto`, `RequestDto`, `ResponseDto`
* Mapper suffix: `Mapper`

---

# 5. Public API Rule

Every feature/module must expose public contracts from `index.ts`.

```ts
export { FundTransferNavigator } from './navigation/FundTransferNavigator';
export type { FundTransferRouteParams } from './navigation/FundTransferRouteParams';
export { createFundTransferModule } from './FundTransferModuleFactory';
```

Rules:

* Other modules can import only from module root.
* No deep imports from another module's internal files.
* Public API must remain stable.

---

# 6. Screen Generation Rules

For each screen, generate:

```txt
presentation/screen/<ScreenName>Screen.tsx
presentation/hook/use<ScreenName>.ts
presentation/type/<ScreenName>State.ts
```

Screen template:

```tsx
import React from 'react';

import { Button, Text, ScreenContainer } from '@design-system';

import { use<ScreenName> } from '../hook/use<ScreenName>';

export function <ScreenName>Screen(): React.JSX.Element {
  const { state, actions } = use<ScreenName>();

  return (
    <ScreenContainer>
      <Text variant="h2">{state.title}</Text>
      <Button
        label="Continue"
        onPress={actions.onSubmit}
        loading={state.loading}
        disabled={state.loading}
      />
    </ScreenContainer>
  );
}
```

Rules:

* Use design-system components.
* No raw API calls.
* No business logic.
* Critical buttons must support loading/disabled.

---

# 7. Hook Generation Rules

Hook template:

```ts
import { useCallback, useState } from 'react';

import type { AppError } from '@shared/error';

import type { <ScreenName>State } from '../type/<ScreenName>State';

export function use<ScreenName>() {
  const [state, setState] = useState<<ScreenName>State>({
    title: '<ScreenName>',
    loading: false,
    error: null,
  });

  const onSubmit = useCallback(async (): Promise<void> => {
    if (state.loading) return;

    setState((prev) => ({ ...prev, loading: true, error: null }));

    try {
      // call use case here
    } catch (error) {
      const appError = error as AppError;
      setState((prev) => ({ ...prev, error: appError }));
    } finally {
      setState((prev) => ({ ...prev, loading: false }));
    }
  }, [state.loading]);

  return {
    state,
    actions: {
      onSubmit,
    },
  };
}
```

Rules:

* Prevent duplicate submit.
* Normalize errors before UI display.
* Keep side effects in hook/application, not screen.

---

# 8. Application Use Case Rules

Use case template:

```ts
export class Submit<FeatureName>UseCase {
  constructor(private readonly repository: <FeatureName>Repository) {}

  async execute(command: Submit<FeatureName>Command): Promise<<FeatureName>Model> {
    return this.repository.submit(command);
  }
}
```

Command template:

```ts
export type Submit<FeatureName>Command = {
  userId: string;
  requestId: string;
};
```

Rules:

* Use case receives command, not UI DTO.
* Use case returns domain model or application response.
* Use case must not return raw API DTO.

---

# 9. Domain Rules

Repository contract:

```ts
export interface <FeatureName>Repository {
  submit(command: Submit<FeatureName>Command): Promise<<FeatureName>Model>;
}
```

Model:

```ts
export type <FeatureName>Model = {
  id: string;
  status: '<STATUS_1>' | '<STATUS_2>';
};
```

Rules:

* Domain contracts must not depend on infrastructure DTOs.
* Domain models should use business naming.

---

# 10. Infrastructure Rules

API DTO:

```ts
export type Submit<FeatureName>RequestDto = {
  request_id: string;
};

export type Submit<FeatureName>ResponseDto = {
  id: string;
  status: string;
};
```

Mapper:

```ts
export class <FeatureName>Mapper {
  static toModel(dto: Submit<FeatureName>ResponseDto): <FeatureName>Model {
    return {
      id: dto.id,
      status: dto.status as <FeatureName>Model['status'],
    };
  }
}
```

Repository implementation:

```ts
export class <FeatureName>RepositoryImpl implements <FeatureName>Repository {
  constructor(private readonly api: <FeatureName>Api) {}

  async submit(command: Submit<FeatureName>Command): Promise<<FeatureName>Model> {
    const response = await this.api.submit(command);
    return <FeatureName>Mapper.toModel(response);
  }
}
```

Rules:

* Map DTO to model in infrastructure.
* Do not leak DTO to application/presentation.
* Normalize API errors.

---

# 11. Navigation Rules

Generate typed route params:

```ts
export type <FeatureName>RouteParams = {
  '<feature>.input': undefined;
  '<feature>.confirm': { draftId: string };
  '<feature>.result': { transactionId: string };
};
```

Rules:

* Route names must be namespaced.
* Params must be typed.
* Pass IDs, not large objects.

---

# 12. Dependency Injection Rules

Generate module factory:

```ts
export type <FeatureName>ModuleDeps = {
  httpClient: HttpClient;
  logger: Logger;
  featureFlags: FeatureFlagService;
};

export function create<FeatureName>Module(deps: <FeatureName>ModuleDeps) {
  const api = new <FeatureName>Api(deps.httpClient);
  const repository = new <FeatureName>RepositoryImpl(api);
  const submitUseCase = new Submit<FeatureName>UseCase(repository);

  return {
    submitUseCase,
  };
}
```

Rules:

* No hidden singletons.
* Dependencies must be injectable.
* Tests must be able to mock dependencies.

---

# 13. Testing Rules

Generate tests when requested:

```txt
__tests__/unit/<FeatureName>UseCase.test.ts
__tests__/integration/<FeatureName>Flow.integration.test.ts
__tests__/builders/<FeatureName>Builder.ts
```

Must test:

* use case success
* use case error
* mapper correctness
* hook loading/error state
* duplicate submit prevention for critical flows

---

# 14. Fintech Rules (CRITICAL)

If `Fintech Flow: yes`, generator must include:

## 14.1 Idempotency

Mutation command must include:

```ts
idempotencyKey: string;
```

Rules:

* Same logical operation reuses same key.
* Retry must not generate a new key.

---

## 14.2 Duplicate Submit Protection

UI/hook must:

* disable submit button while loading
* ignore submit when loading
* show progress state

---

## 14.3 Ambiguous State Handling

For payment/transfer flows:

```txt
submit → timeout/network error → status inquiry → final state
```

Rules:

* Timeout after submit is not automatic failure.
* Do not retry money movement blindly.
* Backend is source of truth.

---

## 14.4 Sensitive Data

Generator must avoid:

* logging raw payload
* storing OTP/PIN
* showing technical errors
* storing sensitive transaction payloads locally

---

# 15. Observability Rules

Generated feature must support:

* logger events
* traceId propagation
* safe error logging

Example events:

```txt
<FEATURE>_FLOW_STARTED
<FEATURE>_SUBMIT_STARTED
<FEATURE>_SUBMIT_SUCCESS
<FEATURE>_SUBMIT_FAILED
```

Rules:

* Do not log sensitive data.
* Include traceId/requestId where available.

---

# 16. Output Format

AI must output generated files grouped by path:

```txt
File: src/modules/<feature>/presentation/screen/<ScreenName>Screen.tsx
<code>

File: src/modules/<feature>/presentation/hook/use<ScreenName>.ts
<code>
```

Rules:

* Do not output unrelated files.
* Do not create duplicate classes if existing ones are available.
* Mention assumptions clearly.

---

# 17. Anti-patterns

* Creating only a screen and calling it a feature.
* Calling API directly from screen.
* Putting business logic in hook/screen.
* Returning API DTO to UI.
* Using untyped navigation params.
* Creating hidden singletons.
* Retrying money movement without idempotency.
* Deep importing another module internals.

---

# 18. Checklist

* [ ] Feature folder generated.
* [ ] Presentation/application/domain/infrastructure separated.
* [ ] Hook bridges UI and application.
* [ ] Public API exported from `index.ts`.
* [ ] Route params typed.
* [ ] DTOs mapped to domain models.
* [ ] Dependencies injected.
* [ ] Errors normalized.
* [ ] Tests generated or test plan provided.
* [ ] Fintech rules applied when relevant.
* [ ] No sensitive logs.

---

# 19. Final Rule

> Generate the smallest complete feature that respects architecture boundaries.
> Do not scatter files, bypass layers, or mix responsibilities.

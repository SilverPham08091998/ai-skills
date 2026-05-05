# generators/create-api-flow.md

## Objective

Generate a complete API-driven flow in React Native following Clean Architecture, type-safe API integration, error normalization, retry/timeout rules, observability, and fintech safety standards.

Applies to:

* React Native
* TypeScript
* API-driven features
* Clean Architecture
* Fintech / Banking apps

Main rule:

> API flow must be generated through proper layers.
> UI must never call API directly, and API DTOs must never leak into presentation.

---

# 1. Input Format

AI must ask for or infer the following input:

```txt
Feature Name:
API Flow Name:
Endpoint:
HTTP Method:
Request Body:
Path Params:
Query Params:
Headers:
Response Body:
Error Response:
Auth Required: yes/no
Idempotency Required: yes/no
Retry Allowed: yes/no
Timeout Handling:
Fintech Critical Flow: yes/no
```

Example:

```txt
Feature Name: Fund Transfer
API Flow Name: Submit Transfer
Endpoint: POST /api/v1/fund-transfer/bank
Request Body:
- fromAccountId
- toBankAccount
- amount
- currency
Response Body:
- transactionId
- status
Auth Required: yes
Idempotency Required: yes
Retry Allowed: no
Fintech Critical Flow: yes
```

Rules:

* If request/response is missing, generate placeholder DTOs and mark TODOs.
* If flow is fintech-critical, default retry to false unless idempotency and inquiry are defined.
* Do not create unrelated screens unless explicitly requested.

---

# 2. Target Folder Structure

Generate API flow under the owning feature/module:

```txt
src/modules/<feature>/
  application/
    command/
      <ApiFlowName>Command.ts
    usecase/
      <ApiFlowName>UseCase.ts
  domain/
    model/
      <ApiFlowName>Model.ts
    repository/
      <FeatureName>Repository.ts
  infrastructure/
    api/
      <FeatureName>Api.ts
    dto/
      <ApiFlowName>RequestDto.ts
      <ApiFlowName>ResponseDto.ts
    mapper/
      <ApiFlowName>Mapper.ts
    repository/
      <FeatureName>RepositoryImpl.ts
```

Optional if needed:

```txt
presentation/hook/use<ApiFlowName>.ts
presentation/type/<ApiFlowName>State.ts
__tests__/unit/
__tests__/integration/
__tests__/builders/
```

---

# 3. Layer Responsibility Rules

## 3.1 Presentation Layer

Responsibilities:

* trigger API flow through hook/use case
* display loading/error/success state
* prevent duplicate submit

Forbidden:

* direct API call
* direct DTO usage
* raw Axios/Fetch error parsing

---

## 3.2 Application Layer

Responsibilities:

* receive command
* orchestrate API flow
* apply idempotency / timeout / inquiry rules
* return domain model/application result

Forbidden:

* React Native imports
* raw API DTO leakage

---

## 3.3 Domain Layer

Responsibilities:

* define repository contract
* define domain model
* define business status types

Forbidden:

* HTTP client dependency
* API DTO dependency

---

## 3.4 Infrastructure Layer

Responsibilities:

* build request DTO
* call HTTP client
* map response DTO to domain model
* normalize API errors

Forbidden:

* UI state
* business decisions that belong to application/domain

---

# 4. Naming Convention

Example for `SubmitTransfer`:

```txt
SubmitTransferCommand.ts
SubmitTransferUseCase.ts
SubmitTransferModel.ts
SubmitTransferRequestDto.ts
SubmitTransferResponseDto.ts
SubmitTransferMapper.ts
TransferApi.ts
TransferRepository.ts
TransferRepositoryImpl.ts
```

Rules:

* Use case suffix: `UseCase`
* Command suffix: `Command`
* DTO suffix: `RequestDto` / `ResponseDto`
* Mapper suffix: `Mapper`
* Repository interface in domain
* Repository implementation in infrastructure

---

# 5. Command Generation

Command must contain all data needed by the use case.

```ts
export type <ApiFlowName>Command = {
  userId: string;
  requestId: string;
  idempotencyKey?: string;
};
```

Rules:

* Include request body fields.
* Include path params.
* Include query params.
* Include required headers if application-owned.
* Do not pass UI DTO directly.

For fintech mutation flows:

```ts
idempotencyKey: string;
```

must be required.

---

# 6. Domain Model Generation

```ts
export type <ApiFlowName>Status = 'PENDING' | 'SUCCESS' | 'FAILED';

export type <ApiFlowName>Model = {
  id: string;
  status: <ApiFlowName>Status;
  traceId?: string;
};
```

Rules:

* Domain model must use business-friendly names.
* Avoid snake_case in domain model.
* Avoid leaking backend DTO shape.

---

# 7. Repository Contract

```ts
export interface <FeatureName>Repository {
  <apiFlowName>(command: <ApiFlowName>Command): Promise<<ApiFlowName>Model>;
}
```

Rules:

* Contract belongs to domain layer.
* It must return domain model, not DTO.

---

# 8. API DTO Generation

Request DTO:

```ts
export type <ApiFlowName>RequestDto = {
  request_id: string;
};
```

Response DTO:

```ts
export type <ApiFlowName>ResponseDto = {
  id: string;
  status: string;
  trace_id?: string;
};
```

Rules:

* DTO follows backend contract exactly.
* snake_case is allowed in DTO if backend uses it.
* DTO must not be used outside infrastructure.

---

# 9. Mapper Generation

```ts
export class <ApiFlowName>Mapper {
  static toRequestDto(command: <ApiFlowName>Command): <ApiFlowName>RequestDto {
    return {
      request_id: command.requestId,
    };
  }

  static toModel(dto: <ApiFlowName>ResponseDto): <ApiFlowName>Model {
    return {
      id: dto.id,
      status: dto.status as <ApiFlowName>Model['status'],
      traceId: dto.trace_id,
    };
  }
}
```

Rules:

* Mapper owns DTO ↔ model conversion.
* Do not map directly inside screen/hook.
* Validate/guard unsafe status values if needed.

---

# 10. API Client Generation

```ts
export class <FeatureName>Api {
  constructor(private readonly httpClient: HttpClient) {}

  async <apiFlowName>(
    request: <ApiFlowName>RequestDto,
    options?: { idempotencyKey?: string },
  ): Promise<<ApiFlowName>ResponseDto> {
    return this.httpClient.post<<ApiFlowName>ResponseDto>('<endpoint>', request, {
      headers: {
        ...(options?.idempotencyKey
          ? { 'Idempotency-Key': options.idempotencyKey }
          : {}),
      },
    });
  }
}
```

Rules:

* HTTP client must be injected.
* Auth headers should be handled by shared HTTP client/interceptor.
* Do not manually attach tokens in every API class.
* Endpoint must not be hardcoded in UI.

---

# 11. Repository Implementation

```ts
export class <FeatureName>RepositoryImpl implements <FeatureName>Repository {
  constructor(private readonly api: <FeatureName>Api) {}

  async <apiFlowName>(command: <ApiFlowName>Command): Promise<<ApiFlowName>Model> {
    const requestDto = <ApiFlowName>Mapper.toRequestDto(command);
    const responseDto = await this.api.<apiFlowName>(requestDto, {
      idempotencyKey: command.idempotencyKey,
    });

    return <ApiFlowName>Mapper.toModel(responseDto);
  }
}
```

Rules:

* Repository implementation belongs to infrastructure.
* It maps command to DTO and DTO to model.
* It does not expose infrastructure details.

---

# 12. Use Case Generation

```ts
export class <ApiFlowName>UseCase {
  constructor(private readonly repository: <FeatureName>Repository) {}

  async execute(command: <ApiFlowName>Command): Promise<<ApiFlowName>Model> {
    return this.repository.<apiFlowName>(command);
  }
}
```

For fintech critical flow, use case must include timeout/ambiguous handling if defined:

```txt
submit
  → timeout/network error
  → mark UNKNOWN/PENDING
  → call status inquiry use case
  → return final state
```

Rules:

* Use case owns orchestration.
* Do not retry money movement blindly.
* Do not swallow errors silently.

---

# 13. Error Handling Rules

All API errors must be normalized to `AppError`.

```ts
try {
  return await this.repository.<apiFlowName>(command);
} catch (error) {
  throw normalizeApiError(error);
}
```

Rules:

* UI receives normalized error only.
* Do not expose raw Axios errors.
* Preserve `traceId` if available.

---

# 14. Retry & Timeout Rules

## 14.1 Retry Allowed

Retry only when:

* operation is safe/idempotent
* error is transient network/server error
* business error is not retryable

## 14.2 Retry Not Allowed

Do not retry blindly for:

* transfer submit
* payment submit
* OTP verify
* wallet mutation

## 14.3 Timeout

Timeout after mutation may be ambiguous.

Correct behavior:

```txt
timeout after submit
  → do not mark FAILED immediately
  → perform status inquiry
```

---

# 15. Observability Rules

Generated API flow must log safe events:

```txt
<API_FLOW>_STARTED
<API_FLOW>_SUCCESS
<API_FLOW>_FAILED
<API_FLOW>_TIMEOUT
<API_FLOW>_AMBIGUOUS
```

Required metadata:

* traceId
* requestId
* endpoint
* method
* status
* durationMs
* errorCode

Forbidden metadata:

* token
* OTP/PIN
* raw payload
* full account/card number

---

# 16. Tests to Generate

Generate or suggest tests for:

```txt
Mapper maps request correctly
Mapper maps response correctly
UseCase calls repository
Repository maps DTO/model correctly
API attaches idempotency key when required
Error is normalized
Timeout triggers inquiry for critical flow
Business error is not retried
```

Test builders:

```txt
build<ApiFlowName>Command
build<ApiFlowName>RequestDto
build<ApiFlowName>ResponseDto
build<ApiFlowName>Model
```

---

# 17. Fintech Rules (CRITICAL)

If `Fintech Critical Flow: yes`, generator must enforce:

* idempotency key required for mutation
* duplicate submit protection if UI/hook generated
* no blind retry
* timeout treated as ambiguous
* status inquiry support if operation can create transaction
* no sensitive logs
* backend remains source of truth

---

# 18. Output Format

AI must output files grouped by path:

```txt
File: src/modules/<feature>/application/command/<ApiFlowName>Command.ts
<code>

File: src/modules/<feature>/application/usecase/<ApiFlowName>UseCase.ts
<code>

File: src/modules/<feature>/domain/model/<ApiFlowName>Model.ts
<code>
```

Rules:

* Generate only relevant files.
* Do not create duplicate repository interfaces if one already exists.
* If repository exists, extend it instead of recreating.
* Mark assumptions clearly.

---

# 19. Anti-patterns

* API call directly in screen/hook.
* Passing API DTO to UI.
* Returning raw Axios response.
* Retrying payment/transfer without idempotency.
* Generating a new idempotency key on retry.
* Logging request payload with sensitive data.
* Catching error and returning fake success.
* Creating duplicate API clients for the same feature.

---

# 20. Checklist

* [ ] Command generated.
* [ ] Domain model generated.
* [ ] Repository contract updated.
* [ ] DTOs generated.
* [ ] Mapper generated.
* [ ] API client method generated.
* [ ] Repository implementation generated.
* [ ] Use case generated.
* [ ] Error normalization applied.
* [ ] Idempotency applied if required.
* [ ] Retry/timeout rules respected.
* [ ] Observability events defined.
* [ ] Tests generated or test plan included.

---

# 21. Final Rule

> API flow generation must preserve architecture boundaries.
> Correctness, traceability, and safety matter more than generating fewer files.

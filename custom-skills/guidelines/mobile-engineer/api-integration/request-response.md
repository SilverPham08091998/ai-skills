========================

📦 REQUEST / RESPONSE RULE (API INTEGRATION)

========================

🎯 OBJECTIVE

Define standard request/response rules for mobile API integration to ensure:

* Consistent API contracts
* Clear mapping boundaries
* Strong typing
* No raw backend response leaking to UI
* Fintech-grade request safety

Applied for:

React Native
TypeScript
API Client
Repository
Mapper
Application Command
Domain Model

⸻

========================

🧠 CORE PRINCIPLE

========================

API Request / Response belongs to infrastructure.
Application uses Command / Result.
Domain uses Model.
Presentation uses UI state / props.

Correct flow:

UI state
→ Hook
→ Application Command
→ Infrastructure API Request
→ Backend
→ Infrastructure API Response
→ Mapper
→ Domain/Application Model
→ UI state

Golden rule:

Raw API response must never go directly to presentation/component.

⸻

========================

📁 STRUCTURE

========================

Recommended structure:

src/application/<feature>/
<action>.command.ts
<action>.result.ts
<action>.usecase.ts
src/domain/<feature>/
<feature>.model.ts
<feature>-rule.ts
<feature>-error.ts
src/infrastructure/<feature>/
<feature>.api.ts
<feature>.repository.ts
<feature>.mapper.ts
request/
<action>.api-request.ts
response/
<action>.api-response.ts

Example:

src/application/transfer/
submit-transfer.command.ts
submit-transfer.result.ts
submit-transfer.usecase.ts
src/domain/transfer/
transfer.model.ts
transfer-rule.ts
src/infrastructure/transfer/
transfer.api.ts
transfer.repository.ts
transfer.mapper.ts
request/
submit-transfer.api-request.ts
response/
submit-transfer.api-response.ts

⸻

========================

🧾 REQUEST TYPES

========================

1. UI State

Belongs to:

src/presentation/<feature>/hook/

Example:

export type TransferState = {
amount: string;
receiverAccountNo: string;
description?: string;
isSubmitting: boolean;
};

Rule:

UI state can be form-friendly, string-based, and screen-specific.

⸻

2. Application Command

Belongs to:

src/application/<feature>/

Example:

export type SubmitTransferCommand = {
requestId: string;
fromAccountId: string;
toAccountNo: string;
amount: number;
description?: string;
};

Rule:

Command is clean input for use case.
Command is not raw API request.

⸻

3. API Request

Belongs to:

src/infrastructure/<feature>/request/

Example:

export type SubmitTransferApiRequest = {
request_id: string;
from_account_id: string;
to_account_no: string;
amount: number;
description?: string;
};

Rule:

API request follows backend contract.
It can use snake_case if backend uses snake_case.

⸻

========================

📥 RESPONSE TYPES

========================

1. API Response

Belongs to:

src/infrastructure/<feature>/response/

Example:

export type SubmitTransferApiResponse = {
transaction_id: string;
request_id: string;
status: 'PENDING' | 'PROCESSING' | 'SUCCESS' | 'FAILED';
amount: number;
created_at: string;
};

Rule:

API response mirrors backend response shape.
It must not be used directly by UI.

⸻

2. Domain Model

Belongs to:

src/domain/<feature>/

Example:

export type TransferModel = {
transactionId: string;
requestId: string;
status: TransactionStatus;
amount: number;
createdAt: Date;
};

Rule:

Domain model uses app/business naming, not backend naming.

⸻

3. Application Result

Belongs to:

src/application/<feature>/

Example:

export type SubmitTransferResult = {
transactionId: string;
requestId: string;
status: TransactionStatus;
};

Rule:

Application result returns what the use case needs to expose.
It may be smaller than domain model.

⸻

========================

🔄 MAPPING RULE

========================

All mapping must happen at boundaries.

Command → API Request

export const mapSubmitTransferCommandToApiRequest = (
command: SubmitTransferCommand,
): SubmitTransferApiRequest => ({
request_id: command.requestId,
from_account_id: command.fromAccountId,
to_account_no: command.toAccountNo,
amount: command.amount,
description: command.description,
});

API Response → Domain Model

export const mapSubmitTransferResponseToModel = (
response: SubmitTransferApiResponse,
): TransferModel => ({
transactionId: response.transaction_id,
requestId: response.request_id,
status: mapTransactionStatus(response.status),
amount: response.amount,
createdAt: new Date(response.created_at),
});

Rule:

Mapper belongs to infrastructure.
Mapper protects the app from backend shape changes.

⸻

========================

🧩 REPOSITORY RULE

========================

Repository owns request/response mapping.

Example:

export const transferRepository = {
async submitTransfer(
command: SubmitTransferCommand,
): Promise<TransferModel> {
const request = mapSubmitTransferCommandToApiRequest(command);
const response = await transferApi.submitTransfer(request);
return mapSubmitTransferResponseToModel(response.data);
},
};

MUST:

* Accept application command or repository input
* Convert to API request
* Call feature API
* Map API response to domain/application model

MUST NOT:

* Return raw API response to application/presentation
* Put UI-specific formatting here
* Contain screen logic

⸻

========================

🌐 FEATURE API RULE

========================

Feature API file owns endpoint call only.

Example:

export const transferApi = {
submitTransfer(request: SubmitTransferApiRequest) {
return apiClient.post<SubmitTransferApiResponse>(
'/transfers',
request,
{
headers: {
'X-Request-Id': request.request_id,
'Idempotency-Key': request.request_id,
},
},
);
},
};

MUST NOT:

* Know UI state
* Know presentation props
* Call navigation
* Format UI display text

⸻

========================

🧠 NAMING RULE

========================

Use explicit names:

SubmitTransferCommand       → application input
SubmitTransferResult        → application output
SubmitTransferApiRequest    → backend request
SubmitTransferApiResponse   → backend response
TransferModel               → domain model
TransferState               → UI state
TransferViewProps           → view props

MUST NOT use vague names:

Data
Payload
Response
ApiData
ResultData

Unless scoped clearly:

SubmitTransferPayload is allowed only if team standard defines payload meaning.

⸻

========================

🔐 SENSITIVE FIELD RULE

========================

Request/response types must clearly identify sensitive fields.

Sensitive fields include:

accessToken
refreshToken
OTP
PIN
password
CVV
full card number
Soft OTP secret
private key
raw identity document image

Rules:

* Do not log request/response body containing sensitive data
* Do not persist sensitive request/response
* Do not pass sensitive response into Redux Persist
* Do not pass sensitive fields via route params

⸻

========================

💸 FINTECH REQUEST RULE

========================

Money-related request must include tracking fields.

Recommended fields:

requestId
transactionId when confirming/querying
amount
currency
source account/wallet id
target account/wallet id
description/reference

Rules:

* requestId must be generated before submit
* requestId must be passed to backend
* requestId may be used as idempotency key
* amount must be validated in domain before API call
* UI must not calculate final transaction success

⸻

========================

💸 FINTECH RESPONSE RULE

========================

Money-related response must support non-final states.

Status examples:

PENDING
PROCESSING
SUCCESS
FAILED
EXPIRED
CANCELLED
UNKNOWN

Rules:

* timeout may map to UNKNOWN or PENDING depending on flow
* success screen only after backend final success
* pending response must lead to processing/pending UI
* failed response must show safe error message

⸻

========================

🚨 ERROR RESPONSE RULE

========================

Backend error response must be normalized.

Example backend response:

export type ApiErrorResponse = {
code?: string;
message?: string;
trace_id?: string;
details?: unknown;
};

Normalized app error:

export type AppApiError = {
code: string;
message: string;
traceId?: string;
httpStatus?: number;
};

Rule:

UI receives normalized error, not backend raw error.

⸻

========================

🧪 VALIDATION RULE

========================

Validation belongs to correct layer:

UI form validation       → presentation hook
Business validation      → domain
Backend contract mapping → infrastructure mapper

Example:

amount input empty       → hook
amount <= 0              → domain
snake_case mapping       → mapper

⸻

========================

🚫 ANTI-PATTERNS

========================

1. Raw API response in UI

❌ BAD

<TransferView data={response.data} />

⸻

2. UI state sent directly to API

❌ BAD

transferApi.submitTransfer(state);

⸻

3. Mapper inside screen

❌ BAD

const model = {
transactionId: response.transaction_id,
};

⸻

4. Vague type names

❌ BAD

type Response = {};
type Data = {};

⸻

========================

🧪 AI GENERATION RULE

========================

AI MUST:

* Create separate command/result/api-request/api-response/model types
* Put API request/response under infrastructure
* Put command/result under application
* Put model/rule under domain
* Put UI state/props under presentation hook
* Use mapper for command → request and response → model
* Keep backend response shape away from UI
* Use clear naming with feature/action prefix
* Include requestId/idempotency fields for money requests

AI MUST NOT:

* Pass raw API response to UI
* Send UI state directly to API
* Put API response type in presentation
* Put UI props in infrastructure
* Put mapper in screen/component
* Use any for API request/response
* Log sensitive request/response
* Create modules/<feature> folder

⸻

========================

📌 SUMMARY

========================

Correct type ownership:

presentation → UI State / View Props
application  → Command / Result / UseCase
domain       → Model / Rule / Error
infrastructure → ApiRequest / ApiResponse / Api / Repository / Mapper

Golden rule:

Backend contract is infrastructure detail.
UI must work with clean state/model only.

This rule is mandatory for all request/response code generation.

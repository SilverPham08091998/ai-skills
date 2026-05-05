========================

🔎 TRACING RULE (MOBILE OBSERVABILITY)

========================

🎯 OBJECTIVE

Define tracing standards for mobile applications to ensure:

* End-to-end request tracking
* Easier production debugging
* Consistent correlation with backend logs
* Safe observability for fintech / banking apps
* No sensitive data leakage in traces

Applied for:

React Native
iOS Swift
Android Kotlin / Java
API Client
Crash reporting
Analytics / Observability
OpenTelemetry when available

⸻

========================

🧠 CORE PRINCIPLE

========================

Tracing = understand what happened without leaking sensitive data.

Golden rule:

Trace IDs are safe.
Sensitive payloads are not.

Tracing must help answer:

Who triggered the flow?        → masked/non-sensitive user reference only
What request was sent?         → method/path/requestId/traceId only
Where did it fail?             → screen/action/API/error code
How long did it take?          → duration/latency
Can backend find same request? → correlationId / traceId / requestId

⸻

========================

📁 STRUCTURE

========================

Recommended structure:

src/observability/
tracing/
trace-context.ts
trace-id.ts
tracing-service.ts
tracing.type.ts
tracing.mapper.ts
src/infrastructure/api/
api-interceptor.ts
api-header.ts
src/common/logger/
logger.ts

Meaning:

trace-context.ts    → current trace/session/action context
trace-id.ts         → generate traceId/correlationId
tracing-service.ts  → abstraction for tracing provider
tracing.type.ts     → trace event/span types
tracing.mapper.ts   → map app events to safe tracing attributes
api-interceptor.ts  → inject trace headers into API calls
logger.ts           → safe structured logs

⸻

========================

🧾 TRACE IDENTIFIERS

========================

Use standard identifiers:

traceId        → one logical user flow / request chain
spanId         → one operation inside trace
correlationId  → shared ID between mobile/backend
requestId      → idempotency/business request id
transactionId  → backend transaction identifier
sessionId      → app session reference, non-sensitive

Rules:

traceId/correlationId can be logged.
requestId can be logged.
transactionId can be logged if policy allows.
Token/OTP/PIN must never be logged.

⸻

========================

🌐 API HEADER RULE

========================

API requests should include trace/correlation headers.

Recommended headers:

X-Trace-Id
X-Correlation-Id
X-Request-Id
X-Device-Id
X-App-Version
X-Platform

Example:

apiClient.interceptors.request.use(config => {
const traceId = traceContext.getTraceId();
const correlationId = traceContext.getCorrelationId();
config.headers['X-Trace-Id'] = traceId;
config.headers['X-Correlation-Id'] = correlationId;
return config;
});

Rules:

* X-Request-Id for business/idempotency flow is owned by application/use case
* X-Trace-Id / X-Correlation-Id is owned by observability/API layer
* Do not overwrite business requestId silently

⸻

========================

🔁 STANDARD TRACE FLOW

========================

Example: transfer flow

TransferInputScreen opened
→ trace screen_view
User taps submit
→ trace action submit_transfer_clicked
Application creates requestId
→ trace business_request_created
API request sent
→ trace api_request_started
API response received
→ trace api_request_finished
Result screen shown
→ trace transfer_result_displayed

Each step should include safe attributes only:

traceId
correlationId
requestId
transactionId if available
screenName
actionName
apiPath
httpStatus
durationMs
safeErrorCode

⸻

========================

🧱 TRACING SERVICE RULE

========================

Use tracing abstraction, not provider directly everywhere.

Example:

export type TraceAttributes = Record<string, string | number | boolean | undefined>;
export const tracingService = {
startSpan(name: string, attributes?: TraceAttributes) {
// provider implementation
},
endSpan(spanId: string, attributes?: TraceAttributes) {
// provider implementation
},
trackEvent(name: string, attributes?: TraceAttributes) {
// provider implementation
},
};

MUST NOT:

call Firebase/Datadog/Sentry/OpenTelemetry SDK randomly across UI files

Rule:

App code uses tracingService. Provider can change later.

⸻

========================

📱 SCREEN TRACING RULE

========================

Screen tracing should include:

screenName
previousScreen
entryPoint
traceId
sessionId

Example:

useEffect(() => {
tracingService.trackEvent('screen_view', {
screenName: RouteName.TransferInput,
});
}, []);

MUST NOT include:

full route params if sensitive
OTP/PIN/token
full account/card number
raw identity data

⸻

========================

🖱️ USER ACTION TRACING RULE

========================

Trace important user actions:

button_click
form_submit
otp_verify_clicked
biometric_prompt_started
payment_confirm_clicked

Example:

tracingService.trackEvent('payment_confirm_clicked', {
screenName: RouteName.TransferConfirm,
requestId,
});

MUST:

* track action name
* track screen name
* track safe requestId when available

MUST NOT:

* track raw form values
* track PIN/OTP
* track full recipient account/card

⸻

========================

🌐 API TRACING RULE

========================

API tracing should include:

method
path
httpStatus
durationMs
traceId
correlationId
requestId
safeErrorCode

Example safe log:

POST /transfers status=200 duration=420ms traceId=abc requestId=req-123

MUST NOT include:

Authorization header
access token
refresh token
request body with sensitive fields
response body with sensitive fields

⸻

========================

🚨 ERROR / CRASH CONTEXT RULE

========================

Crash/error context may include:

traceId
correlationId
screenName
actionName
apiPath
safeErrorCode
httpStatus
appVersion
platform

Crash/error context MUST NOT include:

access token
refresh token
OTP
PIN
password
CVV
private key
Soft OTP secret
full card/account number
raw identity image
full API payload

Rule:

Crash reports must help debugging without becoming data breach.

⸻

========================

💸 FINTECH TRACING RULE

========================

For money flows, trace only safe identifiers/status.

Allowed:

requestId
transactionId
transactionStatus
amountRange or masked amount category if policy allows
currency
safe error code

Forbidden:

PIN
OTP
full account number
full card number
CVV
receiver full identity
full transfer description if user-entered and sensitive
raw payment payload

Rules:

* trace transaction lifecycle
* never trace transaction authorization secret
* never trace full sensitive payload
* backend final status should be correlated by requestId/transactionId

⸻

========================

🔐 PII / MASKING RULE

========================

Before tracing/logging, data must be classified.

Safe

traceId
requestId
httpStatus
apiPath
screenName
appVersion
platform

Masked only

phone number
account number
card number
email
user display name

Forbidden

token
OTP
PIN
password
private key
CVV
Soft OTP secret
raw identity document

Example masking:

maskPhoneNumber('0901234567') // 090*****67

⸻

========================

🧪 TESTING RULE

========================

Must test:

API headers include traceId/correlationId
requestId is preserved for money APIs
sensitive headers are masked in logs
screen trace does not include raw params
error trace does not include token/OTP/PIN
crash context contains traceId

Security test:

Search traces/logs for accessToken → none
Search traces/logs for OTP/PIN → none
Search traces/logs for full card/account → none

⸻

========================

🚫 ANTI-PATTERNS

========================

1. Logging full request body

❌ BAD

logger.info('request', payload);

2. Tracking OTP/PIN

❌ BAD

trackEvent('otp_entered', { otp });

3. Provider SDK everywhere

❌ BAD

Sentry.captureMessage(...)
Datadog.addAction(...)
Firebase.logEvent(...)

randomly inside many components.

4. No correlation with backend

❌ BAD

Mobile logs have no traceId/requestId. Backend cannot find related request.

⸻

========================

🧪 AI GENERATION RULE

========================

AI MUST:

* Create tracing abstraction under src/observability/tracing/
* Add traceId/correlationId headers in API interceptor
* Preserve requestId/idempotency key for money flow
* Trace screen/action/API lifecycle safely
* Mask sensitive values before tracing/logging
* Add crash context with safe attributes only
* Keep provider SDK behind tracingService

AI MUST NOT:

* Log or trace token/OTP/PIN/password/CVV/private key
* Log full request/response body for fintech APIs
* Put tracing provider calls randomly in UI files
* Overwrite business requestId silently
* Send raw route params to tracing
* Create modules/<feature> folder

⸻

========================

📌 SUMMARY

========================

Correct tracing model:

screen/action trace
→ traceId/correlationId
→ API headers
→ backend logs
→ crash/error context

Golden rule:

Trace behavior and identifiers, never secrets or sensitive payloads.

This rule is mandatory for all mobile tracing implementation.

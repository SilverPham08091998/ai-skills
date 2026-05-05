# api-integration/error-handling.md

## Objective

Standardize how the mobile application handles API errors.

Applies to:

* React Native
* TypeScript
* Axios / Fetch wrapper
* Redux / RTK / Redux Observable
* Mobile Clean Architecture
* Fintech / Banking applications

Main rule:

> Do not handle API errors randomly inside screens or components.
> Every API error must be normalized into a standard error shape before it reaches UI or business flow.

---

# 1. API Error Handling Principles

## 1.1 Do not expose raw API errors to UI

The UI must not directly read Axios or Fetch error objects.

Bad:

```ts
catch (error) {
  Alert.alert(error.response.data.message);
}
```

Good:

```ts
catch (error) {
  const appError = normalizeApiError(error);
  showError(appError);
}
```

Rules:

* UI receives only `AppError` or `Result<T, AppError>`.
* UI must not know what Axios is.
* UI must not depend on backend raw error shape.
* Do not duplicate `status`, `code`, or `message` parsing logic across screens.

---

## 1.2 Convert every API error into AppError

All API errors must be converted into a shared format:

```ts
export type AppError = {
  code: string;
  message: string;
  status?: number;
  type: AppErrorType;
  traceId?: string;
  details?: unknown;
  raw?: unknown;
};
```

```ts
export enum AppErrorType {
  NETWORK = 'NETWORK',
  TIMEOUT = 'TIMEOUT',
  UNAUTHORIZED = 'UNAUTHORIZED',
  FORBIDDEN = 'FORBIDDEN',
  BUSINESS = 'BUSINESS',
  VALIDATION = 'VALIDATION',
  SERVER = 'SERVER',
  UNKNOWN = 'UNKNOWN',
}
```

Field meaning:

* `code`: stable error code for business/UI handling.
* `message`: safe user-facing message.
* `status`: HTTP status if available.
* `type`: normalized error group used by UI flow.
* `traceId`: backend trace id for support/debugging.
* `details`: additional data, such as field validation errors.
* `raw`: original error for debugging/logging only. Never use it directly in UI.

---

# 2. API Error Response Standard

Backend should return errors using a stable format:

```json
{
  "code": "INSUFFICIENT_BALANCE",
  "message": "Insufficient balance",
  "traceId": "abc-123",
  "details": {
    "field": "amount"
  }
}
```

Mobile must not depend too deeply on the backend raw response.

Recommended mobile contract:

```ts
type ApiErrorResponse = {
  code?: string;
  message?: string;
  traceId?: string;
  details?: unknown;
};
```

Rules:

* If backend returns `code`, prefer backend `code`.
* If backend returns `message`, it can be shown only if it is already product-approved and safe.
* If backend does not return a valid message, use a mobile fallback message.
* Never show raw stack traces or technical errors to users.

---

# 3. Error Normalizer

A central error normalizer is mandatory.

```ts
export function normalizeApiError(error: unknown): AppError {
  if (isAxiosError(error)) {
    return normalizeAxiosError(error);
  }

  return {
    code: 'UNKNOWN_ERROR',
    message: 'Something went wrong. Please try again.',
    type: AppErrorType.UNKNOWN,
    raw: error,
  };
}
```

Rules:

* Do not normalize errors inside screens.
* Do not normalize errors inside components.
* Do not duplicate normalizing logic in every API function.
* The error normalizer should live in `shared/error`, `core/error`, or `infrastructure/network` depending on the project structure.

Recommended structure:

```txt
src/
  shared/
    error/
      AppError.ts
      AppErrorType.ts
      normalizeApiError.ts
  infrastructure/
    network/
      httpClient.ts
      interceptors.ts
```

---

# 4. Axios Error Handling

## 4.1 Network Error

Network error means the app did not receive a response from the server.

Examples:

* no internet connection
* DNS failure
* SSL failure
* server unreachable
* connection blocked

```ts
if (!error.response) {
  return {
    code: 'NETWORK_ERROR',
    message: 'Unable to connect. Please check your network connection.',
    type: AppErrorType.NETWORK,
    raw: error,
  };
}
```

Rules:

* Do not show raw messages like `Network Error` directly to users.
* For banking apps, messages must be clear, safe, and user-friendly.
* Debug logs may include method/path/status, but must not expose sensitive data.

---

## 4.2 Timeout Error

Timeout means the request exceeded the configured waiting time.

```ts
if (error.code === 'ECONNABORTED') {
  return {
    code: 'TIMEOUT_ERROR',
    message: 'The request timed out. Please try again.',
    type: AppErrorType.TIMEOUT,
    raw: error,
  };
}
```

Rules:

* Do not automatically retry dangerous mutation APIs without idempotency.
* For transfer/payment APIs, retry only when an idempotency key or transaction reference exists.
* UI should avoid allowing users to repeatedly submit the same money transaction.
* Prefer showing a pending/checking status and then perform transaction inquiry.

---

## 4.3 Unauthorized — 401

401 usually means the token is expired, invalid, or the user is not authenticated.

```ts
if (status === 401) {
  return {
    code: apiError.code ?? 'UNAUTHORIZED',
    message: 'Your session has expired. Please sign in again.',
    status,
    type: AppErrorType.UNAUTHORIZED,
    traceId: apiError.traceId,
    raw: error,
  };
}
```

Rules:

* Do not let each screen handle 401 manually.
* 401 must be handled centrally in the auth/session layer.
* Refresh token flow may be triggered if supported.
* If refresh token fails, logout the user and clear sensitive local data.
* Prevent multiple session-expired popups from appearing at the same time.

---

## 4.4 Forbidden — 403

403 means the user is authenticated but does not have permission.

```ts
if (status === 403) {
  return {
    code: apiError.code ?? 'FORBIDDEN',
    message: 'You do not have permission to perform this action.',
    status,
    type: AppErrorType.FORBIDDEN,
    traceId: apiError.traceId,
    raw: error,
  };
}
```

Rules:

* Do not logout the user for 403.
* Do not retry 403.
* UI may navigate to a safe screen or show a permission error state.

---

## 4.5 Validation Error — 400 / 422

Validation error means the request input is invalid.

```ts
if (status === 400 || status === 422) {
  return {
    code: apiError.code ?? 'VALIDATION_ERROR',
    message: apiError.message ?? 'Invalid information. Please check and try again.',
    status,
    type: AppErrorType.VALIDATION,
    traceId: apiError.traceId,
    details: apiError.details,
    raw: error,
  };
}
```

Rules:

* If the error is attached to a specific field, show it near that field.
* If the error is a business validation, show a dialog, bottom sheet, or inline banner.
* Do not hardcode too many validation messages in screens if backend already provides stable error codes.

---

## 4.6 Business Error

Business error means the request is technically valid but violates a business rule.

Examples:

* insufficient balance
* transaction limit exceeded
* locked account
* invalid OTP
* expired transaction

```ts
return {
  code: apiError.code ?? 'BUSINESS_ERROR',
  message: apiError.message ?? 'The transaction cannot be processed. Please try again.',
  status,
  type: AppErrorType.BUSINESS,
  traceId: apiError.traceId,
  details: apiError.details,
  raw: error,
};
```

Rules:

* Business errors must have stable error codes.
* UI should branch by `code`, not by message text.
* Message can change by locale/product copy, but error code should remain stable.

Example:

```ts
switch (error.code) {
  case 'INSUFFICIENT_BALANCE':
    showInsufficientBalanceBottomSheet();
    break;
  case 'OTP_INVALID':
    showOtpError(error.message);
    break;
  default:
    showError(error);
}
```

---

## 4.7 Server Error — 5xx

Server error means the backend failed to process the request.

```ts
if (status >= 500) {
  return {
    code: apiError.code ?? 'SERVER_ERROR',
    message: 'The system is currently unavailable. Please try again later.',
    status,
    type: AppErrorType.SERVER,
    traceId: apiError.traceId,
    raw: error,
  };
}
```

Rules:

* Do not show backend technical messages to users.
* Always keep `traceId` for support/debugging.
* For money transaction APIs, do not conclude failure when the response is ambiguous.
* Move to transaction status inquiry flow if necessary.

---

# 5. Full Axios Normalizer Example

```ts
import { AxiosError, isAxiosError } from 'axios';

export function normalizeAxiosError(error: AxiosError): AppError {
  if (error.code === 'ECONNABORTED') {
    return {
      code: 'TIMEOUT_ERROR',
      message: 'The request timed out. Please try again.',
      type: AppErrorType.TIMEOUT,
      raw: error,
    };
  }

  if (!error.response) {
    return {
      code: 'NETWORK_ERROR',
      message: 'Unable to connect. Please check your network connection.',
      type: AppErrorType.NETWORK,
      raw: error,
    };
  }

  const status = error.response.status;
  const apiError = error.response.data as ApiErrorResponse;

  if (status === 401) {
    return {
      code: apiError.code ?? 'UNAUTHORIZED',
      message: 'Your session has expired. Please sign in again.',
      status,
      type: AppErrorType.UNAUTHORIZED,
      traceId: apiError.traceId,
      raw: error,
    };
  }

  if (status === 403) {
    return {
      code: apiError.code ?? 'FORBIDDEN',
      message: 'You do not have permission to perform this action.',
      status,
      type: AppErrorType.FORBIDDEN,
      traceId: apiError.traceId,
      raw: error,
    };
  }

  if (status === 400 || status === 422) {
    return {
      code: apiError.code ?? 'VALIDATION_ERROR',
      message: apiError.message ?? 'Invalid information. Please check and try again.',
      status,
      type: AppErrorType.VALIDATION,
      traceId: apiError.traceId,
      details: apiError.details,
      raw: error,
    };
  }

  if (status >= 500) {
    return {
      code: apiError.code ?? 'SERVER_ERROR',
      message: 'The system is currently unavailable. Please try again later.',
      status,
      type: AppErrorType.SERVER,
      traceId: apiError.traceId,
      raw: error,
    };
  }

  return {
    code: apiError.code ?? 'BUSINESS_ERROR',
    message: apiError.message ?? 'The transaction cannot be processed. Please try again.',
    status,
    type: AppErrorType.BUSINESS,
    traceId: apiError.traceId,
    details: apiError.details,
    raw: error,
  };
}
```

---

# 6. UI Handling Rule

UI must handle only normalized `AppError`.

```ts
function showError(error: AppError) {
  switch (error.type) {
    case AppErrorType.NETWORK:
      showToast(error.message);
      break;

    case AppErrorType.UNAUTHORIZED:
      openSessionExpiredDialog();
      break;

    case AppErrorType.BUSINESS:
      showBusinessError(error);
      break;

    default:
      showToast(error.message);
  }
}
```

Rules:

* Screen must not parse Axios errors.
* Screen must not check `error.response.status`.
* Screen must not display raw errors.
* Screen should decide UI behavior using only `type` or `code`.

---

# 7. Redux / RTK / Redux Observable Rule

## 7.1 Redux Toolkit / createAsyncThunk

```ts
export const submitTransfer = createAsyncThunk(
  'transfer/submit',
  async (payload: TransferPayload, { rejectWithValue }) => {
    try {
      return await transferRepository.submit(payload);
    } catch (error) {
      return rejectWithValue(normalizeApiError(error));
    }
  }
);
```

Rules:

* `rejectWithValue` must return `AppError`.
* Reducer must not receive raw Axios errors.
* Component should read already-normalized errors from state.

---

## 7.2 Redux Observable

```ts
const submitTransferEpic = (action$) =>
  action$.pipe(
    ofType(submitTransferRequest.type),
    switchMap((action) =>
      from(transferRepository.submit(action.payload)).pipe(
        map((response) => submitTransferSuccess(response)),
        catchError((error) => of(submitTransferFailure(normalizeApiError(error))))
      )
    )
  );
```

Rules:

* `catchError` must normalize the error before dispatching failure action.
* Do not dispatch raw error objects to the store.
* Do not let the observable stream die because of missing `catchError`.

---

# 8. Fintech / Banking Error Rules

## 8.1 Do not retry money movement APIs blindly

The following APIs must not be retried automatically without idempotency:

* fund transfer
* payment
* cash-in
* cash-out
* refund
* OTP confirmation
* wallet balance mutation

Rule:

> For money movement, timeout or network error does not always mean the transaction failed.

Correct flow:

```txt
submit transaction
  -> timeout/network/server error
  -> show pending or processing state
  -> call transaction status inquiry
  -> render final status
```

---

## 8.2 Error messages must be safe

Never show:

* stack trace
* SQL error
* internal service name
* token/session detail
* raw partner error before mapping
* internal IP/host/port

Bad:

```txt
ORA-00001: unique constraint violated
java.lang.NullPointerException
Partner timeout at http://10.0.1.23:8080
```

Good:

```txt
The system is currently unavailable. Please try again later.
```

---

## 8.3 Always preserve traceId

If backend returns `traceId`, mobile must preserve it in `AppError`.

```ts
traceId: apiError.traceId
```

Rules:

* Log traceId in debug logs.
* Display reference code to user only when product/support requires it.
* Do not replace backend traceId with a mobile-generated traceId when backend already returns one.

---

# 9. Logging Rule

Never log sensitive data.

Do not log:

* access token
* refresh token
* OTP
* PIN
* password
* full card number
* full account number
* full citizen id / national id

Allowed logging data:

* endpoint name or path template
* method
* HTTP status
* error code
* traceId
* duration
* masked user id if needed

Example:

```ts
logger.error('API_ERROR', {
  endpoint: '/api/v1/fund-transfer/bank',
  method: 'POST',
  status: error.status,
  code: error.code,
  traceId: error.traceId,
});
```

---

# 10. Localization Rule

Do not hardcode all error messages directly in UI when the app supports multiple languages.

Recommended:

```ts
const message = translateErrorCode(error.code) ?? error.message;
```

Rules:

* Error code is used to map localized messages.
* Backend message can be used as fallback only if safe.
* For banking apps, error messages should be reviewed by Product/Compliance when necessary.

---

# 11. Checklist

Before completing any API integration, verify:

* [ ] All API errors are normalized into `AppError`.
* [ ] UI does not access raw Axios/Fetch errors.
* [ ] 401 is handled centrally.
* [ ] 403 does not trigger logout.
* [ ] Timeout/network errors on money APIs do not blindly retry.
* [ ] Business errors are handled by stable error code.
* [ ] Server errors use safe fallback messages.
* [ ] `traceId` is preserved.
* [ ] Sensitive data is never logged.
* [ ] Redux/RTK/Observable failure actions contain normalized errors only.

---

# 12. Final Rule

> API error handling must be centralized, normalized, safe, and predictable.
> UI must never depend on raw network/library errors.
> For fintech and banking flows, ambiguous API failures must lead to transaction inquiry, not blind retry or duplicate money movement.

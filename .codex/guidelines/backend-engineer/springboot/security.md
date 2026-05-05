# Spring Boot Security Guidelines

## Purpose

Define enterprise-grade security standards for Spring Boot applications.

Goals:

- protect users and data
- secure APIs
- prevent common attacks
- support compliance
- ensure safe production operations
- reduce breach risk

Applies to:

- REST APIs
- microservices
- internal admin systems
- fintech/payment systems
- event-driven services

---

# 1. Core Principles

Security is mandatory by default.

Use:

- least privilege
- defense in depth
- secure by default
- explicit trust boundaries
- auditability

Never assume internal traffic is automatically trusted.

---

# 2. Authentication

Use approved mechanisms:

- OAuth2
- JWT
- mTLS (service-to-service)
- secure session auth where applicable

Do not invent custom auth protocols.

---

# 3. Authorization

Authenticate != Authorize

Every protected endpoint must verify permissions.

Examples:

- role checks
- scope checks
- ownership checks
- resource-level access checks

Bad:

Any logged-in user can read all customer accounts.

---

# 4. Spring Security Required

Use Spring Security for access control.

Prefer centralized config.

Use:

SecurityFilterChain

Avoid legacy insecure ad-hoc filters.

---

# 5. Password Rules

If passwords exist:

- hash using BCrypt / Argon2 / approved standard
- never store plaintext
- never log passwords
- enforce policy via product requirements

Never reversible encryption for passwords.

---

# 6. JWT Rules

If using JWT:

- verify signature
- validate expiration
- validate issuer
- validate audience if applicable
- use short expiration
- rotate keys safely

Never trust unsigned tokens.

Never store secrets inside token payload.

---

# 7. Token Handling

Never log:

- access token
- refresh token
- session id
- API keys

Use secure transport only (HTTPS).

---

# 8. Session Security

If session-based:

- secure cookie
- HttpOnly
- SameSite configured
- timeout policy
- invalidate on logout

---

# 9. HTTPS Mandatory

Use TLS in production.

Never expose credentials over HTTP.

Redirect HTTP to HTTPS when appropriate.

---

# 10. mTLS for Internal Services

Recommended for service-to-service communication in sensitive systems.

Useful for:

- fintech microservices
- zero trust internal networks

---

# 11. Input Validation

All external input must be validated.

Use:

- Bean Validation
- size limits
- type checks
- whitelist rules

Prevents many attacks.

---

# 12. SQL Injection Prevention

Use parameterized queries.

Good:

JPA prepared statements / named params

Bad:

"select * from user where id=" + input

Never concatenate SQL with user input.

---

# 13. XSS Prevention

For APIs:
return escaped/safe output where needed.

For rendered views:
escape templates.

Validate and sanitize rich text inputs.

---

# 14. CSRF Protection

Required for browser session-based apps.

For stateless JWT APIs:
may disable if not cookie-auth based and architecture justifies it.

Understand context before disabling.

---

# 15. CORS Rules

Allow only trusted origins.

Bad:

allow *

Use least privilege:

- specific origins
- specific methods
- specific headers

---

# 16. Sensitive Data Handling

Sensitive examples:

- passwords
- OTP
- tokens
- PAN/card data
- personal identity data
- secret keys

Rules:

- encrypt at rest where required
- mask in logs
- minimize storage
- strict access control

---

# 17. Logging Security

Log:

- auth failures
- suspicious activity
- permission denied
- admin actions
- token misuse signals

Never log secrets.

Include traceId.

---

# 18. Error Message Security

Bad:

User not found with username abc and SQL stack trace...

Good:

Authentication failed

Do not leak internals.

---

# 19. Exception Handling

Centralize security-related responses.

Return proper codes:

401 Unauthorized
403 Forbidden

Do not expose stack traces publicly.

---

# 20. Rate Limiting

Protect sensitive endpoints:

- login
- OTP send
- OTP verify
- password reset
- payment submit

Use:

429 Too Many Requests

---

# 21. Brute Force Protection

Implement for auth flows:

- retry limit
- temporary lock
- CAPTCHA/product policy
- anomaly detection

---

# 22. Secrets Management

Never hardcode secrets.

Bad:

api.key=123456

Use:

- Vault
- AWS Secrets Manager
- Kubernetes Secrets (with policy)
- environment secret injection

Rotate regularly.

---

# 23. Configuration Security

Review configs:

- actuator exposure
- debug enabled
- default passwords
- open ports
- permissive CORS

Secure production profiles.

---

# 24. Dependency Security

Keep dependencies updated.

Scan for CVEs.

Remove unused libraries.

Watch:

- Spring vulnerabilities
- Jackson issues
- logging library issues

---

# 25. File Upload Security

Validate:

- file type
- extension
- size
- malware scan if required

Store outside executable paths.

Never trust filename.

---

# 26. Deserialization Safety

Avoid unsafe Java native serialization.

Prefer JSON with strict DTO models.

Validate polymorphic deserialization settings.

---

# 27. Admin Endpoint Security

Protect:

- actuator
- admin APIs
- migration tools
- debug endpoints

Require strong auth and network restriction.

---

# 28. Spring Actuator Security

Expose only necessary endpoints.

Good:

health
info
prometheus (secured as needed)

Avoid exposing env, beans, heapdump publicly.

---

# 29. Method-Level Security

Use when needed:

@PreAuthorize(...)
@PostAuthorize(...)

Good for resource ownership checks.

---

# 30. Data Access Security

Enforce ownership.

Example:

User can access only own transactions unless admin.

Never trust client-supplied customerId alone.

---

# 31. Fintech Security Controls

For payments/transfers require:

- MFA / OTP when needed
- device risk checks
- velocity checks
- idempotency
- audit logs
- stronger authorization

---

# 32. Audit Logging

Record important actions:

- login success/failure
- password reset
- privilege changes
- payment approval
- refund approval

Logs must be tamper-aware per system policy.

---

# 33. Zero Trust Mindset

Internal network does not equal trusted.

Authenticate service calls where appropriate.

Validate all inputs.

---

# 34. Common Misconfigurations

Avoid:

permitAll everywhere
disabled CSRF without reason
wildcard CORS
plaintext secrets
public actuator
debug stack traces in prod

---

# 35. Security Testing

Include:

- auth tests
- permission tests
- input validation tests
- penetration testing
- dependency scans
- secret scans

---

# 36. Incident Readiness

Need:

- revoke tokens
- rotate keys
- disable compromised accounts
- alerting
- audit trail
- rollback plan

---

# 37. Review Checklist

Before merge ask:

- Endpoint protected?
- Correct roles/scopes checked?
- Inputs validated?
- SQL injection safe?
- Secrets externalized?
- Logs safe?
- HTTPS enforced?
- CORS minimal?
- Sensitive data masked?
- Security tests added?

---

# 38. Mandatory For AI Code Generation

When generating Spring Boot security code:

- Use Spring Security
- Prefer JWT/OAuth2 or approved auth
- Enforce authorization checks
- Validate all inputs
- Use parameterized DB access
- Never hardcode secrets
- Protect sensitive endpoints with rate limits
- Return safe error responses
- Production secure by default
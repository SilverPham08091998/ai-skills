# security/identity-access.md — Identity and Access Architecture Standard

## Objective

Design authentication, authorization, session, token, and service identity.

## When To Use

- Login/auth design
- Service-to-service security
- Gateway identity propagation
- RBAC/ABAC design

## Scope

- Authentication
- Authorization
- JWT
- OAuth2/OIDC
- Session
- RBAC
- ABAC
- Service identity
- mTLS

## Architecture Rules

1. Separate authentication from authorization.
2. Gateway can validate token but service enforces domain permission.
3. Use least privilege.
4. Propagate identity safely.
5. Define token expiry/refresh strategy.

## Security / Compliance Rules

1. Prevent header spoofing.
2. Validate issuer/audience/signature.
3. Mask tokens in logs.
4. Use mTLS/service identity internally where possible.

## Anti-patterns

- Trusting x-user-id from client.
- No service authorization.
- Long-lived token without refresh strategy.
- No admin access audit.

## Expected Output

1. Identity flow
2. Permission model
3. Token/header strategy
4. Security checks

## Review Checklist

- [ ] Identity flow
- [ ] Permission model
- [ ] Token/header strategy
- [ ] Security checks

## Prompt

```text
Use `.sa/security/identity-access.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/security/identity-access.md`.

Task:
<describe the architecture task>

Context:
- Domain:
- Actors:
- Existing systems:
- Constraints:
- NFR:
- Security/compliance concerns:

Output:
- Assumptions
- Architecture/design
- Diagrams if useful
- Trade-offs
- Risks
- Implementation handoff
```

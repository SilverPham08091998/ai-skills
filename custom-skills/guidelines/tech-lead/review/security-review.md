# review/security-review.md — Security Review Standard

## Objective

Review implementation for common security issues.

## When To Use

- Sensitive feature review
- Before merge
- Before release

## Scope

- Authentication
- Authorization
- Input validation
- Secrets
- Logging
- Data exposure
- Dependencies

## Tech Lead Rules

1. Verify auth and authorization.
2. Validate all boundary inputs.
3. Do not log sensitive data.
4. Check dependency vulnerabilities.
5. Check secure defaults.
6. Check audit for critical action.

## Security / Production Rules

1. Financial/identity/admin operations require stronger review.
2. Block critical vulnerabilities.

## Anti-patterns

- Trusting client headers.
- Missing authorization.
- Plain secrets.
- Sensitive logs.
- SQL injection risk.

## Expected Output

1. Security findings
2. Severity
3. Fix recommendation

## Review Checklist

- [ ] Security findings
- [ ] Severity
- [ ] Fix recommendation

## Prompt

```text
Use `.techlead/review/security-review.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/review/security-review.md`.

Task:
<describe the planning/review/leadership task>

Context:
- Feature/change:
- Existing architecture:
- Team constraints:
- Risk level:
- Deadline:
- Production impact:

Output:
- Assumptions
- Findings or plan
- Risks
- Action items
- Definition of Done
```

# api/versioning.md — API Versioning Standard

## Objective

Define API evolution and backward compatibility rules.

## When To Use

- Designing public API
- Changing contract
- Planning deprecation

## Scope

- URL version
- Header version
- Backward compatibility
- Deprecation
- Additive changes
- Breaking changes

## Architecture Rules

1. Prefer additive changes.
2. Do not remove/rename fields without versioning.
3. Document deprecation window.
4. Use versioned base path where platform standard requires.
5. Maintain backward compatibility for mobile clients.

## Security / Compliance Rules

1. Protect old mobile app versions.
2. Do not break partner integrations suddenly.
3. Communicate deprecation.

## Anti-patterns

- Breaking change in same version.
- Silent field semantic change.
- No deprecation plan.
- Forced mobile upgrade.

## Expected Output

1. Versioning policy
2. Compatibility checklist
3. Deprecation plan

## Review Checklist

- [ ] Versioning policy
- [ ] Compatibility checklist
- [ ] Deprecation plan

## Prompt

```text
Use `.sa/api/versioning.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/api/versioning.md`.

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

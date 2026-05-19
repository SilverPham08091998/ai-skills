# sre/chaos-testing.md — Chaos Testing Standard

## Objective

Define controlled failure experiments for resilience validation.

## When To Use

- Testing resilience
- Validating failover
- Preparing production confidence
- Reviewing timeout/retry

## Scope

- Pod kill
- Node failure
- Latency injection
- Network drop
- DB failure
- Redis failure
- Kafka failure
- 5xx dependency

## Core Rules

1. Do not run chaos test in production without approval.
2. Start in dev/staging.
3. Define hypothesis before test.
4. Define stop condition.
5. Observe metrics during test.
6. Document findings.

## Security Rules

1. Limit blast radius.
2. Avoid destructive tests on real customer data.
3. Have rollback/stop mechanism ready.

## Anti-patterns

- Random chaos with no hypothesis.
- Prod chaos without approval.
- No monitoring during test.
- No action items after failure.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. Chaos test plan
2. Hypothesis
3. Blast radius
4. Metrics
5. Stop condition
6. Recovery validation

## Review Checklist

- [ ] Chaos test plan
- [ ] Hypothesis
- [ ] Blast radius
- [ ] Metrics
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/sre/chaos-testing.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/sre/chaos-testing.md`.

Task:
<describe what you want to create or review>

Context:
- Project: <project-name>
- Environment: <dev|staging|prod>
- Runtime: <runtime>
- Dependencies: <aws/kubernetes/platform dependencies>

Requirements:
- Follow production-grade defaults
- Include security considerations
- Include validation commands
- Include rollback notes where applicable
```

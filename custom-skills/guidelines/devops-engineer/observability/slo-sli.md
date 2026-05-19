# observability/slo-sli.md — SLI/SLO Standard

## Objective

Define service level indicators and objectives for platform and services.

## When To Use

- Defining reliability target
- Creating alert policy
- Production review
- SRE planning

## Scope

- Availability
- Latency
- Error rate
- Saturation
- Kafka lag
- Error budget
- Burn rate

## Core Rules

1. SLO must map to user/business impact.
2. Alert should be tied to SLO burn rate where possible.
3. Critical money APIs need stricter SLO.
4. SLO must be realistic and measured.
5. Review SLO periodically.

## Security Rules

1. Avoid vanity SLOs no one measures.
2. Do not set impossible SLO without investment.
3. Protect customer-impact metrics.

## Anti-patterns

- No SLO.
- SLO based only on pod uptime.
- No latency objective.
- No error budget policy.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. SLI/SLO definitions
2. Error budget notes
3. Alerting recommendation
4. Review checklist

## Review Checklist

- [ ] SLI/SLO definitions
- [ ] Error budget notes
- [ ] Alerting recommendation
- [ ] Review checklist
- [ ] Security reviewed
- [ ] Validation commands included

## Prompt

```text
Use `.devops/observability/slo-sli.md`. Generate or review the requested DevOps artifact according to this skill. Include file paths, production-safe defaults, security notes, validation commands, and rollback notes when applicable.
```

## Usage Example

```text
Use `.devops/observability/slo-sli.md`.

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

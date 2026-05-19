# deployment/deployment-architecture.md — Deployment Architecture Standard

## Objective

Design runtime deployment topology across cloud, Kubernetes, network, and dependencies.

## When To Use

- Creating deployment view
- Planning AWS/EKS deployment
- Reviewing runtime topology

## Scope

- Regions
- AZs
- VPC
- Subnets
- EKS
- Gateway
- Services
- Data stores
- External systems

## Architecture Rules

1. Show where components run.
2. Separate public/private layers.
3. Use multi-AZ for critical components.
4. Show traffic entry and exit paths.
5. Document environment differences.

## Security / Compliance Rules

1. Mark trust boundaries.
2. Protect private data stores.
3. Avoid public exposure of internal services.

## Anti-patterns

- No deployment view.
- All components public.
- No environment differences.
- No data store placement.

## Expected Output

1. Deployment diagram
2. Runtime topology
3. Network boundary notes
4. Environment matrix

## Review Checklist

- [ ] Deployment diagram
- [ ] Runtime topology
- [ ] Network boundary notes
- [ ] Environment matrix

## Prompt

```text
Use `.sa/deployment/deployment-architecture.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/deployment/deployment-architecture.md`.

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

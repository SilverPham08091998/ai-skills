# requirements/business-requirement.md — Business Requirement Analysis

## Objective

Translate business goals into structured capabilities, actors, use cases, and constraints.

## When To Use

- Starting architecture from raw business idea
- Clarifying stakeholder goals
- Converting business text into capabilities

## Scope

- Business goals
- Stakeholders
- Actors
- Use cases
- Constraints
- Success criteria
- Out of scope

## Architecture Rules

1. Identify business problem before solution.
2. Separate must-have from nice-to-have.
3. Define actors and responsibilities.
4. Capture assumptions and open questions.
5. Map each requirement to capability.

## Security / Compliance Rules

1. Protect sensitive business flows and customer data.
2. Identify regulated or audited flows early.
3. Mark financial, identity, and privacy-sensitive requirements.

## Anti-patterns

- Jumping to tech stack immediately.
- Missing actors.
- No success criteria.
- No out-of-scope definition.

## Expected Output

1. Business capability list
2. Use case list
3. Assumptions
4. Open questions
5. Acceptance criteria

## Review Checklist

- [ ] Business capability list
- [ ] Use case list
- [ ] Assumptions
- [ ] Open questions
- [ ] Acceptance criteria

## Prompt

```text
Use `.sa/requirements/business-requirement.md`. Generate or review the architecture artifact according to this skill. Include assumptions, diagrams where helpful, trade-offs, risks, security notes, and implementation handoff details.
```

## Usage Example

```text
Use `.sa/requirements/business-requirement.md`.

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

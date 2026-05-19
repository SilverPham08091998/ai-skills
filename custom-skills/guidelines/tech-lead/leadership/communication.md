# leadership/communication.md — Engineering Communication Standard

## Objective

Communicate technical topics clearly to engineers, PMs, QA, SRE, and stakeholders.

## When To Use

- Writing update
- Explaining risk
- Handing off design
- Giving review comments

## Scope

- Audience
- Context
- Impact
- Options
- Decision
- Action items
- Owner

## Tech Lead Rules

1. Start with context and impact.
2. Use language appropriate to audience.
3. Separate facts from opinions.
4. Make action items explicit.
5. Escalate blockers early.

## Security / Production Rules

1. Do not expose sensitive data in broad channels.
2. Be careful with incident/customer-impact communication.

## Anti-patterns

- Long unclear message.
- No owner/action.
- Technical jargon for non-technical audience.
- Hidden blocker.

## Expected Output

1. Communication draft
2. Status update
3. Decision note
4. Action list

## Review Checklist

- [ ] Communication draft
- [ ] Status update
- [ ] Decision note
- [ ] Action list

## Prompt

```text
Use `.techlead/leadership/communication.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/leadership/communication.md`.

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

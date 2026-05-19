# delivery/incident-followup.md — Incident Follow-up Standard

## Objective

Turn incidents into learning and engineering improvements.

## When To Use

- After incident
- Postmortem
- Creating action items

## Scope

- Timeline
- Impact
- Root causes
- Detection
- Mitigation
- Prevention
- Action items

## Tech Lead Rules

1. Postmortem must be blameless.
2. Focus on system/process improvement.
3. Action items must have owner and due date.
4. Improve detection and prevention.
5. Update runbooks/tests after incident.

## Security / Production Rules

1. Sanitize customer data.
2. Protect incident details as required.

## Anti-patterns

- Blame-focused postmortem.
- No action items.
- No runbook update.
- Same incident repeats.

## Expected Output

1. Postmortem summary
2. Action items
3. Process improvements

## Review Checklist

- [ ] Postmortem summary
- [ ] Action items
- [ ] Process improvements

## Prompt

```text
Use `.techlead/delivery/incident-followup.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/delivery/incident-followup.md`.

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

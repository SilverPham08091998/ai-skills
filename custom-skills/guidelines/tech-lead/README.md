# README.md — Tech Lead Skill Pack Overview

## Objective

Explain how to use `.techlead` skills for planning, review, delivery, mentoring, and implementation guidance.

## When To Use

- Onboarding AI agent
- Explaining folder structure
- Choosing the correct Tech Lead skill

## Scope

- Skill usage
- Prompt pattern
- Workflow
- Review and generator usage

## Tech Lead Rules

1. Use master file for global Tech Lead behavior.
2. Use planning skills before implementation.
3. Use review skills before merge.
4. Use production skills before release.
5. Use generator prompts to produce implementation-ready tasks.
6. Use team skills for mentoring and workflow improvements.

## Security / Production Rules

1. Do not paste real secrets into prompts.
2. Sanitize production incident data before using it in examples.

## Anti-patterns

- One giant prompt for all tasks.
- Skipping review skills for generated code.

## Expected Output

1. Usage guide
2. Prompt examples
3. Skill routing explanation

## Review Checklist

- [ ] Usage guide
- [ ] Prompt examples
- [ ] Skill routing explanation

## Prompt

```text
Use `.techlead/README.md` to understand how to apply the Tech Lead skill pack.
```

## Usage Example

```text
Use `.techlead/README.md`.

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

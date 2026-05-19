# README.md — SA Skill Pack Overview

## Objective

Explain how to use the `.sa` skill pack for architecture design, review, and implementation guidance.

## When To Use

- Onboarding AI agent
- Explaining SA folder structure
- Choosing the right architecture skill

## Scope

- Folder structure
- Skill usage
- Prompt pattern
- Architecture workflow

## Architecture Rules

1. Use master file for global architecture behavior.
2. Use domain-specific files for focused design.
3. Use generator files for final deliverables.
4. Use review files before implementation.
5. Use ADR files to capture decisions.

## Security / Compliance Rules

1. Do not paste real secrets or production credentials into prompts.
2. Use sanitized examples for architecture documents.

## Anti-patterns

- One giant architecture prompt for everything.
- Designing from tools before understanding problem.

## Expected Output

1. Clear usage guide
2. Recommended prompt examples
3. File map explanation

## Review Checklist

- [ ] Clear usage guide
- [ ] Recommended prompt examples
- [ ] File map explanation

## Prompt

```text
Use `.sa/README.md` to understand how to apply this Solution Architect skill pack.
```

## Usage Example

```text
Use `.sa/README.md`.

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

# README.md — DevOps Skill Pack Overview

## Objective

Explain how to use the `.devops` skill pack with Claude, Codex, or any AI coding agent.

## When To Use

- Onboarding a new AI agent
- Explaining folder structure
- Teaching team how to apply the skill pack

## Scope

- Skill pack usage
- Folder structure
- Recommended prompts
- How to combine multiple skill files

## Core Rules

1. Use small skill files instead of one huge prompt.
2. Load only relevant skills for the task.
3. Use generator prompts for implementation tasks.
4. Use standard files for review and rule enforcement.
5. Use SKILL_INDEX.md to find the correct skill files.

## Security Rules

1. Do not paste real secrets into prompts.
2. Replace account IDs, domains, tokens, and keys with placeholders unless needed for local testing.

## Anti-patterns

- Do not ask AI to generate infra without environment context.
- Do not mix dev/prod values in a single values file.

## Expected Output

When this skill is used, the AI agent should produce or verify:

1. A clear guide for using this skill pack
2. Examples of task prompts

## Review Checklist

- [ ] Folder structure understood
- [ ] Skill index used
- [ ] Generator selected for implementation task

## Prompt

```text
Use `.devops/README.md` to understand how to apply this DevOps skill pack. Select the most relevant skill files before generating or reviewing DevOps code.
```

## Usage Example

```text
Use `.devops/README.md`.

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

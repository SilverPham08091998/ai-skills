# Ask Workflow

## Purpose

Use this workflow when the user asks a question, requests an explanation, wants to understand an existing system, asks to read a skill/rule, or needs context before deciding whether to implement a change.

Ask is a research and explanation workflow. It is not an implementation step.

## Core Rule

Answer from the user's context first. Use outside knowledge only as a secondary source or fallback.

```text
User question
  -> Classify whether the answer is in local context
  -> Research project/rule/source context first
  -> Explain using local examples as the primary evidence
  -> Add outside/general knowledge only as supporting context
  -> Surface implementation impact only as guidance
```

## When To Use

Use Ask for:

- Concept explanations
- "What is X?" questions
- "How does this project handle X?" questions
- Skill, rule, workflow, or guideline reading
- Architecture or codebase orientation
- Comparing options before implementation
- Understanding impact before adding a feature

Do not use Ask when the user explicitly asks to edit, implement, refactor, fix, commit, or publish changes. Route those requests to the matching workflow.

## Required Behavior

### 1. Classify The Context

Before answering, decide whether the question is likely answered by:

- The current target project source code
- The ai-skills rule root
- A specific skill or workflow
- External/general knowledge
- Current online documentation

If local context may contain the answer, inspect it before giving a general answer.

### 2. Research Local Context First

Prefer targeted local inspection:

```bash
rg -n "<keyword>|<framework>|<concept>"
```

Read only the relevant files needed to answer. Do not scan the entire repository when a bounded search is enough.

Examples:

- For Kafka questions, search producers, consumers, topics, outbox, events, `KafkaTemplate`, and `@KafkaListener`.
- For Spring Boot questions, search controllers, use cases, services, repositories, configuration, and matching Spring annotations.
- For mobile state questions, search feature state, hooks, stores, sagas, epics, thunks, persistence, and navigation flow.
- For ai-skills questions, read the matching rule, workflow, template, or skill.

### 3. Answer From Local Context As Primary Source

If local context exists, lead with it:

```text
Trong project này, X đang nằm ở:
- file A
- file B

Flow hiện tại:
1. ...
2. ...

Nhiệm vụ thực tế của X trong project này là ...
```

Then add general explanation only to clarify the concept.

### 4. Use External Knowledge As Fallback Or Support

Use general knowledge when local context is absent or insufficient.

Use web/docs only when:

- The user asks for latest/current information
- The topic depends on changing APIs, docs, versions, prices, laws, or releases
- The answer needs direct source attribution
- Local context does not answer the question and external precision matters

When external knowledge is used, clearly separate it from local-context findings.

### 5. Provide The Big Picture Before Implementation

The output should help the user decide what to build next.

Include implementation impact when useful:

- Affected layers/modules
- Existing patterns to reuse
- APIs, DB tables, Kafka topics, cache, security, or observability touched
- Test areas likely needed
- Risks, trade-offs, or missing context

Do not create or modify files during Ask.

## Forbidden In Ask

- Do not edit files.
- Do not create implementation TODO/file-scope gates.
- Do not run tests or coverage unless the user explicitly asks for command output.
- Do not create version guides.
- Do not treat Ask as Step 01 of implementation.
- Do not answer from generic knowledge when relevant local context is available.

## Escalation To Other Workflows

If the user asks to proceed after Ask:

- Feature or code generation → `implement` workflow
- Bug fix → `fix-bug` workflow when available, otherwise `implement` with bug-fix scope
- Refactor → `refactor` workflow when available, otherwise `implement` with refactor scope
- Code review → `review` workflow

Ask ends with understanding, options, and impact. Implementation starts only after the user explicitly requests it.

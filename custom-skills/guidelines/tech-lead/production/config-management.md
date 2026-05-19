# production/config-management.md — Configuration Management Standard

## Objective

Review application config, environment config, and secret separation.

## When To Use

- Reviewing config
- Preparing deployment
- Fixing environment issues

## Scope

- Env vars
- Config files
- Secrets
- Feature flags
- Defaults
- Validation

## Tech Lead Rules

1. Separate config from code.
2. Secrets are not config files.
3. Validate required config at startup.
4. Use safe defaults.
5. Document environment differences.
6. Use feature flags for risky rollout.

## Security / Production Rules

1. Do not expose secrets.
2. Avoid logging config values containing credentials.

## Anti-patterns

- Hard-coded env config.
- Secret in YAML.
- No startup validation.
- Different hidden prod behavior.

## Expected Output

1. Config checklist
2. Required variables
3. Secret list

## Review Checklist

- [ ] Config checklist
- [ ] Required variables
- [ ] Secret list

## Prompt

```text
Use `.techlead/production/config-management.md`. Produce Tech Lead-level guidance with assumptions, actionable steps, risks, review criteria, and concrete output.
```

## Usage Example

```text
Use `.techlead/production/config-management.md`.

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

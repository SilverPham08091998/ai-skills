# react-native/code-quality-config.md

## Objective

Define mandatory code quality configuration for React Native + TypeScript projects, including TypeScript strict mode, ESLint, Prettier, Husky, lint-staged, and Commitlint.

Applies to:

* React Native
* TypeScript
* Yarn / npm projects
* CI/CD pipelines
* Fintech / Banking applications

Main rule:

> Code quality must be enforced automatically before code reaches the repository.
> Developers should not rely on manual review for formatting, linting, type checking, or commit message rules.

---

# 1. Required Tooling

Install required dev dependencies:

```bash
yarn add -D \
  typescript \
  eslint \
  prettier \
  eslint-config-prettier \
  eslint-plugin-import \
  @typescript-eslint/parser \
  @typescript-eslint/eslint-plugin \
  husky \
  lint-staged \
  @commitlint/cli \
  @commitlint/config-conventional \
  madge
```

For React Native projects, also use the official React Native TypeScript config when available:

```bash
yarn add -D @react-native/typescript-config
```

Rules:

* ESLint enforces code correctness.
* Prettier enforces code formatting.
* TypeScript enforces type safety.
* Husky enforces local Git hooks.
* lint-staged runs checks only on staged files.
* Commitlint enforces commit message convention.

---

# 2. TypeScript Config

## 2.1 `tsconfig.json`

Use strict TypeScript configuration.

```json
{
  "extends": "@react-native/typescript-config/tsconfig.json",
  "compilerOptions": {
    "strict": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noPropertyAccessFromIndexSignature": true,
    "isolatedModules": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true,
    "baseUrl": "./",
    "paths": {
      "@domain/*": ["src/domain/*"],
      "@application/*": ["src/application/*"],
      "@infrastructure/*": ["src/infrastructure/*"],
      "@presentation/*": ["src/presentation/*"],
      "@di/*": ["src/di/*"],
      "@config/*": ["src/config/*"],
      "@utils/*": ["src/utils/*"]
    }
  },
  "include": ["src/**/*", "types/**/*"],
  "exclude": ["node_modules", "dist", "build", "coverage"]
}
```

Rules:

* `strict` must be enabled.
* `noUncheckedIndexedAccess` must be enabled to avoid unsafe array/object access.
* `exactOptionalPropertyTypes` must be enabled for safer optional fields.
* Path aliases must follow the project architecture.
* Do not disable strict flags to make code pass quickly.

---

# 3. ESLint Config

## 3.1 `.eslintrc.json`

```json
{
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "project": "./tsconfig.json",
    "tsconfigRootDir": ".",
    "ecmaVersion": 2022,
    "sourceType": "module"
  },
  "plugins": ["@typescript-eslint", "import"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "plugin:import/recommended",
    "plugin:import/typescript",
    "prettier"
  ],
  "rules": {
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/no-unsafe-assignment": "error",
    "@typescript-eslint/no-unsafe-call": "error",
    "@typescript-eslint/no-unsafe-member-access": "error",
    "@typescript-eslint/no-unsafe-return": "error",
    "@typescript-eslint/no-unsafe-argument": "error",

    "@typescript-eslint/explicit-function-return-type": [
      "warn",
      {
        "allowExpressions": true,
        "allowTypedFunctionExpressions": true,
        "allowHigherOrderFunctions": true,
        "allowDirectConstAssertionInArrowFunctions": true
      }
    ],
    "@typescript-eslint/explicit-module-boundary-types": "warn",

    "@typescript-eslint/consistent-type-imports": [
      "error",
      {
        "prefer": "type-imports",
        "disallowTypeAnnotations": true
      }
    ],
    "@typescript-eslint/no-import-type-side-effects": "error",

    "@typescript-eslint/no-floating-promises": "error",
    "@typescript-eslint/await-thenable": "error",
    "@typescript-eslint/no-misused-promises": [
      "error",
      {
        "checksVoidReturn": {
          "attributes": false
        }
      }
    ],
    "@typescript-eslint/require-await": "error",

    "@typescript-eslint/prefer-nullish-coalescing": "error",
    "@typescript-eslint/prefer-optional-chain": "error",
    "@typescript-eslint/no-non-null-assertion": "warn",

    "@typescript-eslint/prefer-readonly": "error",
    "@typescript-eslint/prefer-readonly-parameter-types": "off",

    "@typescript-eslint/no-unnecessary-type-assertion": "error",
    "@typescript-eslint/consistent-type-assertions": [
      "error",
      {
        "assertionStyle": "as",
        "objectLiteralTypeAssertions": "allow-as-parameter"
      }
    ],

    "@typescript-eslint/no-unused-vars": [
      "error",
      {
        "argsIgnorePattern": "^_",
        "varsIgnorePattern": "^_",
        "destructuredArrayIgnorePattern": "^_"
      }
    ],

    "@typescript-eslint/naming-convention": [
      "error",
      {
        "selector": "variable",
        "format": ["camelCase", "UPPER_CASE", "PascalCase"]
      },
      {
        "selector": "function",
        "format": ["camelCase", "PascalCase"]
      },
      {
        "selector": "parameter",
        "format": ["camelCase"],
        "leadingUnderscore": "allow"
      },
      {
        "selector": "class",
        "format": ["PascalCase"]
      },
      {
        "selector": "interface",
        "format": ["PascalCase"]
      },
      {
        "selector": "typeAlias",
        "format": ["PascalCase"]
      },
      {
        "selector": "enum",
        "format": ["PascalCase"]
      },
      {
        "selector": "enumMember",
        "format": ["PascalCase"]
      }
    ],

    "no-magic-numbers": "off",
    "@typescript-eslint/no-magic-numbers": [
      "warn",
      {
        "ignore": [0, 1, -1, 2, 100],
        "ignoreEnums": true,
        "ignoreNumericLiteralTypes": true,
        "ignoreReadonlyClassProperties": true,
        "ignoreArrayIndexes": true
      }
    ],

    "import/order": [
      "error",
      {
        "groups": ["builtin", "external", "internal", ["parent", "sibling", "index"]],
        "pathGroups": [
          {
            "pattern": "@domain/**",
            "group": "internal",
            "position": "before"
          },
          {
            "pattern": "@application/**",
            "group": "internal",
            "position": "before"
          },
          {
            "pattern": "@infrastructure/**",
            "group": "internal"
          },
          {
            "pattern": "@presentation/**",
            "group": "internal"
          }
        ],
        "newlines-between": "always",
        "alphabetize": {
          "order": "asc",
          "caseInsensitive": true
        }
      }
    ],
    "import/no-cycle": "error",
    "import/no-self-import": "error",
    "import/no-duplicates": "error"
  }
}
```

Rules:

* `any` is not allowed.
* Unsafe TypeScript operations are not allowed.
* Floating promises are not allowed.
* Type imports must be explicit.
* Circular imports are not allowed.
* Prettier must be the final formatter conflict resolver.

---

# 4. Prettier Config

## 4.1 `.prettierrc`

```json
{
  "semi": true,
  "singleQuote": true,
  "quoteProps": "as-needed",
  "trailingComma": "all",
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

## 4.2 `.prettierignore`

```txt
node_modules
coverage
dist
build
android
ios
.bundle
```

Rules:

* Prettier owns formatting.
* ESLint owns correctness.
* Do not add formatting-only ESLint rules that conflict with Prettier.

---

# 5. lint-staged Config

Add to `package.json`:

```json
{
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix --max-warnings 0",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ]
  }
}
```

Rules:

* Run fast checks on staged files.
* Keep expensive checks in pre-push or CI.
* Do not run full test suite in pre-commit unless the project is small.

---

# 6. Husky Setup

## 6.1 Initialize Husky

```bash
yarn husky init
```

Or manually:

```bash
yarn husky install
```

Add to `package.json`:

```json
{
  "scripts": {
    "prepare": "husky install"
  }
}
```

---

## 6.2 `.husky/pre-commit`

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

yarn lint-staged
yarn type-check
```

Rules:

* Pre-commit must run lint-staged.
* Pre-commit should run type-check for TypeScript safety.
* If type-check is too slow, move it to pre-push and CI.

---

## 6.3 `.husky/pre-push`

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

yarn type-check
yarn lint
yarn test
```

Rules:

* Pre-push should verify full source health.
* CI must still run all checks even if hooks pass locally.

---

# 7. Commitlint Config

## 7.1 `commitlint.config.js`

```js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',
        'fix',
        'docs',
        'style',
        'refactor',
        'perf',
        'test',
        'build',
        'ci',
        'chore',
        'revert'
      ]
    ],
    'subject-case': [0],
    'subject-empty': [2, 'never'],
    'type-empty': [2, 'never'],
    'header-max-length': [2, 'always', 100]
  }
};
```

## 7.2 `.husky/commit-msg`

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

yarn commitlint --edit "$1"
```

## 7.3 Commit Message Format

```txt
<type>(optional-scope): <subject>
```

Examples:

```txt
feat(auth): add biometric login
fix(payment): prevent duplicate submit
refactor(api): normalize network errors
perf(list): optimize transaction history rendering
test(transfer): add integration tests
```

Rules:

* Commit messages must follow Conventional Commits.
* Use meaningful scopes: `auth`, `payment`, `transfer`, `api`, `ui`, `security`, `testing`.
* Do not commit vague messages like `update`, `fix bug`, or `wip`.

---

# 8. Required package.json Scripts

```json
{
  "scripts": {
    "type-check": "tsc --noEmit",
    "type-check:watch": "tsc --noEmit --watch",
    "lint": "eslint src --ext .ts,.tsx --max-warnings 0",
    "lint:fix": "eslint src --ext .ts,.tsx --fix",
    "format": "prettier --write \"src/**/*.{ts,tsx,json,md}\"",
    "format:check": "prettier --check \"src/**/*.{ts,tsx,json,md}\"",
    "test": "jest",
    "test:watch": "jest --watch",
    "circular-check": "madge --circular src/",
    "commitlint": "commitlint"
  }
}
```

Rules:

* CI must run `type-check`, `lint`, `test`, and `format:check`.
* `circular-check` should run in CI or pre-push for large projects.
* Do not rely only on local hooks.

---

# 9. CI Quality Gate

Minimum CI checks:

```bash
yarn type-check
yarn lint
yarn format:check
yarn test
yarn circular-check
```

Rules:

* No merge if type-check fails.
* No merge if lint fails.
* No merge if tests fail.
* No merge if circular dependencies are detected.

---

# 10. Fintech Rules (CRITICAL)

## 10.1 No Unsafe TypeScript

* `any` is forbidden.
* unsafe assignment/call/member access is forbidden.
* floating promises are forbidden.

## 10.2 Async Safety

* All promises must be handled.
* Fire-and-forget must use `void` explicitly.

```ts
void syncInBackground();
```

## 10.3 Commit Traceability

* Commit messages must clearly describe changes.
* Security/payment changes must use meaningful scopes.

Examples:

```txt
fix(payment): add idempotency key to submit transfer
security(auth): prevent token logging
```

---

# 11. Anti-patterns

* Disabling strict TypeScript rules to pass quickly.
* Adding `any` to bypass compile errors.
* Running Prettier manually only.
* Skipping hooks with `--no-verify` without strong reason.
* Using vague commit messages.
* Allowing CI to differ from local checks.

---

# 12. Checklist

* [ ] `strict` TypeScript enabled.
* [ ] ESLint type-aware rules enabled.
* [ ] Prettier configured.
* [ ] lint-staged configured.
* [ ] Husky pre-commit configured.
* [ ] Husky pre-push configured.
* [ ] Commitlint configured.
* [ ] CI runs type-check, lint, format check, and tests.
* [ ] Circular dependency check exists.

---

# 13. Final Rule

> Quality gates must be automated.
> Every commit should be formatted, linted, type-safe, and traceable before it reaches the repository.

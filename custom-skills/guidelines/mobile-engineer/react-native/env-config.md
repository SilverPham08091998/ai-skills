# react-native/env-config.md

## Objective

Define a standardized environment configuration system for React Native applications using `react-native-config`, supporting multiple environments (dev, staging, prod) with Android flavors and iOS schemes.

Applies to:

* React Native (iOS + Android)
* TypeScript
* CI/CD pipelines
* Fintech / Banking apps

Main rule:

> Environment configuration must be explicit, isolated, and impossible to mix accidentally.

---

# 1. Environment Strategy

## 1.1 Supported Environments

```txt
dev
staging
prod
```

## 1.2 Goals

* Each environment must use its own API
* Each build must map to exactly one environment
* No runtime ambiguity

---

# 2. ENV File Structure

```txt
.env.dev
.env.staging
.env.prod
```

## Example

```env
# .env.dev
API_URL=https://dev-api.myapp.com
APP_ENV=dev

# .env.staging
API_URL=https://staging-api.myapp.com
APP_ENV=staging

# .env.prod
API_URL=https://api.myapp.com
APP_ENV=prod
```

---

# 3. Usage in Code

```ts
import Config from 'react-native-config';

export const ENV = {
  apiUrl: Config.API_URL,
  env: Config.APP_ENV,
};
```

Rules:

* Never hardcode URLs
* Always read from Config

---

# 4. Android Configuration

## 4.1 Flavor Setup

```gradle
productFlavors {
  dev {
    applicationIdSuffix ".dev"
  }
  staging {
    applicationIdSuffix ".staging"
  }
  prod {}
}
```

---

## 4.2 ENV Mapping

```gradle
project.ext.envConfigFiles = [
  dev: ".env.dev",
  staging: ".env.staging",
  prod: ".env.prod"
]
```

---

## 4.3 Build Commands

```bash
./gradlew assembleDevRelease
./gradlew assembleStagingRelease
./gradlew assembleProdRelease
```

---

# 5. iOS Configuration

## 5.1 Schemes

```txt
MyApp-Dev
MyApp-Staging
MyApp-Prod
```

---

## 5.2 xcconfig

```txt
ios/config/dev.xcconfig
ios/config/staging.xcconfig
ios/config/prod.xcconfig
```

---

## 5.3 ENV Mapping

```txt
ENVFILE=.env.dev
ENVFILE=.env.staging
ENVFILE=.env.prod
```

---

# 6. CI/CD Mapping

```txt
branch → env

develop → dev
release/* → staging
main → prod
```

Rules:

* CI must control ENVFILE
* Do not rely on developer machine

---

# 7. Security Rules (CRITICAL)

## 7.1 No Secrets in ENV

Do NOT store:

* API keys
* private keys
* tokens

Use:

* backend-issued tokens
* CI secret manager

---

## 7.2 Prevent Environment Mix

* prod build must NEVER call staging API
* staging must NEVER call prod API

---

# 8. Runtime Guards

```ts
if (Config.APP_ENV === 'prod') {
  disableDebugLogs();
}
```

---

# 9. Fintech Rules

## 9.1 Payment Isolation

* prod → real payment
* staging → sandbox only

## 9.2 Logging

* no sensitive logs in prod

---

# 10. Anti-patterns

* hardcoding API URLs
* using single .env for all environments
* committing secrets
* mixing staging and prod configs

---

# 11. Checklist

* [ ] .env files created per environment
* [ ] Android flavors configured
* [ ] iOS schemes configured
* [ ] CI maps env correctly
* [ ] no secrets in env
* [ ] runtime guards applied

---

# 12. Final Rule

> Environment configuration is a safety boundary.
> If environments mix, production incidents will happen.

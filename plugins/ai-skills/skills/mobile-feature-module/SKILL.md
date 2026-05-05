---
name: mobile-feature-module
description: Mobile feature module standards. Use when creating or reviewing React Native feature folders, boundaries, and ownership.
---

# Mobile Feature Module Guidelines

This skill converts `mobile-engineer/architecture/feature-module.md` into Claude Code plugin skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================

# 🧩 FEATURE ORGANIZATION (NO MODULE FOLDER)

# ========================

## 🎯 OBJECTIVE

Define how to organize feature code when using **global layer architecture**.

⚠️ This project DOES NOT use:

```txt
modules/<feature>/...
```

Instead, feature is split across layers:

```txt
application/
domain/
infrastructure/
presentation/
component/
```

---

# ========================

# 🧠 CORE IDEA

# ========================

A feature is NOT a folder.

A feature is a **set of files across layers**.

Example feature: `transfer`

```txt
application/transfer/
domain/transfer/
infrastructure/transfer/
presentation/transfer/
```

---

# ========================

# 📁 FEATURE STRUCTURE BY LAYER

# ========================

## 1. PRESENTATION

```txt
presentation/transfer/
  transfer.screen.tsx
  transfer.view.tsx
  transfer.style.ts
```

---

## 2. APPLICATION

```txt
application/transfer/
  use-transfer.ts
  submit-transfer.usecase.ts
  submit-transfer.command.ts
  transfer.state.ts
```

---

## 3. DOMAIN

```txt
domain/transfer/
  transfer.model.ts
  transfer.rule.ts
  transfer.error.ts
```

---

## 4. INFRASTRUCTURE

```txt
infrastructure/transfer/
  transfer.repository.ts
  transfer.api.ts
  transfer.mapper.ts
```

---

## 5. COMPONENT (OPTIONAL)

```txt
component/
  transfer-form/
  amount-input/
```

---

# ========================

# 🔁 FEATURE FLOW

# ========================

```txt
TransferScreen
  → useTransfer
  → submitTransferUseCase
  → transferRepository
  → apiClient
```

---

# ========================

# 🔥 RULES

# ========================

## MUST

* Group files by feature inside each layer
* Keep naming consistent: transfer.*
* Follow same flow across all features

---

## MUST NOT

* Create `modules/transfer`
* Mix files of multiple features in same folder
* Put all logic into one file

---

# ========================

# 💸 FINTECH RULE

# ========================

Every feature related to money must include:

* requestId generation
* validation rule (domain)
* use case (application)
* repository (infrastructure)
* UI state (loading / success / error)

---

# ========================

# 🧪 AI RULE

# ========================

AI MUST:

* Create feature folder inside EACH layer
* Follow naming pattern `<feature>`
* Split files correctly across layers

---

AI MUST NOT:

* Create a single folder containing all layers
* Skip domain or application layer

---

# ========================

# 📌 SUMMARY

# ========================

Feature = logical grouping across layers

NOT = folder

This ensures:

* Clean architecture
* Easy scaling
* No spaghetti structure

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

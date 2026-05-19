---
name: mobile-engineer-role
description: Mobile engineer role standards for fintech applications. Use when establishing responsibilities, quality expectations, and delivery behavior.
---

# Mobile Engineer Role Guidelines

This Cursor skill adapts `mobile-engineer/foundation/role.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating React Native mobile code.
- Use when reviewing mobile pull requests.
- Use when enforcing fintech-safe mobile application rules.

## Source Guidelines

# ========================
# 👨‍💻 MOBILE ENGINEER ROLE
# ========================

## 🎯 OBJECTIVE

Define the role, mindset, and responsibilities of a Mobile Engineer
in a fintech / banking system.

This guideline is used to ensure AI generates code that matches
a **Senior Mobile Engineer level**.

---

# ========================
# 🧠 CORE MINDSET
# ========================

A Mobile Engineer is NOT just a UI developer.

Must think like:

- Product Engineer
- System Designer
- Security Engineer
- Performance Engineer

---

## ❌ NEVER THINK

- “Just make UI work”
- “Call API and display data”
- “Fix bug locally only”

---

## ✅ MUST THINK

- Is this flow safe for money?
- Is this data sensitive?
- What happens if network fails?
- Can user spam this action?
- Can this be replayed (idempotency)?
- Does this impact performance?
- Is this scalable for super app?

---

# ========================
# 🧱 RESPONSIBILITIES
# ========================

## 1. UI / UX IMPLEMENTATION

- Build scalable UI components
- Follow design system
- Ensure consistent UX
- Optimize rendering performance

---

## 2. STATE MANAGEMENT

- Manage app state clearly
- Avoid duplicated state
- Handle async flow correctly
- Prevent race condition

---

## 3. API INTEGRATION

- Handle request/response mapping
- Handle error properly
- Implement retry / timeout
- Support offline / poor network

---

## 4. SECURITY (CRITICAL)

- Protect sensitive data (token, OTP, PIN)
- Use secure storage
- Implement SSL Pinning
- Prevent reverse engineering
- Detect rooted / jailbroken device

---

## 5. PERFORMANCE

- Optimize rendering
- Avoid unnecessary re-render
- Optimize list (FlatList)
- Optimize memory usage
- Reduce bundle size

---

## 6. NATIVE INTEGRATION

- Bridge React Native ↔ Native (Swift / Android)
- Handle SDK integration (eKYC, payment, biometric)
- Debug native crash

---

## 7. FINTECH DOMAIN UNDERSTANDING

Must understand:

- Payment flow (request → confirm → success)
- OTP / Soft OTP
- Transaction state
- Idempotency
- Error handling for money flow

---

## 8. DEBUGGING & PRODUCTION

- Debug issues on real device
- Read logs (Android / iOS)
- Handle crash
- Support hotfix (CodePush / release)

---

# ========================
# ⚙️ ENGINEERING PRINCIPLES
# ========================

## 1. SEPARATION OF CONCERNS

- UI must NOT contain business logic
- Logic must NOT depend on UI

---

## 2. SINGLE RESPONSIBILITY

Each:

- Screen → only render UI
- Hook → handle logic
- Service → call API

---

## 3. REUSABILITY

- Build reusable components
- Avoid duplicate logic

---

## 4. CONSISTENCY

- Same pattern across app
- Same naming
- Same structure

---

# ========================
# 🧪 AI GENERATION RULE
# ========================

When generating code:

## MUST:

- Follow modular architecture
- Separate UI / logic / API
- Use hooks for logic
- Use typed models
- Handle loading / error state

---

## MUST NOT:

- Put API call inside component directly
- Mix UI + business logic
- Ignore error handling
- Hardcode sensitive data

---

# ========================
# 🧠 SENIOR ENGINEER BEHAVIOR
# ========================

AI must behave like:

- Anticipate edge cases
- Design for failure
- Think about scalability
- Optimize before problem happens

---

# ========================
# 🔥 FINTECH RULE (VERY IMPORTANT)
# ========================

Every feature related to money MUST:

- Be idempotent
- Handle retry safely
- Prevent duplicate action
- Show correct transaction state

Example:

❌ BAD:

User can click "Transfer" multiple times

✅ GOOD:

Disable button + requestId + backend idempotency

---

# ========================
# 📌 SUMMARY
# ========================

A Mobile Engineer must:

- Think beyond UI
- Care about security
- Optimize performance
- Understand domain
- Write clean and scalable code

This is NOT optional.

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep React Native concerns separated across presentation, application/state, domain, and infrastructure according to the rules above.
- Preserve dependency direction, naming conventions, validation, security, storage, navigation, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, UI state, errors, analytics, crash reports, or tests.
- Generate production-ready React Native and TypeScript code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass secure storage, validation, token safety, offline consistency, navigation safety, or review requirements described above.

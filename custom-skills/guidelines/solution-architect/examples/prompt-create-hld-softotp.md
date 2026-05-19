# Example Prompt — Create HLD for Soft OTP

Use these skills:
- `.sa/SA.md`
- `.sa/generators/create-hld.md`
- `.sa/architecture/hld.md`
- `.sa/architecture/c4-model.md`
- `.sa/security/security-architecture.md`
- `.sa/security/threat-modeling.md`
- `.sa/integration/external-partner.md`
- `.sa/observability/architecture-observability.md`

Task:
Create HLD for banking Soft OTP system.

Context:
- Mobile app: React Native
- Backend: Spring Boot
- Security: device binding, secret provisioning, OTP verification, audit
- External: optional vendor SDK / HSM / bank core
- Need: QR provisioning and local secret-based OTP generation

Output:
- Business context
- Actors
- C4 context/container diagrams
- Main flows
- Security controls
- Failure handling
- NFR
- Risks
- Implementation roadmap

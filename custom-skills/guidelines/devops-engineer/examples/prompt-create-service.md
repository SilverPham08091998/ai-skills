# Example Prompt — Create Platform Service

Use `.devops/generators/create-platform-service.md`.

Task:
Create full DevOps package for `payment-service`.

Context:
- Runtime: Java 21 Spring Boot
- Port: 8080
- Namespace: prod
- Environment: prod
- Dependencies: RDS PostgreSQL, Redis, Kafka
- Exposure: external-through-kong for public APIs, internal through Istio for service-to-service
- Health endpoints:
  - /actuator/health/readiness
  - /actuator/health/liveness
  - /actuator/prometheus

Output:
- Helm values
- K8s resources
- Istio config
- Kong config if needed
- ExternalSecret
- ArgoCD Application
- Production checklist
- Rollback steps

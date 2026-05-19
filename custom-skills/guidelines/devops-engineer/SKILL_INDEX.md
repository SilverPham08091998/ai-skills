# SKILL_INDEX.md — DevOps Skill Index

## Objective

Map every file in `.devops/` to its purpose and recommended use case.

## How To Use

1. Identify the task.
2. Select one generator file if implementation is needed.
3. Add related standard files for the domain.
4. Add security and observability files for production work.
5. Ask the AI agent to follow the selected files strictly.

## Task Routing

| Task | Recommended Skills |
|---|---|
| Create AWS VPC | `.devops/aws/vpc.md`, `.devops/terraform/module-standard.md`, `.devops/terraform/tagging-standard.md` |
| Create EKS | `.devops/aws/eks.md`, `.devops/aws/iam.md`, `.devops/terraform/module-standard.md` |
| Create RDS | `.devops/aws/rds.md`, `.devops/aws/secrets-manager.md`, `.devops/security/secret-management.md` |
| Create Redis | `.devops/aws/redis.md`, `.devops/security/secret-management.md` |
| Create Kafka/MSK | `.devops/aws/msk.md`, `.devops/observability/alerting.md` |
| Create Kubernetes deployment | `.devops/kubernetes/deployment-standard.md`, `.devops/kubernetes/probes.md`, `.devops/kubernetes/resource-limit.md` |
| Create Helm chart | `.devops/generators/create-helm-chart.md`, `.devops/helm/chart-standard.md` |
| Create ArgoCD app | `.devops/generators/create-argocd-app.md`, `.devops/gitops/argocd-standard.md` |
| Create Jenkins pipeline | `.devops/generators/create-jenkins-pipeline.md`, `.devops/cicd/jenkins-standard.md` |
| Expose public API | `.devops/kong/gateway-standard.md`, `.devops/kong/jwt-plugin.md`, `.devops/kong/rate-limit.md`, `.devops/kong/cors.md` |
| Configure service mesh | `.devops/istio/service-mesh.md`, `.devops/istio/mtls.md`, `.devops/istio/retry-timeout.md` |
| Production review | `.devops/generators/production-review.md`, `.devops/security/compliance.md`, `.devops/sre/runbook.md` |

## Full File Map

| File | Purpose | Use When |
|---|---|---|
| `.devops/DEVOPS.md` | DevOps Engineer Master Skill | Starting any DevOps/platform task, Generating Terraform, Helm, Kubernetes, ArgoCD, or Jenkins files |
| `.devops/README.md` | DevOps Skill Pack Overview | Onboarding a new AI agent, Explaining folder structure |
| `.devops/aws/eks.md` | Amazon EKS Standard | Creating new EKS cluster, Reviewing EKS Terraform module |
| `.devops/aws/iam.md` | AWS IAM Standard | Creating IAM Terraform module, Configuring IRSA |
| `.devops/aws/msk.md` | Amazon MSK Kafka Standard | Creating MSK Terraform module, Designing Kafka topics |
| `.devops/aws/rds.md` | Amazon RDS PostgreSQL Standard | Creating RDS Terraform module, Reviewing database network/security |
| `.devops/aws/redis.md` | Amazon ElastiCache Redis Standard | Creating Redis Terraform module, Implementing idempotency |
| `.devops/aws/secrets-manager.md` | AWS Secrets Manager Standard | Creating secrets strategy, Generating ExternalSecret manifests |
| `.devops/aws/vpc.md` | AWS VPC Standard | Creating VPC Terraform module, Reviewing AWS network design |
| `.devops/cicd/deployment-flow.md` | CI/CD Deployment Flow Standard | Designing pipeline, Explaining release path |
| `.devops/cicd/docker-build.md` | Docker Build Standard | Writing Dockerfile, Reviewing image security |
| `.devops/cicd/jenkins-standard.md` | Jenkins Pipeline Standard | Creating Jenkinsfile, Reviewing pipeline |
| `.devops/cicd/release-strategy.md` | Release Strategy Standard | Planning release, Designing prod promotion |
| `.devops/cicd/trivy-scan.md` | Trivy Scan Standard | Adding image scan to CI, Reviewing vulnerabilities |
| `.devops/generators/create-argocd-app.md` | Generator — Create ArgoCD Application | User asks for ArgoCD app, Onboarding service to GitOps |
| `.devops/generators/create-helm-chart.md` | Generator — Create Helm Chart | User asks for Helm chart, Packaging new service |
| `.devops/generators/create-jenkins-pipeline.md` | Generator — Create Jenkins Pipeline | User asks for Jenkinsfile, Adding CI/CD |
| `.devops/generators/create-platform-service.md` | Generator — Create Platform Service Package | Onboarding new Spring Boot service, Creating full K8s/Helm/GitOps package |
| `.devops/generators/create-terraform-module.md` | Generator — Create Terraform Module | User asks to create Terraform module, Implementing AWS infrastructure |
| `.devops/generators/production-review.md` | Generator — Production Readiness Review | User asks for review, Before production deployment |
| `.devops/gitops/app-of-apps.md` | ArgoCD App-of-Apps Standard | Creating GitOps root app, Managing many apps |
| `.devops/gitops/argocd-standard.md` | ArgoCD Standard | Creating ArgoCD app, Designing GitOps repo |
| `.devops/gitops/rollback.md` | GitOps Rollback Standard | Preparing production release, Handling failed deployment |
| `.devops/gitops/sync-policy.md` | ArgoCD Sync Policy Standard | Choosing auto/manual sync, Reviewing production GitOps risk |
| `.devops/helm/chart-standard.md` | Helm Chart Standard | Creating Helm chart, Packaging Spring Boot service |
| `.devops/helm/deployment-template.md` | Helm Deployment Template Standard | Writing templates/deployment.yaml, Refactoring chart |
| `.devops/helm/reusable-chart.md` | Reusable Helm Chart Standard | Building platform chart, Reducing copy-paste |
| `.devops/helm/values-standard.md` | Helm Values Standard | Creating values files, Reviewing GitOps values |
| `.devops/istio/destination-rule.md` | Istio DestinationRule Standard | Creating mesh traffic policy, Configuring mTLS |
| `.devops/istio/mtls.md` | Istio mTLS Standard | Enabling service mesh security, Migrating PERMISSIVE to STRICT |
| `.devops/istio/retry-timeout.md` | Istio Retry Timeout Standard | Configuring service call resilience, Reviewing payment/wallet APIs |
| `.devops/istio/service-mesh.md` | Istio Service Mesh Standard | Designing internal traffic, Enabling mTLS |
| `.devops/istio/traffic-management.md` | Istio Traffic Management Standard | Canary release, Blue/green deployment |
| `.devops/istio/virtual-service.md` | Istio VirtualService Standard | Creating service route, Adding timeout/retry |
| `.devops/kong/cors.md` | Kong CORS Standard | Configuring browser API access, Reviewing public API security |
| `.devops/kong/gateway-standard.md` | Kong Gateway Standard | Exposing public API, Configuring API gateway |
| `.devops/kong/jwt-plugin.md` | Kong JWT/OIDC Plugin Standard | Adding JWT validation, Integrating OIDC provider |
| `.devops/kong/observability.md` | Kong Observability Standard | Monitoring API gateway, Creating Grafana dashboard |
| `.devops/kong/rate-limit.md` | Kong Rate Limit Standard | Protecting public APIs, Securing login/OTP/payment endpoints |
| `.devops/kubernetes/deployment-standard.md` | Kubernetes Deployment Standard | Creating Deployment manifest, Creating Helm deployment template |
| `.devops/kubernetes/hpa.md` | Kubernetes HPA Standard | Adding autoscaling, Reviewing CPU/memory targets |
| `.devops/kubernetes/namespace-standard.md` | Kubernetes Namespace Standard | Creating platform namespaces, Separating dev/staging/prod |
| `.devops/kubernetes/network-policy.md` | Kubernetes NetworkPolicy Standard | Creating secure namespace, Restricting service traffic |
| `.devops/kubernetes/pdb.md` | Kubernetes PDB Standard | Adding production resilience, Preparing node upgrades |
| `.devops/kubernetes/probes.md` | Kubernetes Probes Standard | Adding health checks, Reviewing Spring Boot Actuator integration |
| `.devops/kubernetes/resource-limit.md` | Kubernetes Resource Limit Standard | Sizing Spring Boot service, Creating Helm values |
| `.devops/observability/alerting.md` | Alerting Standard | Creating PrometheusRule, Reviewing incident readiness |
| `.devops/observability/grafana-dashboard.md` | Grafana Dashboard Standard | Creating dashboards, Reviewing service health |
| `.devops/observability/logging.md` | Logging Standard | Reviewing logs, Designing service observability |
| `.devops/observability/metrics.md` | Metrics Standard | Adding service metrics, Creating alerts |
| `.devops/observability/slo-sli.md` | SLI/SLO Standard | Defining reliability target, Creating alert policy |
| `.devops/observability/tracing.md` | Distributed Tracing Standard | Adding tracing, Debugging distributed flow |
| `.devops/security/compliance.md` | Compliance Review Standard | Production readiness review, Security audit |
| `.devops/security/container-security.md` | Container Security Standard | Reviewing Dockerfile, Hardening Kubernetes container |
| `.devops/security/iam-rule.md` | IAM Security Rule | Reviewing IAM policy, Creating IRSA role |
| `.devops/security/kubernetes-security.md` | Kubernetes Security Standard | Reviewing manifests, Hardening workloads |
| `.devops/security/secret-management.md` | Secret Management Security Standard | Designing secret flow, Reviewing Helm values |
| `.devops/sre/capacity-planning.md` | Capacity Planning Standard | Forecasting growth, Reviewing resource usage |
| `.devops/sre/chaos-testing.md` | Chaos Testing Standard | Testing resilience, Validating failover |
| `.devops/sre/disaster-recovery.md` | Disaster Recovery Standard | Planning DR, Reviewing backup/restore |
| `.devops/sre/incident-response.md` | Incident Response Standard | Handling outage, Creating incident process |
| `.devops/sre/runbook.md` | Runbook Standard | Creating service runbook, Preparing on-call handover |
| `.devops/terraform/environment-structure.md` | Terraform Environment Structure Standard | Creating environment folders, Separating Terraform states |
| `.devops/terraform/module-standard.md` | Terraform Module Standard | Creating Terraform module, Reviewing module quality |
| `.devops/terraform/naming-convention.md` | Terraform Naming Convention Standard | Naming AWS resources, Reviewing Terraform consistency |
| `.devops/terraform/remote-state.md` | Terraform Remote State Standard | Setting up Terraform backend, Reviewing IaC security |
| `.devops/terraform/tagging-standard.md` | Terraform Tagging Standard | Adding Terraform tags, Reviewing cloud cost governance |

## Recommended Prompt Pattern

```text
Use these skills:
- .devops/DEVOPS.md
- .devops/SKILL_INDEX.md
- <specific skill files>

Task:
<what you want>

Context:
- Project:
- Environment:
- Runtime:
- AWS region:
- Dependencies:

Output:
- Full file paths
- Full file content
- Security notes
- Validation commands
- Rollback notes
- Production checklist
```

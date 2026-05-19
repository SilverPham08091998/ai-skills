# Example Prompt — Create EKS

Use these skills:
- `.devops/DEVOPS.md`
- `.devops/aws/vpc.md`
- `.devops/aws/eks.md`
- `.devops/aws/iam.md`
- `.devops/terraform/module-standard.md`
- `.devops/terraform/naming-convention.md`
- `.devops/terraform/tagging-standard.md`
- `.devops/terraform/remote-state.md`

Task:
Generate Terraform modules and dev environment usage for AWS EKS.

Context:
- Project: vpay
- Environment: dev
- Region: ap-southeast-1
- Node groups: system, app, observability
- Add-ons: vpc-cni, coredns, kube-proxy, ebs-csi
- Platform: ArgoCD, Istio, Kong, External Secrets installed later by Helm/GitOps

Output:
- Full folder tree
- Full Terraform files
- Validation commands
- Security notes
- Next steps

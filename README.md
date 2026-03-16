# Production-ready Kubernetes Platform (GitOps + Security + Autoscaling)

Portfolio project for junior+/middle- DevOps track.

## Goals
- Build a reproducible Kubernetes platform with GitOps delivery.
- Enforce baseline security controls and policy checks.
- Demonstrate horizontal and event-driven autoscaling patterns.
- Manage application runtime secrets via External Secrets and SOPS.

## Stack
- Kubernetes: `k3d`/`k3s` for local lab.
- GitOps: Argo CD (App of Apps pattern).
- Packaging: Helm.
- Security: Pod Security Standards, NetworkPolicies, Trivy, Conftest/OPA.
- Autoscaling: HPA + KEDA.
- TLS: ingress-nginx + cert-manager ClusterIssuer.
- Secrets: External Secrets Operator + SOPS (Age).
- CI: GitHub Actions.

## Repository Layout
```text
.
+-- apps/
¦   L-- sample-api/chart/                  # Helm chart with secure defaults
+-- clusters/
¦   L-- dev/                               # Environment state (GitOps source of truth)
+-- gitops/
¦   +-- apps/                              # Argo CD applications for bootstrap
¦   L-- projects/                          # Argo CD projects
+-- policies/
¦   L-- kubernetes/                        # OPA/Rego policies for CI
+-- scripts/                               # Bootstrap and validation scripts
+-- secrets/                               # SOPS-managed secret templates/workflow
L-- .github/workflows/ci.yaml              # CI checks
```

## Architecture
See [docs/architecture.md](docs/architecture.md).

## Quick Start (local)
1. Create local cluster:
   - `k3d cluster create devops-platform --agents 2`
2. Install Argo CD:
   - `kubectl create namespace argocd`
   - `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`
3. Bootstrap GitOps root apps (after pushing repo):
   - Update repo URL in:
     - `gitops/apps/platform-root.yaml`
     - `gitops/apps/workloads-root.yaml`
     - `clusters/dev/apps/sample-api.yaml`
   - Apply bootstrap manifests:
     - `kubectl apply -f gitops/projects/platform-project.yaml`
     - `kubectl apply -f gitops/projects/workloads-project.yaml`
     - `kubectl apply -f gitops/apps/platform-root.yaml`
     - `kubectl apply -f gitops/apps/workloads-root.yaml`
4. Provision sample runtime secret source via SOPS:
   - create encrypted secret file from template:
     - `./scripts/encrypt-secret.ps1 -AgeRecipient "<age-public-key>"`
   - decrypt+apply to cluster:
     - `./scripts/apply-secret.ps1`
5. Check sync status:
   - `kubectl get applications -n argocd`
6. Access sample API via ingress:
   - Host configured by default: `sample-api.localdev.me`
   - TLS issuer default: `selfsigned-cluster-issuer`

## What This Baseline Deploys
- `dev-apps` and `shared-secrets` namespaces.
- Default deny ingress/egress + DNS egress allow.
- ingress-nginx installation via Argo CD.
- cert-manager installation via Argo CD.
- KEDA installation via Argo CD.
- External Secrets Operator installation via Argo CD.
- ClusterIssuers:
  - `selfsigned-cluster-issuer` (works in local/dev),
  - `letsencrypt-staging` (for public DNS test).
- ClusterSecretStore backed by Kubernetes provider (`shared-secrets` namespace).
- `sample-api` Helm release with:
  - secure container settings,
  - HPA and KEDA autoscaling,
  - Ingress TLS,
  - ExternalSecret resource,
  - secret-based environment injection.

## CI Checks
- Helm lint and render.
- Kustomize build for `clusters/dev`.
- Conftest policy validation.
- Trivy IaC scan.

## What to Add Next
- External Secrets backend migration to Vault.
- Production ClusterIssuer + DNS-01 challenge.
- Runtime detection with Falco.
- SLO dashboards + synthetic checks.
- Terraform layer for cloud provisioning.

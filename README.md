# Production-ready Kubernetes Platform (GitOps + Security + Autoscaling)

Portfolio project for junior+/middle- DevOps track.

## Goals
- Build a reproducible Kubernetes platform with GitOps delivery.
- Enforce baseline security controls and policy checks.
- Demonstrate horizontal and event-driven autoscaling patterns.
- Keep deployment process auditable and CI-validated.

## Stack
- Kubernetes: `k3d`/`k3s` for local lab, cloud-managed cluster ready structure.
- GitOps: Argo CD (App of Apps pattern).
- Packaging: Helm.
- Security: Pod Security Standards, NetworkPolicies, Trivy, Conftest/OPA.
- Autoscaling: HPA + KEDA.
- TLS: ingress-nginx + cert-manager ClusterIssuer.
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
4. Check sync status:
   - `kubectl get applications -n argocd`
5. Access sample API via ingress:
   - Host configured by default: `sample-api.localdev.me`
   - TLS issuer default: `selfsigned-cluster-issuer`

## What This Baseline Deploys
- `dev-apps` namespace with Pod Security labels.
- Default deny ingress/egress + DNS egress allow.
- ingress-nginx installation via Argo CD.
- cert-manager installation via Argo CD.
- ClusterIssuers:
  - `selfsigned-cluster-issuer` (works in local/dev),
  - `letsencrypt-staging` (for public DNS test).
- `sample-api` Helm release with:
  - secure container settings,
  - HPA (CPU-based),
  - KEDA `ScaledObject` (cron trigger),
  - PDB, app-specific ingress allow policy, and Ingress TLS.

## CI Checks
- Helm lint and render
- Kustomize build for `clusters/dev`
- Conftest policy validation
- Trivy IaC scan

## What to Add Next
- External Secrets + Vault integration.
- Production ClusterIssuer + DNS-01 challenge.
- Runtime detection with Falco.
- SLO dashboards + synthetic checks.
- Terraform layer for cloud provisioning.

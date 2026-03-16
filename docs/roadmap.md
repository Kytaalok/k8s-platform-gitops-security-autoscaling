# Roadmap (2-3 weeks)

## Week 1
- Bootstrap `k3d` cluster + Argo CD App-of-Apps.
- Deploy sample workload via Helm.
- Configure HPA and basic observability checks.

## Week 2
- Add KEDA ScaledObject trigger.
- Add Kyverno policies and namespace hardening.
- Add CI checks (Conftest, Trivy, Helm, Kustomize).

## Week 3
- Add cert-manager + ingress TLS.
- Add External Secrets + Vault or SOPS.
- Add incident runbook and DR drill scenario.

## Done Criteria
- One command path from git commit to deployed workload.
- Security policy violations block PR.
- Autoscaling behavior reproducible and documented.

# Secrets Workflow

This project uses External Secrets Operator and keeps bootstrap source secrets encrypted with SOPS.

## Files
- `secrets/dev/sample-api-runtime.secret.yaml.example`: secret template.
- `secrets/dev/sample-api-runtime.secret.enc.yaml`: encrypted secret committed to git.

## Create encrypted secret
```powershell
./scripts/encrypt-secret.ps1 -AgeRecipient "<your-age-public-key>"
```

## Apply secret to cluster
```powershell
./scripts/apply-secret.ps1
```

This decrypts with `sops --decrypt` and applies to `shared-secrets` namespace.

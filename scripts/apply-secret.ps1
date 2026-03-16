param(
  [string]$EncryptedSecretPath = "secrets/dev/sample-api-runtime.secret.enc.yaml"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command sops -ErrorAction SilentlyContinue)) {
  Write-Error "sops is not installed. Install sops and rerun this script."
}

if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
  Write-Error "kubectl is not installed. Install kubectl and rerun this script."
}

$root = Split-Path -Parent $PSScriptRoot
$fullPath = Join-Path $root $EncryptedSecretPath

sops --decrypt $fullPath | kubectl apply -f -
Write-Host "Applied decrypted secret from: $fullPath"

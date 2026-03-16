param(
  [Parameter(Mandatory = $true)]
  [string]$AgeRecipient
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command sops -ErrorAction SilentlyContinue)) {
  Write-Error "sops is not installed. Install sops and rerun this script."
}

$root = Split-Path -Parent $PSScriptRoot
$src = Join-Path $root "secrets/dev/sample-api-runtime.secret.yaml.example"
$out = Join-Path $root "secrets/dev/sample-api-runtime.secret.enc.yaml"

Copy-Item $src $out -Force
$env:SOPS_AGE_RECIPIENTS = $AgeRecipient
sops --encrypt --in-place $out

Write-Host "Encrypted secret created: $out"
Write-Host "Commit this file to git. Do not commit decrypted secret files."

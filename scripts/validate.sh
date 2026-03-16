#!/usr/bin/env bash
set -euo pipefail

helm lint apps/sample-api/chart
helm template sample-api apps/sample-api/chart > /tmp/sample-api.yaml
kustomize build clusters/dev > /tmp/dev-cluster.yaml
conftest test /tmp/sample-api.yaml -p policies/kubernetes

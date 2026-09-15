#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/helm-test-gc.sh -n <namespace> -r <release> [--all]

Deletes stale Helm test pods for a release.
Defaults to deleting only succeeded pods.

Options:
  -n, --namespace   Kubernetes namespace
  -r, --release     Helm release name (app.kubernetes.io/instance)
      --all         Delete succeeded and failed test pods
  -h, --help        Show this help message
USAGE
}

namespace=""
release=""
delete_all="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--namespace)
      namespace="$2"
      shift 2
      ;;
    -r|--release)
      release="$2"
      shift 2
      ;;
    --all)
      delete_all="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$namespace" || -z "$release" ]]; then
  echo "Both --namespace and --release are required." >&2
  usage
  exit 2
fi

base_selector="app.kubernetes.io/instance=${release},tests.neurobagel.io/category"

if [[ "$delete_all" == "true" ]]; then
  kubectl delete pod -n "$namespace" -l "$base_selector" --field-selector=status.phase==Succeeded --ignore-not-found
  kubectl delete pod -n "$namespace" -l "$base_selector" --field-selector=status.phase==Failed --ignore-not-found
else
  kubectl delete pod -n "$namespace" -l "$base_selector" --field-selector=status.phase==Succeeded --ignore-not-found
fi

echo "GC completed for release=${release} namespace=${namespace} all=${delete_all}"

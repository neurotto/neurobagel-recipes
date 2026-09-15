#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/helm-test-matrix.sh [--gc] [--gc-all] [--logs] [--chart <path>] [--tests-dir <path>]

Runs install/upgrade + helm test across the standard scenario overlays.
Releases that were not present before the run are uninstalled after the scenario finishes.
Namespaces that were not present before the run are deleted after uninstall.

Options:
      --gc                 Run test GC after each scenario (default keeps failed pods)
      --gc-all             With --gc, delete succeeded and failed test pods
  --logs               Pass --logs to helm test (not compatible with hook-succeeded cleanup)
      --chart <path>       Chart path (default: charts/neurobagel)
      --tests-dir <path>   Overlay values directory (default: charts/neurobagel/tests/values)
  -h, --help               Show this help message
USAGE
}

do_gc="false"
gc_all="false"
show_logs="false"
chart_path="charts/neurobagel"
tests_dir="charts/neurobagel/tests/values"
mock_data_source="charts/neurobagel/tests/mock-data/mock_dataset.jsonld"
mock_input_dir=""

if [[ "$PWD" = /* ]]; then
  mock_input_dir="$PWD/.nb-test-mock-input"
else
  mock_input_dir="$(pwd)/.nb-test-mock-input"
fi

prepare_mock_input_data() {
  if [[ ! -f "$mock_data_source" ]]; then
    echo "Missing mock data source: $mock_data_source" >&2
    return 1
  fi

  mkdir -p "$mock_input_dir"
  cp "$mock_data_source" "$mock_input_dir/mock_dataset.jsonld"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --gc)
      do_gc="true"
      shift
      ;;
    --gc-all)
      do_gc="true"
      gc_all="true"
      shift
      ;;
    --chart)
      chart_path="$2"
      shift 2
      ;;
    --logs)
      show_logs="true"
      shift
      ;;
    --tests-dir)
      tests_dir="$2"
      shift 2
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

scenarios=(dev-node dev-full prod-native prod-ingress prod-ingress-cert-manager)
failed=0

for scenario in "${scenarios[@]}"; do
  release="nb-${scenario}"
  namespace="nb-${scenario}"
  values_file="${tests_dir}/${scenario}.yaml"
  release_preexisting="false"
  namespace_preexisting="false"

  echo "==== Scenario: ${scenario} ===="
  if [[ ! -f "$values_file" ]]; then
    echo "Missing values file: $values_file" >&2
    failed=1
    continue
  fi

  if ! prepare_mock_input_data; then
    failed=1
    continue
  fi

  if helm status "$release" -n "$namespace" >/dev/null 2>&1; then
    release_preexisting="true"
  fi

  if kubectl get namespace "$namespace" >/dev/null 2>&1; then
    namespace_preexisting="true"
  fi

  helm upgrade --install "$release" "$chart_path" -n "$namespace" --create-namespace -f "$values_file" \
    --set-string "initData.inputData.hostPath.path=${mock_input_dir}"

  helm_test_cmd=(helm test "$release" -n "$namespace")
  if [[ "$show_logs" == "true" ]]; then
    helm_test_cmd+=(--logs)
  fi

  if ! "${helm_test_cmd[@]}"; then
    echo "Scenario failed: ${scenario}" >&2
    failed=1
  fi

  if [[ "$do_gc" == "true" ]]; then
    if [[ "$gc_all" == "true" ]]; then
      scripts/helm-test-gc.sh -n "$namespace" -r "$release" --all || failed=1
    else
      scripts/helm-test-gc.sh -n "$namespace" -r "$release" || failed=1
    fi
  fi

  if [[ "$release_preexisting" == "false" ]]; then
    if helm status "$release" -n "$namespace" >/dev/null 2>&1; then
      helm uninstall "$release" -n "$namespace" || failed=1
    fi
    if [[ "$namespace_preexisting" == "false" ]]; then
      kubectl delete namespace "$namespace" --ignore-not-found >/dev/null || failed=1
    fi
  fi

done

if [[ "$failed" -ne 0 ]]; then
  echo "One or more scenarios failed." >&2
  exit 1
fi

echo "All scenarios passed."

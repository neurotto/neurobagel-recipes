#!/usr/bin/env bash
set -euo pipefail

chart_path="charts/neurobagel"

expect_fail() {
  local name="$1"
  local values_file="$2"
  local expected="$3"
  local out_file err_file
  out_file="${TMPDIR:-/tmp}/${name}.out"
  err_file="${TMPDIR:-/tmp}/${name}.err"

  if helm template "$name" "$chart_path" -f "$values_file" >"$out_file" 2>"$err_file"; then
    echo "expected render failure for ${name}" >&2
    cat "$out_file" >&2
    return 1
  fi

  grep -q "$expected" "$err_file"
}

expect_pass() {
  local name="$1"
  local values_file="$2"
  helm template "$name" "$chart_path" -f "$values_file" >/dev/null
}

expect_fail \
  prod-ingress-missing-secret \
  charts/neurobagel/tests/values/prod-ingress-missing-secret.yaml \
  "routing.ingress.tls.secretName is required when ingress TLS is enabled"

expect_fail \
  prod-ingress-missing-host \
  charts/neurobagel/tests/values/prod-ingress-missing-host.yaml \
  "routing.ingress host is required for each enabled production endpoint"

expect_fail \
  prod-ingress-clusterissuer-without-tls \
  charts/neurobagel/tests/values/prod-ingress-clusterissuer-without-tls.yaml \
  "routing.ingress.tls.clusterIssuer requires routing.ingress.tls.enabled=true"

expect_fail \
  prod-deprecated-proxy \
  charts/neurobagel/tests/values/prod-deprecated-proxy.yaml \
  "routing.proxy.enabled is deprecated for Kubernetes-native deployment. Use routing.ingress.enabled instead."

expect_fail \
  init-data-missing-input-path \
  charts/neurobagel/tests/values/init-data-missing-input-path.yaml \
  "initData requires initData.inputData.hostPath.enabled=true and a non-empty initData.inputData.hostPath.path"

expect_fail \
  node-missing-init-data \
  charts/neurobagel/tests/values/node-missing-init-data.yaml \
  "node API requires initData.enabled=true with hostPath input data configured"

expect_pass \
  prod-ingress-cert-manager \
  charts/neurobagel/tests/values/prod-ingress-cert-manager.yaml

expect_pass \
  prod-ingress-native-routing \
  charts/neurobagel/tests/values/prod-ingress-native-routing.yaml

echo "Render contracts passed."

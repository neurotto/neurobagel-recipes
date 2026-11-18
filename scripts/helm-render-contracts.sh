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
  "initData.inputData requires hostPath.enabled with a path or persistentVolumeClaim.existingClaim"

expect_fail \
  init-data-hostpath-missing-path \
  charts/neurobagel/tests/values/init-data-hostpath-missing-path.yaml \
  "initData.inputData.hostPath.path must be non-empty when hostPath is enabled"

expect_fail \
  init-data-conflicting-inputs \
  charts/neurobagel/tests/values/init-data-conflicting-inputs.yaml \
  "select either hostPath or persistentVolumeClaim.existingClaim, not both"

expect_fail \
  node-missing-metadata-source \
  charts/neurobagel/tests/values/node-missing-init-data.yaml \
  "node API requires storage.neurobagelData.type to be pvc or hostPath"

expect_pass \
  prod-ingress-cert-manager \
  charts/neurobagel/tests/values/prod-ingress-cert-manager.yaml

expect_pass \
  prod-ingress-native-routing \
  charts/neurobagel/tests/values/prod-ingress-native-routing.yaml

expect_pass \
  node-input-pvc \
  charts/neurobagel/tests/values/node-input-pvc.yaml

expect_pass \
  node-existing-metadata \
  charts/neurobagel/tests/values/node-existing-metadata.yaml

rendered=$(helm template node-input-pvc charts/neurobagel \
  -f charts/neurobagel/tests/values/node-input-pvc.yaml)
grep -q 'claimName: "shared-jsonld-input"' <<<"$rendered"

rendered=$(helm template node-existing-metadata charts/neurobagel \
  -f charts/neurobagel/tests/values/node-existing-metadata.yaml)
grep -q '/scripts/wait-for-metadata.sh' <<<"$rendered"
grep -q 'datasets_metadata.json' <<<"$rendered"

echo "Render contracts passed."

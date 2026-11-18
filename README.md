## Usage

[Helm](https://helm.sh) must be installed to use the charts. Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add neurobagel https://neurotto.github.io/neurobagel-recipes

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
neurobagel` to see the charts.

To install the neurobagel chart:

```bash
helm install my-neurobagel neurobagel/neurobagel
```

To uninstall the chart:

```bash
helm uninstall my-neurobagel
```

## Neurobagel Chart Test Workflow

The chart includes scenario overlays and Helm test hooks under `charts/neurobagel`.

Kubernetes-native production routing uses ingress mode (`routing.ingress.enabled=true`) with
`routing.hosts` + `routing.basePaths` and optional TLS configuration.

Proxy stack mode (`routing.proxy.enabled=true`) is deprecated and intentionally blocked.

For cert-manager managed TLS, set `routing.ingress.tls.clusterIssuer` to have the chart
emit the `cert-manager.io/cluster-issuer` ingress annotation automatically.

`init-data` runs as a Kubernetes Job with TTL-based cleanup enabled by default
(`initData.ttlSecondsAfterFinished`, default `60`). Completed job pods are
removed automatically by the TTL controller.

By default, the init-data Job uses a base Python image and executes
`python -m init_data.process_jsonld /input_data /data` using init_data source
files embedded in the chart package.

For node profile deployments that use the chart's init-data Job, set
`initData.enabled=true` and provide exactly one input source:
`initData.inputData.hostPath` or a caller-managed
`initData.inputData.persistentVolumeClaim.existingClaim`.

If another process provides `datasets_metadata.json`, leave init-data disabled,
place the file on the shared `storage.neurobagelData` PVC or hostPath, and set
`api.metadataIndex.waitForFile=true`. The API waits for a non-empty index for
`api.metadataIndex.timeoutSeconds` and fails with a diagnostic if it never
appears. The default development behavior remains unchanged unless init-data is
enabled or this wait is explicitly requested.

Portal-only deployments can keep init-data disabled.

To override the embedded processing implementation, set
`initData.source.overrideConfigMap` to a ConfigMap containing these keys:
`init_data___init__.py`, `init_data__process_jsonld.py`,
`init_data__requirements.txt`, `init_data__utils___init__.py`,
`init_data__utils__dataset_description_model.py`,
`init_data__utils__dictionary_models.py`, and `init_data__utils__models.py`.

### Run the full scenario matrix

```bash
./scripts/helm-test-matrix.sh
```

### Run matrix and clean successful test pods after each scenario

```bash
./scripts/helm-test-matrix.sh --gc
```

### Run matrix with Helm test logs (for debugging)

>[Note]
> This is not compatible with auto-deleting successful test hook pods

```bash
./scripts/helm-test-matrix.sh --logs
```

### Run matrix with aggressive cleanup (delete successful and failed test pods)

```bash
./scripts/helm-test-matrix.sh --gc-all
```

### Clean stale test pods for a single release/namespace

```bash
./scripts/helm-test-gc.sh -n <namespace> -r <release>
```

### Clean both successful and failed test pods for a release/namespace

```bash
./scripts/helm-test-gc.sh -n <namespace> -r <release> --all
```

# neurobagel

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

Kubernetes-native Helm chart for deploying Neurobagel node and portal profiles

**Homepage:** <https://github.com/neurobagel/recipes>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| neurobagel |  | <https://github.com/neurobagel> |

## Source Code

* <https://github.com/neurobagel/recipes>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules applied to chart workloads. |
| api | object | `{"enabled":true,"env":{"NB_API_ALLOWED_ORIGINS":"*","NB_API_PORT":"8000","NB_CATALOG_MODE":"false","NB_CONFIG":"Neurobagel","NB_GRAPH_DB":"repositories/my_db","NB_MIN_CELL_SIZE":"0","NB_NAPI_BASE_PATH":"","NB_RETURN_AGG":"true"},"image":{"pullPolicy":"IfNotPresent","repository":"neurobagel/api","tag":"latest"},"replicas":1,"resources":{},"service":{"nodePort":null,"port":8000,"type":"ClusterIP"}}` | Neurobagel API deployment configuration. |
| api.enabled | bool | `true` | Deploy the Neurobagel API. |
| api.env | object | `{"NB_API_ALLOWED_ORIGINS":"*","NB_API_PORT":"8000","NB_CATALOG_MODE":"false","NB_CONFIG":"Neurobagel","NB_GRAPH_DB":"repositories/my_db","NB_MIN_CELL_SIZE":"0","NB_NAPI_BASE_PATH":"","NB_RETURN_AGG":"true"}` | Environment variables for the API service. |
| api.env.NB_API_ALLOWED_ORIGINS | string | `"*"` | Allowed CORS origins for the API. |
| api.env.NB_API_PORT | string | `"8000"` | API container listen port. |
| api.env.NB_CATALOG_MODE | string | `"false"` | Run the API in catalog mode instead of single-node mode. |
| api.env.NB_CONFIG | string | `"Neurobagel"` | Named Neurobagel configuration profile used by the API. |
| api.env.NB_GRAPH_DB | string | `"repositories/my_db"` | Graph repository path used by the API. |
| api.env.NB_MIN_CELL_SIZE | string | `"0"` | Minimum cell size returned by the API. |
| api.env.NB_NAPI_BASE_PATH | string | `""` | Base path prefix served by the API. |
| api.env.NB_RETURN_AGG | string | `"true"` | Enable aggregate counts in API responses. |
| api.image | object | `{"pullPolicy":"IfNotPresent","repository":"neurobagel/api","tag":"latest"}` | API container image settings. |
| api.image.pullPolicy | string | `"IfNotPresent"` | API image pull policy. |
| api.image.repository | string | `"neurobagel/api"` | API image repository. |
| api.image.tag | string | `"latest"` | API image tag. |
| api.replicas | int | `1` | Number of API replicas. |
| api.resources | object | `{}` | Compute resource requests and limits for the API. |
| api.service | object | `{"nodePort":null,"port":8000,"type":"ClusterIP"}` | Service settings for the API. |
| api.service.nodePort | string | `nil` | Fixed NodePort to use when `api.service.type` is `NodePort`. |
| api.service.port | int | `8000` | API service port. |
| api.service.type | string | `"ClusterIP"` | API service type. |
| dev | object | `{"exposure":{"apiNodePort":null,"federationNodePort":null,"graphNodePort":null,"queryNodePort":null},"hostPath":{"enabled":true}}` | Development-mode overrides. |
| dev.exposure | object | `{"apiNodePort":null,"federationNodePort":null,"graphNodePort":null,"queryNodePort":null}` | Development service exposure settings. |
| dev.exposure.apiNodePort | string | `nil` | NodePort override for the API service in development mode. |
| dev.exposure.federationNodePort | string | `nil` | NodePort override for the federation API service in development mode. |
| dev.exposure.graphNodePort | string | `nil` | NodePort override for the GraphDB service in development mode. |
| dev.exposure.queryNodePort | string | `nil` | NodePort override for the query frontend service in development mode. |
| dev.hostPath | object | `{"enabled":true}` | HostPath-specific development settings. |
| dev.hostPath.enabled | bool | `true` | Use hostPath-backed storage defaults in development mode. |
| federation | object | `{"enabled":true,"env":{"NB_API_PORT":"8000","NB_FAPI_BASE_PATH":"","NB_FEDERATE_REMOTE_PUBLIC_NODES":"True"},"image":{"pullPolicy":"IfNotPresent","repository":"neurobagel/federation_api","tag":"latest"},"replicas":1,"resources":{},"service":{"nodePort":null,"port":8000,"type":"ClusterIP"}}` | Federation API deployment configuration. |
| federation.enabled | bool | `true` | Deploy the federation API. |
| federation.env | object | `{"NB_API_PORT":"8000","NB_FAPI_BASE_PATH":"","NB_FEDERATE_REMOTE_PUBLIC_NODES":"True"}` | Environment variables for the federation API. |
| federation.env.NB_API_PORT | string | `"8000"` | Federation API container listen port. |
| federation.env.NB_FAPI_BASE_PATH | string | `""` | Base path prefix served by the federation API. |
| federation.env.NB_FEDERATE_REMOTE_PUBLIC_NODES | string | `"True"` | Include public remote nodes when federating queries. |
| federation.image | object | `{"pullPolicy":"IfNotPresent","repository":"neurobagel/federation_api","tag":"latest"}` | Federation API container image settings. |
| federation.image.pullPolicy | string | `"IfNotPresent"` | Federation API image pull policy. |
| federation.image.repository | string | `"neurobagel/federation_api"` | Federation API image repository. |
| federation.image.tag | string | `"latest"` | Federation API image tag. |
| federation.replicas | int | `1` | Number of federation API replicas. |
| federation.resources | object | `{}` | Compute resource requests and limits for the federation API. |
| federation.service | object | `{"nodePort":null,"port":8000,"type":"ClusterIP"}` | Service settings for the federation API. |
| federation.service.nodePort | string | `nil` | Fixed NodePort to use when `federation.service.type` is `NodePort`. |
| federation.service.port | int | `8000` | Federation API service port. |
| federation.service.type | string | `"ClusterIP"` | Federation API service type. |
| fullnameOverride | string | `""` | Override the fully qualified release name used for generated resources. |
| global | object | `{"enableAuth":false,"queryClientId":""}` | Shared application settings consumed across components. |
| global.enableAuth | bool | `false` | Enable authentication-aware frontend behavior. |
| global.queryClientId | string | `""` | OAuth client ID exposed to the query application when auth is enabled. |
| graph | object | `{"enabled":true,"env":{"NB_GRAPH_DB":"repositories/my_db","NB_GRAPH_MEMORY":"2G","NB_GRAPH_PORT":"7200","NB_GRAPH_USERNAME":"dbuser"},"image":{"pullPolicy":"IfNotPresent","repository":"ontotext/graphdb","tag":"10.8.12"},"replicas":1,"resources":{},"service":{"nodePort":null,"port":7200,"type":"ClusterIP"}}` | GraphDB deployment configuration. |
| graph.enabled | bool | `true` | Deploy the GraphDB stateful workload. |
| graph.env | object | `{"NB_GRAPH_DB":"repositories/my_db","NB_GRAPH_MEMORY":"2G","NB_GRAPH_PORT":"7200","NB_GRAPH_USERNAME":"dbuser"}` | Environment variables for GraphDB. |
| graph.env.NB_GRAPH_DB | string | `"repositories/my_db"` | Graph repository path used by Neurobagel services. |
| graph.env.NB_GRAPH_MEMORY | string | `"2G"` | Java heap memory setting for GraphDB. |
| graph.env.NB_GRAPH_PORT | string | `"7200"` | GraphDB listen port. |
| graph.env.NB_GRAPH_USERNAME | string | `"dbuser"` | GraphDB admin username. |
| graph.image | object | `{"pullPolicy":"IfNotPresent","repository":"ontotext/graphdb","tag":"10.8.12"}` | GraphDB container image settings. |
| graph.image.pullPolicy | string | `"IfNotPresent"` | GraphDB image pull policy. |
| graph.image.repository | string | `"ontotext/graphdb"` | GraphDB image repository. |
| graph.image.tag | string | `"10.8.12"` | GraphDB image tag. |
| graph.replicas | int | `1` | Number of GraphDB replicas. |
| graph.resources | object | `{}` | Compute resource requests and limits for GraphDB. |
| graph.service | object | `{"nodePort":null,"port":7200,"type":"ClusterIP"}` | Service settings for GraphDB. |
| graph.service.nodePort | string | `nil` | Fixed NodePort to use when `graph.service.type` is `NodePort`. |
| graph.service.port | int | `7200` | GraphDB service port. |
| graph.service.type | string | `"ClusterIP"` | GraphDB service type. |
| imagePullSecrets | list | `[]` | Image pull secrets applied to chart workloads. |
| initData | object | `{"backoffLimit":3,"command":"sh -euxc \"pip install --no-cache-dir --upgrade -r /app/init_data/requirements.txt && rm -rf /data/* && PYTHONPATH=/app python -m init_data.process_jsonld /input_data /data\"\n","enabled":false,"env":{"NB_CATALOG_MODE":"false"},"image":{"pullPolicy":"IfNotPresent","repository":"python","tag":"3.11-slim"},"inputData":{"hostPath":{"enabled":false,"path":"","type":"Directory"}},"source":{"overrideConfigMap":""},"ttlSecondsAfterFinished":60}` | Init-data job configuration for preparing graph input data. |
| initData.backoffLimit | int | `3` | Maximum number of retries before the init-data job is marked failed. |
| initData.command | string | `"sh -euxc \"pip install --no-cache-dir --upgrade -r /app/init_data/requirements.txt && rm -rf /data/* && PYTHONPATH=/app python -m init_data.process_jsonld /input_data /data\"\n"` | Command executed by the init-data job. |
| initData.enabled | bool | `false` | Run the init-data job. |
| initData.env | object | `{"NB_CATALOG_MODE":"false"}` | Extra environment variables for the init-data job. |
| initData.env.NB_CATALOG_MODE | string | `"false"` | Run init-data in catalog mode instead of single-node mode. |
| initData.image | object | `{"pullPolicy":"IfNotPresent","repository":"python","tag":"3.11-slim"}` | Container image settings for the init-data job. |
| initData.image.pullPolicy | string | `"IfNotPresent"` | Init-data image pull policy. |
| initData.image.repository | string | `"python"` | Init-data image repository. |
| initData.image.tag | string | `"3.11-slim"` | Init-data image tag. |
| initData.inputData | object | `{"hostPath":{"enabled":false,"path":"","type":"Directory"}}` | Input dataset mount configuration for the init-data job. |
| initData.inputData.hostPath | object | `{"enabled":false,"path":"","type":"Directory"}` | HostPath mount settings for source datasets. |
| initData.inputData.hostPath.enabled | bool | `false` | Mount input data from a hostPath instead of supplying another volume source. |
| initData.inputData.hostPath.path | string | `""` | Absolute host path containing the input JSON-LD datasets. |
| initData.inputData.hostPath.type | string | `"Directory"` | HostPath volume type for the input dataset mount. |
| initData.source | object | `{"overrideConfigMap":""}` | Override the embedded init-data source files with a ConfigMap. |
| initData.source.overrideConfigMap | string | `""` | Name of a ConfigMap containing replacement init_data sources. |
| initData.ttlSecondsAfterFinished | int | `60` | Seconds to keep completed init-data jobs before Kubernetes garbage-collects them. |
| localNodes | list | `[{"ApiURL":"http://api:8000","NodeName":"Local graph 1"}]` | Local node definitions exposed to the portal and federation services. Each entry should include a display `NodeName` and an internal `ApiURL`. |
| mode | string | `"dev"` | Deployment mode profile to render (`dev` or `prod`). |
| nameOverride | string | `""` | Override the chart name used for generated resources. |
| nodeSelector | object | `{}` | Node selector labels for chart workloads. |
| podAnnotations | object | `{}` | Extra annotations to add to workload pods. |
| podLabels | object | `{}` | Extra labels to add to workload pods. |
| podSecurityContext | object | `{}` | Pod-level security context applied to workload pods. |
| prod | object | `{"internalOnly":true}` | Production-mode overrides. |
| prod.internalOnly | bool | `true` | Keep production services cluster-internal unless ingress is enabled. |
| profiles | object | `{"node":{"enabled":true},"portal":{"enabled":true}}` | Toggle the node and portal deployment profiles. |
| profiles.node | object | `{"enabled":true}` | Enable the Neurobagel node components. |
| profiles.node.enabled | bool | `true` | Deploy the node profile resources. |
| profiles.portal | object | `{"enabled":true}` | Enable the Neurobagel portal components. |
| profiles.portal.enabled | bool | `true` | Deploy the portal profile resources. |
| queryFederation | object | `{"enabled":true,"env":{"NB_API_QUERY_URL":"http://localhost:8080","NB_QUERY_APP_BASE_PATH":"/","NB_QUERY_HEADER_SCRIPT":""},"image":{"pullPolicy":"IfNotPresent","repository":"neurobagel/query_tool","tag":"latest"},"replicas":1,"resources":{},"service":{"nodePort":null,"port":5173,"type":"ClusterIP"}}` | Query frontend deployment configuration. |
| queryFederation.enabled | bool | `true` | Deploy the query frontend. |
| queryFederation.env | object | `{"NB_API_QUERY_URL":"http://localhost:8080","NB_QUERY_APP_BASE_PATH":"/","NB_QUERY_HEADER_SCRIPT":""}` | Environment variables for the query frontend. |
| queryFederation.env.NB_API_QUERY_URL | string | `"http://localhost:8080"` | Backend API URL consumed by the query frontend. |
| queryFederation.env.NB_QUERY_APP_BASE_PATH | string | `"/"` | Base path prefix served by the query frontend. |
| queryFederation.env.NB_QUERY_HEADER_SCRIPT | string | `""` | Optional inline script injected into the query frontend header. |
| queryFederation.image | object | `{"pullPolicy":"IfNotPresent","repository":"neurobagel/query_tool","tag":"latest"}` | Query frontend container image settings. |
| queryFederation.image.pullPolicy | string | `"IfNotPresent"` | Query frontend image pull policy. |
| queryFederation.image.repository | string | `"neurobagel/query_tool"` | Query frontend image repository. |
| queryFederation.image.tag | string | `"latest"` | Query frontend image tag. |
| queryFederation.replicas | int | `1` | Number of query frontend replicas. |
| queryFederation.resources | object | `{}` | Compute resource requests and limits for the query frontend. |
| queryFederation.service | object | `{"nodePort":null,"port":5173,"type":"ClusterIP"}` | Service settings for the query frontend. |
| queryFederation.service.nodePort | string | `nil` | Fixed NodePort to use when `queryFederation.service.type` is `NodePort`. |
| queryFederation.service.port | int | `5173` | Query frontend service port. |
| queryFederation.service.type | string | `"ClusterIP"` | Query frontend service type. |
| routing | object | `{"basePaths":{"fapi":"/","napi":"/","query":"/"},"hosts":{"fapi":"","napi":"","query":""},"ingress":{"annotations":{},"className":"","enabled":false,"tls":{"clusterIssuer":"","enabled":false,"secretName":""}},"proxy":{"acme":{"enabled":false},"enabled":false,"reverseProxyConf":"proxy_read_timeout 900;\nproxy_connect_timeout 900;\nproxy_send_timeout 900;\n"}}` | External routing settings for the API, federation API, and query frontend. |
| routing.basePaths | object | `{"fapi":"/","napi":"/","query":"/"}` | URL path prefixes assigned to ingress or proxy routes. |
| routing.basePaths.fapi | string | `"/"` | Base path for the federation API route. |
| routing.basePaths.napi | string | `"/"` | Base path for the Neurobagel API route. |
| routing.basePaths.query | string | `"/"` | Base path for the query frontend route. |
| routing.hosts | object | `{"fapi":"","napi":"","query":""}` | Hostnames assigned to ingress or proxy routes. |
| routing.hosts.fapi | string | `""` | Hostname for the federation API route. |
| routing.hosts.napi | string | `""` | Hostname for the Neurobagel API route. |
| routing.hosts.query | string | `""` | Hostname for the query frontend route. |
| routing.ingress | object | `{"annotations":{},"className":"","enabled":false,"tls":{"clusterIssuer":"","enabled":false,"secretName":""}}` | Native Kubernetes ingress settings. |
| routing.ingress.annotations | object | `{}` | Extra annotations to add to the Ingress. |
| routing.ingress.className | string | `""` | Ingress class name to target. |
| routing.ingress.enabled | bool | `false` | Expose services through a Kubernetes Ingress. |
| routing.ingress.tls | object | `{"clusterIssuer":"","enabled":false,"secretName":""}` | TLS settings for the Ingress. |
| routing.ingress.tls.clusterIssuer | string | `""` | cert-manager ClusterIssuer name to annotate on the Ingress. |
| routing.ingress.tls.enabled | bool | `false` | Enable TLS on the Ingress. |
| routing.ingress.tls.secretName | string | `""` | Existing Secret name containing the TLS certificate. |
| routing.proxy | object | `{"acme":{"enabled":false},"enabled":false,"reverseProxyConf":"proxy_read_timeout 900;\nproxy_connect_timeout 900;\nproxy_send_timeout 900;\n"}` | Deprecated proxy-stack routing settings. |
| routing.proxy.acme | object | `{"enabled":false}` | ACME automation settings for the deprecated proxy stack. |
| routing.proxy.acme.enabled | bool | `false` | Enable ACME certificate management for the deprecated proxy stack. |
| routing.proxy.enabled | bool | `false` | Enable the deprecated reverse-proxy stack. |
| routing.proxy.reverseProxyConf | string | `"proxy_read_timeout 900;\nproxy_connect_timeout 900;\nproxy_send_timeout 900;\n"` | Raw reverse proxy configuration injected into the proxy stack. |
| secrets | object | `{"create":true,"existingSecret":"","keys":{"admin":"admin-password","user":"user-password"},"name":""}` | Secret management for GraphDB credentials. |
| secrets.create | bool | `true` | Create a Secret for GraphDB credentials. |
| secrets.existingSecret | string | `""` | Reuse an existing Secret instead of creating one. |
| secrets.keys | object | `{"admin":"admin-password","user":"user-password"}` | Secret key names expected by the workloads. |
| secrets.keys.admin | string | `"admin-password"` | Secret key holding the admin password. |
| secrets.keys.user | string | `"user-password"` | Secret key holding the user password. |
| secrets.name | string | `""` | Override the generated Secret name. |
| securityContext | object | `{}` | Container-level security context applied to workload containers. |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | Service account configuration shared by chart workloads. |
| serviceAccount.annotations | object | `{}` | Extra annotations to add to the service account. |
| serviceAccount.automount | bool | `true` | Automatically mount the service account token into pods. |
| serviceAccount.create | bool | `true` | Create a dedicated service account for the release. |
| serviceAccount.name | string | `""` | Reuse an existing service account name instead of creating one. |
| storage | object | `{"graphdbHome":{"accessMode":"ReadWriteOnce","hostPath":{"path":"/tmp/neurobagel/graphdb-home","type":"DirectoryOrCreate"},"size":"20Gi","storageClassName":"","type":"pvc"},"neurobagelData":{"accessMode":"ReadWriteOnce","hostPath":{"path":"/tmp/neurobagel/neurobagel-data","type":"DirectoryOrCreate"},"size":"5Gi","storageClassName":"","type":"pvc"}}` | Persistent storage settings used by GraphDB and generated Neurobagel data. |
| storage.graphdbHome | object | `{"accessMode":"ReadWriteOnce","hostPath":{"path":"/tmp/neurobagel/graphdb-home","type":"DirectoryOrCreate"},"size":"20Gi","storageClassName":"","type":"pvc"}` | Storage settings for the GraphDB home volume. |
| storage.graphdbHome.accessMode | string | `"ReadWriteOnce"` | PersistentVolume access mode for GraphDB home. |
| storage.graphdbHome.hostPath | object | `{"path":"/tmp/neurobagel/graphdb-home","type":"DirectoryOrCreate"}` | HostPath settings used when `storage.graphdbHome.type` is `hostPath`. |
| storage.graphdbHome.hostPath.path | string | `"/tmp/neurobagel/graphdb-home"` | Host path for GraphDB home data. |
| storage.graphdbHome.hostPath.type | string | `"DirectoryOrCreate"` | HostPath volume type for GraphDB home. |
| storage.graphdbHome.size | string | `"20Gi"` | Requested GraphDB home volume size. |
| storage.graphdbHome.storageClassName | string | `""` | StorageClass name for the GraphDB home PVC. Leave empty for the cluster default. |
| storage.graphdbHome.type | string | `"pvc"` | Volume backend type for GraphDB home (`pvc` or `hostPath`). |
| storage.neurobagelData | object | `{"accessMode":"ReadWriteOnce","hostPath":{"path":"/tmp/neurobagel/neurobagel-data","type":"DirectoryOrCreate"},"size":"5Gi","storageClassName":"","type":"pvc"}` | Storage settings for generated Neurobagel data. |
| storage.neurobagelData.accessMode | string | `"ReadWriteOnce"` | PersistentVolume access mode for Neurobagel data. |
| storage.neurobagelData.hostPath | object | `{"path":"/tmp/neurobagel/neurobagel-data","type":"DirectoryOrCreate"}` | HostPath settings used when `storage.neurobagelData.type` is `hostPath`. |
| storage.neurobagelData.hostPath.path | string | `"/tmp/neurobagel/neurobagel-data"` | Host path for generated Neurobagel data. |
| storage.neurobagelData.hostPath.type | string | `"DirectoryOrCreate"` | HostPath volume type for generated Neurobagel data. |
| storage.neurobagelData.size | string | `"5Gi"` | Requested Neurobagel data volume size. |
| storage.neurobagelData.storageClassName | string | `""` | StorageClass name for the Neurobagel data PVC. Leave empty for the cluster default. |
| storage.neurobagelData.type | string | `"pvc"` | Volume backend type for Neurobagel data (`pvc` or `hostPath`). |
| tests | object | `{"enabled":true,"hookDeletePolicy":"before-hook-creation,hook-succeeded","kubectlImage":"bitnami/kubectl:latest"}` | Helm test hook settings. |
| tests.enabled | bool | `true` | Enable Helm test resources bundled with the chart. |
| tests.hookDeletePolicy | string | `"before-hook-creation,hook-succeeded"` | Hook delete policy applied to Helm test jobs. |
| tests.kubectlImage | string | `"bitnami/kubectl:latest"` | Kubectl image used by Helm test jobs. |
| tolerations | list | `[]` | Tolerations applied to chart workloads. |

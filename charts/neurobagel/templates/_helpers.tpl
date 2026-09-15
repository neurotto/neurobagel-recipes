{{/*
Expand the name of the chart.
*/}}
{{- define "neurobagel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "neurobagel.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "neurobagel.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "neurobagel.labels" -}}
helm.sh/chart: {{ include "neurobagel.chart" . }}
{{ include "neurobagel.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "neurobagel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "neurobagel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "neurobagel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "neurobagel.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return a component specific fullname.
*/}}
{{- define "neurobagel.componentFullname" -}}
{{- $root := index . 0 -}}
{{- $component := index . 1 -}}
{{- printf "%s-%s" (include "neurobagel.fullname" $root) $component | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Common labels with component marker.
*/}}
{{- define "neurobagel.componentLabels" -}}
{{- $root := index . 0 -}}
{{- $component := index . 1 -}}
{{ include "neurobagel.labels" $root }}
app.kubernetes.io/component: {{ $component }}
{{- end }}

{{/*
Selector labels with component marker.
*/}}
{{- define "neurobagel.componentSelectorLabels" -}}
{{- $root := index . 0 -}}
{{- $component := index . 1 -}}
{{ include "neurobagel.selectorLabels" $root }}
app.kubernetes.io/component: {{ $component }}
{{- end }}

{{/*
Whether node profile services should be rendered.
*/}}
{{- define "neurobagel.nodeEnabled" -}}
{{- if and .Values.profiles.node.enabled (or (ne .Values.mode "prod") .Values.prod.internalOnly) -}}true
{{- else }}false
{{- end }}
{{- end }}

{{/*
Whether portal profile services should be rendered.
*/}}
{{- define "neurobagel.portalEnabled" -}}
{{- if .Values.profiles.portal.enabled -}}true
{{- else }}false
{{- end }}
{{- end }}

{{/*
Secret name resolution with existing secret preference.
*/}}
{{- define "neurobagel.secretName" -}}
{{- if .Values.secrets.existingSecret -}}
{{- .Values.secrets.existingSecret -}}
{{- else if .Values.secrets.name -}}
{{- .Values.secrets.name -}}
{{- else -}}
{{- printf "%s-db-secrets" (include "neurobagel.fullname" .) -}}
{{- end -}}
{{- end }}

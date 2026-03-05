{{/*
Expand the name of the chart.
*/}}
{{- define "affine.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "affine.fullname" -}}
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
{{- define "affine.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "affine.labels" -}}
helm.sh/chart: {{ include "affine.chart" . }}
{{ include "affine.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "affine.selectorLabels" -}}
app.kubernetes.io/name: {{ include "affine.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Front labels
*/}}
{{- define "front.labels" -}}
{{ include "affine.labels" . }}
app.kubernetes.io/component: front
{{- end }}

{{/*
Front selector labels
*/}}
{{- define "front.selectorLabels" -}}
{{ include "affine.selectorLabels" . }}
app.kubernetes.io/component: front
{{- end }}

{{/*
GraphQL labels
*/}}
{{- define "graphql.labels" -}}
{{ include "affine.labels" . }}
app.kubernetes.io/component: graphql
{{- end }}

{{/*
GraphQL selector labels
*/}}
{{- define "graphql.selectorLabels" -}}
{{ include "affine.selectorLabels" . }}
app.kubernetes.io/component: graphql
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "front.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "affine.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "graphql.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "affine.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the Database Secret Name
*/}}
{{- define "affine.database.secretName" -}}
{{- if .Values.db.database.existingSecret }}
    {{- .Values.db.database.existingSecret }}
{{- else }}
    {{- printf "%s-%s" (include "affine.fullname" .) "database" }}
{{- end }}
{{- end -}}

{{/*
Return the Database Secret Key (Password)
*/}}
{{- define "affine.database.secretKey" -}}
{{- .Values.db.database.existingSecretPasswordKey }}
{{- end -}}

{{/*
Return the Redis Host
*/}}
{{- define "affine.redis.host" -}}
{{- .Values.db.redis.host }}
{{- end -}}

{{/*
Return the Redis Port
*/}}
{{- define "affine.redis.port" -}}
{{- .Values.db.redis.port }}
{{- end -}}

{{/*
Return the Redis Secret Name
*/}}
{{- define "affine.redis.secretName" -}}
{{- if .Values.db.redis.existingSecret }}
    {{- .Values.db.redis.existingSecret }}
{{- else }}
    {{- printf "%s-%s" (include "affine.fullname" .) "redis" }}
{{- end }}
{{- end -}}

{{/*
Return the Redis Secret Key (Password)
*/}}
{{- define "affine.redis.secretKey" -}}
{{- .Values.db.redis.existingSecretPasswordKey }}
{{- end -}}

{{/*
Return the Indexer Secret Name
*/}}
{{- define "affine.indexer.secretName" -}}
{{- if .Values.db.indexer.existingSecret }}
    {{- .Values.db.indexer.existingSecret }}
{{- else -}}
    {{- printf "%s-%s" (include "affine.fullname" .) "indexer" }}
{{- end -}}
{{- end -}}

{{/*
Return the Indexer Secret Key (API Key)
*/}}
{{- define "affine.indexer.secretKey" -}}
{{- .Values.db.indexer.existingSecretApiKey }}
{{- end -}}

{{/*
Create a default fully qualified app name for front.
*/}}
{{- define "front.fullname" -}}
{{- if .Values.front.fullnameOverride }}
{{- .Values.front.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-%s" .Release.Name "front" | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" .Release.Name $name "front" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name for graphql.
*/}}
{{- define "graphql.fullname" -}}
{{- if .Values.graphql.fullnameOverride }}
{{- .Values.graphql.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-%s" .Release.Name "graphql" | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" .Release.Name $name "graphql" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Return the Encryption Secret Name
*/}}
{{- define "affine.encryption.secretName" -}}
{{- if .Values.encryption.existingSecret }}
    {{- .Values.encryption.existingSecret }}
{{- else -}}
    {{- printf "%s-%s" (include "affine.fullname" .) "private-key" }}
{{- end -}}
{{- end -}}

{{/*
Return the Encryption Secret Key
*/}}
{{- define "affine.encryption.secretKey" -}}
{{- .Values.encryption.existingSecretKey }}
{{- end -}}

{{/*
Doc labels
*/}}
{{- define "doc.labels" -}}
{{ include "affine.labels" . }}
app.kubernetes.io/component: doc
{{- end }}

{{/*
Doc selector labels
*/}}
{{- define "doc.selectorLabels" -}}
{{ include "affine.selectorLabels" . }}
app.kubernetes.io/component: doc
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "doc.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "affine.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name for doc.
*/}}
{{- define "doc.fullname" -}}
{{- if .Values.doc.fullnameOverride }}
{{- .Values.doc.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-%s" .Release.Name "doc" | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" .Release.Name $name "doc" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
返回完整的镜像地址
*/}}
{{- define "affine.image" -}}
{{- $registry := .Values.global.registry -}}
{{- $repository := .Values.global.repository -}}
{{- $tag := .Values.global.tag | default .Chart.AppVersion -}}
{{- if .Values.global.digest -}}
{{- printf "%s/%s@%s" $registry $repository .Values.global.digest -}}
{{- else -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the unified NODE_OPTIONS
*/}}
{{- define "affine.nodeOptions" -}}
{{- $opts := .default -}}
{{- if .context.Values.global.envVars -}}
  {{- range .context.Values.global.envVars -}}
    {{- if eq .name "NODE_OPTIONS" -}}
      {{- if $opts -}}
        {{- $opts = printf "%s %s" $opts .value -}}
      {{- else -}}
        {{- $opts = .value -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if .componentEnv -}}
  {{- range .componentEnv -}}
    {{- if eq .name "NODE_OPTIONS" -}}
      {{- if $opts -}}
        {{- $opts = printf "%s %s" $opts .value -}}
      {{- else -}}
        {{- $opts = .value -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if $opts -}}
- name: NODE_OPTIONS
  value: {{ $opts | trim | quote }}
{{- end -}}
{{- end -}}

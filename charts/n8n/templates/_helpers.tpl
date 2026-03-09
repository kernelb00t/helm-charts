{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "n8n.names.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "n8n.names.fullname" -}}
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
{{- define "n8n.names.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Standard labels
*/}}
{{- define "n8n.labels.standard" -}}
helm.sh/chart: {{ include "n8n.names.chart" . }}
{{ include "n8n.labels.matchLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels }}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end -}}

{{/*
Match labels
*/}}
{{- define "n8n.labels.matchLabels" -}}
app.kubernetes.io/name: {{ include "n8n.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Component labels
Usage: {{ include "n8n.labels.component" (dict "context" . "component" "main") }}
*/}}
{{- define "n8n.labels.component" -}}
{{ include "n8n.labels.standard" .context }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{/*
Component match labels
Usage: {{ include "n8n.labels.matchLabelsComponent" (dict "context" . "component" "main") }}
*/}}
{{- define "n8n.labels.matchLabelsComponent" -}}
{{ include "n8n.labels.matchLabels" .context }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{/*
Return the proper image name
Usage: {{ include "n8n.images.image" (dict "imageRoot" .Values.path.to.the.image "global" .Values.global "chart" .Chart) }}
*/}}
{{- define "n8n.images.image" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $tag := .imageRoot.tag | default .chart.AppVersion | toString -}}
{{- if .global }}
    {{- if and .global.image .global.image.registry (not $registryName) }}
     {{- $registryName = .global.image.registry -}}
    {{- end -}}
{{- end -}}
{{- if $registryName }}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- else -}}
{{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image pull secrets
Usage: {{ include "n8n.images.pullSecrets" ( dict "images" (list .Values.path.to.the.image1, .Values.path.to.the.image2) "global" .Values.global) }}
*/}}
{{- define "n8n.images.pullSecrets" -}}
{{- $pullSecrets := list -}}
{{- if .global }}
  {{- if and .global.image .global.image.pullSecrets }}
    {{- range .global.image.pullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- range .images -}}
  {{- if and . (hasKey . "pullSecrets") }}
    {{- range .pullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if (not (empty $pullSecrets)) -}}
imagePullSecrets:
{{- range $pullSecrets }}
  - name: {{ .name }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Service Account Name
*/}}
{{- define "n8n.serviceAccountName" -}}
{{- if .Values.global.serviceAccount.create -}}
    {{ default (include "n8n.names.fullname" .) .Values.global.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.global.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create redis name secret name.
*/}}
{{- define "n8n.redis.fullname" -}}
{{- printf "%s-redis" (include "n8n.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create postgresql name secret name.
*/}}
{{- define "n8n.postgresql.fullname" -}}
{{- printf "%s-postgresql" (include "n8n.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create PostgreSQL database username
*/}}
{{- define "n8n.postgresql.username" -}}
{{- printf "%s" .Values.db.postgresdb.username | default "postgres" }}
{{- end }}

{{/*
Generate random hex similar to `openssl rand -hex 16` command.
Usage: {{ include "n8n.generateRandomHex" 32 }}
*/}}
{{- define "n8n.generateRandomHex" -}}
{{- $length := . -}}
{{- $chars := list "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" -}}
{{- $result := "" -}}
{{- range $i := until $length -}}
  {{- $result = print $result (index $chars (randInt 0 16)) -}}
{{- end -}}
{{- $result -}}
{{- end -}}

{{/*
Extract package names from a list of strings
*/}}
{{- define "n8n.packageNames" -}}
{{- $packageNames := list -}}
{{- range . -}}
  {{- $matches := regexFindAll "^@?[^@]+" . 1 -}}
  {{- if and $matches (not (hasPrefix "n8n-nodes-" (index $matches 0))) -}}
    {{- $packageNames = append $packageNames (index $matches 0) -}}
  {{- end -}}
{{- end -}}
{{- join "," $packageNames -}}
{{- end -}}

{{/*
Filter community packages (starting with n8n-nodes-)
*/}}
{{- define "n8n.communityPackages" -}}
{{- $community := list -}}
{{- range .Values.nodes.external.packages -}}
{{- if hasPrefix "n8n-nodes-" . -}}
{{- $community = append $community . -}}
{{- end -}}
{{- end -}}
{{- join " " $community -}}
{{- end -}}

{{/*
Filter non-community packages (as a space-separated string)
*/}}
{{- define "n8n.nonCommunityPackages" -}}
{{- $nonCommunity := list -}}
{{- range .Values.nodes.external.packages -}}
{{- if not (hasPrefix "n8n-nodes-" .) -}}
{{- $nonCommunity = append $nonCommunity . -}}
{{- end -}}
{{- end -}}
{{- join " " $nonCommunity -}}
{{- end -}}

{{/*
Convert n8n log level to npm log level
*/}}
{{- define "n8n.npmLogLevel" -}}
{{- $level := . | lower -}}
{{- if eq $level "debug" }}verbose
{{- else }}{{ $level }}
{{- end -}}
{{- end -}}

{{/*
n8n npm install script logic
*/}}
{{- define "n8n.npmInstallScript" -}}
export PACKAGES="{{ join " " .Values.nodes.external.packages }}"
export COMMUNITY_PACKAGES="{{ include "n8n.communityPackages" . }}"
export NON_COMMUNITY_PACKAGES="{{ include "n8n.nonCommunityPackages" . }}"
echo "$PACKAGES" | sha256sum > /npmdata/packages.hash.new
if [ ! -f /npmdata/packages.hash ] || ! cmp /npmdata/packages.hash /npmdata/packages.hash.new; then
  if [ -n "$NON_COMMUNITY_PACKAGES" ]; then
    npm install --loglevel {{ include "n8n.npmLogLevel" .Values.global.log.level }} --no-save $NON_COMMUNITY_PACKAGES --prefix /npmdata
  fi
  if [ -n "$COMMUNITY_PACKAGES" ]; then
    npm install --loglevel {{ include "n8n.npmLogLevel" .Values.global.log.level }} --no-save $COMMUNITY_PACKAGES --prefix /nodesdata/nodes
  fi
  mv /npmdata/packages.hash.new /npmdata/packages.hash
else
  rm /npmdata/packages.hash.new
fi
{{- end -}}

{{/*
Check Certificate Authority file defined for the Postgresql SSL connection
*/}}
{{- define "n8n.postgres.ssl.hasCA" -}}
{{- $result := false -}}
{{- if and (eq .Values.db.type "postgresdb") .Values.db.postgresdb.ssl.enabled (or .Values.db.postgresdb.ssl.base64EncodedCertificateAuthorityFile .Values.db.postgresdb.ssl.existingCertificateAuthorityFileSecret.name) -}}
  {{- $result = true -}}
{{- end -}}
{{- $result -}}
{{- end -}}

{{/*
Check Certificate file defined for the Postgresql SSL connection
*/}}
{{- define "n8n.postgres.ssl.hasCert" -}}
{{- $result := false -}}
{{- if and (eq .Values.db.type "postgresdb") .Values.db.postgresdb.ssl.enabled (or .Values.db.postgresdb.ssl.base64EncodedCertFile .Values.db.postgresdb.ssl.existingCertFileSecret.name) -}}
  {{- $result = true -}}
{{- end -}}
{{- $result -}}
{{- end -}}

{{/*
Check Private Key file defined for the Postgresql SSL connection
*/}}
{{- define "n8n.postgres.ssl.hasKey" -}}
{{- $result := false -}}
{{- if and (eq .Values.db.type "postgresdb") .Values.db.postgresdb.ssl.enabled (or .Values.db.postgresdb.ssl.base64EncodedPrivateKeyFile .Values.db.postgresdb.ssl.existingPrivateKeyFileSecret.name) -}}
  {{- $result = true -}}
{{- end -}}
{{- $result -}}
{{- end -}}

{{/*
Check postgres ssl certificate file content exist or not
*/}}
{{- define "n8n.postgres.ssl.hasFileInternal" -}}
{{- $internalResult := false -}}
{{- if or (eq (include "n8n.postgres.ssl.hasCA" .) "true") (eq (include "n8n.postgres.ssl.hasCert" .) "true") (eq (include "n8n.postgres.ssl.hasKey" .) "true") -}}
  {{- $internalResult = true -}}
{{- end -}}
{{- $internalResult -}}
{{- end -}}

{{/*
Check if volumes should be included to main. If the context is not provided, result must be false
*/}}
{{- define "n8n.main.hasVolumes" -}}
{{- $hasVolumes := false -}}
{{- if or .Values.volumes .Values.main.volumes .Values.nodes.external.packages .Values.npmRegistry.enabled (eq (include "n8n.postgres.ssl.hasFileInternal" .) "true") -}}
  {{- $hasVolumes = true -}}
{{- end -}}
{{- $hasVolumes -}}
{{- end -}}

{{/*
Check if volumeMounts should be included to main. If the context is not provided, result must be false
*/}}
{{- define "n8n.main.hasVolumeMounts" -}}
{{- $hasVolumeMounts := false -}}
{{- if or .Values.volumeMounts .Values.main.volumeMounts .Values.nodes.external.packages .Values.npmRegistry.enabled (eq (include "n8n.postgres.ssl.hasFileInternal" .) "true") -}}
  {{- $hasVolumeMounts = true -}}
{{- end -}}
{{- $hasVolumeMounts -}}
{{- end -}}

{{/*
Check if volumes should be included to worker. If the context is not provided, result must be false
*/}}
{{- define "n8n.worker.hasVolumes" -}}
{{- $hasVolumes := false -}}
{{- if or .Values.volumes .Values.worker.volumes .Values.nodes.external.packages .Values.npmRegistry.enabled (eq (include "n8n.postgres.ssl.hasFileInternal" .) "true") -}}
  {{- $hasVolumes = true -}}
{{- end -}}
{{- $hasVolumes -}}
{{- end -}}

{{/*
Check if volumeMounts should be included to worker. If the context is not provided, result must be false
*/}}
{{- define "n8n.worker.hasVolumeMounts" -}}
{{- $hasVolumeMounts := false -}}
{{- if or .Values.volumeMounts .Values.worker.volumeMounts .Values.nodes.external.packages .Values.npmRegistry.enabled (eq (include "n8n.postgres.ssl.hasFileInternal" .) "true") -}}
  {{- $hasVolumeMounts = true -}}
{{- end -}}
{{- $hasVolumeMounts -}}
{{- end -}}

{{/*
Check if volumes should be included to webhook. If the context is not provided, result must be false
*/}}
{{- define "n8n.webhook.hasVolumes" -}}
{{- $hasVolumes := false -}}
{{- if or .Values.volumes .Values.webhook.volumes (eq (include "n8n.postgres.ssl.hasFileInternal" .) "true") -}}
  {{- $hasVolumes = true -}}
{{- end -}}
{{- $hasVolumes -}}
{{- end -}}

{{/*
Check if volumeMounts should be included to webhook. If the context is not provided, result must be false
*/}}
{{- define "n8n.webhook.hasVolumeMounts" -}}
{{- $hasVolumeMounts := false -}}
{{- if or .Values.volumeMounts .Values.webhook.volumeMounts (eq (include "n8n.postgres.ssl.hasFileInternal" .) "true") -}}
  {{- $hasVolumeMounts = true -}}
{{- end -}}
{{- $hasVolumeMounts -}}
{{- end -}}

{{/*
Check if volumes should be included to MCP webhook. If the context is not provided, result must be false
*/}}
{{- define "n8n.mcp-webhook.hasVolumes" -}}
{{- $hasVolumes := false -}}
{{- if or .Values.volumes .Values.webhook.mcp.volumes (eq (include "n8n.postgres.ssl.hasFileInternal" .) "true") -}}
  {{- $hasVolumes = true -}}
{{- end -}}
{{- $hasVolumes -}}
{{- end -}}

{{/*
Check if volumeMounts should be included to MCP webhook. If the context is not provided, result must be false
*/}}
{{- define "n8n.mcp-webhook.hasVolumeMounts" -}}
{{- $hasVolumeMounts := false -}}
{{- if or .Values.volumeMounts .Values.webhook.mcp.volumeMounts (eq (include "n8n.postgres.ssl.hasFileInternal" .) "true") -}}
  {{- $hasVolumeMounts = true -}}
{{- end -}}
{{- $hasVolumeMounts -}}
{{- end -}}

{{/*
Standard environment variables
*/}}
{{- define "n8n.env" -}}
- name: N8N_HIRING_BANNER_ENABLED
  value: "false"
- name: NODE_ENV
  value: production
- name: N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS
  value: "true"
- name: N8N_PORT
  value: {{ .Values.global.service.port | quote }}
- name: N8N_DEFAULT_LOCALE
  value: {{ .Values.defaultLocale | quote }}
- name: GENERIC_TIMEZONE
  value: {{ .Values.timezone | quote }}
- name: N8N_GRACEFUL_SHUTDOWN_TIMEOUT
  value: {{ .Values.gracefulShutdownTimeout | quote }}
{{- if .Values.main.editorBaseUrl }}
- name: N8N_EDITOR_BASE_URL
  value: {{ .Values.main.editorBaseUrl | quote }}
{{- else if and .Values.main.ingress.enabled (gt (len .Values.main.ingress.hosts) 0) }}
  {{- $schema := ternary "http" "https" (empty .Values.main.ingress.tls) }}
  {{- with (first .Values.main.ingress.hosts) }}
- name: N8N_EDITOR_BASE_URL
  value: {{ printf "%s://%s" $schema .host | quote }}
  {{- end }}
{{- else if and .Values.main.httpRoute.enabled (gt (len .Values.main.httpRoute.hostnames) 0) }}
  {{- with (first .Values.main.httpRoute.hostnames) }}
- name: N8N_EDITOR_BASE_URL
  value: {{ printf "https://%s" . | quote }}
  {{- end }}
{{- end }}
{{- if eq .Values.db.type "postgresdb" }}
- name: DB_POSTGRESDB_USER
  value: {{ include "n8n.postgresql.username" . }}
- name: DB_POSTGRESDB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ default (include "n8n.postgresql.fullname" .) .Values.db.postgresdb.existingSecret }}
      key: postgres-password
      optional: true
{{- if or (eq .Values.worker.mode "queue") (eq .Values.webhook.mode "queue") }}
- name: QUEUE_BULL_REDIS_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ default (include "n8n.redis.fullname" .) .Values.db.redis.existingSecret }}
      key: redis-username
      optional: true
- name: QUEUE_BULL_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ default (include "n8n.redis.fullname" .) .Values.db.redis.existingSecret }}
      key: redis-password
      optional: true
{{- end }}
{{- end }}
{{- if .Values.webhook.url }}
- name: WEBHOOK_URL
  value: {{ .Values.webhook.url | quote }}
{{- end }}

{{- if gt (int .Values.main.count) 1 }}
- name: N8N_MULTI_MAIN_SETUP_ENABLED
  value: "true"
{{- end }}
{{- if has "s3" .Values.binaryData.availableModes }}
- name: N8N_EXTERNAL_STORAGE_S3_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ default (printf "%s-s3-secret" (include "n8n.names.fullname" .)) .Values.binaryData.s3.existingSecret }}
      key: access-key-id
- name: N8N_EXTERNAL_STORAGE_S3_ACCESS_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ default (printf "%s-s3-secret" (include "n8n.names.fullname" .)) .Values.binaryData.s3.existingSecret }}
      key: secret-access-key
{{- end }}
{{- if eq .Values.taskRunners.mode "internal" }}
{{- include "n8n.runners.env" . | nindent 0 }}
{{- end }}
{{- end -}}

{{/*
Runners environment variables (for internal and external task runners)
*/}}
{{- define "n8n.runners.env" -}}
{{- if .Values.nodes.builtin.enabled }}
- name: NODE_FUNCTION_ALLOW_BUILTIN
  value: {{ if .Values.nodes.builtin.modules }}{{ join "," .Values.nodes.builtin.modules }}{{ else }}"*"{{ end }}
{{- end }}
{{- if .Values.nodes.builtin.pythonStdlibAllow }}
- name: N8N_RUNNERS_STDLIB_ALLOW
  value: {{ .Values.nodes.builtin.pythonStdlibAllow | quote }}
{{- end }}
{{- if .Values.nodes.builtin.pythonBuiltinsDeny }}
- name: N8N_RUNNERS_BUILTINS_DENY
  value: {{ .Values.nodes.builtin.pythonBuiltinsDeny | quote }}
{{- end }}
{{- if .Values.nodes.external.allowAll }}
- name: NODE_FUNCTION_ALLOW_EXTERNAL
  value: "*"
{{- else if .Values.nodes.external.packages }}
- name: NODE_FUNCTION_ALLOW_EXTERNAL
  value: {{ include "n8n.packageNames" .Values.nodes.external.packages | quote }}
{{- end }}
{{- if .Values.nodes.external.reinstallMissingPackages }}
- name: N8N_REINSTALL_MISSING_PACKAGES
  value: "true"
{{- end }}
{{- if .Values.nodes.external.pythonExternalAllow }}
- name: N8N_RUNNERS_EXTERNAL_ALLOW
  value: {{ .Values.nodes.external.pythonExternalAllow | quote }}
{{- end }}
{{- if hasKey .Values.taskRunners "maxPayload" }}
- name: N8N_RUNNERS_MAX_PAYLOAD
  value: {{ .Values.taskRunners.maxPayload | quote }}
{{- end }}
{{- if hasKey .Values.taskRunners "blockEnvAccess" }}
- name: N8N_BLOCK_RUNNER_ENV_ACCESS
  value: {{ .Values.taskRunners.blockEnvAccess | quote }}
{{- end }}
{{- if hasKey .Values.taskRunners "allowPrototypeMutation" }}
- name: N8N_RUNNERS_ALLOW_PROTOTYPE_MUTATION
  value: {{ .Values.taskRunners.allowPrototypeMutation | quote }}
{{- end }}
{{- end -}}

{{/*
Standard environment variable sources
*/}}
{{- define "n8n.envFrom" -}}
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-database-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-logging-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-diagnostics-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-version-notifications-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-public-api-configmap
{{- if and (eq .Values.db.type "postgresdb") (or (eq .Values.worker.mode "queue") (eq .Values.webhook.mode "queue")) }}
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-queue-configmap
{{- end }}
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-workflow-history-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-task-broker-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-metrics-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-binary-data-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-security-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-workflows-configmap
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-ai-assistant-configmap
{{- if .Values.license.enabled }}
- configMapRef:
    name: {{ template "n8n.names.fullname" . }}-license-configmap
- secretRef:
    name: {{ default (printf "%s-license-activation-key" (include "n8n.names.fullname" .)) .Values.license.existingActivationKeySecret }}
{{- end }}
- secretRef:
    name: {{ default (printf "%s-encryption-key-secret-v2" (include "n8n.names.fullname" .)) .Values.existingEncryptionKeySecret }}
{{- range (default .Values.extraSecretNamesForEnvFrom .Values.main.extraSecretNamesForEnvFrom) }}
- secretRef:
    name: {{ . }}
{{- end }}
{{- end -}}

{{/*
Get the correct webhook service name for MCP routes
*/}}
{{- define "n8n.mcp-webhook.serviceName" -}}
{{- if or (gt (int .Values.webhook.count) 1) .Values.webhook.autoscaling.enabled .Values.webhook.allNodes -}}
{{ printf "%s-mcp-webhook" (include "n8n.names.fullname" .) }}
{{- else -}}
{{ printf "%s-webhook" (include "n8n.names.fullname" .) }}
{{- end -}}
{{- end -}}

{{/*
Labels for main persistence
*/}}
{{- define "n8n-main.persistence.labels" -}}
{{ include "n8n.labels.component" (dict "context" . "component" "main") }}
{{- end -}}

{{/*
Labels for worker persistence
*/}}
{{- define "n8n-worker.persistence.labels" -}}
{{ include "n8n.labels.component" (dict "context" . "component" "worker") }}
{{- end -}}


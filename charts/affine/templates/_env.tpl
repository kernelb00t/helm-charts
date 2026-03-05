{{/*
Environment variables for AFFiNE
*/}}
{{- define "affine.env" -}}
- name: LOG_LEVEL
  value: {{ .Values.app.logLevel | default "log" | quote }}
- name: NODE_ENV
  value: {{ .Values.app.env | quote }}
- name: AFFINE_ENV
  value: {{ .Values.app.env | quote }}
- name: DEPLOYMENT_TYPE
  value: {{ .Values.app.type | quote }}
- name: DEPLOYMENT_PLATFORM
  value: "distribution"
- name: AFFINE_SERVER_HOST
  value: {{ .Values.app.host | quote }}
- name: AFFINE_SERVER_PORT
  value: {{ .Values.app.port | quote }}
- name: AFFINE_SERVER_HTTPS
  value: {{ .Values.app.https | quote }}
{{- if .Values.app.path }}
- name: AFFINE_SERVER_SUB_PATH
  value: {{ .Values.app.path | quote }}
{{- end }}
{{- if .Values.app.externalUrl }}
- name: AFFINE_SERVER_EXTERNAL_URL
  value: {{ .Values.app.externalUrl | quote }}
{{- end }}
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "affine.database.secretName" . }}
      key: {{ include "affine.database.secretKey" . }}
- name: DATABASE_URL
  {{- if and (hasSuffix "migration.yaml" .Template.Name) .Values.db.database.migrationHost }}
  value: postgres://{{ .Values.db.database.user }}:$(DATABASE_PASSWORD)@{{ .Values.db.database.migrationHost }}:{{ .Values.db.database.port }}/{{ .Values.db.database.database }}
  {{- else }}
  value: postgres://{{ .Values.db.database.user }}:$(DATABASE_PASSWORD)@{{ .Values.db.database.host }}:{{ .Values.db.database.port }}/{{ .Values.db.database.database }}
  {{- end }}
- name: REDIS_SERVER_HOST
  value: {{ include "affine.redis.host" . }}
- name: REDIS_SERVER_PORT
  value: {{ include "affine.redis.port" . | quote }}
- name: REDIS_SERVER_DATABASE
  value: {{ .Values.db.redis.database | quote }}
- name: REDIS_SERVER_USER
  value: {{ .Values.db.redis.username | default "" | quote }}
- name: REDIS_SERVER_PASSWORD
  {{- if or .Values.db.redis.existingSecret .Values.db.redis.password }}
  valueFrom:
    secretKeyRef:
      name: {{ include "affine.redis.secretName" . }}
      key: {{ include "affine.redis.secretKey" . }}
  {{- else }}
  value: ""
  {{- end }}
- name: AFFINE_INDEXER_ENABLED
  value: {{ .Values.db.indexer.enabled | quote }}
{{- if .Values.db.indexer.enabled }}
- name: AFFINE_INDEXER_SEARCH_ENDPOINT
  value: {{ .Values.db.indexer.endpoint | default "" | quote }}
- name: AFFINE_INDEXER_SEARCH_PROVIDER
  value: {{ .Values.db.indexer.provider | default "" | quote }}
- name: AFFINE_INDEXER_SEARCH_API_KEY
  {{- if .Values.db.indexer.existingSecretApiKey }}
  valueFrom:
    secretKeyRef:
      name: {{ include "affine.indexer.secretName" . }}
      key: {{ include "affine.indexer.secretKey" . }}
  {{- else }}
  value: ""
  {{- end }}
- name: AFFINE_INDEXER_SEARCH_USERNAME
  value: {{ .Values.db.indexer.username | default "" | quote }}
- name: AFFINE_INDEXER_SEARCH_PASSWORD
  value: {{ .Values.db.indexer.password | default "" | quote }}
{{- end }}
{{- if .Values.global.envVars }}
{{- range .Values.global.envVars }}
{{- if ne .name "NODE_OPTIONS" }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

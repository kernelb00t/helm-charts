# n8n

Helm chart for n8n - A workflow automation platform that gives technical teams the flexibility of code with the speed of no-code.

## Introduction

This chart bootstraps an [n8n](https://n8n.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## TL;DR

```bash
helm repo add dev-charts https://kernelb00t.github.io/helm-charts
helm repo update
helm install my-n8n dev-charts/n8n
```

## Prerequisites

- Kubernetes >=1.23.0-0
- Helm 3.0+
- PV provisioner support in the underlying infrastructure
- PostgreSQL (Required for production)
- Redis (Required for queue mode)

## Installing the Chart

To install the chart with the release name `my-n8n`:

```bash
helm install my-n8n dev-charts/n8n
```

## Uninstalling the Chart

To uninstall/delete the `my-n8n` deployment:

```bash
helm uninstall my-n8n
```

## Parameters

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aiAssistant.baseUrl | string | `""` | Base URL for the n8n AI Assistant backend. Maps to N8N_AI_ASSISTANT_BASE_URL. Leave empty to use the default. |
| binaryData.mode | string | `"default"` | Binary data storage mode. Valid values: `default` (in-memory) \| `filesystem` \| `s3`. |
| binaryData.s3.accessKey | string | `""` | S3 access key. |
| binaryData.s3.accessSecret | string | `""` | S3 access secret. |
| binaryData.s3.bucketName | string | `""` | S3 bucket name. |
| binaryData.s3.bucketRegion | string | `"us-east-1"` | S3 bucket region. |
| binaryData.s3.existingSecret | string | `""` | Existing secret for S3 credentials (keys: `access-key-id`, `secret-access-key`). |
| binaryData.s3.host | string | `""` | S3-compatible storage host. |
| db.postgresdb.database | string | `"n8n"` | PostgreSQL database name. |
| db.postgresdb.existingSecret | string | `""` | Existing secret with `postgres-password` key. Overrides `db.postgresdb.password`. |
| db.postgresdb.host | string | `""` | PostgreSQL server host |
| db.postgresdb.password | string | `""` | PostgreSQL password |
| db.postgresdb.port | int | `5432` | PostgreSQL server port |
| db.postgresdb.schema | string | `"public"` | The PostgreSQL schema. |
| db.postgresdb.ssl.enabled | bool | `false` | Whether to enable SSL. |
| db.postgresdb.username | string | `"postgres"` | PostgreSQL username |
| db.redis.database | int | `0` | Redis database for Bull queue. |
| db.redis.existingSecret | string | `""` | Existing secret with `redis-password` key. Overrides `db.redis.password`. |
| db.redis.host | string | `""` | Redis server host |
| db.redis.password | string | `""` | Redis password |
| db.redis.port | int | `6379` | Redis server port |
| db.redis.username | string | `""` | Redis username |
| db.type | string | `"sqlite"` | Database engine. Valid values: `sqlite` \| `postgresdb`. |
| encryptionKey | string | `""` | If you install n8n first time, you can keep this empty and it will be auto generated and never change again. If you already have a encryption key generated before, please use it here. |
| existingEncryptionKeySecret | string | `""` | The name of an existing secret with encryption key. The secret must contain a key with the name N8N_ENCRYPTION_KEY. |
| global.log.level | string | `"info"` | Log level. Options: `error` \| `warn` \| `info` \| `debug`. |
| global.log.output | list | `["console"]` | Log output target. Options: `console` \| `file`. |
| n8nPath | string | `"/"` | The base path under which n8n runs. Useful for serving n8n at a sub-path (e.g. /n8n/). Include a trailing slash. Maps to N8N_PATH environment variable. |
| nodes.external.allowAll | bool | `false` | Allow all external npm packages in Code node. |
| security.blockEnvAccessInNode | bool | `false` | Whether to block access to the runner's environment from within Node.js code tasks. Maps to N8N_BLOCK_ENV_ACCESS_IN_NODE. Default is false. |
| security.blockFileAccessToN8nFiles | bool | `true` | Whether to block access to sensitive n8n files from within code nodes. Maps to N8N_BLOCK_FILE_ACCESS_TO_N8N_FILES. Default is true. |
| security.restrictFileAccessTo | string | `""` | Semicolon-separated list of additional directories that code nodes are allowed to access. Maps to N8N_RESTRICT_FILE_ACCESS_TO. Leave empty to use defaults. |
| security.secureCookie | bool | `true` | Whether to use secure cookies (HTTPS only). Set to false in HTTP-only environments. Maps to N8N_SECURE_COOKIE. Default is true. |
| taskRunners.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| taskRunners.image.registry | string | `""` | Image registry. Overrides global.image.registry. |
| taskRunners.image.tag | string | `""` | Image tag (defaults to chart appVersion). |
| webhook.image | object | `{"pullPolicy":"IfNotPresent","repository":"n8nio/n8n","tag":""}` | Webhook node image configuration. |
| webhook.mcp.image | object | `{"pullPolicy":"IfNotPresent","repository":"n8nio/n8n","tag":""}` | MCP webhook node image configuration. |
| webhook.url | string | `""` | Webhook URL (include http/https schema). |
| worker.image | object | `{"pullPolicy":"IfNotPresent","repository":"n8nio/n8n","tag":""}` | Worker node image configuration. |
| workflows.activationBatchSize | int | `1` | Number of workflows to activate in one batch during startup. Maps to N8N_WORKFLOW_ACTIVATION_BATCH_SIZE. Default is 1. |
| workflows.callerPolicyDefaultOption | string | `"workflowsFromSameOwner"` | Default caller policy for workflow-to-workflow calls. Allowed values: any | none | workflowsFromAList | workflowsFromSameOwner. Maps to N8N_WORKFLOW_CALLER_POLICY_DEFAULT_OPTION. Default is workflowsFromSameOwner. |
| workflows.defaultName | string | `"My workflow"` | Default name for new workflows. Maps to WORKFLOWS_DEFAULT_NAME. Default is "My workflow". |
| workflows.onboardingFlowDisabled | bool | `false` | Whether to disable the onboarding flow for new users. Maps to N8N_ONBOARDING_FLOW_DISABLED. Default is false. |
| workflows.tagsDisabled | bool | `false` | Whether to disable the tags feature. Maps to N8N_WORKFLOW_TAGS_DISABLED. Default is false. |

*(See [values.yaml](values.yaml) for the full list of configuration options.)*

## Chart Info

![Version: 1.0.32](https://img.shields.io/badge/Version-1.0.32-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.13.4](https://img.shields.io/badge/AppVersion-2.13.4-informational?style=flat-square)

| Field | Value |
|-------|-------|
| Chart Version | `1.0.32` |
| App Version | `2.13.4` |
| Source | <a href="https://github.com/n8n-io/n8n">https://github.com/n8n-io/n8n</a><br><a href="https://github.com/dalamudx/helm-charts">https://github.com/dalamudx/helm-charts</a> |

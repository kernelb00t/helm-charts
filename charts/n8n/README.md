# n8n

Helm chart for n8n - A workflow automation platform that gives technical teams the flexibility of code with the speed of no-code.

## Introduction

This chart bootstraps an [n8n](https://n8n.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## TL;DR

```bash
helm repo add dev-charts https://dalamudx.github.io/helm-charts
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
| global.service.annotations | object | `{}` | Service annotations. |
| global.service.enabled | bool | `true` | Enable the Service. |
| global.service.labels | object | `{}` | Service labels. |
| global.service.name | string | `"http"` | Service port name. |
| global.service.port | int | `5678` | Service port. |
| global.service.type | string | `"ClusterIP"` | Service type (ClusterIP, NodePort, LoadBalancer). |
| nodes.external.allowAll | bool | `false` | Allow all external npm packages in Code node. |
| taskRunners.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| taskRunners.image.tag | string | `""` | Image tag (defaults to chart appVersion). |
| webhook.url | string | `""` | Webhook URL (include http/https schema). |

*(See [values.yaml](values.yaml) for the full list of configuration options.)*

## Chart Info

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.7.4](https://img.shields.io/badge/AppVersion-2.7.4-informational?style=flat-square)

| Field | Value |
|-------|-------|
| Chart Version | `1.0.1` |
| App Version | `2.7.4` |
| Source | <a href="https://github.com/n8n-io/n8n">https://github.com/n8n-io/n8n</a><br><a href="https://github.com/dalamudx/helm-charts">https://github.com/dalamudx/helm-charts</a> |

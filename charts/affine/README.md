# AFFiNE

Helm chart for AFFiNE - The next-gen knowledge base.

## Introduction

This chart bootstraps an [AFFiNE](https://github.com/toeverything/AFFiNE) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## TL;DR

```bash
helm repo add dev-charts https://dalamudx.github.io/helm-charts
helm repo update
helm install my-affine dev-charts/affine
```

## Prerequisites

- Kubernetes >=1.24.0-0
- Helm 3.0+
- PostgreSQL 16+ (Required)
  - For AI features: `pgvector/pgvector:pg16` is required
- Redis 6.x or 7.x (Required)

## Installing the Chart

To install the chart with the release name `my-affine`:

```bash
helm install my-affine dev-charts/affine -f your-values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `my-affine` deployment:

```bash
helm uninstall my-affinebash
```

## Parameters

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| app.externalUrl | string | `""` | Public URL — **required** (e.g. `https://affine.example.com`) |
| app.logLevel | string | `"log"` | Log level: `verbose` \| `debug` \| `log` \| `warn` \| `error` |
| db.database.existingSecret | string | `""` | Existing Secret containing `postgres-password` key |
| db.database.host | string | `"pg-postgresql"` | PostgreSQL host |
| db.indexer.enabled | bool | `false` | Enable external search indexer |
| db.indexer.provider | string | `"manticoresearch"` | Indexer provider: `manticoresearch` \| `elasticsearch` |
| db.redis.existingSecret | string | `""` | Existing Secret containing `redis-password` key |
| db.redis.host | string | `"redis-master"` | Redis host |
| front.httpRoute.enabled | bool | `false` | Enable Gateway API HTTPRoute |
| global.registry | string | `"ghcr.io"` | Image registry |
| global.tag | string | `""` | Image tag (defaults to chart appVersion) |
| persistence.enabled | bool | `false` | Enable PVC for blob/avatar storage |

*(See [values.yaml](values.yaml) for the full list of configuration options.)*

## Chart Info

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.26.2](https://img.shields.io/badge/AppVersion-0.26.2-informational?style=flat-square)

| Field | Value |
|-------|-------|
| Chart Version | `1.0.1` |
| App Version | `0.26.2` |
| Source | <a href="https://github.com/toeverything/AFFiNE">https://github.com/toeverything/AFFiNE</a><br><a href="https://github.com/dalamudx/helm-charts">https://github.com/dalamudx/helm-charts</a> |

# Helm Charts

This repository hosts Helm charts for various applications.

## Usage

Add this repository to your Helm client:

```bash
helm repo add dev-charts https://kernelb00t.github.io/helm-charts
helm repo update
```

## Available Charts

| Chart | Description |
|---|---|
| **affine** | Helm chart for AFFiNE - The next-gen knowledge base. |
| **n8n** | Helm chart for n8n - A workflow automation platform that gives technical teams the flexibility of code with the speed of no-code. |

## Installation

```bash
# Install affine
helm install affine-release dev-charts/affine -f your-values.yaml

# Install n8n
helm install n8n-release dev-charts/n8n -f your-values.yaml

```

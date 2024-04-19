# aks-workload-id-101

## Introduction

Seamlessly Integrating Azure Kubernetes Service (AKS) with Azure KeyVault Using Workload Identity: A Comprehensive Guide for Beginners.

## Prerequisites

1. Azure Subscription
2. Azure CLI
3. Kubernetes Tools (Kubectl, Helm, Kustomize)
4. NodeJS
5. Docker
8. Taskfile

or All-in-one 🚀 VSCode + DevContainer

## Getting Started

1. Clone the repository

```bash
git clone https://github.com/phucnt1992/aks-workload-id-101.git
```

2. To start the minikube and deploy the application

```bash
task minikube

task deploy TARGET=minikube -y
```

3. To deploy Bicep template

```bash
task az-deploy -y
```

4. Create .env file and update values

```bash
cp .env.example .env
```

5. To prepare the secrets and federate the identity

```bash
task aks-populatesecrets

task aks-createfed
```

6. To deploy the application to AKS

```bash
task az-login

task deploy TARGET=dev -y
```

## Known Issues

Thumbnail image is not displayed in the product detail page. This is due to the fact that the image is stored in the local file system and the application is not able to access it.
The solution is to store the image in the cloud storage and update the image URL in the database.
Or follow this [guideline](https://github.com/saleor/saleor/discussions/11117#discussioncomment-5604251) to manualy update domain

## References

1. [Workload Identity](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview)
2. [Deploy and configure cluster](https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster)
3. [Saleor Architecture](https://docs.saleor.io/docs/3.x/overview/architecture)

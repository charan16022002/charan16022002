# Docker + Kubernetes CI/CD Workflow

The GitHub Actions workflow builds the Docker app from `../dockerized-python-app`, runs it, and smoke-tests its HTTP endpoint.

## Run locally

```bash
docker build -t sre-demo:ci ../dockerized-python-app
docker run --rm -p 8080:8080 sre-demo:ci
curl http://localhost:8080/health
```

## Deployment extension

A next stage can publish an image to GHCR and deploy it to a test Kubernetes cluster. That stage is intentionally not enabled by default: it requires a registry package configuration, scoped credentials or GitHub token permissions, a trusted cluster context, and a review of deployment permissions.

The included workflow is a container build and smoke-test CI example; it does not publish an image or deploy to a cluster.

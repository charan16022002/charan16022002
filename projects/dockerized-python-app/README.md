# Dockerized Python Health Endpoint

A minimal HTTP service that returns a JSON health response.

## Build and run

```bash
docker build -t sre-demo:local .
docker run --rm -p 8080:8080 sre-demo:local
curl -i http://localhost:8080/health
```

Expected response includes `"status": "ok"`.

## Container practices demonstrated

- Small Python slim base image
- Non-root runtime user
- Configurable port
- JSON response suitable for a simple smoke check

This project is a starter implementation. Build and runtime behavior should be tested on a machine with Docker installed.

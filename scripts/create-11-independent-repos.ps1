$ErrorActionPreference = "Stop"

$owner = "charan16022002"
$sourceUrl = "https://github.com/$owner/$owner.git"
$workRoot = Join-Path $env:TEMP ("sre-portfolio-repos-" + [guid]::NewGuid().ToString("N"))
$sourceDir = Join-Path $workRoot "source"

# Requires Git and GitHub CLI (gh), authenticated with: gh auth login
git --version | Out-Null
gh auth status
New-Item -ItemType Directory -Path $workRoot -Force | Out-Null
git clone $sourceUrl $sourceDir

$projects = @(
    @{ Name = "github-actions-python-ci"; Folder = "github-actions-python-ci"; Description = "Python unit tests and GitHub Actions CI pipeline" },
    @{ Name = "dockerized-python-app"; Folder = "dockerized-python-app"; Description = "Dockerized Python HTTP application and container CI" },
    @{ Name = "kubernetes-deployment"; Folder = "kubernetes-deployment"; Description = "Kubernetes deployment, service, probes, and troubleshooting lab" },
    @{ Name = "linux-admin-toolkit"; Folder = "linux-admin-toolkit"; Description = "Linux server administration and health check scripts" },
    @{ Name = "terraform-aws-vpc"; Folder = "terraform-aws-vpc"; Description = "Terraform AWS VPC infrastructure as code lab" },
    @{ Name = "ansible-linux-baseline"; Folder = "ansible-linux-baseline"; Description = "Ansible Linux baseline and read-only host checks" },
    @{ Name = "prometheus-monitoring"; Folder = "prometheus-monitoring"; Description = "Prometheus scrape configuration and alerting examples" },
    @{ Name = "zabbix-linux-monitoring"; Folder = "zabbix-linux-monitoring"; Description = "Zabbix Linux monitoring and alert investigation runbook" },
    @{ Name = "terraform-ansible-workflow"; Folder = "terraform-ansible-workflow"; Description = "Terraform and Ansible provisioning workflow guide" },
    @{ Name = "docker-kubernetes-cicd"; Folder = "docker-kubernetes-cicd"; Description = "Docker CI workflow and Kubernetes delivery extension" },
    @{ Name = "python-infrastructure-utilities"; Folder = "python-infrastructure-utilities"; Description = "Python infrastructure health reporting utilities" }
)

$pythonWorkflow = @'
name: Python CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: read
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - name: Run unit tests
        run: python -m unittest discover -s tests -v
      - name: Smoke test
        run: python app.py
'@

$containerWorkflow = @'
name: Container CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: read
jobs:
  build-and-smoke-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build container image
        run: docker build -t sre-demo:ci .
      - name: Start container
        run: docker run -d --name sre-demo -p 8080:8080 sre-demo:ci
      - name: Smoke test endpoint
        run: |
          for attempt in $(seq 1 10); do
            if curl --fail --silent http://127.0.0.1:8080/health; then
              echo
              exit 0
            fi
            sleep 2
          done
          docker logs sre-demo
          exit 1
      - name: Stop container
        if: always()
        run: docker rm -f sre-demo || true
'@

foreach ($project in $projects) {
    $name = $project.Name
    $folder = $project.Folder
    $dest = Join-Path $workRoot $name
    $sourceProject = Join-Path $sourceDir ("projects/" + $folder)

    if (-not (Test-Path $sourceProject)) {
        throw "Project folder not found: $sourceProject"
    }

    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    Copy-Item -Path (Join-Path $sourceProject "*") -Destination $dest -Recurse -Force

    # The combined Docker/Kubernetes delivery repository gets its own runnable app.
    if ($name -eq "docker-kubernetes-cicd") {
        Copy-Item -Path (Join-Path $sourceDir "projects/dockerized-python-app/*") -Destination $dest -Recurse -Force
        @'
# Docker + Kubernetes CI/CD Workflow

This repository builds a container image, starts it, and smoke-tests its HTTP endpoint through GitHub Actions. Kubernetes deployment can be added for a target test cluster.

## Run locally

    docker build -t sre-demo:ci .
    docker run --rm -p 8080:8080 sre-demo:ci
    curl http://localhost:8080/health

The workflow performs container CI only; it does not publish an image or deploy to a live Kubernetes cluster.
'@ | Set-Content -Path (Join-Path $dest "README.md") -Encoding utf8
    }

    $workflowDir = Join-Path $dest ".github/workflows"
    if ($name -eq "github-actions-python-ci") {
        New-Item -ItemType Directory -Path $workflowDir -Force | Out-Null
        $pythonWorkflow | Set-Content -Path (Join-Path $workflowDir "ci.yml") -Encoding utf8
    }
    if ($name -eq "dockerized-python-app" -or $name -eq "docker-kubernetes-cicd") {
        New-Item -ItemType Directory -Path $workflowDir -Force | Out-Null
        $containerWorkflow | Set-Content -Path (Join-Path $workflowDir "container-ci.yml") -Encoding utf8
    }

    Push-Location $dest
    try {
        git init -b main
        git add .
        git commit -m "Initial commit: $name portfolio project"
        gh repo create "$owner/$name" --public --description $project.Description --source . --remote origin --push
    }
    finally {
        Pop-Location
    }

    Write-Host "Published https://github.com/$owner/$name" -ForegroundColor Green
}

Write-Host ""
Write-Host "Finished. Check all repositories and GitHub Actions runs before describing every lab as fully tested."
Write-Host "Working files are in: $workRoot"

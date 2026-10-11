# SRE / DevOps Portfolio Labs

These labs are being built as practical, reviewable examples. Each project has its own folder and README. They currently live inside the profile repository because the connected GitHub actions available in this session can create and edit files but do not expose a create-new-repository operation.

| Project | Focus |
|---|---|
| [GitHub Actions Python CI](github-actions-python-ci/) | Automated tests on pushes and pull requests |
| [Dockerized Python App](dockerized-python-app/) | Container build, non-root runtime, HTTP JSON response |
| [Kubernetes Deployment](kubernetes-deployment/) | Deployment, Service, probes, resources, troubleshooting |
| [Linux Admin Toolkit](linux-admin-toolkit/) | Read-only server health snapshot |
| [Terraform AWS VPC](terraform-aws-vpc/) | Infrastructure as Code for a lab VPC and subnet |
| [Ansible Linux Baseline](ansible-linux-baseline/) | Read-only Linux inventory and health checks |

## Validation status

The Python CI and container build/smoke-test workflows have passed on GitHub Actions. The other labs are published starter examples and still need their documented validation steps run in appropriate environments.

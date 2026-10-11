# Terraform + Ansible Provisioning Workflow

This project documents a safe sequence for infrastructure provisioning followed by operating-system configuration.

## Workflow

1. Review Terraform configuration and variables.
2. Run `terraform fmt -check`, `terraform validate`, and `terraform plan`.
3. Apply only after reviewing the plan and cost/security impact.
4. Populate Ansible inventory with the actual reachable lab host.
5. Run Ansible syntax checks and a read-only baseline playbook.
6. Validate the host state, then destroy lab infrastructure when no longer needed.

## Example command sequence

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply

ansible-playbook --syntax-check -i ../ansible-linux-baseline/inventory.ini ../ansible-linux-baseline/playbook.yml
ansible-playbook -i ../ansible-linux-baseline/inventory.ini ../ansible-linux-baseline/playbook.yml --limit linux

terraform destroy
```

The Terraform and Ansible examples in neighboring folders are starter labs and are not yet wired together automatically. Networking, SSH access, credentials, and inventory generation must be configured for a real lab. Never commit secrets or state files.

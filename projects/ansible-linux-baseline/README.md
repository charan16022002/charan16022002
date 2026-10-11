# Ansible Linux Baseline

A read-only Ansible playbook that gathers OS/kernel facts, root filesystem usage, and uptime from Linux hosts.

## Prerequisites

- Ansible installed on the control node
- SSH connectivity and an authorized account on target hosts
- Inventory updated for your lab environment

## Run syntax check and playbook

```bash
ansible-playbook --syntax-check -i inventory.ini playbook.yml
ansible-playbook -i inventory.ini playbook.yml --limit linux
```

The inventory intentionally contains no real host or credential. Add only systems you own or are authorized to administer. This starter playbook does not change target configuration.

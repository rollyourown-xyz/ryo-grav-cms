#!/bin/sh

echo "Running host setup playbooks"
echo ""

# Generic host setup
echo "Executing generic host setup playbooks"
ansible-playbook -i configuration/inventory modules/ryo-host-setup-generic/host-setup/master.yml

# Project-specific host setup
echo "Executing project-specific host setup playbooks"
ansible-playbook -i configuration/inventory host-setup-project/master.yml

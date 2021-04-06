#!/bin/sh
ansible-playbook -i configuration/inventory.ini host-setup/master.yml

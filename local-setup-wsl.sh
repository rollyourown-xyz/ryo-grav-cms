#!/bin/sh
ansible-playbook -i configuration/inventory.ini control-node-wsl/master.yml

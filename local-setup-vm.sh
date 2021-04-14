#!/bin/sh
ansible-playbook -i configuration/inventory.ini control-node-virtual-machine/master.yml

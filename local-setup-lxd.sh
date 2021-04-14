#!/bin/sh
ansible-playbook -i configuration/inventory.ini control-node-lxd-container/master.yml

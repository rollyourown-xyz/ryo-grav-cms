#!/bin/sh
ansible-playbook -i configuration/inventory.ini control-node/master.yml

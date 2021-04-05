#!/bin/sh
ansible-playbook -i configuration/inventory.ini local-setup-ubuntu/master.yml

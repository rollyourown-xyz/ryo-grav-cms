#!/bin/sh
ansible-playbook -i configuration/inventory.ini host-setup/master.yml

## TODO ADD configuration of LXD remote hosts (both ends)

# On local machine (with become: yes, become_user: "{{ local_non_root_user }}")
# lxc remote add {{ host_hostname }} {{ host_wireguard_address }} --accept-certificate=true --auth-type="tls" --password="{{ lxd_core_trust_password }}" --public=false

# On remote host (with become: yes, become_user: "{{ host_non_root_user }}")
# lxc remote add control {{ host_wireguard_address_range | replace("0/24", "2") }} --accept-certificate=true --auth-type="tls" --password="{{ lxd_core_trust_password }}" --public=false

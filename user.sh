#/bin/bash

source ./common.sh
app_name=user

check_root_access
app_setup
nodejs_setup
systemd_setup
print_time
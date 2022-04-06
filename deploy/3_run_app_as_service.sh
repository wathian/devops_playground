#!/bin/bash

set -euxo pipefail

cd /app/govtech_devops_2022

sudo systemctl is-active symbiosis-app.service
if [ $? -gt 0] ; then
    sudo systemctl stop symbiosis-app.service
fi
# sudo cp deploy/symbiosis-app.service /etc/systemd/system
# chown ec2-user /etc/systemd/system/symbiosis-app.service
# chmod u+x /etc/systemd/system/symbiosis-app.service
sudo systemctl enable symbiosis-app.service
sudo systemctl daemon-reload
sudo systemctl start symbiosis-app.service
sudo systemctl status symbiosis-app.service
# Useful
# sudo systemctl stop symbiosis-app.service
# Returns 0 (active) | >0 (inactive)
# sudo systemctl is-active symbiosis-app.service
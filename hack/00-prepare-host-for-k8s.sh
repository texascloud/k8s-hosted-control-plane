#!/bin/bash

# https://support.platform9.com/hc/en-us/articles/360002046074-Kubernetes-Instability-After-Upgrading-to-Platform9-v3-3

# Disable swap now
swapoff -a

# Run the following command to update fstab so that swap remains disabled after a reboot.
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Needed to avoid https://platform9.atlassian.net/browse/PMK-1639
# https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

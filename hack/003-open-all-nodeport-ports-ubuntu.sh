#!/bin/bash

# I found out this port range was the ports used when creating nodeport services by running `kubectl cluster-info dump | grep -i "nodeport"`
ufw allow 30000:32767/tcp

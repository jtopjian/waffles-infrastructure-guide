#!/bin/bash

echo " ===> Allow root to login via SSH"
cp /home/ubuntu/.ssh/authorized_keys /root/.ssh

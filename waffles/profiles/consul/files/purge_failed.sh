#!/bin/bash

for failed_node in $(/usr/local/bin/consul members | grep failed | cut -d" " -f1); do
  /usr/local/bin/consul force-leave $failed_node
done

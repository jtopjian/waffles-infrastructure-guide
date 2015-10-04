# Declare global variables
declare -ag data_users=()
declare -Ag data_user_info=()
declare -ag data_services=()
declare -Ag data_service_info=()

# Standard node information
declare -Ag data_node_info=()
data_node_info[domain]="example.com"
data_node_info[hostname]=$(hostname)
data_node_info[ip]=$(ip addr show dev eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1 | head -1)
data_node_info[ip6]=$(ip addr show dev eth0 | grep inet6 | awk '{print $2}' | head -1 | cut -d/ -f1)
data_node_info[nproc]=$(nproc)

# Packages to be installed on all nodes
declare -ag data_packages=()
stdlib.array_push data_packages wget
stdlib.array_push data_packages curl
stdlib.array_push data_packages tmux
stdlib.array_push data_packages vim
stdlib.array_push data_packages iptables

# ACNG server
data_acng_server="acng.example.com"

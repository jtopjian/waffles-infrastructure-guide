# Tell Waffles about the user and service
stdlib.array_push data_users "consul"
stdlib.array_push data_services "consul"

# Consul Version
data_consul_version="0.5.2"
data_consul_template_version="0.10.0"

# Consul Tokens and Keys
data_consul_encrypt_key="CHANGEME"
data_consul_cluster_name="consul.example.com"

# Describe the user
# This user is installed by common/user
data_user_info[consul|name]="consul"
data_user_info[consul|uid]="900"
data_user_info[consul|gid]="900"
data_user_info[consul|homedir]="/var/lib/consul"

# Any extra generic packages
# This package is installed by common/packages
stdlib.array_push data_packages unzip

# Consul config
declare -Ag data_consul_server_config=(
  [server]="true"
  [advertise_addr]="${data_node_info[ip6]}"
  [client_addr]="127.0.0.1"
  [bind_addr]="0.0.0.0"
  [bootstrap_expect]="3"
  [datacenter]="honolulu"
  [data_dir]="/var/lib/consul"
  [encrypt]="${data_consul_encrypt_key}"
  [enable_syslog]="true"
  [log_level]="INFO"
  [rejoin_after_leave]="true"
  [retry_interval]="30s"
  [ui_dir]="/opt/consul-web/dist"
)

declare -Ag data_consul_client_config=(
  [advertise_addr]="${data_node_info[ip6]}"
  [client_addr]="127.0.0.1"
  [datacenter]="honolulu"
  [data_dir]="/var/lib/consul"
  [encrypt]="${data_consul_encrypt_key}"
  [enable_syslog]="true"
  [log_level]="INFO"
  [rejoin_after_leave]="true"
  [retry_interval]="30s"
)

declare -Ag data_consul_template_config=(
  [global|consul]="localhost:8500"
  [global|retry]="10s"
  [global|max_stale]="10m"
  [global|log_level]="INFO"
  [syslog|enabled]="true"
  [syslog|facility]="LOCAL5"
)

stdlib.title "consul/server"

_user="${data_user_info[consul|name]}"

# Consul Directories
stdlib.directory --name /var/lib/consul --owner $_user --group $_user --mode 750
stdlib.directory --name /etc/consul --owner $_user --group $_user --mode 750
stdlib.directory --name /etc/consul/agent --owner $_user --group $_user --mode 750
stdlib.directory --name /etc/consul/agent/conf.d --owner $_user --group $_user --mode 750
stdlib.directory --name /opt/consul-web --owner $_user --group $_user --mode 750
stdlib.file --name /var/log/consul.log --owner $_user --group $_user --mode 640

# Install Consul
if [[ ! -f /usr/local/bin/consul ]]; then
  stdlib.mute pushd /tmp
    stdlib.capture_error wget https://dl.bintray.com/mitchellh/consul/${data_consul_version}_linux_amd64.zip
    stdlib.capture_error unzip ${data_consul_version}_linux_amd64.zip
    stdlib.capture_error mv consul /usr/local/bin
  stdlib.mute popd
fi

if [[ ! -f /usr/local/bin/consul-cli ]]; then
  stdlib.mute pushd /tmp
    stdlib.capture_error wget https://github.com/CiscoCloud/consul-cli/releases/download/v0.1.0/consul-cli_0.1.0_linux_amd64.tar.gz
    stdlib.capture_error tar xzf consul-cli_0.1.0_linux_amd64.tar.gz
    stdlib.capture_error mv consul-cli_0.1.0_linux_amd64/consul-cli /usr/local/bin
  stdlib.mute popd
fi

# Configure Consul
for key in "${!data_consul_server_config[@]}"; do
  augeas.json_dict --file "/etc/consul/agent/conf.d/config.json" --path / --key "$key" --value "${data_consul_server_config[$key]}"
done

for attempt in {1..10}; do
  _nodes=($(dig -t txt $data_consul_cluster_name | grep TXT | awk '{print $5}' | grep -v ^$ | sort | tr -d \"))
  if [[ -z "$_nodes" ]]; then
    stdlib.warn "No consul nodes found. Sleeping"
    sleep 60
  else
    break
  fi
done

for _node in "${_nodes[@]}"; do
  _consul_nodes="${_consul_nodes}--value ${_node} "
done

augeas.json_array --file "/etc/consul/agent/conf.d/config.json" --path / --key "retry_join" $_consul_nodes

stdlib.file --name /usr/local/bin/purge_failed.sh --mode "750" --source "$WAFFLES_SITE_DIR/profiles/consul/files/purge_failed.sh"
stdlib.cron --name consul_purge_failed_nodes --cmd /usr/local/bin/purge_failed.sh

# Server nodes get the web UI
if [[ ! -d /opt/consul-web/dist ]]; then
  stdlib.mute pushd /tmp
    stdlib.capture_error wget https://dl.bintray.com/mitchellh/consul/${data_consul_version}_web_ui.zip
    stdlib.capture_error unzip -d /opt/consul-web ${data_consul_version}_web_ui.zip
    stdlib.capture_error chown -R consul: /opt/consul-web
  stdlib.mute popd
fi

# Consul Service
stdlib.file --name /etc/init/consul.conf --source "$WAFFLES_SITE_DIR/profiles/consul/files/consul.conf"
stdlib.upstart --name consul --state running

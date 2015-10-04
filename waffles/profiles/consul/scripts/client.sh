stdlib.title "consul/client"

_user="${data_user_info[consul|name]}"

# Consul Directories
stdlib.directory --name /var/lib/consul --owner $_user --group $_user --mode 750
stdlib.directory --name /etc/consul --owner $_user --group $_user --mode 750
stdlib.directory --name /etc/consul/agent --owner $_user --group $_user --mode 750
stdlib.directory --name /etc/consul/agent/conf.d --owner $_user --group $_user --mode 750
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
for key in "${!data_consul_client_config[@]}"; do
  augeas.json_dict --file "/etc/consul/agent/conf.d/config.json" --path / --key "$key" --value "${data_consul_client_config[$key]}"
done

augeas.json_array --file "/etc/consul/agent/conf.d/config.json" --path / --key "retry_join" --value "$data_consul_cluster_name"

# Consul Service
stdlib.file --name /etc/init/consul.conf --source "$WAFFLES_SITE_DIR/profiles/consul/files/consul.conf"
stdlib.upstart --name consul --state running

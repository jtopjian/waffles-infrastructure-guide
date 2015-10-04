stdlib.title "consul/template"

_user="${data_user_info[consul|name]}"

# Consul Template Directories
stdlib.directory --name /etc/consul/template --owner $_user --group $_user --mode 750
stdlib.directory --name /etc/consul/template/ctmpl --owner $_user --group $_user --mode 750
stdlib.directory --name /etc/consul/template/conf.d --owner $_user --group $_user --mode 750
stdlib.file --name /var/log/consul-template.log --owner root --group syslog --mode 640
stdlib.file --name /etc/init/consul-template.conf --source "$WAFFLES_SITE_DIR/profiles/consul/files/consul-template.conf"

if [[ ! -f /usr/local/bin/consul-template ]]; then
  stdlib.mute pushd /tmp
    stdlib.capture_error wget https://github.com/hashicorp/consul-template/releases/download/v${data_consul_template_version}/consul-template_${data_consul_template_version}_linux_amd64.tar.gz
    stdlib.capture_error tar xzvf consul-template_${data_consul_template_version}_linux_amd64.tar.gz
    stdlib.capture_error mv consul-template_${data_consul_template_version}_linux_amd64/consul-template /usr/local/bin
  stdlib.mute popd
fi

for key in "${!data_consul_template_config[@]}"; do
  stdlib.split $key "|"
  _section="${__split[0]}"
  _option="${__split[1]}"

  if [[ $_section == "global" ]]; then
    augeas.json_dict --file "/etc/consul/template/conf.d/config.json" --path / --key "$_option" --value "${data_consul_template_config[$key]}"
  else
    augeas.json_dict --file "/etc/consul/template/conf.d/config.json" --path "/$_section" --key "$_option" --value "${data_consul_template_config[$key]}"
  fi
done

stdlib.upstart --name consul-template --state running

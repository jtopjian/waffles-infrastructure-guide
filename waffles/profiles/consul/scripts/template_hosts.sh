stdlib.title "consul/template_hosts"

consul.template --name hosts --destination /etc/hosts
stdlib.file --name /etc/consul/template/ctmpl/hosts.ctmpl --mode 640 --source "$WAFFLES_SITE_DIR/profiles/consul/files/hosts.ctmpl"

if [[ $stdlib_state_change == "true" ]]; then
  restart consul-template
fi

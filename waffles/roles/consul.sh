stdlib.enable_augeas
stdlib.enable_consul

stdlib.data common
stdlib.data consul

stdlib.profile common/acng
stdlib.profile common/packages
stdlib.profile common/users
stdlib.profile common/updates
stdlib.profile common/sudo

stdlib.profile augeas/apt_install
stdlib.profile augeas/update_lenses

stdlib.profile consul/server
stdlib.profile consul/template
stdlib.profile consul/template_hosts

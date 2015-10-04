stdlib.title "augeas/apt_install"

stdlib.apt_key --name augeas --key AE498453 --keyserver keyserver.ubuntu.com
stdlib.apt_source --name augeas --uri http://ppa.launchpad.net/raphink/augeas/ubuntu --distribution trusty --component main
stdlib.apt --package augeas-tools --version latest

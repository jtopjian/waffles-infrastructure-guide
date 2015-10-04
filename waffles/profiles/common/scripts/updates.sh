stdlib.title "common/updates"

read -r -d '' _security_updates <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
stdlib.file --name /etc/apt/apt.conf.d/20auto-upgrades --content "$_security_updates"

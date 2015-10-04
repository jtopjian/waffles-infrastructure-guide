stdlib.title "common/acng"

# Set an acng server to use
stdlib.file --name /etc/apt/apt.conf.d/01acng --content "Acquire::http { Proxy \"http://$data_acng_server:3142\"; };"

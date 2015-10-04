stdlib.title "common/packages"

# install a set of common packages
for pkg in "${data_packages[@]}"; do
  stdlib.split $pkg '='
  stdlib.apt --state present --package "${__split[0]}" --version "${__split[1]}"
done

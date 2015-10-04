stdlib.title "augeas/update_lenses"

stdlib.git --state latest --name /usr/src/augeas --source https://github.com/hercules-team/augeas

if [[ $stdlib_resource_change == "true" ]]; then
  stdlib.info "Updating lenses"
  stdlib.capture_error cp "/usr/src/augeas/lenses/*.aug" /usr/share/augeas/lenses/dist/
fi

stdlib.title "common/users"

for user in "${data_users[@]}"; do
  _state="${data_user_info[$user|state]:-present}"
  _username="${data_user_info[$user|name]:-present}"
  _homedir="${data_user_info[$user|homedir]:-""}"
  _uid="${data_user_info[$user|uid]:-""}"
  _gid="${data_user_info[$user|gid]:-""}"
  _comment="${data_user_info[$user|comment]:-""}"
  _shell="${data_user_info[$user|shell]:-""}"
  _passwd="${data_user_info[$user|password]:-""}"
  _create_home="${data_user_info[$user|create_home]:-"true"}"
  _create_group="${data_user_info[$user|create_group]:-"true"}"
  _groups="${data_user_info[$user|groups]:-""}"
  _sudo="${data_user_info[$user|sudo]:-""}"
  _system="${data_user_info[$user|system]:-""}"

  if [[ $_create_group == "true" ]]; then
    stdlib.groupadd --state $_state --group "$_username" --gid "$_gid"
  fi

  stdlib.useradd --state $_state --user "$_username" --uid "$_uid" --gid "$_gid" --comment "$_comment" --homedir "$_homedir" --shell "$_shell" --passwd "$_passwd" --groups "$_groups" --createhome "$_createhome"
done

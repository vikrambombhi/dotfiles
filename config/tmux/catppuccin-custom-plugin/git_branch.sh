show_git_branch() {
  local index=$1
  local icon="$(get_tmux_option "@catppuccin_git_branch_icon" "")"
  local color="$(get_tmux_option "@catppuccin_git_branch_color" "$thm_blue")"
  local text="$(get_tmux_option "@catppuccin_git_branch_text" "#(git rev-parse --abbrev-ref HEAD)")"

  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}

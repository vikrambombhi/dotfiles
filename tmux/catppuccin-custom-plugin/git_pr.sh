show_git_pr() {
  local index=$1
  local icon="$(get_tmux_option "@catppuccin_git_pr_icon" "")"

  # Per-state accent colors, resolved to hex now (the helper runs outside this
  # context and can't see the catppuccin $thm_* shell vars). Override with
  # @catppuccin_git_pr_color_{open,draft,merged,closed}.
  tmux set-option -gq "@_catppuccin_git_pr_color_open"   "$(get_tmux_option "@catppuccin_git_pr_color_open"   "$thm_green")"
  tmux set-option -gq "@_catppuccin_git_pr_color_draft"  "$(get_tmux_option "@catppuccin_git_pr_color_draft"  "$thm_yellow")"
  tmux set-option -gq "@_catppuccin_git_pr_color_merged" "$(get_tmux_option "@catppuccin_git_pr_color_merged" "$thm_magenta")"
  tmux set-option -gq "@_catppuccin_git_pr_color_closed" "$(get_tmux_option "@catppuccin_git_pr_color_closed" "$thm_red")"

  # CI job-count colours and symbols (shown for open/draft PRs). Override with
  # @catppuccin_git_pr_ci_color_{pass,fail,running} and
  # @catppuccin_git_pr_ci_symbol_{pass,fail,running}.
  tmux set-option -gq "@_catppuccin_git_pr_ci_color_pass"    "$(get_tmux_option "@catppuccin_git_pr_ci_color_pass"    "$thm_green")"
  tmux set-option -gq "@_catppuccin_git_pr_ci_color_fail"    "$(get_tmux_option "@catppuccin_git_pr_ci_color_fail"    "$thm_red")"
  tmux set-option -gq "@_catppuccin_git_pr_ci_color_running" "$(get_tmux_option "@catppuccin_git_pr_ci_color_running" "$thm_yellow")"
  tmux set-option -gq "@_catppuccin_git_pr_ci_sym_pass"      "$(get_tmux_option "@catppuccin_git_pr_ci_symbol_pass"    "✓")"
  tmux set-option -gq "@_catppuccin_git_pr_ci_sym_fail"      "$(get_tmux_option "@catppuccin_git_pr_ci_symbol_fail"    "✗")"
  tmux set-option -gq "@_catppuccin_git_pr_ci_sym_running"   "$(get_tmux_option "@catppuccin_git_pr_ci_symbol_running" "●")"

  # Build the styled segment once with placeholders for the accent color and PR
  # text. The helper swaps in the live values for the current branch's PR (or
  # prints nothing when there is no PR, hiding the module entirely).
  local template
  template=$(build_status_module "$index" "$icon" "__COLOR__" "__PR__")
  # Also colour the text itself by state, not just the separator/icon block.
  template="${template/fg=$thm_fg/fg=__COLOR__}"
  tmux set-option -gq "@_catppuccin_git_pr_template" "$template"

  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Wrap the segment in a named click range (tmux 3.4+) so a status-line mouse
  # binding can open the PR only when this exact pill is clicked. The range is
  # zero-width (unclickable) when the helper prints nothing for a no-PR branch.
  echo "#[range=user|pr]#($script_dir/git_pr_status.sh)#[norange]"
}

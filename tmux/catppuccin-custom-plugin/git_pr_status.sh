#!/usr/bin/env bash
#
# Emits the catppuccin status segment (built by show_git_pr and stashed in the
# @_catppuccin_git_pr_template tmux option) for the current branch's PR, e.g.
# " PR #1234", coloured by PR state (open / draft / merged / closed). Prints
# nothing when the branch has no PR, so the module disappears entirely.
#
# A single `gh pr list` call fetches ALL of my PRs in the repo at once and
# caches one TSV line per PR:
#   branch  number  state  isDraft  pass  fail  running  url
# The status line just looks up the current branch in that cache, so switching
# branches is instant and there is no per-branch network call. The cache is
# refreshed in the background.
#
# Modes: `--refresh` force-refetches this repo; `--open` opens the current
# branch's PR in the browser.

set -u

ttl_minutes=1

command -v git >/dev/null 2>&1 || exit 0
branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" || exit 0
[ -n "$branch" ] || exit 0
[ "$branch" = "HEAD" ] && exit 0  # detached HEAD
repo="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0

cache_dir="${TMPDIR:-/tmp}/tmux-git-pr"
mkdir -p "$cache_dir" 2>/dev/null || exit 0
key="$(printf '%s' "$repo" | tr -c 'A-Za-z0-9' '_')"
cache_file="$cache_dir/$key"

# One call lists every PR I authored in this repo (any state) as
# "branch<TAB>number<TAB>state<TAB>isDraft<TAB>pass<TAB>fail<TAB>running" lines,
# where the last three are CI job counts derived from statusCheckRollup (same
# call, no extra requests). An empty file (no PRs) is still written so we honor
# the TTL instead of refetching every redraw.
refresh() {
  command -v gh >/dev/null 2>&1 || return
  (cd "$repo" && gh pr list --author "@me" --state all --limit 200 \
     --json number,headRefName,state,isDraft,statusCheckRollup,url \
     --jq '
       .[] |
       ( [ .statusCheckRollup[] |
           if .__typename == "CheckRun" then
             ( if   .status != "COMPLETED" then "R"
               elif (.conclusion == "SUCCESS" or .conclusion == "NEUTRAL" or .conclusion == "SKIPPED") then "P"
               else "F" end )
           else
             ( if   .state == "PENDING" then "R"
               elif (.state == "SUCCESS" or .state == "EXPECTED") then "P"
               else "F" end )
           end ] ) as $c |
       [ .headRefName, .number, .state, .isDraft,
         ([$c[] | select(. == "P")] | length),
         ([$c[] | select(. == "F")] | length),
         ([$c[] | select(. == "R")] | length),
         .url ] | @tsv' 2>/dev/null) \
       >"$cache_file.tmp" 2>/dev/null &&
    mv -f "$cache_file.tmp" "$cache_file" 2>/dev/null
}

# Pick the most relevant PR for the current branch: prefer open > draft >
# merged > closed, breaking ties by the highest (most recent) PR number. Prints
# "status number pass fail running url" (single line) or nothing.
select_pr() {
  [ -f "$cache_file" ] || return
  awk -F '\t' -v b="$branch" '
    $1 == b {
      n = $2; st = $3; dr = $4
      if      (st == "OPEN" && dr == "true") { rank = 1; s = "draft"  }
      else if (st == "OPEN")                 { rank = 0; s = "open"   }
      else if (st == "MERGED")               { rank = 2; s = "merged" }
      else                                   { rank = 3; s = "closed" }
      if (!have || rank < brank || (rank == brank && n + 0 > bn + 0)) {
        bs = s; brank = rank; bn = n; bp = $5; bf = $6; brun = $7; burl = $8; have = 1
      }
    }
    END { if (have) print bs, bn, bp + 0, bf + 0, brun + 0, burl }
  ' "$cache_file"
}

# `--refresh` (e.g. from a key binding) forces a synchronous refetch of this
# repo, bypassing the TTL, then exits. The caller redraws the status afterward.
if [ "${1:-}" = "--refresh" ] || [ "${1:-}" = "-r" ]; then
  refresh
  exit 0
fi

# `--open` opens the current branch's PR in the browser (used by the status-bar
# mouse binding). Falls back to a synchronous refresh if the URL isn't cached.
if [ "${1:-}" = "--open" ] || [ "${1:-}" = "-o" ]; then
  read -r _ _ _ _ _ url < <(select_pr)
  if [ -z "${url:-}" ]; then
    refresh
    read -r _ _ _ _ _ url < <(select_pr)
  fi
  if [ -n "${url:-}" ]; then
    opener="$(command -v open || command -v xdg-open)"
    [ -n "$opener" ] && "$opener" "$url" >/dev/null 2>&1
  fi
  exit 0
fi

# Refresh in the background when the cache is missing or older than the TTL, so
# the status redraw returns immediately with whatever is currently cached.
if [ ! -f "$cache_file" ] ||
   [ -z "$(find "$cache_file" -mmin "-$ttl_minutes" 2>/dev/null)" ]; then
  (refresh) >/dev/null 2>&1 &
fi

[ -f "$cache_file" ] || exit 0

read -r status num pass fail running url < <(select_pr)
[ -n "${num:-}" ] || exit 0

color="$(tmux show-option -gqv "@_catppuccin_git_pr_color_$status")"
[ -n "$color" ] || color="$(tmux show-option -gqv @_catppuccin_git_pr_color_open)"

# CI job counts, shown only for open/draft PRs (irrelevant once merged/closed).
ci=""
case "$status" in
  open | draft)
    cp="$(tmux show-option -gqv @_catppuccin_git_pr_ci_color_pass)"
    cf="$(tmux show-option -gqv @_catppuccin_git_pr_ci_color_fail)"
    cr="$(tmux show-option -gqv @_catppuccin_git_pr_ci_color_running)"
    sp="$(tmux show-option -gqv @_catppuccin_git_pr_ci_sym_pass)"
    sf="$(tmux show-option -gqv @_catppuccin_git_pr_ci_sym_fail)"
    sr="$(tmux show-option -gqv @_catppuccin_git_pr_ci_sym_running)"
    ci=" #[fg=$cp]$sp${pass:-0} #[fg=$cf]$sf${fail:-0} #[fg=$cr]$sr${running:-0}"
    ;;
esac

template="$(tmux show-option -gqv @_catppuccin_git_pr_template)"
[ -n "$template" ] || exit 0

# Fill in the accent colour, PR number, and CI counts. The doubled ## keeps a
# literal '#' after tmux re-parses this command's output as a format string.
out="${template//__COLOR__/$color}"
out="${out/__PR__/PR ##$num$ci}"
printf '%s' "$out"

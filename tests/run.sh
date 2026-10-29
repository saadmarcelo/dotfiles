#!/usr/bin/env bash
# Runs all dotfiles tests: plenary (Neovim config) + shell checks.
#   tests/run.sh            # everything
#   tests/run.sh nvim       # only Neovim specs
#   tests/run.sh shell      # only shell/tmux/toml checks
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${1:-all}"
status=0

PLENARY="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/plenary.nvim"

run_nvim() {
  if [ ! -d "$PLENARY" ]; then
    echo "plenary.nvim not found at $PLENARY — open nvim once so lazy.nvim installs it" >&2
    return 1
  fi
  echo "== nvim specs =="
  nvim --headless --noplugin -u "$HERE/minimal_init.lua" \
    -c "PlenaryBustedDirectory $HERE/nvim { minimal_init = '$HERE/minimal_init.lua', sequential = true }"
}

run_shell() {
  echo "== shell checks =="
  bash "$HERE/shell/config_test.sh"
}

case "$target" in
  nvim)  run_nvim || status=1 ;;
  shell) run_shell || status=1 ;;
  all)   run_nvim || status=1; run_shell || status=1 ;;
  *) echo "usage: $0 [all|nvim|shell]" >&2; exit 2 ;;
esac
exit $status

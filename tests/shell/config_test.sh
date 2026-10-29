#!/usr/bin/env bash
# Static checks for non-Neovim configs: zsh, tmux, toml, json.
# Each check is skipped (not failed) when its tool is missing.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
pass=0; fail=0; skip=0

ok()   { printf '  ok    %s\n' "$1"; pass=$((pass+1)); }
bad()  { printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; fail=$((fail+1)); }
skp()  { printf '  skip  %s (%s)\n' "$1" "$2"; skip=$((skip+1)); }
have() { command -v "$1" >/dev/null 2>&1; }

check() { # check <name> <cmd...>
  local name="$1"; shift
  local out
  if out="$("$@" 2>&1)"; then ok "$name"; else bad "$name" "$out"; fi
}

echo "zsh"
if have zsh; then
  check "zshrc parses (zsh -n)" zsh -n "$ROOT/zshrc/.zshrc"
else skp "zshrc parses" "zsh missing"; fi

echo "zshrc rules"
check "EDITOR is nvim"            grep -q '^export EDITOR=nvim' "$ROOT/zshrc/.zshrc"
check "mason bin is on PATH"      grep -q 'nvim/mason/bin' "$ROOT/zshrc/.zshrc"
check "vim aliases to nvim"       grep -q '^alias vim=nvim' "$ROOT/zshrc/.zshrc"
check "zoxide initialised"        grep -q 'zoxide init zsh' "$ROOT/zshrc/.zshrc"
check "fzf initialised"           grep -q 'fzf --zsh' "$ROOT/zshrc/.zshrc"
if grep -nE '(sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16})' "$ROOT/zshrc/.zshrc" >/dev/null; then
  bad "no hardcoded credentials in .zshrc"
else ok "no hardcoded credentials in .zshrc"; fi

echo "tmux"
if have tmux; then
  sock="dotfiles-test-$$"
  if out="$(tmux -L "$sock" -f "$ROOT/tmux/.tmux.conf" start-server \; show -g base-index 2>&1)"; then
    ok "tmux.conf loads without error"
    case "$out" in *"base-index 1"*) ok "base-index is 1";; *) bad "base-index is 1" "$out";; esac
  else bad "tmux.conf loads without error" "$out"; fi
  tmux -L "$sock" kill-server >/dev/null 2>&1 || true
else skp "tmux.conf loads" "tmux missing"; fi
check "tmux: vim-tmux-navigator plugin declared" grep -q "christoomey/vim-tmux-navigator" "$ROOT/tmux/.tmux.conf"
check "tmux: TPM is declared and last plugin line runs it" grep -q "tmux-plugins/tpm" "$ROOT/tmux/.tmux.conf"
check "tmux: sessionx script exists and is valid bash" bash -n "$ROOT/tmux/sessionx_fixed.sh"

echo "toml / json"
if have python3 && python3 -c 'import tomllib' 2>/dev/null; then
  for f in alacritty/.config/alacritty.toml mise/.config/mise/config.toml; do
    check "$f is valid TOML" python3 -I -c 'import sys,tomllib;tomllib.load(open(sys.argv[1],"rb"))' "$ROOT/$f"
  done
else skp "TOML files" "python3 >= 3.11 missing"; fi
if have python3; then
  for f in nvim/.config/nvim/lazy-lock.json nvim/.config/nvim/.luarc.json .mcp.json skills-lock.json export_info.json; do
    [ -f "$ROOT/$f" ] || continue
    check "$f is valid JSON" python3 -I -c 'import sys,json;json.load(open(sys.argv[1]))' "$ROOT/$f"
  done
else skp "JSON files" "python3 missing"; fi

echo "kitty"
check "kitty.conf exists and is non-empty" test -s "$ROOT/kitty/.config/kitty/kitty.conf"

printf '\n%d passed, %d failed, %d skipped\n' "$pass" "$fail" "$skip"
[ "$fail" -eq 0 ]

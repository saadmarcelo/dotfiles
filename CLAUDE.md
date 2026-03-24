# Codebase Overview

This repo contains a modular Neovim setup (lazy.nvim) plus terminal, tmux, and Zsh configuration files, with OpenCode integration for AI tooling and MCP servers. Neovim loads core options/keymaps first, then lazy.nvim plugin specs under `nvim/.config/nvim/lua/saad/`.

**Stack**: Neovim (Lua), lazy.nvim, OpenCode CLI/MCP, tmux, Zsh, Alacritty/Kitty.
**Structure**: Root-level docs and scripts with configs under `nvim/`, `tmux/`, `zshrc/`, `alacritty/`, `kitty/`, and `opencode/`.

For detailed architecture, see `docs/CODEBASE_MAP.md`.

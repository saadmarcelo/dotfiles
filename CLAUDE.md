## Context Navigation

1. SEMPRE consulte o knowledge graph primeiro
2. Só leia arquivos brutos se eu pedir explicitamente
3. Use graphify-out/wiki/index.md como ponto de entrada

# Codebase Overview

This repo contains a modular Neovim setup (lazy.nvim) plus terminal, tmux, and Zsh configuration files, with OpenCode integration for AI tooling and MCP servers. Neovim loads core options/keymaps first, then lazy.nvim plugin specs under `nvim/.config/nvim/lua/saad/`.

**Stack**: Neovim (Lua), lazy.nvim, OpenCode CLI/MCP, tmux, Zsh, Alacritty/Kitty.
**Structure**: Root-level docs and scripts with configs under `nvim/`, `tmux/`, `zshrc/`, `alacritty/`, `kitty/`, and `opencode/`.

For detailed architecture, see `docs/CODEBASE_MAP.md`.

## graphify

This project has a graphify knowledge graph at graphify-out/.

Rules:
- Before answering architecture or codebase questions, read graphify-out/GRAPH_REPORT.md for god nodes and community structure
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- After modifying code files in this session, run `graphify update .` to keep the graph current (AST-only, no API cost)

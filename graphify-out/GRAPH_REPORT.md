# Graph Report - .  (2026-04-29)

## Corpus Check
- Corpus is ~9,227 words - fits in a single context window. You may not need a graph.

## Summary
- 40 nodes · 37 edges · 11 communities detected
- Extraction: 92% EXTRACTED · 8% INFERRED · 0% AMBIGUOUS · INFERRED: 3 edges (avg confidence: 0.77)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_MCP Server Ecosystem|MCP Server Ecosystem]]
- [[_COMMUNITY_Neovim Core & Plugins|Neovim Core & Plugins]]
- [[_COMMUNITY_OpenCode & Project Context|OpenCode & Project Context]]
- [[_COMMUNITY_Documentation & Graph|Documentation & Graph]]
- [[_COMMUNITY_Tmux Tools|Tmux Tools]]
- [[_COMMUNITY_OpenCode CLI|OpenCode CLI]]
- [[_COMMUNITY_Theme Configuration|Theme Configuration]]
- [[_COMMUNITY_nvim-tree|nvim-tree]]
- [[_COMMUNITY_Telescope|Telescope]]
- [[_COMMUNITY_LSP Mason|LSP Mason]]
- [[_COMMUNITY_LSP Config|LSP Config]]

## God Nodes (most connected - your core abstractions)
1. `MCP Servers` - 13 edges
2. `Dotfiles Project Context` - 5 edges
3. `OpenCode.nvim` - 5 edges
4. `lazy.nvim` - 5 edges
5. `secrets.lua` - 3 edges
6. `opencode CLI` - 3 edges
7. `Neovim Plugins` - 2 edges
8. `tmux-sessionx` - 2 edges
9. `opencode.jsonc MCP config` - 2 edges
10. `saad.plugins module` - 2 edges

## Surprising Connections (you probably didn't know these)
- `Git Command Restriction Policy` --rationale_for--> `Dotfiles Project Context`  [EXTRACTED]
  GIT_WARNING.md → context.md
- `MCP Server Configuration Guide` --documents--> `MCP Servers`  [EXTRACTED]
  servidormcp.md → context.md
- `GNU Stow` --conceptually_related_to--> `Codebase Map`  [INFERRED]
  README.md → docs/CODEBASE_MAP.md
- `Keybinding conflict <leader>rn` --affects--> `Neovim Plugins`  [EXTRACTED]
  .claude/napkin.md → context.md
- `Theme background mismatch` --affects--> `Catppuccin Theme`  [EXTRACTED]
  .claude/napkin.md → context.md

## Communities

### Community 0 - "MCP Server Ecosystem"
Cohesion: 0.18
Nodes (11): Ansible MCP Server, AWS IaC MCP Server, AWS MCP Server, Context7 MCP Server, Docker MCP Server, GitHub MCP Server, Kubernetes MCP Server, MCP Servers (+3 more)

### Community 1 - "Neovim Core & Plugins"
Cohesion: 0.33
Nodes (7): lazy.nvim, nvim init.lua, Neovim Plugins, saad.core module, saad.plugins module, saad.plugins.lsp module, Keybinding conflict <leader>rn

### Community 2 - "OpenCode & Project Context"
Cohesion: 0.4
Nodes (6): Avante.nvim (disabled), Dotfiles Project Context, OpenCode.nvim, secrets.lua, secrets.lua.example, Git Command Restriction Policy

### Community 3 - "Documentation & Graph"
Cohesion: 0.4
Nodes (5): Codebase Overview, Graph Report, graphify Knowledge Graph, Codebase Map, GNU Stow

### Community 4 - "Tmux Tools"
Cohesion: 0.67
Nodes (2): fzf, tmux-sessionx

### Community 5 - "OpenCode CLI"
Cohesion: 1.0
Nodes (2): opencode CLI, opencode.jsonc MCP config

### Community 6 - "Theme Configuration"
Cohesion: 1.0
Nodes (2): Catppuccin Theme, Theme background mismatch

### Community 7 - "nvim-tree"
Cohesion: 1.0
Nodes (1): nvim-tree.lua

### Community 8 - "Telescope"
Cohesion: 1.0
Nodes (1): telescope.lua

### Community 9 - "LSP Mason"
Cohesion: 1.0
Nodes (1): LSP Mason

### Community 10 - "LSP Config"
Cohesion: 1.0
Nodes (1): LSP LSPConfig

## Knowledge Gaps
- **23 isolated node(s):** `Avante.nvim (disabled)`, `secrets.lua.example`, `AWS MCP Server`, `Kubernetes MCP Server`, `Docker MCP Server` (+18 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `OpenCode CLI`** (2 nodes): `opencode CLI`, `opencode.jsonc MCP config`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Theme Configuration`** (2 nodes): `Catppuccin Theme`, `Theme background mismatch`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `nvim-tree`** (1 nodes): `nvim-tree.lua`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Telescope`** (1 nodes): `telescope.lua`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `LSP Mason`** (1 nodes): `LSP Mason`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `LSP Config`** (1 nodes): `LSP LSPConfig`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
# Napkin Runbook

## Curation Rules
- Re-prioritize on every read.
- Keep recurring, high-value notes only.
- Max 10 items per category.
- Each item includes date + "Do instead".

## Execution & Validation (Highest Priority)
1. **[2026-04-27] Verify Neovim config loads without errors**
   Do instead: run `nvim --headless -c 'qa!'` to check for Lua init errors.

## Shell & Command Reliability
1. **[2026-04-27] `zshrc` changes require sourcing or new shell**
   Do instead: run `source zshrc/.zshrc` or open fresh terminal.

## Domain Behavior Guardrails
1. **[2026-04-27] lazy.nvim plugins lazy-load by default**
   Do instead: do not assume plugins are loaded at startup; trigger via keymap or command.

## User Directives
1. **[2026-04-27] User prefers terse responses without summaries**
   Do instead: output only what was done and what's next, no trailing summaries.
2. **[2026-04-28] AI tool used for all queries = Claude CLI**
   Do instead: always reference Claude CLI behavior, not OpenCode.

## OpenCode Integration
1. **[2026-04-13] OpenCode local skills live in `~/.config/opencode/skills/<skill>/SKILL.md`**
   Do instead: place local skill definitions there.
2. **[2026-04-13] Global always-on behavior for OpenCode controlled by `~/.config/opencode/AGENTS.md`**
   Do instead: edit AGENTS.md to make skills auto-load every session.
3. **[2026-04-13] `caveman` skill works in OpenCode via local skill + always-on section in AGENTS.md**
   Do instead: combine both for persistent caveman mode.

## Tmux
1. **[2026-04-28] `O` no Neovim disparava sessionx (tmux interceptava)**
   Do instead: `unbind -n O` no tmux.conf DESPOIS do `run '~/.tmux/plugins/tpm/tpm'` — plugin sessionx cria binding root `-n O` na linha 176 de sessionx.tmux que captura O global.

## Neovim / Treesitter / Telescope
1. **[2026-04-13] `nvim-ts-autotag` setup through `nvim-treesitter.configs` is deprecated**
   Do instead: configure with `require("nvim-ts-autotag").setup()` or plugin `opts`.
2. **[2026-04-13] `telescope.setup()` must keep `defaults`, `pickers`, `extensions` as top-level keys**
   Do instead: do not nest them inside another table.
3. **[2026-04-13] `telescope.nvim` master/v0.2 requires Neovim 0.11+**
   Do instead: local machine runs 0.12.1 — safe, but master may break on older Neovim.

## User Preferences
- Uses lazy.nvim for Neovim plugin management.
- Modular configuration structure.
- macOS (darwin) platform.
- Neovim with Lua configuration.

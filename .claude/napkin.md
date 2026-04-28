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

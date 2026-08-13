# Napkin

## Mistakes

- Avoid assuming a local OpenAI-compatible endpoint can replace the primary OpenCode model without verifying tool-calling support first.

## Corrections

- Reproduced the Kimi local failure with `opencode run --print-logs` before editing config.
- Confirmed the active blocker is server-side: the Kimi endpoint returns `"auto" tool choice requires --enable-auto-tool-choice and --tool-call-parser to be set`.
- Removed project-level `model` and `small_model` overrides so OpenCode keeps a working default model instead of failing silently.

## What Worked

- Checking both repo-local and global OpenCode configs before changing anything.
- Using `opencode run --print-logs` to capture the exact provider error.
- Comparing Alacritty and Kitty font family names before changing terminal config.

## Session Notes

- Alacritty failed because `SauceCodePro Nerd Font` was configured, but the installed variants on this macOS setup are `SauceCodePro Nerd Font Mono`.
- Follow-up: macOS did not register the `SauceCodePro Nerd Font Mono` files as a usable family for Alacritty; `Hack Nerd Font Mono` is registered correctly and works as fallback.
- `nvim-treesitter` in this repo was lazy-loaded by buffer events, but upstream docs say lazy-loading is not supported; this can surface parser/highlighter crashes in Markdown on Neovim 0.12.x.
- When `vim.treesitter` errors only on Markdown in Neovim 0.12.x, disable Treesitter highlighting for `markdown`/`markdown_inline` first; parser may be fine while queries/highlighter are not.
- If the stack mentions Treesitter markdown but the trigger is UI text like `msg_show` or completion docs, inspect `noice.nvim` and other markdown render overrides before blaming file buffers.
- Confirmed by test: with `nvim-treesitter` fully disabled, Neovim opens Markdown without the `Decoration provider "start"` / `range()` crash on Neovim `0.12.4`.

## Corrections

- Root cause is not Markdown content itself; it is the installed `nvim-treesitter` line being incompatible with Neovim `0.12.4`.

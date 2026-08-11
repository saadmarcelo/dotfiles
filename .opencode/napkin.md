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

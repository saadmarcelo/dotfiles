-- Minimal init for plenary tests: loads only the repo's nvim config (no lazy.nvim, no plugin downloads).
local this = debug.getinfo(1, "S").source:sub(2)
local root = vim.fn.fnamemodify(this, ":p:h:h")
local nvim_dir = root .. "/nvim/.config/nvim"

vim.opt.rtp:prepend(nvim_dir)
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/plenary.nvim")
package.path = nvim_dir .. "/lua/?.lua;" .. nvim_dir .. "/lua/?/init.lua;" .. package.path

_G.DOTFILES_ROOT = root
_G.NVIM_DIR = nvim_dir

vim.cmd("runtime plugin/plenary.vim")

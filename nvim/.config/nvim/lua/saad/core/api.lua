vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Higlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
vim.defer_fn(function()
	vim.api.nvim_set_hl(0, "@property", { fg = "#0000FF" })
	vim.api.nvim_set_hl(0, "@variable.member", { fg = "#9400D3" })
end, 100)

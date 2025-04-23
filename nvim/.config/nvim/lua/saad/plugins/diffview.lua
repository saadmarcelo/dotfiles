return {
	"sindrets/diffview.nvim",
	requires = "nvim-lua/plenary.nvim",
	vim.keymap.set("n", "<leader>gpv", ":DiffviewOpen<CR>"),
	vim.keymap.set("n", "<leader>gpf", ":DiffviewFileHistory<CR>"),
}

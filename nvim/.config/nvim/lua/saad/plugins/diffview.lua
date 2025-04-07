return {
	"sindrets/diffview.nvim",
	requires = "nvim-lua/plenary.nvim",
	vim.keymap.set("n", "<leader>gdv", ":DiffviewOpen<CR>"),
	vim.keymap.set("n", "<leader>gdf", ":DiffviewFileHistory<CR>"),
}

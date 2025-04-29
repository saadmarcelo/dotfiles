return {
	"sindrets/diffview.nvim",
	requires = "nvim-lua/plenary.nvim",
	vim.keymap.set("n", "<leader>gfv", ":DiffviewOpen<CR>"),
	vim.keymap.set("n", "<leader>gff", ":DiffviewFileHistory<CR>"),
}

return {
	"akinsho/flutter-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
	config = function()
		require("flutter-tools").setup({})
	end,
}

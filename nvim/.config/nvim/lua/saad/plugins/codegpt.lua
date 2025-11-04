return {
	"dpayne/CodeGPT.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	event = "VeryLazy",
	config = function()
		require("config.codegpt")
	end,
}

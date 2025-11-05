-- ~/.config/nvim/lua/plugins/chatgpt.lua
-- Plugin ChatGPT.nvim (melhor alternativa)

return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("config.chatgpt")
	end,
}

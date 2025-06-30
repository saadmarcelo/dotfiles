return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- Garante que o tema carregue antes de outros plugins
	config = function()
		-- Configura o plugin do Catppuccin
		require("catppuccin").setup({
			flavour = "latte", -- O tema claro que você quer!
			background = {
				light = "latte",
				dark = "mocha",
			},
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = true,
				-- Adicione outras integrações que você usa
			},
		})

		-- Carrega o esquema de cores
		vim.cmd.colorscheme("catppuccin")
	end,
}

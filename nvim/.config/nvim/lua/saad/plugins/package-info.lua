-- ~/.config/nvim/lua/plugins/package-info.lua
-- Mostra informações de versões do package.json inline

return {
	"vuki656/package-info.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	event = "BufRead package.json",
	config = function()
		require("package-info").setup({
			colors = {
				up_to_date = "#3C4048", -- Texto verde quando atualizado
				outdated = "#d19a66", -- Texto laranja quando desatualizado
			},
			icons = {
				enable = true,
				style = {
					up_to_date = "|  ", -- Icon quando atualizado
					outdated = "|  ", -- Icon quando desatualizado
				},
			},
			autostart = true, -- Auto-mostrar versões ao abrir package.json
			hide_up_to_date = false, -- Mostrar mesmo quando atualizado
			hide_unstable_versions = false, -- Mostrar versões beta/alpha
		})

		-- Keymaps
		local keymap = vim.keymap.set
		keymap("n", "<leader>ns", require("package-info").show, { silent = true, desc = "Show package versions" })
		keymap("n", "<leader>nc", require("package-info").hide, { silent = true, desc = "Hide package versions" })
		keymap("n", "<leader>nt", require("package-info").toggle, { silent = true, desc = "Toggle package versions" })
		keymap("n", "<leader>nu", require("package-info").update, { silent = true, desc = "Update package" })
		keymap("n", "<leader>nd", require("package-info").delete, { silent = true, desc = "Delete package" })
		keymap("n", "<leader>ni", require("package-info").install, { silent = true, desc = "Install package" })
		keymap(
			"n",
			"<leader>np",
			require("package-info").change_version,
			{ silent = true, desc = "Change package version" }
		)
	end,
}

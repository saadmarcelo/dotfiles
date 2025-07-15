return {
	"ngtuonghy/live-server-nvim",
	event = "VeryLazy",
	config = function()
		require("live-server-nvim").setup({
			-- Força a abertura no navegador. O valor padrão já é true, mas é bom explicitar
			open = "folder", -- Ou "folder", "cwd" se você quiser controle mais granular
			cmd = "/opt/homebrew/bin/live-server",
			cwd = vim.fn.expand("%:p:h"),
			custom = { "--port=8080" }, -- Você pode mudar a porta se 8080 estiver em uso
			-- Descomente a linha abaixo para ver mais logs no terminal do live-server
			verbose = true,
		})

		vim.keymap.set("n", "<leader>ls", function()
			vim.fn.jobstart({ "/opt/homebrew/bin/live-server", vim.fn.expand("%") }, {
				detach = true,
			})
		end, { desc = "Start Live Server manually" })

		vim.keymap.set("n", "<leader>lx", function()
			vim.fn.jobstart({ "pkill", "-f", "live-server" })
		end, { desc = "Stop Live Server manually" })
	end,
}

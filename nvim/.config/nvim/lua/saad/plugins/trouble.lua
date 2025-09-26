return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	cmd = "Trouble",
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Open trouble document diagnostics",
		},
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
	},
	opts = {
		focus = true,
		-- Configurações específicas para diferentes modos
		modes = {
			diagnostics = {
				auto_open = false,
				auto_close = true,
				auto_preview = true,
				auto_refresh = true,
			},
		},
		-- Ícones personalizados para diagnósticos
		icons = {
			indent = {
				top = "│ ",
				middle = "├╴",
				last = "└╴",
				fold_open = " ",
				fold_closed = " ",
				ws = "  ",
			},
			folder_closed = " ",
			folder_open = " ",
			kinds = {
				Array = " ",
				Boolean = "󰨙 ",
				Class = " ",
				Constant = "󰏿 ",
				Constructor = " ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Function = "󰊕 ",
				Interface = " ",
				Key = " ",
				Method = "󰊕 ",
				Module = " ",
				Namespace = "󰦮 ",
				Null = " ",
				Number = "󰎠 ",
				Object = " ",
				Operator = " ",
				Package = " ",
				Property = " ",
				String = " ",
				Struct = "󰆼 ",
				TypeParameter = " ",
				Variable = "󰀫 ",
			},
		},
		-- Configurações visuais
		win = {
			border = "rounded",
			title = true,
			title_pos = "center",
			zindex = 50,
		},
		-- Preview window
		preview = {
			type = "split",
			relative = "win",
			position = "right",
			size = 0.3,
		},
		-- Auto commands para abrir automaticamente em caso de erros
		action = {
			open_split = { "<c-x>" },
			open_vsplit = { "<c-v>" },
			open_tab = { "<c-t>" },
			jump = { "<cr>", "<tab>" },
			jump_close = { "o" },
			toggle_mode = "m",
			hover = "K",
			preview = "p",
			close = "q",
			toggle_preview = "P",
			toggle_fold = { "zA", "za" },
		},
	},
	config = function(_, opts)
		require("trouble").setup(opts)

		-- Auto comando para abrir Trouble quando há erros
		vim.api.nvim_create_autocmd("DiagnosticChanged", {
			callback = function()
				local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				if #diagnostics > 0 then
					-- Opção: abrir automaticamente o Trouble quando há erros
					-- vim.cmd("Trouble diagnostics open")
				end
			end,
		})
	end,
}

-- lazy.nvim
return {
	"folke/noice.nvim",
	enabled = false,
	event = "VeryLazy",
	opts = {
		views = {
			cmdline = {
				position = {
					row = "50%",
					col = "50%",
				},
				border = {
					style = "rounded",
				},
				messages = {
					enable = true,
					show = "always",
				},
			},
		},
		lsp = {
			-- Avoid Treesitter-based markdown rendering here. Neovim 0.12.4 is
			-- crashing in markdown highlighter paths on this setup.
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
				["vim.lsp.util.stylize_markdown"] = false,
				["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
			},
		},
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = false, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
		disable = {
			cmdline = true,
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
}

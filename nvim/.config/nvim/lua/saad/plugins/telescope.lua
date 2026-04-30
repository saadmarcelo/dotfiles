return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						preview_width = 0.4,
						results_width = 0.6,
						width = 0.98,
						height = 0.98,
					},
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = function(prompt_bufnr)
							actions.send_selected_to_qflist(prompt_bufnr)
							actions.open_qflist()
						end,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					no_ignore = true,
					file_ignore_patterns = { "^.git/", "^.venv/", "^node_modules/", "^.opencode/node_modules/" },
				},
			},
		})

		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "noice")
		local keymap = vim.keymap

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "Fuzzy find registers" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "[F]ind [K]eymaps" })
		keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "[F]ind [D]iagnostics" })
		keymap.set("n", "<leader><leader>", "<cmd>Telescope buffers<cr>", { desc = "find existing buffers" })
	end,
}

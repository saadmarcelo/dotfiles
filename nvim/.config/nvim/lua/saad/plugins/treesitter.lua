return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- Configurar filetype para Jinja2
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = { "*.j2", "*.jinja", "*.jinja2" },
			callback = function()
				vim.bo.filetype = "jinja2"
			end,
		})

		-- configure treesitter
		treesitter.setup({ -- enable syntax highlighting
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "terraform", "jinja2" },
				disable = { "tmux" },
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"hcl",
				"helm",
				"toml",
				"regex",
				"bash",
				"lua",
				"python",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"terraform",
				"vimdoc",
				"c",
				"tmux",
				"htmldjango", -- Para highlighting de Django/Jinja2
			},
			auto_install = true,
			sync_install = false,
			ignore_install = {},
			modules = {},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}

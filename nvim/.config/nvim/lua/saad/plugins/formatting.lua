return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				-- Formatação para arquivos Jinja2
				jinja2 = { "djlint" },
			},
			formatters = {
				-- Configuração específica do djlint
				djlint = {
					command = "djlint",
					args = {
						"--reformat",
						"--indent",
						"2",
						"--profile",
						"jinja",
						"--preserve-leading-space",
						"--preserve-blank-lines",
						"-",
					},
					stdin = true,
				},
				-- Configuração do Prettier com regras para CDK
				prettier = {
					prepend_args = {
						"--single-quote",
						"--trailing-comma=all",
						"--print-width=100",
						"--tab-width=2",
					},
				},
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		-- Keymaps para formatação
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		-- Comando personalizado para formatação específica de Jinja2
		vim.api.nvim_create_user_command("FormatJinja", function()
			conform.format({
				formatters = { "djlint" },
				timeout_ms = 3000,
			})
		end, { desc = "Format Jinja2 file with djlint" })
	end,
}
